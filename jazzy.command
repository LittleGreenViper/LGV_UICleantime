#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"

echo "Creating Docs for the LGV_UICleantime Library\n"
rm -drf docs/*

jazzy  --readme ./README.md \
       --github_url https://github.com/LittleGreenViper/LGV_UICleantime \
       --title "LGV_UICleantime Doumentation" \
       --min_acl public \
       --theme fullwidth \
       --module LGV_UICleantime \
       --xcodebuild-arguments -project,LGV_UICleantime.xcodeproj,-scheme,LGV_UICleantime,-destination,generic/platform=iOS,CODE_SIGNING_ALLOWED=NO,CODE_SIGNING_REQUIRED=NO,CODE_SIGN_IDENTITY=
cp ./img/* docs/img
