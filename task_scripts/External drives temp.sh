TH=40
EXIT=0

for i in $(seq 5); do
  USB[$i]=$(smartctl -a /dev/usb$i -d sat | grep "Temperature_Celsius" | awk '{print $NF}')
  if (( ${USB[$i]} >  $TH )); then
    EXIT=1
  fi
  echo "USB$i ${USB[$i]}"
done

exit $EXIT
