#!/bin/bash
CLUSTER_PREFIX=Fedora4-
CLUSTER_SIZE=3
INSTALL_DIR=/data

# clean local project
killall java
sleep 20
cd $INSTALL_DIR/fcrepo-test-profiles
mvn clean
mvn -U package

# Shutdown local and remote services
for i in {1..3}
do
  echo "STOPPING $CLUSTER_PREFIX$i"
  ssh $CLUSTER_PREFIX$i "killall java"
  sleep 20
  echo "SYNCING $CLUSTER_PREFIX$i"
  rsync -ar $INSTALL_DIR/fcrepo-test-profiles $CLUSTER_PREFIX$i:$INSTALL_DIR
  rsync -ar ~/.m2 $CLUSTER_PREFIX$i:~
done

cd $INSTALL_DIR/fcrepo-test-profiles
mvn -P $1 -Dhost.ip=172.27.244.223 compile cargo:run > $INSTALL_DIR/out.log 2> $INSTALL_DIR/err.log < /dev/null &

for i in {1..3}
do
  echo "STARTING $CLUSTER_PREFIX$i"
#  IP=`nslookup Fedora4-1 | tail -2 | awk -F ": " '{print $2}'`
  IP=$CLUSTER_PREFIX$i
  ssh $CLUSTER_PREFIX$i "cd $INSTALL_DIR/fcrepo-test-profiles; nohup mvn -U -P $1 -Dhost.ip=$IP clean compile cargo:run > $INSTALL_DIR/out.log 2> $INSTALL_DIR/err.log < /dev/null &"
done

sleep 20

cd $INSTALL_DIR/fcrepo-test-profiles
mvn -P $1,workflow-profile -Dhost.ip=172.27.244.223 verify
