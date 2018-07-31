<%@ page language="java" import="com.ibm.ws.batch.jobmanagement.web.forms.AbstractDetailForm"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="detailName"   classname="java.lang.String"/>
<tiles:useAttribute name="action"   classname="java.lang.String"/>
<tiles:useAttribute name="propertyList" classname="java.util.List"/>

  <tr>
    <td>
    <form name="<%=detailName%>" method="post" action="/jmc/<%=action%>.do?action=back">
    <table border="0" cellpadding="5" cellspacing="0" width="50%" class="framing-table">
      <tbody>
        <bean:define id="detailForm" name="<%=detailName%>"/>
        <tr  valign="top">
          <td class="table-text" width="100%" scope="row" valign="top">
          <h2><bean:message key="generalProperties"/></h2>
           </td>
        </tr>
<%
    AbstractDetailForm df = (AbstractDetailForm) detailForm;

    for (int i = 0; i < propertyList.size(); i++) {
      String property = (String) propertyList.get(i);
%>
      <bean:define id="propertyValue" name="<%=detailName%>" property="<%=property%>" type="java.lang.String"/>
<%
      if (!df.showPropertyWhenEmpty(property)) 
          continue;
%>
        <tr  valign="top">
          <td class="table-text" width="100%" scope="row" valign="top">
            <label><bean:message key="<%=property%>"/></label>
            <P CLASS="readOnlyElement">
<%
      if (df.isPropertyNeedTranslate(property, propertyValue)) {
%>
          <bean:message key="<%=propertyValue%>"/>
<%    } else { %>
          <%=propertyValue == null || propertyValue.length() < 1 ? "&nbsp;" : propertyValue%>
<%    } %>
            </P>
          </td>
        </tr>
<%
    }
%>
        <tr  valign="top">
          <td class="table-text" width="100%" scope="row" valign="top">&nbsp;</td>
        </tr>
        <tr  valign="top"></tr>
        <tr  valign="top"></tr>
        <tr>
            <td class="navigation-button-section" VALIGN="top">
                &nbsp;<br>
                <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="back"/>" class="buttons" id="navigation">
            </td>
        </tr>
	    </tbody>
    </table>
    </form>

    </td>
  </tr>
