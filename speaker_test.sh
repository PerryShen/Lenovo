#!/bin/bash

ssh_cmd=" ssh -i /home/perryshen/Speaker_Mini_id_rsa root@"          #root前面的是我的主机的目录。
path=/home/perryshen/speaker_auto_test/                                  #varible path
log_file=auto_test.log                                             #varible log file 





cnt=0
#let max=12*60*3
let max=3

speaker_1=192.168.31.71
speaker_2=
speaker_3=
num=1                                           #标志有多少个音响参与测试，下面的循环也都是为了遍历这几个音响


#定义了一堆变量，音箱个数，各个音箱对应的IP地址


#cat /data/messages | grep "NLU select111" | awk 'BEGIN{FS="\"input\":"}{print $2}' | cut -d , -f 1 | sed 's/^[ \t]*//g' | awk 'END {print}'    
#cat /data/messages | grep "VoiceEngine receive00" | awk 'BEGIN{FS="\"input\":"}{print $2}' | cut -d , -f 1 | awk 'END {print}'
#sed -r 's/(.*"input":)([^; ]+)(.*)/\2/g'                          


time=`date '+%Y%m%d%H%M%S'` #取完之后就不会变，下面遇到的也就是用这个值，不会log文件的名字一直变

touch ${path}${time}_${log_file}
>${path}${time}_${log_file}


upload_speaker_log ()                                                        #上传音箱日志，
{
    #上传测试设备log
    for i in $(seq 1 $num)                                                  #seq是序列的意思，i从1到$num 
    do
        speaker_num=speaker_$i
        ip=`eval echo '$'"$speaker_num"`                                    #单引号会忽略所有特殊字符的含义，先命令替换，再执行，该命令至今无法解释，结果是可以实现的
        $ssh_cmd$ip "logMonitor start" >> ${path}${time}_${log_file}        #logMonitor start是一个脚本，在音箱端执行这个脚本能够把音箱的messages传到云端。
    done
}


trigger_rate_test ()
{
    echo "trigger rate test start..." >> ${path}${time}_${log_file}
    while true
    do
        echo "******************************" >> ${path}${time}_${log_file}
        date >> ${path}${time}_${log_file}
        cvlc --play-and-exit $1 2>&1 &>/dev/null                                                     #
        if [ $? -ne 0 ]; then                                                       #播放音频命令运行失败
            echo "cvlc play trigger audio error" >> ${path}${time}_${log_file}
        fi
	
        sleep 10s
        let cnt++                                                                   #播放次数计数
        echo "play trigger audio cnt: $cnt" >> ${path}${time}_${log_file}
        if [ $cnt -gt $max ]; then                                                  #超过最大计数次数，就跳出循环，否则每隔20秒循环一次，计数值加1.
            break
        fi
    done

    #查看测试结果
    for i in $(seq 1 $num)
    do
	echo        
	echo >>${path}${time}_${log_file}
	echo "speaker_$i trigger count... ..."
	echo "speaker_$i trigger count:" >> ${path}${time}_${log_file}
        speaker_num=speaker_$i
        ip=`eval echo '$'"$speaker_num"`
        $ssh_cmd$ip "cat /data/messages | grep \"trigger start\" | wc -l" >> ${path}${time}_${log_file}        #查看测试结果，将测试结果输入本地日志文件
	$ssh_cmd$ip "cat /data/messages | grep \"trigger start\" | wc -l"
    done
	echo "Done" 
	echo "Done" >> ${path}${time}_${log_file}
}

trigger_fault_rate_test ()
{
    echo "trigger fault rate test start..." >> ${path}${time}_${log_file}
    date >> ${path}${time}_${log_file}
    cvlc --play-and-exit $1

    #查看测试结果
    for i in $(seq 1 $num)
    do
        echo "speaker$i trigger count:" >> ${path}${time}_${log_file}
        speaker_num=speaker_$i
        ip=`eval echo '$'"$speaker_num"`          #先把eval拿掉试试，这里是两次变量引用
        $ssh_cmd$ip "cat /data/messages | grep \"trigger start\" | wc -l" >> ${path}${time}_${log_file}
    done
}


