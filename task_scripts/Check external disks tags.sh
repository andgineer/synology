if [ ! -d "/volumeUSB4/usbshare/_tag_backup_box" ]; then
  echo "wrong backup_box"
  exit 1
fi
if [ ! -d "/volumeUSB2/usbshare/_tag_backup_video" ]; then
  echo "wrong backup_video"
  exit 1
fi
if [ ! -d "/volumeUSB5/usbshare/_tag_backup_series" ]; then
  echo "wrong backup_series"
  exit 1
fi
if [ ! -d "/volumeUSB3/usbshare/_tag_series2" ]; then
  echo "wrong series2"
  exit 1
fi
if [ ! -d "/volumeUSB1/usbshare1-2/_tag_backup_pc" ]; then
  echo "wrong backup_pc"
  exit 1
fi

