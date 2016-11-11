#!/bin/bash

DATE_STR=`date +%Y-%m-%d`

cp tempMarkdown $DATE_STR-$1
open -a "Sublime Text" /Users/Coupang/Documents/03.STUDY/Jekyll_Unclebae/_posts/$DATE_STR-$1
