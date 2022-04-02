#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"

echo "Creating Docs for the LGV_UICleantime Library\n"
rm -drf docs/*

jazzy  --readme ./README.md \
       --build-tool-arguments -scheme,"LGV_UICleantime",-target,"LGV_UICleantime" \
       --github_url https://github.com/LittleGreenViper/LGV_UICleantime \
       --title "LGV_UICleantime Doumentation" \
       --min_acl public \
       --theme fullwidth
cp ./icon.png docs/
cp ./img/* docs/img
