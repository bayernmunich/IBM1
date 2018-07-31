<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
								xmlns:ns="http://www.w3.org/1999/xhtml" 
								xmlns:rc="http://www.ibm.com/xmlns/prod/SystemsManagement/v2.0/ResourceCollection" 
								xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								version="1.0">
	<xsl:output encoding="utf-8" indent="yes" method="html" version="4.01" media-type="text/html" />
	
	<!-- Template to print an inventory section -->
	<xsl:template match="//rc:ResourceInstance">
		<xsl:param name="label_prop">name</xsl:param>
			<div class="key_identifier">
			<a onclick="toggleTable(this);" title="Collapse section">[-]</a>
				<xsl:choose>
					<xsl:when test="$label_prop = 'name'">
						<xsl:value-of select="./rc:Property[@name='Name']"/>
					</xsl:when>
					<xsl:when test="$label_prop = 'osTypeString'">
						<xsl:value-of select="./rc:Property[@name='OSTypeString']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="./rc:Property[@name='DisplayName']">
								<xsl:value-of select="./rc:Property[@name='DisplayName']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="./rc:Property[@name='Name']"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</div>

		<div class="inventory-props">
			<table><tbody>
				<xsl:for-each select="rc:Property">
					<tr>
						<td valign="top" width="145px"><strong><xsl:value-of select="@name" /></strong></td>
						<td><xsl:value-of select="rc:Value" /></td>
					</tr>
				</xsl:for-each>
			</tbody></table>
		</div>
	</xsl:template>
	
	
	<xsl:template match="rc:ResourceCollection">
		<html lang="en-US" xml:lang="en-US">
			<head profile="http://www.w3.org/2000/08/w3c-synd/#">
				<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
				<title>IBM Support Assistant Data Collector - Inventory</title>
			</head>
			<body id="ibm-com">
				<div id="ibm-top">
					<!-- MASTHEAD_BEGIN -->
					<div id="ibm-masthead">
						<!-- <div id="ibm-logo"><a href=""><img alt="IBM®" height="26" src="img/ibm-logo-small.gif" width="54"/></a></div> -->
						<div id="ibm-site-name">Inventory Information</div>
						<h1>IBM Support Assistant Data Collector</h1>
					</div>
					<!-- MASTHEAD_END -->
					
					<div id="ibm-content-main">
						<div id="isadc-inventory-nav">
							<ul>
								<li class="ibm-first">Inventory Information Types:</li>
								<li><a onclick="showSection('all')" >Show All</a></li>
								<li><a onclick="showSection('server-inventory')">Server Information</a></li>
								<li><a onclick="showSection('os-inventory')" >Operating System Information</a></li>
								<li><a onclick="showSection('software-inventory')" >Software Installations</a></li>
								<li><a onclick="showSection('component-inventory')" >Software Component Installation</a></li>
								<li><a onclick="showSection('tempfix-inventory')" >Temporary Fix Installations</a></li>
								<li><a onclick="showSection('hardware-inventory')" >Hardware Information</a></li>
							</ul>
						</div>
						
						<div id="isadc-inventory-info">

							<!-- Server Information -->
							<div class="inventory-div" id="server-inventory">
								<h2>Server Information</h2>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='Server']">
								</xsl:apply-templates>
							</div>

							<!-- Operating System Information -->
							<div class="inventory-div" id="os-inventory">
								<h2>Operating System Information</h2>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='OperatingSystem']">
									<xsl:with-param name="label_prop">osTypeString</xsl:with-param>
								</xsl:apply-templates>
							</div>

							<!-- Software Information -->
							<div class="inventory-div" id="software-inventory">
								<h2>Software Installations</h2>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='SoftwareInstallation']">
									<xsl:with-param name="label_prop">displayName</xsl:with-param>
									<xsl:sort select="./rc:Property[@name='DisplayName'] | ./rc:Property[@name='Name']" />
								</xsl:apply-templates>
							</div>

							<!-- Software Component Installations -->
							<div class="inventory-div" id="component-inventory">
								<h2>Software Component Installations</h2>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='SoftwareComponentInstallation']">
									<xsl:sort select="./rc:Property[@name='Name']" />
								</xsl:apply-templates>
							</div>

						  <!-- Temporary Fix Installations -->
							<div class="inventory-div" id="tempfix-inventory">
								<h2>Temporary Fix Installations</h2>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='TemporaryFixInstallation']">
									<xsl:sort select="./rc:Property[@name='Name']" />
								</xsl:apply-templates>
							</div>

							<!-- Hardware Inventory -->
							<div class="inventory-div" id="hardware-inventory">
								<h2>Hardware Information</h2>
								
								<h3>Physical Memory</h3>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='PhysicalMemory']">
									<xsl:sort select="./rc:Property[@name='Name']" />
								</xsl:apply-templates>
								
								<h3>Chassis</h3>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='Chassis']">
									<xsl:sort select="./rc:Property[@name='Name']" />
								</xsl:apply-templates>
								
								<h3>Disk Drives</h3>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='DiskDrive']">
									<xsl:sort select="./rc:Property[@name='Name']" />
								</xsl:apply-templates>
								
								<h3>Processors</h3>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='Processor']">
									<xsl:sort select="./rc:Property[@name='Name']" />
								</xsl:apply-templates>
								
								<h3>Logical Volumes</h3>
								<xsl:apply-templates select="//rc:ResourceInstance[@resourceType='LogicalVolume']">
									<xsl:sort select="./rc:Property[@name='Name']" />
								</xsl:apply-templates>

							</div>
							
						</div>
					</div>
					
					<!-- Required footer information -->
					<div id="footer">(C) Copyright IBM Corp. 2011</div>
					
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
