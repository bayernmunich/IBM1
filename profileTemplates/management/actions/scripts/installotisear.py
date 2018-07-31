from java.lang import System
wasLocation = System.getProperty("was.install.root" )
wasLocation = wasLocation.replace( '\\', '/' )
print ("WAS Location: " + wasLocation )

AdminApp.install(  wasLocation  + '/systemApps/OTiS.ear', '[-server' 'jobmgr -zeroEarCopy -skipPreparation -appname OTiS -installed.ear.destination ' + "\"" + wasLocation + "/systemApps\"" + ']' )
AdminConfig.save()

# need code to start the application