asr_nlu_test ()
{
    echo "asr nlu test start..." >> ${path}${time}_${log_file}
    #while true
    #do
        flist=`ls $1`                                      #这么写的话，传递的参数应该是一个路径
        cd $1
        for file in $flist
        do
            if [ -d "$file" ]; then
                asr_nlu_test $file                         #函数的递归调用，直到$file是一个文件，才开始用这个音频文件进行测试
            else
                # date 2>&1 | tee ${path}${time}_${log_file}                #将该时刻的时间同时输出到log文件和终端
		#echo " 进入了子文件夹,该文件夹只包含音频语料，不再有子文件夹"   #这一句是为了向屏幕终端上输出测试的信息，因为甘爽要做一个demo，最好在记录log的同时在终端上显示现在在干嘛，当然最后是可
							                        #以去log中查看抓取的记录。下面有好多语句，也是这个作用再向本地log中写记录时，同时输出到终端，而且输出端终端的信息更多
                #trigger
                echo "******************************" >> ${path}${time}_${log_file}
                echo "******************************"
	        echo "play trigger" >> ${path}${time}_${log_file}
		echo "play trigger... ...播放唤醒预料“你好联想”"
                cvlc --play-and-exit /home/perryshen/你好联想.wav 2>&1 &>/dev/null             #先将音箱唤醒
                sleep 2s                                                          #不用延时，这会导致唤醒和命令之间的时间间隔超出音箱愿意等待的时间。

               
	        date >> ${path}${time}_${log_file}
	        echo "$data"
	        echo "play $file" >> ${path}${time}_${log_file}                    #这里面的play $file是将播放的文件的名称写进log
		echo "play $file"
                
                cvlc --play-and-exit $file  2>&1 &>/dev/null                                    #会有执行时间，这句执行完才能执行下一句，这里时间不是那么重要
                sleep 20s

                for i in $(seq 1 $num)                                             #队列处理几个音箱
                do
                    speaker_num=speaker_$i
                    ip=`eval echo '$'"$speaker_num"`
		    echo "Recording ASR_Result form the speaker log into native log... ..."
                    asr_rlt=`$ssh_cmd$ip "cat /data/messages | grep L_MSG_CB_NOTIFY_ASR_RESULT | sed -r 's/(.*\"input\":)([^ ]+)/\2/g' | cut -d , -f 1 | awk 'END {print}'"`
			echo "asr_result=$asr_rlt"	
		   # echo "Recording the NLU_Input derived from ASR_Result into native log from the speaker log... ..."
                   # nlu_input=`$ssh_cmd$ip "cat /data/messages | grep L_MSG_CB_NOTIFY_NLU_RESULT | sed -r 's/(.*\"input\":)([^ ]+)/\2/g' | cut -d , -f 1 | sed 's/^[ \t]*//g' | awk 'END {print}'"`
		  #	echo "nlu_input=$nlu_input"	
		    echo "Recording the NLU_Domain Judged from the NLU_Input and corresponding reply into the native log from the speaker log... ..."
                    nlu_domain=`$ssh_cmd$ip "cat /data/messages | grep L_MSG_CB_NOTIFY_NLU_RESULT | sed -r 's/(.*\"domain\":)([^ ]+)/\2/g' | cut -d , -f 1 | sed 's/^[ \t]*//g' | awk 'END {print}'"`
                    nlu_reply=`$ssh_cmd$ip "cat /data/messages | grep L_MSG_CB_NOTIFY_NLU_RESULT | sed -r 's/(.*\"reply\":)([^ ]+)/\2/g' | cut -d , -f 1 | sed 's/^[ \t]*//g' | awk 'END {print}'"`
			echo "nlu_domain=$nlu_domain"
			echo "nlu_reply=$nlu_reply"	
		  
		    echo "Recording the intent... ..."
		    intent=`$ssh_cmd$ip "cat /data/messages | grep L_MSG_CB_NOTIFY_NLU_RESULT | sed 's/.*\"intent\"://g' | cut -d , -f 2 | cut -d ']' -f 1 | awk 'END{print}'"`
			echo "intent=$intent"
		    echo "Recording the audio file name we triggered into the native log for the later comparision... ..."
                    asr_org=`echo $file | cut -d . -f 2 | cut -d . -f 1`

		    asr_org="\"$asr_org\""           #给变量asr_org加上双引号，因为asr_rlt、nlu_input、nlu_domain、nlu_reply都加上了双引号

			echo "asr_org=$asr_org"                    
			
                    echo "asr_result=$asr_rlt" >> ${path}${time}_${log_file}
                    echo "nlu_input=$nlu_input" >> ${path}${time}_${log_file}
                    echo "nlu_domain=$nlu_domain" >> ${path}${time}_${log_file}
                    echo "nlu_reply=$nlu_reply" >> ${path}${time}_${log_file}
		    echo "intent=$intent" >> ${path}${time}_${log_file}
                    echo "asr_org=$asr_org" >> ${path}${time}_${log_file}
		    echo "All the Recordig work has been done!! "

                    if [ $asr_org == $asr_rl ]; then                                        #计算机播放的原始的音频和音箱识别出来的音频进行比较,装意这两个字串的比较不能有空的字符
                        echo "speaker$i ASR_asr Succeeded =1" >> ${path}${time}_${log_file} 
               	    	echo "speaker$i ASR Succeeded"
		    else
			echo "speaker$i ASR_asr Failed =0" >> ${path}${time}_${log_file} 
			echo "speaker$i ASR Failed"
		    fi

                done
		echo   #输出空行
		echo
		echo >> ${path}${time}_${log_file}
            fi
        done
	cd ../
    #done
}
#cat /data/messages 作用是输出整个文本
#grep \"VoiceEngine receive00\" 是为了抓出这一行；
#sed -r 's/(.*\"input\":)([^; ]+)(.*)/\2/g' 是为了拿出关键词到最后的部分
#cut -d , -f 1 是为了拿出关键词的部分
#awk 'END {print}' 是为了将最后一个部分的结果输出，否则会输出所有带有关键词的行的相应部分。


