date
SERIES2=$(rsync --recursive --checksum --dry-run --delete --info=NAME --exclude @eaDir --exclude .DS_Store /volumeUSB3/usbshare/video/series/ /volumeUSB4/usbshare/backup_series2)
date

if [[ $SERIES2 ]]; then
  echo $SERIES2
  exit 1
fi
