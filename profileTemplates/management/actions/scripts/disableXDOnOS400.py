#------------------------------------------------------------------------------
# disableXDOnOS400.py - profile creation script for disabling XD functionality on OS/400
#------------------------------------------------------------------------------
#
# Example:
# wsadmin.sh -conntype NONE -f disableXDOnOS400
#

import sys

lineSep = java.lang.System.getProperty('line.separator')

def disableXD():
	cell = AdminConfig.list('Cell')
	#print cell
	# create custom property to disable XD code 
	prop = AdminConfig.create("Property", cell, [['name', 'LargeTopologyOptimization'], ['value', 'false'], ['required', 'true']])
	print "Property created %s" % (prop)


#===============
# Main
#===============
disableXD()
AdminConfig.save()
