#!/bin/sh

DEVICE=$1
METRIC=$2

# Validate arguments
if [ -z "$DEVICE" ] || [ -z "$METRIC" ]; then
  echo "Usage: $0 <device> <metric>"
  echo "Metrics: device_model, capacity, health, predict, errors, temperature"
  exit 1
fi


# Basic Info (Model + Capacity)
MODEL=$(smartctl -i /dev/$DEVICE \
  | awk -F': ' '/Device Model/ {print $2}' \
  | sed 's/^ *//g')

CAPACITY=$(smartctl -i /dev/$DEVICE \
  | awk -F'[' '/User Capacity/ {print $2}' \
  | awk -F']' '{print $1}')

# Disk Health
HEALTH=$(smartctl -H /dev/$DEVICE \
  | awk '/overall-health self-assessment test result:/ {print $NF}')

# Predictive Failures
PREDICT=$(smartctl -A /dev/$DEVICE \
  | grep -c "FAILING_NOW")

# Self Test Errors
ERRORS=$(smartctl --log=selftest /dev/$DEVICE \
  | grep -i "error" \
  | wc -l)

# Disk Temperature
TEMP=$(smartctl -A /dev/$DEVICE \
  | awk '/Temperature_Celsius/ {print $10}')

[ -z "$TEMP" ] && TEMP="N/A"

# Output Metrics
case "$METRIC" in
  "device_model")   echo "$MODEL"       ;;
  "capacity")       echo "$CAPACITY"    ;;
  "health")         echo "$HEALTH"      ;;
  "predict")        echo "$PREDICT"     ;;
  "errors")         echo "$ERRORS"      ;;
  "temperature")    echo "$TEMP"        ;;
  *)
    echo "Unknown metric: $METRIC"
    exit 1
    ;;
esac
