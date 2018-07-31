<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xalan xsi" xmlns:stsconfig="http://www.ibm.com/xmlns/prod/websphere/200608/securitytokenservice" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="WebServicesFeaturePack/copy.xsl"/>  
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>

  
  <xsl:template match="/stsconfig:STSConfigGroup">
    <xsl:element name="stsconfig:STSConfigGroup">
      <xsl:attribute name="Name">STSConfigGroup</xsl:attribute>
      <xsl:for-each select="stsconfig:STSConfigGroup">
        <xsl:choose>
          <xsl:when test="@Name='TrustServiceProperties'">
            <xsl:element name="stsconfig:STSConfigGroup">
              <xsl:attribute name="Name">TrustServiceProperties</xsl:attribute>
              <xsl:for-each select="stsconfig:STSProperty">
                <xsl:element name="stsconfig:STSProperty">
                  <xsl:for-each select="@*">
                    <xsl:apply-templates select="."/>
                  </xsl:for-each>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@Name='PolicySet'">
            <xsl:element name="stsconfig:STSConfigGroup">
              <xsl:attribute name="Name">PolicySet</xsl:attribute>
              <xsl:for-each select="stsconfig:STSConfigGroup">
                <xsl:element name="stsconfig:STSConfigGroup">
                  <xsl:attribute name="Name">Schemas</xsl:attribute>
                  <xsl:for-each select="stsconfig:STSProperty">
                    <xsl:choose>
                      <xsl:when test="@Value='http://schemas.xmlsoap.org/ws/2005/02/trust'">
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">wst</xsl:attribute>
                          <xsl:attribute name="Value">
                            <xsl:value-of select="@Value"/>
                          </xsl:attribute>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="@Value='http://schemas.xmlsoap.org/ws/2005/02/sc/sct'">
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">wsc</xsl:attribute>
                          <xsl:attribute name="Value">
                            <xsl:value-of select="@Value"/>
                          </xsl:attribute>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="@Value='http://docs.oasis-open.org/ws-sx/ws-trust/200512'"/>
                      <xsl:when test="@Value='http://docs.oasis-open.org/ws-sx/ws-secureconversation/200512/sct'"/>
                      <xsl:otherwise>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:for-each select="@*">
                            <xsl:apply-templates select="."/>
                          </xsl:for-each>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@Name='MessageReceiver'">
            <xsl:element name="stsconfig:STSConfigGroup">
              <xsl:attribute name="Name">MessageReceiver</xsl:attribute>
              <xsl:for-each select="stsconfig:STSConfigGroup">
                <xsl:choose>
                  <xsl:when test="@Name='http://docs.oasis-open.org/ws-sx/ws-trust/200512'"/>
                  <xsl:when test="@Name='http://docs.oasis-open.org/ws-sx/ws-secureconversation/200512/sct'"/>
                  <xsl:otherwise>
                    <xsl:call-template name="copy"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@Name='STSMapping'">
            <xsl:element name="stsconfig:STSConfigGroup">
              <xsl:attribute name="Name">STSMapping</xsl:attribute>
              <xsl:for-each select="stsconfig:STSConfigGroup">
                <xsl:choose>
                  <xsl:when test="@Name='Default'">
                    <xsl:element name="stsconfig:STSConfigGroup">
                      <xsl:attribute name="Name">Default</xsl:attribute>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Issue</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|Action|issue,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|issue</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Cancel</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|Action|cancel,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|cancel</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Renew</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|Action|renew,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|renew</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Validate</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|Action|validate,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|validate</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">IssueActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|issue</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">CancelActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|cancel</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">RenewActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|renew</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">ValidateActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|validate</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="@Name='Security Context Token'">
                    <xsl:element name="stsconfig:STSConfigGroup">
                      <xsl:attribute name="Name">SCT</xsl:attribute>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Issue</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/sc/sct|Action|issue,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|issue</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Cancel</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/sc/sct|Action|cancel,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|cancel</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Renew</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/sc/sct|Action|renew,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|renew</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">Validate</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">Action</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|Action|validate,RST</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|validate</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">IssueActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|issue</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">CancelActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|cancel</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">RenewActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|renew</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="stsconfig:STSConfigGroup">
                        <xsl:attribute name="Name">ValidateActionNull</xsl:attribute>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">TokenType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">$URI</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="stsconfig:STSProperty">
                          <xsl:attribute name="Name">RequestType</xsl:attribute>
                          <xsl:attribute name="Type">EMK</xsl:attribute>
                          <xsl:attribute name="Value">#MessageReceiver|http://schemas.xmlsoap.org/ws/2005/02/trust|RequestType|validate</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="copy"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:element>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  
</xsl:stylesheet>
