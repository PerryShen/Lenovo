#!/bin/bash
name=20180810143558_auto_test.log

path=/home/perryshen/pythonprogram/                                  #varible path
asr_result=asr_result.log
songName=songName.log                                           #varible log file 
songId=songId.log       
artistName=artistName.log
artistId=artistId.log
reply=reply.log
asr_org=asr_org.log
ASR_asr=ASR_asr.log                                          #this log records the asr result 1/0

 cat $name | grep asr_result | sed  's/.*=//g' > ${path}${asr_result}
 cat $name | grep songName | sed -r 's/(.*=)([^ ]+)/\2/g' >  ${path}${songName}
 cat $name | grep songId | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${songId}
 cat $name | grep artistName | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${artistName}
 cat $name | grep artistId | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${artistId}
 cat $name | grep reply   | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${reply}
 cat $name | grep asr_org | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${asr_org}
 cat $name | grep ASR_asr | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${ASR_asr}
