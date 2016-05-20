# ghettoVCB

### Description

The ghettoVCB script performs backups of virtual machines residing on ESX(i) 3.x, 4.x, 5.x & 6.x servers using methodology similar to VMware's VCB tool. The script takes snapshots of live running virtual machines, backs up the  master VMDK(s) and then upon completion, deletes the snapshot until the next backup. The only caveat is that it utilizes resources available to the ESXi Shell running the backups as opposed to following the traditional method of offloading virtual machine backups through a VCB proxy.

### How to install

You can quickly install ghettoVCB by downloading and install either the VIB or offline bundle using the following commands:

Install VIB
```
esxcli software vib install -v /vghetto-ghettoVCB.vib -f
```

Install offline bundle
```
esxcli software vib install -d /vghetto-ghettoVCB-offline-bundle.zip -f
```
Configure firewall rule 
```
<ConfigRoot>
  <service>
      <id>smtpout</id>
      <rule id="0000">
         <direction>outbound</direction>
         <protocol>tcp</protocol>
         <porttype>dst</porttype>
         <port>25</port>
      </rule>
         <enabled>true</enabled>
         <required>false</required>
  </service>
</ConfigRoot>


cp smtpout.xml /etc/vmware/firewall/smtpout.xml
```
```
esxcli network firewall refresh
```
```
esxcli network firewall ruleset list | grep smtp
```

Manually running backup
```
./ghettoVCB.sh -a (all vms)
./ghettoVCB.sh -f vmlistfile 
```
Setting up a cronjob
```
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

vi /var/spool/cron/crontabs/root
0    14   *   *   * /vmfs/volumes/backupdatastore/ghettoVCB.sh -f /vmfs/volumes/backupdatastore/vmlist  > /tmp/ghettoVCB.log
```
List installed vibs
```
esxcli software vib list |grep -i ghetto
ghettoVCB                      1.0.0-0.0.0                           virtuallyGhetto  CommunitySupported  2015-10-06  
```
Remove ghettoVCB
```
esxcli software vib remove --vibname=ghettoVCB
Removal Result
   Message: Operation finished successfully.
   Reboot Required: false
   VIBs Installed: 
   VIBs Removed: virtuallyGhetto_bootbank_ghettoVCB_1.0.0-0.0.0
   VIBs Skipped: 
```
To restore a vm manually


Note: Do not restore the -flat.vmdk. It will do that for you. 
```
rm original .vmdk files
vmkfstools -i <backup vmdk> <original vmdk>
```

### Additional Documentation & Resources
- [ghettoVCB Documentation](http://communities.vmware.com/docs/DOC-8760)
- [ghettoVCB VMTN Group](http://communities.vmware.com/groups/ghettovcb)
- [ghettoVCB Restore Documentation](http://communities.vmware.com/docs/DOC-10595)
