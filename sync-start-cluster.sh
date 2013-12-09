#!/bin/bash
hosts[0]=Fedora4-Master.libint.unc.edu # used as initial host for jgroups
hosts[1]=Fedora4-1.libint.unc.edu
hosts[2]=Fedora4-2.libint.unc.edu
hosts[3]=Fedora4-3.libint.unc.edu
hosts[4]=Fedora4-4.libint.unc.edu
hosts[5]=Fedora4-5.libint.unc.edu
hosts[6]=Fedora4-6.libint.unc.edu
hosts[7]=Fedora4-7.libint.unc.edu

CLUSTER_SIZE=3
INSTALL_DIR=/data # you need write permissions
STORE_FAST=target/stores # if you move these stores, you must clean them up
STORE_SLOW=target/stores
INITIAL_IP=`nslookup ${hosts[0]} | tail -2 | awk -F ": " '{print $2}'`

mvn -U clean package

for i in ${hosts[*]}
do
  echo STOPPING $i
  ssh $i "killall java"
done

for i in ${hosts[*]}
do
  echo "SYNCING $i"
  rsync -ar . $i:$INSTALL_DIR/fcrepo-test-profiles
  ssh $i "rm -rf --preserve-root $INSTALL_DIR/fcrepo-test-profiles/target"
done

for i in $(seq 0 $CLUSTER_SIZE)
do
  echo "STARTING ${hosts[$i]}"
  IP=`nslookup ${hosts[$i]} | tail -2 | awk -F ": " '{print $2}'`
#  IP=${hosts[$i]}
  ssh ${hosts[$i]} "cd $INSTALL_DIR/fcrepo-test-profiles; nohup mvn -U -P $1 -Dhost.ip=$IP -Dfcrepo.store.fast=$STORE_FAST -Dfcrepo.store.slow=$STORE_SLOW -Djgroups.tcpping.initial_hosts=$INITIAL_IP[7800] clean compile cargo:run > $INSTALL_DIR/out.log 2> $INSTALL_DIR/err.log < /dev/null &"
done

echo "$CLUSTER_SIZE nodes started with profiles: $1"
