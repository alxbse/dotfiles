#!/bin/bash

CMUS=`cmus-remote -C status`

if [ $? -eq 0 ]
then
  ARTIST=`echo $CMUS | grep artist`
  echo "<fn=1><fc=#00aa00></fc></fn> $ARTIST hello"
fi
