<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:sibresources="http://www.ibm.com/websphere/appserver/schemas/6.0/sibresources.xmi"
     xmlns:xmi="http://www.omg.org/XMI" >

  <xsl:import href="copy.xsl"/>

  <xsl:template match="sibresources:SIBAuthSpace/user">
    <user><xsl:attribute name="xmi:id"><xsl:value-of select="@xmi:id"/></xsl:attribute><xsl:attribute name="identifier"><xsl:value-of select="@identifier"/></xsl:attribute></user>
    <xsl:if test="@uniqueName">
      <user><xsl:attribute name="xmi:id"><xsl:value-of select="@xmi:id"/>_1</xsl:attribute><xsl:attribute name="identifier"><xsl:value-of select="@uniqueName"/></xsl:attribute></user>
    </xsl:if>
    
  </xsl:template>

  <xsl:template match="sibresources:SIBAuthSpace/group">
    <group><xsl:attribute name="xmi:id"><xsl:value-of select="@xmi:id"/></xsl:attribute><xsl:attribute name="identifier"><xsl:value-of select="@identifier"/></xsl:attribute></group>
    <xsl:if test="@uniqueName">
      <group><xsl:attribute name="xmi:id"><xsl:value-of select="@xmi:id"/>_1</xsl:attribute><xsl:attribute name="identifier"><xsl:value-of select="@uniqueName"/></xsl:attribute></group>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sibresources:SIBAuthSpace/busConnect">
    <xsl:call-template name="updateRole">
      <xsl:with-param name="roleName">busConnect</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sibresources:SIBAuthSpace//browser">
    <xsl:call-template name="updateRole">
      <xsl:with-param name="roleName">browser</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sibresources:SIBAuthSpace//sender">
    <xsl:call-template name="updateRole">
      <xsl:with-param name="roleName">sender</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sibresources:SIBAuthSpace//receiver">
    <xsl:call-template name="updateRole">
      <xsl:with-param name="roleName">receiver</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sibresources:SIBAuthSpace//creator">
    <xsl:call-template name="updateRole">
      <xsl:with-param name="roleName">creator</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sibresources:SIBAuthSpace//identityAdopter">
    <xsl:call-template name="updateRole">
      <xsl:with-param name="roleName">identityAdopter</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- This template updates the role. It is provided a role name and
       creates the element based on that.
  -->
  <xsl:template name="updateRole">
    <xsl:param name="roleName"/>
    
    <!-- create an element based on the role name -->
    <xsl:element name="{$roleName}">
      <!-- pass the xmi:id across to the output xml -->
      <xsl:attribute name="xmi:id">
        <xsl:value-of select="@xmi:id"/>
      </xsl:attribute>
      <!-- We only want to write the groups attribute if there are groups in the role.
           This can be achieved by converting the groups xml to a string and normalizing
           the spaces. The result of this will be the empty string if no groups exist.
      -->
      <xsl:if test="@group != ''">
        <!-- create the group attribute and loop around the id elements in the
             variable theGroups, converting it to a string and putting that string
             in the attribute value.
        -->
        <xsl:attribute name="group">
          <xsl:call-template name="processEntities">
            <xsl:with-param name="remainingIds"><xsl:value-of select="@group"/></xsl:with-param>
            <xsl:with-param name="userOrGroup">user</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <!-- this works in the same way as groups processing does -->
      <xsl:if test="@user != ''">
        <xsl:attribute name="user">
          <xsl:call-template name="processEntities">
            <xsl:with-param name="remainingIds"><xsl:value-of select="@user"/></xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- This method processes the ids. The ids are a space separated list of xmi:ids
       It takes the first string and then calls itself again with the strings after
       the first space until they have all been delt with. This template is called
       within the context of a variable block so anything written is not inserted
       into the post transformed document.       
  -->
  <xsl:template name="processEntities">
    <xsl:param name="remainingIds"/>
    <xsl:param name="userOrGroup">user</xsl:param>

    <xsl:choose>
      <!-- if the remaining ids contains a space we have more than one id in the list -->
      <xsl:when test="contains($remainingIds, ' ')">

        <!-- write out the first id -->
        <xsl:call-template name="writeId">
          <xsl:with-param name="id" select="substring-before($remainingIds, ' ')"/>
        </xsl:call-template>

        <!-- recurse for all the remaining ids -->
        <xsl:call-template name="processEntities">
          <xsl:with-param name="remainingIds" select="substring-after($remainingIds, ' ')"/>
        </xsl:call-template>

      </xsl:when>
      <xsl:otherwise>
        <!-- Call writeId for the final id in the list, after this call the stack will unwind. -->
        <xsl:call-template name="writeId">
          <xsl:with-param name="id" select="$remainingIds"/>
          <xsl:with-param name="tailWithSpace">false</xsl:with-param>
        </xsl:call-template>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This template is called to write out the id, it is called from processEntities, which is
       called from a variable directive, so this does not affect the resultant document. 
       An optional parameter of tailWithSpace exists, if it is not provided then it defaults to
       true. When true the ids will be terminated by a space. If false the last one written will
       not be terminated by a space. This makes the updateRole template easier to write as it can
       ensure that the last id written to the space separated list does not end in a space.
  -->
  <xsl:template name="writeId">
    <xsl:param name="id"/>
    <xsl:param name="tailWithSpace">true</xsl:param>
    <xsl:param name="userOrGroup">user</xsl:param>

    <xsl:value-of select="$id"/><xsl:if test="$tailWithSpace='true'"><xsl:text> </xsl:text></xsl:if>
    <xsl:if test="//$userOrGroup[@xmi:id=$id]/@uniqueName!=''">
      <xsl:if test="$tailWithSpace='false'"><xsl:text> </xsl:text></xsl:if><xsl:value-of select="$id"/>_1<xsl:if test="$tailWithSpace='true'"><xsl:text> </xsl:text></xsl:if>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
