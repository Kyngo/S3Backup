# S3 Backup System 💾

## Installation / Setup

1. Copy all the files in here to `/opt/s3backup` on your machine.
2. Then change the permissions of the scripts so they can be executed, like this: `chmod +x /opt/s3backup/{backup,delete}.sh`.
3. Then `cp /opt/s3backup/credentials.dist /opt/s3backup/credentials`, and then put your AWS programatic credentials and prefered region inside that file.
4. Finally, create a file named `directories` inside the project folder, and add each directory to backup, one per line. No slashes at the end!

Easy as pie! 🥧

## Cron to run script ⏱

`0 0 * * * root test -x /opt/s3backup/backup.sh && bash /opt/s3backup/backup.sh`
`0 0 * * * root test -x /opt/s3backup/delete.sh && bash /opt/s3backup/delete.sh`

## Restoring

There is a script called "backup.sh" which will assist you on restoring a lost project.