: '
#reboot speaker
for i in $(seq 1 $num)
do
    echo "reboot speaker"

    speaker_num=speaker_$i
    echo $speaker_num
    ip=`eval echo '$'"$speaker_num"`
    echo $ip
    $ssh_cmd$ip "reboot"
done

sleep 60s
'
#首先要远程删除音箱中的messageslog文件
delete_messages ()                                                       
{
    for i in $(seq 1 $num)                                                  
    do
        speaker_num=speaker_$i
        ip=`eval echo '$'"$speaker_num"`                                    
        $ssh_cmd$ip "rm /data/messages*"        
     echo "the old messages file of speaker_$i has been deleted !"
     echo "the old messages file of speaker_$i has been deleted !" >>${path}${time}_${log_file}
    done

}

delete_messages

#播放音源
if [ $1 = "trigger-rate" ]; then
    trigger_rate_test $2
elif [ $1 = "trigger-fault-rate" ]; then
    trigger_fault_rate_test $2
elif [ $1 = "asr-nlu-test" ]; then
    echo "We are going to take the ASR-NLU_Test !"                                #$1是测试功能关键词，$2是音频文件
    asr_nlu_test $2                                                               #语音识别技术和自然语言理解
fi

#上传音箱的log文件messages到云端，作为排查问题的依据，后续再一次执行这个程序的时候会把log文件messages删除，重建一个新的
upload_speaker_log

