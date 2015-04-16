@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=Rewards Demo
set AUTHORS=Andrew Block, Eric D. Schabell
set PROJECT=git@github.com:jbossdemocentral/bpms-rewards-demo.git
set PRODUCT=JBoss BPM Suite
set JBOSS_HOME=%PROJECT_HOME%target\jboss-eap-6.4
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%installs
set SUPPORT_DIR=%PROJECT_HOME%support
set PRJ_DIR=%PROJECT_HOME%projects
set BPMS=jboss-bpmsuite-6.1.0.GA-installer.jar
set EAP=jboss-eap-6.4.0-installer.jar
set VERSION=6.1

REM wipe screen.
cls

echo.
echo #################################################################
echo ##                                                             ##   
echo ##  Setting up the %DEMO%                                ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##     ####  ####   #   #      ### #   # ##### ##### #####     ##
echo ##     #   # #   # # # # #    #    #   #   #     #   #         ##
echo ##     ####  ####  #  #  #     ##  #   #   #     #   ###       ##
echo ##     #   # #     #     #       # #   #   #     #   #         ##
echo ##     ####  #     #     #    ###  ##### #####   #   #####     ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##  brought to you by,                                         ##   
echo ##   %AUTHORS%                            ##
echo ##                                                             ##   
echo ##  %PROJECT%      ##
echo ##                                                             ##   
echo #################################################################
echo.

REM make some checks first before proceeding.	
if exist %SRC_DIR%\%EAP% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %EAP% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist %SRC_DIR%\%BPMS% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %BPMS% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

REM Remove the old JBoss instance, if it exists.
if exist %JBOSS_HOME% (
         echo - removing existing JBoss product install...
         echo.
         rmdir /s /q "%JBOSS_HOME%"
 )

REM Run installers.
echo EAP installer running now...
echo.
call java -jar %SRC_DIR%/%EAP% %SUPPORT_DIR%\installation-eap -variablefile %SUPPORT_DIR%\installation-eap.variables

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Installation!
	echo.
	GOTO :EOF
)

echo JBoss BPM Suite installer running now...
echo.
call java -jar %SRC_DIR%/%BPMS% %SUPPORT_DIR%\installation-bpms -variablefile %SUPPORT_DIR%\installation-bpms.variables

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During %PRODUCT% Installation!
	echo.
	GOTO :EOF
)

echo - enabling demo accounts role setup in application-roles.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"
echo. 

echo - setting up demo projects...
echo.

mkdir "%SERVER_BIN%\.niogit\"
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-niogit\*" "%SERVER_BIN%\.niogit\"
mkdir "%SERVER_BIN%\.index\"

REM Optional: uncomment to make use of the mock data.
REM
REM echo - setting up mock bpm dashboard data...
REM echo.
REM xcopy /Y /Q "%SUPPORT_DIR%\1000_jbpm_demo_h2.sql" "%SERVER_DIR%\dashbuilder.war\WEB-INF\etc\sql"
REM echo. 

echo - setup email task notification users...
echo.
xcopy "%SUPPORT_DIR%\userinfo.properties" "%SERVER_DIR%\business-central.war\WEB-INF\classes\"

echo - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone.xml" "%SERVER_CONF%"
echo.

echo.
echo ========================================================================
echo =                                                                     =
echo =  You can now start the %PRODUCT% with:                         =
echo =                                                                      =
echo =   %SERVER_BIN%\standalone.sh                           =
echo =                                                                      =
echo =  Login into business central at:                                     =
echo =                                                                      =
echo =    http:\\localhost:8080\business-central  u:erics &  p:bpmsuite1!   =
echo =                                                                      =
echo =  If you want to see email notifications on user tasks, you will      =
echo =  need to have a mail server running to accept SMTP requests on       =
echo =  the default port 25. We include fakeSMTP java solution for you      =
echo =  to capture email notifications, just start as admin:                =
echo =                                                                      =
echo =    $ java -jar support\fakeSMTP.jar                                  =
echo =                                                                      =
echo =  Be sure to start it by clicking on 'START SERVER' to avoid any      =
echo =  connection errors when email notifications are triggered. Note      =
echo =  that these errors will not stop the process from running.           =
echo =                                                                      =
echo =  %PRODUCT% %VERSION% %DEMO% Setup Complete.            =
echo =                                                                      =
echo ========================================================================
echo.
