#!/bin/sh 
DEMO="Rewards Demo"
AUTHORS="Andrew Block, Eric D. Schabell"
PROJECT="git@github.com:jbossdemocentral/bpms-rewards-demo.git"
PRODUCT="JBoss BPM Suite"
JBOSS_HOME=./target/jboss-eap-6.1
SERVER_DIR=$JBOSS_HOME/standalone/deployments
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
BPMS=jboss-bpms-installer-6.0.3.GA-redhat-1.jar
VERSION=6.0.3

# wipe screen.
clear 

echo
echo "#################################################################"
echo "##                                                             ##"   
echo "##  Setting up the ${DEMO}                                ##"
echo "##                                                             ##"   
echo "##                                                             ##"   
echo "##     ####  ####   #   #      ### #   # ##### ##### #####     ##"
echo "##     #   # #   # # # # #    #    #   #   #     #   #         ##"
echo "##     ####  ####  #  #  #     ##  #   #   #     #   ###       ##"
echo "##     #   # #     #     #       # #   #   #     #   #         ##"
echo "##     ####  #     #     #    ###  ##### #####   #   #####     ##"
echo "##                                                             ##"   
echo "##                                                             ##"   
echo "##  brought to you by,                                         ##"   
echo "##             ${AUTHORS}                  ##"
echo "##                                                             ##"   
echo "##  ${PROJECT}      ##"
echo "##                                                             ##"   
echo "#################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$BPMS ] || [ -L $SRC_DIR/$BPMS ]; then
		echo Product sources are present...
		echo
else
		echo Need to download $BPMS package from the Customer Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# Move the old JBoss instance, if it exists, to the OLD position.
if [ -x $JBOSS_HOME ]; then
		echo "  - existing JBoss product install detected..."
		echo
		echo "  - moving existing JBoss product install moved aside..."
		echo
		rm -rf $JBOSS_HOME.OLD
		mv $JBOSS_HOME $JBOSS_HOME.OLD
fi

# Run installer.
echo Product installer running now...
echo
java -jar $SRC_DIR/$BPMS $SUPPORT_DIR/installation-bpms -variablefile $SUPPORT_DIR/installation-bpms.variables

if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation!
	exit
fi

echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
cp $SUPPORT_DIR/application-roles.properties $SERVER_CONF

echo "  - setting up demo projects..."
echo
cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit

echo "  - setup email task notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/business-central.war/WEB-INF/classes/

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo
echo "========================================================================"
echo "=                                                                      ="
echo "=  You can now start the $PRODUCT with:                         ="
echo "=                                                                      ="
echo "=   $SERVER_BIN/standalone.sh                           ="
echo "=                                                                      ="
echo "=  Login into business central at:                                     ="
echo "=                                                                      ="
echo "=    http://localhost:8080/business-central  (u:erics / p:bpmsuite1!)  ="
echo "=                                                                      ="
echo "=  If you want to see email notifications on user tasks, you will      ="
echo "=  need to have a mail server running to accept SMTP requests on       ="
echo "=  the default port 25. We include fakeSMTP java solution for you      ="
echo "=  to capture email notifications, just start as root:                 ="
echo "=                                                                      ="
echo "=    $ sudo java -jar support/fakeSMTP.jar                             ="
echo "=                                                                      ="
echo "=  Be sure to start it by clicking on 'START SERVER' to avoid any      ="
echo "=  connection errors when email notifications are triggered. Note      ="
echo "=  that these errors will not stop the process from running.           ="
echo "=                                                                      ="
echo "=  $PRODUCT $VERSION $DEMO Setup Complete.            ="
echo "=                                                                      ="
echo "========================================================================"

