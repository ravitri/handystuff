# Scripts

Standalone shell scripts. Each script documents its options in a header comment.

## backup.sh

Backs up files and dotfiles from your home directory, then creates compressed archives.

What it does:

1. Copies top-level files in `$HOME`, plus `Documents`, `Downloads`, `bin` and `scripts`, into `$BACKUP_DIR`.
   Logs, videos, tarballs and similar large files are skipped.
2. Copies shell, editor, SSH, cloud and tool configuration into `$CORE_DIR`.
   Paths that don't exist on your machine are skipped, so edit the lists in the script to match your setup.
3. Records the list of user-installed packages, if `dnf` is available.
4. Records the `origin` URL of each git checkout under `$REPOS_DIR`, if that variable is set.
5. Creates `backup-<date>.tar.gz` and `core-<date>.tar.gz` in `$HOME` with mode `600`.
   Optionally deletes older archives.

### Requirements

`bash` 4.4+, `rsync`, `tar`, `gzip`; `git` and `dnf` are optional.

### Usage

```bash
./scripts/backup.sh
```

With options:

```bash
REPOS_DIR=~/src KEEP=5 ./scripts/backup.sh
```

| Variable     | Default     | Description                                                     |
|--------------|-------------|-----------------------------------------------------------------|
| `BACKUP_DIR` | `~/backup`  | Destination for regular files                                   |
| `CORE_DIR`   | `~/core`    | Destination for dotfiles and configuration                      |
| `REPOS_DIR`  | *(unset)*   | Directory of git checkouts whose remote URLs are recorded       |
| `KEEP`       | `0`         | Number of archives of each kind to keep; `0` keeps all of them  |

### Notes

- Syncs use `rsync --delete`, so files removed from the source are also removed from the backup copy.
  The dated archives keep the older versions.
- The `core` archive contains private keys and credentials (`~/.ssh`, `~/.aws`, ...).
  Encrypt it before storing it anywhere else, for example:

  ```bash
  gpg -c core-<date>.tar.gz
  ```
