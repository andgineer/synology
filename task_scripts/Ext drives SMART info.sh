EXIT=0

for i in $(seq 5); do
  smartctl -a /dev/usb$i -d sat | grep "\(Start_Stop\|Raw_Read\|Seek_Error\|Retract\|Serial\|overall-health\)" | awk '{printf "%25s\t%s\n", $2, $NF}'
  echo
done

exit $EXIT