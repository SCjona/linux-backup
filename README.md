# Simple Encrypted Backups

## Dependencies
- `openssl` (encryption)
- `uuidgen` (keyfile generation)
- `xz` (compression)
- `tar` (backup creation)
- `sha512sum` (change detection)
- `notify-send` (for error notifications)

## Usage
1. Run `./install.sh`
2. Back up your fallback keyfile (as well as all custom keyfiles you create)
3. Mount your backup destination under `destination` directory (e.g. `S3FS` or `SSHFS`) or replace the directory with a symlink (`ln -s /path/to/backup destination`)
4. Add your backup destination to your `/etc/fstab`
5. Reboot, ensure your `/etc/fstab` config is working
6. Add `backup-error-notify.sh` to autostart or other scheduled execution methods (e.g. Cron)
7. Add your backup folders as symlinks under `sources` using `ln -s /full/path/to/backup backup-name` (backup name is limited to alphanumeric chars, minus and underscore)
8. Run `./backup.sh` manually and test your setup

## Possible Customizations

### Custom notification system
Edit `notify.sh` to your liking

### Customize upload/download commands (as replacement for directory mounts)
Edit `download.sh` and `upload.sh`. They are used like a `mv <source> <destination>` command, the remote file is always just a file name, the local file is a relative path.

### Custom keyfiles for certain backups
Create a keyfile using this command: `uuidgen > keyfiles/backup-name.keyfile`

### Exclude files in backup directories
This works using the `tar --exclude-cache` switch. To exclude a directory use the following command: `echo 'Signature: 8a477f597d28d172789f06886806bc55' > /directory/to/exclude/CACHEDIR.TAG`

