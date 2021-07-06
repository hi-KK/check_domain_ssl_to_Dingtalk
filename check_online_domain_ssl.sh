#!/bin/bash
# 检测https证书有效期
# 官方参考文档：https://developers.dingtalk.com/document/app/custom-robot-access

TOKEN="https://oapi.dingtalk.com/robot/send?access_token=钉钉token"


dir="/root/Check_domain_ssl"

for host in `cat ${dir}/check_online_domains.txt` #读取存储了需要监控的域名文件

do

 end_date=`date +%s -d "$(echo |openssl s_client -servername $host  -connect $host:443 2>/dev/null | openssl x509 -noout -dates|awk -F '=' '/notAfter/{print $2}')"`
 #当前时间戳
 
 new_date=$(date +%s) #计算SSL证书截止到现在的过期天数
 
 days=$(expr $(expr $end_date - $new_date) / 86400) #计算SSL正式到期时间和当前时间的差值
 
 if [ $days -lt 60 ]; #当到期时间小于n天时，发钉钉群告警
 
 then
 
    curl ${TOKEN} -H 'Content-Type: application/json' -X POST --data '{"msgtype":"text","text":{"content":"告警域名：'$host'    SSL证书即将到期，剩余：'$days' 天"} , "at": {"isAtAll": true}}'
    
 fi
 
done
