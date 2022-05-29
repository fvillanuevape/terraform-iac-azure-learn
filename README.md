# IaC con Terraform y Azure Cloud

## Detalle de versiones

| Version     | Description |
| ----------- | ----------- |
| v1.0.0      | Creación de Resource Group       |
| v1.1.0      | Se añade la creación de una Azure Virtual Machine  |

## Comandos

| Comandos     | Description |
| ----------- | ----------- |
| ``terraform init``    | Descargar los provider e inicializarlos para ejecutar los otros comandos     |
| ``terraform plan``    | Evalua la configuración de Terraform |
| ``terraform apply``   | Ejecutar el terraform plan y pedir la confirmación.     |
| ``terraform destroy`` | Elimina la infraestructuea en base al terraform state |

## Variables de Terraform

| Concepto     | Description |
| ----------- | ----------- |
| Variables de Terraform   | |
|Tipos de Variables|||
|Referenciar la variable|||

### Precedencia en las variables

1. Variables de entorno

2. Fichero ``terraform.tfvars``

3. Fichero ``terraform.tfvars.json``

4. Ficheros acabados en ``.auto.tfvars`` o .``auto.tfvars.json``, si hay más de uno, será en orden lexicográfico

5. Cualquier variable ``-var`` o ``-var-file``, en el orden que son especificadas

## Archivos Terraform

```
project-terraform
+---.terraform
¦   ¦
¦   +---providers
¦       ¦   file111.
¦   main.tf
¦   outputs.tf   
¦   variables.tf
¦   terraform.tfstate
¦   terraform.tfstate.backup
¦   .terraform.lock.hcl
```
