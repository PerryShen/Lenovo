#!usr/bin/python
# -*- coding: utf-8 -*-

#This script is going to extract information in certain log files, and to write them in EXCEL

import xlsxwriter                                                 
import linecache2 as linecache


workbook = xlsxwriter.Workbook('speaker_test.xlsx')               

worksheet = workbook.add_worksheet('asr-nlu-test')           

#using examples
#worksheet.write('A1', 'trigger times')                           # write somethong into A1
#count = linecache.getline(filename,linenum)                      #extract something of a certain line 
#str = linecache.getlines(filename)                               #get the log information by a list style,str is a list
#linenumbers=len(filename)                                        #probably to judge how many lines the log file has


#loops to read information from the log file into excel

str_asr_result = linecache.getlines('asr_result.log')                    #calculating that how many lines the log has
worksheet.write('A1','ASR_Result')
for i in range(len(str_asr_result)+1):
    worksheet.write('A%s'%(i+1),'%s'%linecache.getline('asr_result.log',i))  #Write the lines into the corresponding cell of a certain sheet in sequence                       

linecache.clearcache()                                                  #other operation about using linecache, somethong like clearing cache 


               

str_nlu_domain = linecache.getlines('nlu_domain.log')                    #calculating that how many lines the log has
worksheet.write('B1','NLU_Domain')
for i in range(len(str_nlu_domain)+1):
    worksheet.write('B%s'%(i+1),'%s'%linecache.getline('nlu_domain.log',i))  #Write the lines into the corresponding cell of a certain sheet in sequence                       

linecache.clearcache()


str_nlu_reply = linecache.getlines('nlu_reply.log')                    #calculating that how many lines the log has
worksheet.write('C1','NLU_Reply')
for i in range(len(str_nlu_reply)+1):
    worksheet.write('C%s'%(i+1),'%s'%linecache.getline('nlu_reply.log',i))  #Write the lines into the corresponding cell of a certain sheet in sequence                       

linecache.clearcache()

str_intent=linecache.getlines('intent.log')
worksheet.write('D1','Intent')
for i in range(len(str_intent)+1):
    worksheet.write('D%s'%(i+1),'%s'%linecache.getline('intent.log',i))
linecache.clearcache()

str_asr_org = linecache.getlines('asr_org.log')
worksheet.write('E1','ASR_Org')
for i in range(len(str_asr_org)+1):
    worksheet.write('E%s'%(i+1),'%s'%linecache.getline('asr_org.log',i))

linecache.clearcache()

str_ASR_asr=linecache.getlines('ASR_asr.log')
worksheet.write('F1','successful_or_not')
for i in range(len(str_ASR_asr)+1):
    worksheet.write('F%s'%(i+1),'%s'%linecache.getline('ASR_asr.log',i))

linecache.clearcache()




workbook.close() 




#2018-8-3 11:31:10
#Author: keshengshen@163.com
#Lenove, Audio Service Department, BSP Group  
