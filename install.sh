#!/bin/sh
workDir=`pwd`
unpackDir="/usr/local/bigdata"
downloadDir="${workDir}/download"

Yum() {
	yum update
}

FILES=(
	"https://file.s3.didiyunapi.com/java/jdk-8u212-linux-x64.rpm,jdk8_x64.rpm"
	"https://file.s3.didiyunapi.com/java/jdk-8u212-linux-x64.tar.gz,jdk8_x64.tar.gz,jdk8_x64:z"
	"https://file.s3.didiyunapi.com/zookeeper/apache-zookeeper-3.5.5-bin.tar.gz,zookeeper.tar.gz,zookeeper:z"
	"https://file.s3.didiyunapi.com/hadoop/hadoop-3.2.1.tar.gz,hadoop.tar.gz,hadoop:z"
	"https://file.s3.didiyunapi.com/hbase/hbase-2.2.1-bin.tar.gz,hbase.tar.gz,hbase:z"
	"https://file.s3.didiyunapi.com/hive/apache-hive-3.1.2-bin.tar.gz,hive.tar.gz,hive:z"
	"https://file.s3.didiyunapi.com/hbase/hbase-1.4.10-bin.tar.gz,hbase-1.4.tar.gz,hbase-1.4:z"
	"https://file.s3.didiyunapi.com/phoenix/apache-phoenix-4.14.3-HBase-1.4-bin.tar.gz,phoenix.tar.gz,phonenix:z"
)


Download() {
	mkdir -p $downloadDir
	for file in ${FILES[*]};
	do
		arr=(${file//,/ })
		url=${arr[0]}
		name=${arr[1]}
		if [ ! -f $downloadDir/$name ]; then
			wget $url -O $downloadDir/$name
		fi
	done
}

Unpack() {
	for file in ${FILES[*]};
	do
		arr1=(${file//,/ })
		
		name=${arr1[1]}
		opt=${arr1[2]}
		
		opt_arr=(${opt//:/ })
		opt_dir=${opt_arr[0]}
		opt_mode=${opt_arr[1]}
		
		if [ ! -d $unpackDir/$opt_dir ]; then
			if [ $opt_mode == 'z' ] ; then
				mkdir -p $unpackDir/$opt_dir
				tar -zxf $downloadDir/$name -C $unpackDir/$opt_dir --strip 1
			fi
		fi
	done
}

Init() {
	export JAVA_HOME=$unpackDir/jdk_x64
	export PATH=$unpackDir/hbase/bin:$JAVA_HOME/bin:$unpackDir/zookeeper/bin:$PATH
}

Download
Unpack
