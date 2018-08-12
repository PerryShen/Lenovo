#!/bin/bash
name=20180810163229_auto_test.log

path=/home/perryshen/pythonprogram/                                  #varible path
asr_result=asr_result.log                                            #varible log file 
nlu_domain=nlu_domain.log
nlu_reply=nlu_reply.log
intent=intent.log
asr_org=asr_org.log
ASR_asr=ASR_asr.log

 cat $name | grep asr_result | sed  's/.*=//g' >  ${path}${asr_result}
 cat $name | grep nlu_domain | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${nlu_domain}
 cat $name | grep nlu_reply | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${nlu_reply}
 cat $name | grep intent | sed  's/.*=//g' > ${path}${intent}
 cat $name | grep asr_org | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${asr_org}
 cat $name | grep ASR_asr | sed -r 's/(.*=)([^ ]+)/\2/g' > ${path}${ASR_asr}

