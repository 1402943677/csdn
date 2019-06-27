#!/bin/bash
#定义博客前缀
owner="https://blog.csdn.net/xxx/article/list/"
#定义文章列表页数
page=3
#定义访问次数
times=500

WORKSPACE='./'
mkdir -p $WORKSPACE
touch $WORKSPACE/url.txt
#获取改用户所有文章列表
for i in `seq $page`; do
{
    owner_url=$owner$i
    echo "抓取网址："$owner_url
    curl $owner_url >> index.txt
}
done
#清洗出改用户所有文章链接
grep -o "\"https://blog.csdn.net/xxx/article/details.*\"" index.txt | awk -F "target" '{gsub("\"","",$1);print $1 >> ".//url.txt"}'

#对所有文章链接排序去除
sort -n url.txt | uniq | tee .//url_uniq.txt >/dev/null 2>&1

#将所有链接添加到数组
url_list=(`awk '{print $0}' url_uniq.txt`) 

count=1;
for i in `seq $times`; do
    for url in ${url_list[@]}; do
    {   
        curl $url >/dev/null 2>&1
        echo "访问链接："$url
    } 
    done
    echo "第"$count"次"
    ((count++))
    sleep 30s
done
