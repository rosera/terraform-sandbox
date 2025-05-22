# Lab Terraform Templates 

Ensure the folder structure matches the lab bundle format to avoid complexity.
A script to perform a copy from the source to the destination based on folder.

## Generate

To generate the templates use the following bash script:

```bash
bash build-template.sh
```

The script takes the input of the `labs.txt` file to determine which folders 
to create.

## Migration

Move the generated Terraform to the Lab Bundle for the repository
e.g. `cp -r [FOLDER] arcade-generator/lb-gen/chatbot/templates`


Copy generated Terraform to the template folder...
```
cp -r arc* ~/repos/arcade-generator/lb-gen/chatbot/templates
```

The above command replaces the generated chatbot folders with the arc folders.


The above replaces the existing `tf` folder with the generated content.
Merge the folder contents gives a template that can be pushed to the `gcp-brex` 
repository.

## Developer Notes 

The content generate can be run as often as required.
Ensure both the folder and the `labs.txt` reflect the folders to be created.
