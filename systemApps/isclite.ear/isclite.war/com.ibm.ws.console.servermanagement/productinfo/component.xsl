<?xml version="1.0" ?>

<!--
THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
5724-i63, 5724-H88(C) COPYRIGHT International Business Machines Corp., 1997, 2004
All Rights Reserved * Licensed Materials - Property of IBM
US Government Users Restricted Rights - Use, duplication or disclosure
restricted by GSA ADP Schedule Contract with IBM Corp. 
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
<xsl:output indent="no"/>

<xsl:template match="docRoot">
    <xsl:apply-templates/>
</xsl:template>           

<xsl:template match="component">
    <tr valign="top" class="table-row">
        <td class="collection-table-text"  valign="top" scope="row">
            <xsl:value-of select="./@name"/>
        </td>
        <td class="collection-table-text"  valign="top">
            <xsl:value-of select="./@spec-version"/>
        </td> 
        <td class="collection-table-text"  valign="top">
            <xsl:value-of select="./@build-version"/>
        </td>
        <td class="collection-table-text"  valign="top">
            <xsl:value-of select="./@build-date"/>
        </td>
    </tr>
</xsl:template>           


</xsl:stylesheet>



