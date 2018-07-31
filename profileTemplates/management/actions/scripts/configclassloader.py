
# Configure the WAS Class loader for single for the OTiS Application

dep = AdminConfig.getid("/Deployment:OTiS/")
deployedObject = AdminConfig.showAttribute(dep, "deployedObject")
AdminConfig.show(deployedObject, 'warClassLoaderPolicy')
# Change from default of MULTIPLE to SINGLE
AdminConfig.modify(deployedObject, [['warClassLoaderPolicy', 'SINGLE']])
AdminConfig.save()







