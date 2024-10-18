# Infra As Code & Snowflake

🎯 Goal : **Infra as Code** with Terraform

- for dev / prod environnements (db / schema / wh)
- for **role** creations & **grants** to db / schema / wh

![recap](./snow_terraform_dbt.png)

🎓 Ressources

- Mistertemp : [article IaC & Snow](https://tech.mistertemp.com/infra-as-code-avec-snowflake-ab961dd4d190?gi=a9060ed6cd68) (img up there 👆)
- ❄️ quickstart : [terraforming snowflake](https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html) ([github demo](https://github.com/Snowflake-Labs/sfguide-terraform-sample)) ✅
- ❄️ Github : [Snowflake-Labs/terraform-provider-snowflake](https://github.com/Snowflake-Labs/terraform-provider-snowflake) > [examples](https://github.com/Snowflake-Labs/terraform-provider-snowflake/tree/main/examples)

## Archi CIBLE 🎯

### environnments: `dev` | `val` | `prod`

in each env', we have the 3 following database & schemas

- 🥉 `{env}_db_bronze`
  - `sage_x3_cdc`
  - `sage_x3_full`
  - ...
- 🥈 `{env}_db_silver`
  - schemas created by dbt
- 🥇 `{env}_db_gold`
  - schemas created by dbt

### 🎯 Roles

- **loader** : usr kafka_debezium (dev / prod)\
  can create/drop schemas & tables in db_bronze
  - 🖥️ `loader_warehouse`
- **transformer** : usr dbt_runner (dev / prod)\
  can create/drop schemas & tables in db_silver & db_gold
  - 🖥️ `transformer_warehouse`
- **analyst** : can create/drop schemas & tables on all db\
  **ONLY** on dev env'
  - 🖥️ `analyst_warehouse`
- **reader** : can read everywhere
  - 🖥️ `reader_warehouse`
  - **reader_gold** : can read gold layers only

### 🪖 Admin roles in Snowflake ❄️

- **userAdmin** : add user & adjust ssh public key
- **securityAdmin** : grant privileges (user to group, object to group, group to group ...)
- **sysAdmin** : can delete/create all objects\
  all object roles must have sysAdmin as a parent
- **accountAdmin** : parent de userAdmin, securityAdmin, sysAdmin\
  ~ Dieu 😎 => n'utiliser qu'en extrème urgence #drop

## récap

![recap](./demo_terraform_snowflake_brz_slv_gld.jpg)
