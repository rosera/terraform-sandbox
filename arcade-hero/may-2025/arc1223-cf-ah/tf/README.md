# Arcade Hero

Data driven labs based on Terraform input.
Information presented in the Lab is defined in the `locals.tasks` variable.

## Logo

- [x] GCP Logos location:

```
https://.storage.googleapis.com/spls/arc-hero/assets/images/artifact_registry.png`
```

## Modules

Module definitions include:
* Resources
* Variables
* Hero

Resources
---

Modular definitions for resources.

- [x] ar.tf - Artifact Registry resource 
- [x] cb.tf - CloudBuild resource 
- [x] cr.tf - Cloud Run resource 
- [x] delay.tf - Wait mechanism resource 
- [x] gcs.tf - Google Cloud Storage resource 
- [x] sa.tf - Service Account resource 

Variables
---

Add variable definitions for resource definitions.

- [x] locals.tf - Local variables definitions
- [x] outputs.tf - Output variables definitions
- [x] variables.tf - General variable definitions

HERO
---

Datasets for the Hero game.

- [x] hero-ar.tf
- [x] hero-bq.tf
- [x] hero-cf.tf
- [x] hero-fw.tf
- [x] hero-gcs.tf
- [x] hero-vpc.tf

## Changelog

* Sept 2025 - Migrate cb.tf to deploy CR directly.
*  May 2025  - Make TF more modular for easier maintenance.
