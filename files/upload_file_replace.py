#!/usr/bin/env python
#
# b2 upload_file_replace <bucketName> <localFilePath> <b2FileName>
#

import json
import sys
import subprocess
import re

bucketName = sys.argv[2]
localFilePath = sys.argv[3]
remoteFilePath = sys.argv[4]

output = subprocess.check_output(["/entrypoint.sh", "upload_file", bucketName, localFilePath, remoteFilePath])
print output.replace('\n', '')

output = subprocess.check_output(["/entrypoint.sh", "list_file_versions", bucketName, remoteFilePath])
m = re.search('(\{.+\})', output.replace('\n', ''))
jsonText = m.group(0)

jsonObject = json.loads(jsonText)

fileIdToDelete = []
latestFile = jsonObject["files"][0]

for f in jsonObject["files"]:
    if f["uploadTimestamp"] >= latestFile["uploadTimestamp"]:
        latestFile = f
    else:
        fileIdToDelete.append(f["fileId"])

for fileId in fileIdToDelete:
    output = subprocess.check_output(["/entrypoint.sh", "delete_file_version", remoteFilePath, fileId])
    print output
