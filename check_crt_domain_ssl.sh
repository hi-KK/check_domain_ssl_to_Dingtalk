#!/bin/bash
# 检测https证书有效期
# 官方参考文档：https://developers.dingtalk.com/document/app/custom-robot-access

TOKEN="https://oapi.dingtalk.com/robot/send?access_token=钉钉token"

# 获取文件夹下所有文件

dir="/root/Check_domain_ssl/crt_all/" # 证书文件目录

files=$(ls $dir) # 遍历目录下所有文件名

for file in ${files}

do


 end_date=`date +%s -d "$(echo| openssl x509 -noout -in $dir$file -dates|awk -F '=' '/notAfter/{print $2}')"`
 # 获取证书过期当前时间戳
 
 new_date=$(date +%s) # 计算SSL证书截止到现在的过期天数
 
 days=$(expr $(expr $end_date - $new_date) / 86400) #计算SSL正式到期时间和当前时间的差值
 
 if [ $days -lt 35 ]; # 当到期时间小于n天时，发钉钉群告警,https://www.cnblogs.com/jjzd/p/6397495.html,https://www.jianshu.com/p/9f3017d966a4
 
 then
    #去掉file的后缀crt
    curl ${TOKEN} -H 'Content-Type: application/json' -X POST --data '{"msgtype":"text","text":{"content":"告警域名：'${file%.crt}'，SSL证书有效期剩余：'$days' 天！注意提前续签更新证书！"} , "at": {"isAtAll": true}}'
    
 fi
 
done
