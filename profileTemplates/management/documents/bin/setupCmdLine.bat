SET WAS_USER_SCRIPT=$(instance.script)
SET USER_INSTALL_ROOT=$(instance.root)
SET WAS_HOME=$(was.install.root)
CALL "%~dp0sdk\_setupSdk.bat"
REM SET JAVA_HOME=%WAS_HOME%\java
SET WAS_CELL=$(cell.name)
SET WAS_NODE=$(node.name)

REM Set the default OSGI -X and -D java ARGS.
SET OSGI_INSTALL=-Dosgi.install.area="%WAS_HOME%"
SET OSGI_CFG=-Dosgi.configuration.area="%USER_INSTALL_ROOT%"\configuration

SET ITP_LOC=%WAS_HOME%\deploytool\itp
REM SET CONFIG_ROOT=%WAS_HOME%\config
SET CONFIG_ROOT=%USER_INSTALL_ROOT%\config
SET CLIENTSAS=-Dcom.ibm.CORBA.ConfigURL=file:%USER_INSTALL_ROOT%/properties/sas.client.props
SET CLIENTSOAP=-Dcom.ibm.SOAP.ConfigURL=file:%USER_INSTALL_ROOT%/properties/soap.client.props
SET CLIENTIPC=-Dcom.ibm.IPC.ConfigURL=file:%USER_INSTALL_ROOT%/properties/ipc.client.props
SET CLIENTSSL=-Dcom.ibm.SSL.ConfigURL=file:%USER_INSTALL_ROOT%/properties/ssl.client.props
SET JAASSOAP=-Djava.security.auth.login.config=%USER_INSTALL_ROOT%/properties/wsjaas_client.conf
SET WAS_EXT_DIRS=%JAVA_HOME%\lib;%WAS_HOME%\classes;%WAS_HOME%\lib;%WAS_HOME%\installedChannels;%WAS_HOME%\lib\ext;%WAS_HOME%\web\help;%ITP_LOC%\plugins\com.ibm.etools.ejbdeploy\runtime
REM SET WAS_BOOTCLASSPATH=
REM SET CLIENT_CONNECTOR_INSTALL_ROOT=%WAS_HOME%\installedConnectors
SET CLIENT_CONNECTOR_INSTALL_ROOT=%USER_INSTALL_ROOT%\installedConnectors

SET WAS_CLASSPATH=%WAS_HOME%\properties;%WAS_HOME%\lib\startup.jar;%WAS_HOME%\lib\bootstrap.jar;%WAS_HOME%/lib/lmproxy.jar;%WAS_HOME%/lib/urlprotocols.jar;%JAVA_HOME%\lib\tools.jar
SET WAS_PATH=%JAVA_NATIVE_LIB_DIR%;%WAS_HOME%\bin;%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;%PATH%
SET FFDCLOG=%USER_INSTALL_ROOT%/logs/ffdc/
SET WAS_LOGGING=-Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager -Djava.util.logging.configureByServer=true

SET QUALIFYNAMES=

