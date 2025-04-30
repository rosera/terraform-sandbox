# Lab Migration

Ensure the folder structure matches the lab bundle format to avoid complexity.
A script to perform a copy from the source to the destination based on folder.

## Generate

To generate the templates use the following bash script:

```bash
bash build-template.sh
```

The script takes the input of the `labs.txt` file to determine which folders 
to create.


## Developer Notes 

The content generate can be run as often as required.
Ensure both the folder and the `labs.txt` reflect the folders to be created.
