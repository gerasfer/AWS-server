#!/bin/bash
set -euo pipefail
DB_NAME=wordpress_db
BUCKET=YOUR-BUCKET
TMP_DIR=/tmp
DATE=$(date +%F_%H-%M)
FILE=$TMP_DIR/${DB_NAME}_$DATE.sql.gz

mariadb-dump --single-transaction "$DB_NAME" | gzip > "$FILE"
gzip -t "$FILE"
aws s3 cp "$FILE" "s3://$BUCKET/db/"
rm -f "$FILE"
echo "$(date '+%F %T') OK $FILE" >> /var/log/db-backup.log
