#!/bin/bash
java \
     -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true \
     -jar Mars.jar "$@"
