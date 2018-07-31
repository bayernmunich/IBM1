<%@ page language="java" import="com.ibm.ws.batch.jobmanagement.web.forms.AbstractDetailForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils,com.ibm.ws.batch.security.BatchSecurity,com.ibm.websphere.wim.SchemaConstants"%>

<%@ page import="com.ibm.ws.security.core.SecurityContext" errorPage="/errors/error.jsp" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="collectionName" classname="java.lang.String"/>
<tiles:useAttribute name="action"         classname="java.lang.String"/>
<tiles:useAttribute name="detailAction"   classname="java.lang.String"/>
<tiles:useAttribute name="actionSection"  classname="java.lang.String"/>
<tiles:useAttribute name="filterSection"  classname="java.lang.String"/>
<tiles:useAttribute name="propertyList"   classname="java.util.List"/>
<tiles:useAttribute name="refreshColumn"  classname="java.lang.String"/>

<%
  boolean isAdmin = true;
  if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lradmin"))
     isAdmin = false;
%>

<%
  boolean isSubmitter = true;
  if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lrsubmitter"))
     isSubmitter = false;
	 
  BatchSecurity.JOB_SECURITY_POLICY currentSecurityPolicy = BatchSecurity.getCurrentBatchSecurityPolicy();
			
  if((currentSecurityPolicy.equals(BatchSecurity.JOB_SECURITY_POLICY.ROLE)) && 
	((collectionName == "JobCollectionForm") || (collectionName == "SavedJobCollectionForm" ) || (collectionName == "JobScheduleCollectionForm")))
	{
	propertyList.remove(propertyList.size() - 1);
	}
%>

	
        <tr>
          <td>

          <form name="<%=collectionName%>" method="post" action="/jmc/<%=action%>.do" id="<%=collectionName%>" ENCTYPE="multipart/form-data">

          <%@ include file="/tiles/preferences.jspf" %>

          <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" class="framing-table" role="presentation">
<% if (isAdmin || isSubmitter) { %> 
          <tiles:insert component="<%=actionSection%>" beanScope="request">
            <tiles:put name="numOfColumns" value="<%=Integer.toString(propertyList.size()+1)%>"/>
          </tiles:insert>
<% } %>
          <%@ include file="/tiles/collectionButtons.jspf" %>

            <!--  Header Section -->
			 <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" class="framing-table">
            <TR>
              <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
                <bean:message key="select"/>
              </TH>
<%
    for (int i = 0; i < propertyList.size(); i++) {
        String property = (String) propertyList.get(i);
%>
              <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="20%" ID="<%=property%>">
                <bean:message key="<%=property%>"/>
<%
        if (property.equals(refreshColumn)) {
%>
                <A HREF="/jmc/<%=action%>.do"><IMG SRC="images/refresh.gif" title="<bean:message key="refreshView"/>" alt="<bean:message key="refreshView"/>" align="texttop" border="0"/>
<%
        }
%>
              </TH>
<%
    }
%>
            </TR>
            <!--  End of Header Section -->

            <tiles:insert component="<%=filterSection%>" beanScope="request">
              <tiles:put name="collectionName" value="<%=collectionName%>"/>
              <tiles:put name="numOfColumns"   value="<%=Integer.toString(propertyList.size()+1)%>"/>
            </tiles:insert>


          <!--  Rows Section -->
<%  int r = 0; %>          
          <logic:iterate id="detailForm" name="<%=collectionName%>" property="contents">
            <TR CLASS="table-row">

<%

    AbstractDetailForm df = (AbstractDetailForm) detailForm;

    for (int i = 0; i < propertyList.size(); i++) {
        String property = (String) propertyList.get(i);
%>
        <bean:define id="propertyValue"  name="detailForm" property="<%=property%>" type="java.lang.String"/>
<%
        String propertyLink = propertyValue;
        if (df.isPropertyNeedConvertToCharset(property)) {
            propertyLink  = JMCUtils.urlEncode(propertyValue);
            propertyValue = JMCUtils.convertToCharset(propertyValue, response.getCharacterEncoding());
        }

        if (i == 0) {
%>
              <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                
                  <input type="checkbox" TITLE='Select: <%=propertyValue%>' name="selectedObjectIds" value="<%=propertyLink%>"" id="selectId<%= r %>">
                
              </TD>
<%    
        }
%>
      	      <TD VALIGN="top"  class="collection-table-text" headers="<%=property%>">
<%      if (i == 0) { %>
                <bean:define id="detailActionParms" name="detailForm" property="detailActionParms" type="java.lang.String"/>
                <a href="/jmc/<%=detailAction%><%=detailActionParms%>"><%=propertyValue%></a>
<%      } else { 
            if (df.isPropertyNeedTranslate(property, propertyValue)) {
%>
                <bean:message key="<%=propertyValue%>"/>
<%          } else { %>
                <%=propertyValue%>
<%          }
        }
%>
              </TD>
<%
    }
    r++;
%>
            </TR>
          </logic:iterate>
          <!--  End of Rows Section -->
		  

          <tiles:insert component="/tiles/blocking.jsp" beanScope="request">
            <tiles:put name="collectionName" value="<%=collectionName%>"/>
            <tiles:put name="numOfColumns"   value="<%=Integer.toString(propertyList.size()+1)%>"/>
          </tiles:insert>
		  </table>
          </TABLE>
          </form>
          </td>
        </tr>
