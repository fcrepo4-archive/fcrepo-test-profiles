fcrepo-test-profiles
====================

Runs fcrepo performance tests against a documented test profile.

Step-by-step
------------

1. Provision a bunch of cluster nodes with a jvm, mvn..
2. Currently you still need to clone and build the benchtool locally, since it is not in a maven repository.


On each node:
2. Edit your maven settings file, adding profile for local machine config:

    <profile>
      <id>localhost-config</id>
      <activation><activeByDefault>true</activeByDefault></activation>
      <properties>
        <!-- local node storage, by default within target -->
        <fcrepo.store.fast>target/stores</fcrepo.store.fast>
        <fcrepo.store.slow>target/stores</fcrepo.store.slow>
        <!-- your local node ip -->
        <jgroups.tcp.address>172.27.244.223</jgroups.tcp.address>
        <!-- your cluster host name, port -->
        <jgroups.tcpping.initial_hosts>Fedora4-Master.example.com[7800]</jgroups.tcpping.initial_hosts>
        <!-- cargo will give this much memory to the jetty container -->
        <max.memory>2g</max.memory>
      </properties>
    </profile>

3. Establish your storage location on nodes, some place like /data/tests
4. Clone this repository into your storage location:

        git clone https://github.com/gregjan/fcrepo-test-profiles
        
5. Run a maven build to verify it works:

        cd fcrepo-test-profiles
        mvn -U -P platform-cluster-baseline,repository-100o-50mb-3t clean verify
        
 This will start and stop the Fedora webapp within Jetty, giving it the chosen configuration profiles.
 
6. Run your tests by adding a workflow profile:

        mvn -U -P platform-cluster-baseline,repository-100o-50mb-3t,workflow-profile clean verify

