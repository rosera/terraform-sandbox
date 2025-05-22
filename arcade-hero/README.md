# RELEASE

- [ ] Get the latest version from GitHub
- [ ] Set the latest version on GitHub

Use rsync to synchronise folders with updates.

Rsync options

| Option | Description |
| -------|-------------|
| -p     | Preserve permissions |
| -t     | Preserve timestamps  |
| -g     | Preserve group ownership |
| -o     | Preserve owner |
| -v     | Verbose information, provides information on command |
| --delete | Delete destination files not found in the source |
| --dry-run | Shows the command result without performing actions |

## Get Version

Synchronise the version maintained in Git to the local folder.

### Sync source folder to current destination using dry-run
```
 rsync -avP --delete /home/richardrose/repos/work/gcp-brex/labs/arc1223-cf-ah . --dry-run
```

### Sync source folder to current destination
```
 rsync -avP --delete /home/richardrose/repos/work/gcp-brex/labs/arc1223-cf-ah . 
```


## Set Version

Synchronise the local folder to the version maintained in Git

### Sync source folder to current destination using dry-run
```
 rsync -avP --delete . /home/richardrose/repos/work/gcp-brex/labs/arc1223-cf-ah --dry-run
```

### Sync source folder to current destination
```
 rsync -avP --delete . /home/richardrose/repos/work/gcp-brex/labs/arc1223-cf-ah
```


