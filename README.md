JBoss BPM Suite Rewards Demo
============================


Quickstart
----------

1. Clone project.

2. Add products to installs directory.

3. Run 'init.sh'.

4. Start JBoss BPMS Server by running 'standalone.sh' or 'standalone.bat' in the <path-to-project>/target/jboss-eap-6.1/bin directory.

5. Login to http://localhost:8080/business-central  (u:erics / p:bpmsuite).

6. Rewards demo pre-installed as project.

8. Read the documentation found in the docs directory & enjoy JBoss BPM Suite!


Notes
-----

This project is pre-loaded into the JBoss BPM Suite, after starting it you can login,
examine the rule, process, and data model from within the various product components.
You can then build and deploy the project, thereby generating the kjar maven artifact 
that the developer team needs to begin working on any application using this projects
knowledge artifacts.

Once you setup the project in JBoss Developer Studio (see the docs), you can use maven 
to pull in the kjar dependency, then examine the unit tests to discover how an application
can interact with a knowledge project (rules, processes, and model).


Released versions
-----------------

See the tagged releases for the following versions of the product:

- v1.0 - JBoss BPM Suite 6.0.1.GA, JBoss EAP 6.1.1, and migrated from BRMS 5.3.



![Process](https://github.com/eschabell/bpms-rewards-demo/blob/master/docs/demo-images/rewards-process.png?raw=true)

![Process & Task Dashboard](https://github.com/eschabell/bpms-customer-evaluation-demo/blob/master/docs/demo-images/mock-bpm-data.png?raw=true)

![Install Console](https://github.com/eschabell/bpms-customer-evaluation-demo/blob/master/docs/demo-images/install-console.png?raw=true)

