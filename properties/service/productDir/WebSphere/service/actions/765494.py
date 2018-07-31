import sys

# The function that actually reads and modifies the metadata_cei.xml file. The exception handling is taken care to check
# existing of file and ability to read/write file etc.
def modifyFile():
	fileName  =  sys.argv[0]
	print "fileName:",fileName
	found = 0
	fileReadingError = 0
	strToFind = "<context-name>clusters</context-name>"
	strAddIndex = "</contexts>"

	listToAdd = ['              <context>\n',
				 '                     <context-name>clusters</context-name>\n',
				 '                     <child-document-names>\n',
				 '                            <child-document-name>Resources-CEI</child-document-name>\n',
				 '                     </child-document-names>\n',
				 '              </context>\n',
				 '       </contexts>\n']


	try:
		my_file_to_read = open(fileName,"r")
		listOfLines = my_file_to_read.readlines()
		my_file_to_read.close()
	except:
		fileReadingError = 1

	if fileReadingError == 0:

		for line in listOfLines:
			if line.find(strToFind) != -1:
				found = 1
				break

		listOfLinesInNewFile = []

		if found == 0:

			print "Changes required for the file are not present. Hence modifying the file"
			for line in listOfLines:
				if line.find(strAddIndex) == -1:
					listOfLinesInNewFile.append(line)
				else:
					listOfLinesInNewFile.extend(listToAdd)
			try:
				my_file_to_write = open(fileName,"w")
				my_file_to_write.writelines(listOfLinesInNewFile)
				my_file_to_write.close()
				print "Successfully updated the file"
				return 0
			except:
				print "Error updating (or) writing to the file"
				return 1

		else:
			print "Changes required for the file are present already. Hence skipping the file for modification"
			return 0

	else:
		print "Not able to read the file metadata_cei.xml. Hence skipping the file for modification"
		return 0

# Execute the main procedure (script execution begins here)
modifyFile()
