# server-backup-2nfs

set yourown nfs info for backup
---
- var_nfs=**UPDATE_TO_MYOWN_NFS:MYOWN_NFS_SHARE**  # e.g. 192.168.0.100:/nfs
- var_local=**UPDATE_TO_MYOWN_LOCAL_MOUNTPOINT** # e.g. /mnt/nfs

usage:
--- 
- ./sbk.sh folder1 folder2 .. folderN (max value of N is 9)
- e.g. ./sbk /etc /opt
- script will tar folder to /mnt/nfs as a backup

