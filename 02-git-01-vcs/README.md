# devops-netology-hw

Файлы, которые будут проигнорированы на основе terraform(.gitignore):

- Все локальные директории .terraform
- Файлы состояния Terraform (*.tfstate, *.tfstate.*)
- Файлы журнала аварий (crash.log, crash.*.log)
- Файлы переменных Terraform (*.tfvars, *.tfvars.json)
- Файлы переопределения ресурсов Terraform (override.tf, override.tf.json, *_override.tf, *_override.tf.json)
- Файлы конфигурации CLI Terraform (.terraformrc, terraform.rc)
