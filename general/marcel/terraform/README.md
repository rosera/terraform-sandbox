# Build a Streaming Data Pipeline on Confluent Cloud with GCS

This Qwiklab will introduce you to Confluent Cloud and help you build a streaming data pipeline to send data to Google Cloud Storage.

## Repository Information

This terraform code will set up a Confluent Cloud environment and invite a user with access to the newly created environment.

The components created using this Terraform code are:

- [Confluent Cloud Environment](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_environment)
- [Confluent Cloud Invitation](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_invitation)
- [Confluent Cloud Role Binding](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_role_binding)

### Prerequisites

- [Confluent Cloud Subscription](https://confluent.cloud)
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)

## Variables

The `qwiklab.tfvars` file is used to declare variables to be passed as input parameters to the Terraform code and modules. You can search for the string `xx-replace-xx` to locate all instances of a variable that need your input to run this lab.

``` zsh
confluent_cloud_csp = "xx-replace-xx"
confluent_cloud_csp_region = "xx-replace-xx"
user_email = "xx-replace-xx"
```

## Lab Creation

When executing the Terraform code to create the lab environment use the `qwiklab.tfvars` file as your input source for your declared variables. If you have another way of declaring variables, feel free to use that as well.

## Lab Deletion

Runnning a Terraform destroy after the lab has been completed will destroy all but one resource, the user invitation. Once a user has accepted an invitation in Confluent Cloud, the invitation becomes an invalid object. Confluent will periodically remove the created user accounts from the organization as part of a cleanup routine.