#!/bin/sh

# List of all detected disks
DRIVES=$(sysctl -n kern.disks | tr ' ' '\n' | grep '^ada\|^da' | sort)

# Output Zabbix LLD discovery
echo "{"
echo "  \"data\":["

FIRST=1
for DRIVE in $DRIVES; do
  if [ $FIRST -eq 0 ]; then
    echo ","
  fi
  FIRST=0
  echo "    { \"{#DISKNAME}\": \"$DRIVE\" }"
done

echo "  ]"
echo "}"
