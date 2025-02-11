
# pfSense Zabbix Smart Monitoring

A Zabbix template for monitoring pfSense disk health with SMART metrics. It uses Zabbix LLD and bash scripts to track disk status.

Tested with pfSense 2.7.x, Zabbix 7.2.

## What It Does

- **Disk Discovery**  
  Scans your pfSense system to find disks.

- **SMART Metrics**  
  For each detected disk, it gathers:
  - **Device Model** – Identifies the disk.
  - **Capacity** – Shows capacity.
  - **SMART Health** – Checks overall SMART status.
  - **Predictive Failures** – Counts warnings flagged as `FAILING_NOW`.
  - **Self-Test Errors** – Counts any self-test errors.
  - **Temperature** – Shows the temperature.

- **Alerts**  
  Triggers notify you if:
  - The SMART status isnt PASSED.
  - Predictive failures or self-test errors are found.
  - The disk temperature exceeds 50°C.

## Setup

Download & Make Scripts Executable:
```
curl --create-dirs -o /root/scripts/smart_discovery.sh https://raw.githubusercontent.com/joelmeyerch/pfSense-Zabbix-SMART/refs/heads/main/smart_discovery.sh
curl --create-dirs -o /root/scripts/smart_monitor.sh https://raw.githubusercontent.com/joelmeyerch/pfSense-Zabbix-SMART/refs/heads/main/smart_monitor.sh
chmod +x /root/scripts/smart_discovery.sh /root/scripts/smart_monitor.sh
```
    
    
In pfSense, under **Advanced Features → User Parameters**, add:
    
```
AllowRoot=1
UserParameter=smart.discovery,/root/scripts/smart_discovery.sh
UserParameter=smart.device_model[*],/root/scripts/smart_monitor.sh $1 device_model
UserParameter=smart.capacity[*],/root/scripts/smart_monitor.sh $1 capacity
UserParameter=smart.health[*],/root/scripts/smart_monitor.sh $1 health
UserParameter=smart.predict[*],/root/scripts/smart_monitor.sh $1 predict
UserParameter=smart.errors[*],/root/scripts/smart_monitor.sh $1 errors
UserParameter=smart.temp[*],/root/scripts/smart_monitor.sh $1 temperature
```
    
Import & Link the Template in Zabbix:
  
- Import the `pfSense_Smart_Template.yaml` file.
- Link the template to your pfSense host.
- Run the discovery rule to see your disk items.


## Credits
Inspired by the [pfSense Zabbix Templates](https://github.com/rbicelli/pfsense-zabbix-template).  

Maintained by [joelmeyerch](https://github.com/joelmeyerch).
