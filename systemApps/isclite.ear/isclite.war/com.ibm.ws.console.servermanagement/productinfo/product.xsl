<?xml version="1.0" ?>

<!--THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 COPYRIGHT International Business Machines Corp., 1997, 2012
All Rights Reserved * Licensed Materials - Property of IBM
US Government Users Restricted Rights - Use, duplication or disclosure
restricted by GSA ADP Schedule Contract with IBM Corp.--> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
<xsl:output indent="no"/>

<xsl:template match="docRoot">
    <xsl:apply-templates/>
</xsl:template>           

<xsl:template match="product">
    <tr valign="top"  class="table-row">
        <td class="collection-table-text"  valign="top" scope="row">
        <label>
            <xsl:value-of select="./@name"/>
        </label>
        </td>
        <td class="collection-table-text"  valign="top">
            <xsl:value-of select="./id"/>
        </td>
        <td class="collection-table-text"  valign="top">
            <xsl:value-of select="./version"/>
        </td> 
        <td class="collection-table-text"  valign="top">
            <xsl:value-of select="./build-info/@date"/>
        </td>
        <td class="collection-table-text"  valign="top">
            <xsl:value-of select="./build-info/@level"/>
        </td>
    </tr>
</xsl:template>           


</xsl:stylesheet>



