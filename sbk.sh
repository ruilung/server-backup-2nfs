#!/bin/bash
set -euo pipefail
var_nfs=**UPDATE_TO_MYOWN_NFS:MYOWN_NFS_SHARE**  # e.g. 192.168.0.100:/nfs
var_local=**UPDATE_TO_MYOWN_LOCAL_MOUNTPOINT** # e.g. /mnt/nfs
var_hostname=$(hostname -I | awk '{print $1}')-$(hostname -s)  #first ip and host shortname
var_date=$(date +%F)
var_type=nfs4
var_type_count=1
var_starttime=$(date +%s)
var_nfstimeout=5
###

if [[  $# < 1 ]]; then
  echo "
usage:
=== 
$0 folder1 folder2 .. folderN (max value of N is 9)
i.g. $0 /etc /opt
script will tar folder to ${var_nfs} as a backup"
  exit 1
fi

[ ! -d ${var_local} ] && echo "nfs mount point:${var_local} was not found"  && exit 2

timeout ${var_nfstimeout} mount -t nfs  ${var_nfs} ${var_local}
# auto exit if timeout for nfsmount
#[ $? -ne 0 ] && echo "nfs server: ${var_nfs} not found"  && exit 3

if [[ $(mount | grep  ${var_local} | grep -c ${var_type}) == ${var_type_count}  ]] ; then
  for var_src_folder in "$@" ; do
     var_src_folder_dash=$(echo ${var_src_folder} | tr '/' _)         
     var_backup_name=${var_local}/${var_hostname}-${var_src_folder_dash}-${var_date}.tgz 
     echo "tar backup ${var_src_folder} to ${var_backup_name}"
     tar czf ${var_backup_name} ${var_src_folder}
  done
fi

umount ${var_local}
echo "execute time: $(( $(date +%s) - ${var_starttime} )) seconds"
