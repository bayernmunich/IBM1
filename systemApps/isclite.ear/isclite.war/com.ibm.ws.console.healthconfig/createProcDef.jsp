<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<tiles:useAttribute  name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />

<%
java.util.ArrayList attributeList_ext =  new java.util.ArrayList();
for(int i=0;i<attributeList.size(); i++)
     attributeList_ext.add(attributeList.get(i));

pageContext.setAttribute("attributeList_ext",attributeList_ext);
%>




<%
//  If there's no properties, don't show this section
if (attributeList_ext.size() > 0) {
%>
  <table class="framing-table" border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >
    <tbody>
    <logic:iterate id="item" name="attributeList_ext" type="com.ibm.ws.console.core.item.PropertyItem">
       <tr valign="top">
         <%
           String isRequired = item.getRequired();
           String strType = item.getType();
           String isReadOnly = item.getReadOnly();
         %>

         <% if (strType.equalsIgnoreCase("Text")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("TextMedium")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="60" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("TextLong")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("TextArea")) { %>
              <tiles:insert page="/secure/layouts/textAreaLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="5" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("FilePath")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
              <tiles:put name="isRequired" value="<%=isRequired%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="FILEPATH" />
              </tiles:insert>
         <% } %>
     
         <% if (strType.equalsIgnoreCase("URL")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
              <tiles:put name="isRequired" value="<%=isRequired%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90"  />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="URL" />
              </tiles:insert>
         <% } %>
     
         <% if (strType.equalsIgnoreCase("EMAIL")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
              <tiles:put name="isRequired" value="<%=isRequired%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="EMAIL" />
              </tiles:insert>
         <% } %>
     
         <% if (strType.equalsIgnoreCase("XPATH")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
              <tiles:put name="isRequired" value="<%=isRequired%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="XPATH" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("checkbox")) { %>
              <tiles:insert page="/secure/layouts/checkBoxLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("Password")) { %>
              <tiles:insert page="/secure/layouts/passwordLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("Custom")) { %>
              <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value=""/>
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
              <tiles:put name="legend" value="<%=item.getLegend()%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("jsp")) { %>
              <tiles:insert page="<%=item.getUnits()%>" flush="false">
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value=""/>
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("select")) {

              try {
                  session.removeAttribute("valueVector");
                  session.removeAttribute("descVector");
              }
              catch (Exception e) {
              }

              StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
              Vector descVector = new Vector();
              while(st1.hasMoreTokens())
              {
                  String enumDesc = st1.nextToken();
                  descVector.addElement(enumDesc);
              }
              StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
              Vector valueVector = new Vector();
              while(st.hasMoreTokens())
              {
                  String str = st.nextToken();
                  valueVector.addElement(str);
              }

              session.setAttribute("descVector", descVector);
              session.setAttribute("valueVector", valueVector);
              %>

              <tiles:insert page="/secure/layouts/submitLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="readOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("Dynamicselect")) {
              try {
                  session.removeAttribute("valueVector");
                  session.removeAttribute("descVector");
              }
              catch (Exception e) {
              }
              //Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
              //Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());
              StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ";,");
              Vector descVector = new Vector();
              while(st1.hasMoreTokens())
              {
                  String enumDesc = st1.nextToken();
                  descVector.addElement(enumDesc);
              }
              StringTokenizer st = new StringTokenizer(item.getEnumValues(), ";,");
              Vector valueVector = new Vector();
              while(st.hasMoreTokens())
              {
                  String str = st.nextToken();
                  valueVector.addElement(str);
              }

              session.setAttribute("descVector", descVector);
              session.setAttribute("valueVector", valueVector);
              %>

              <tiles:insert page="/com.ibm.ws.console.healthconfig/dynamicSelectionLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="readOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
              </tiles:insert>
         <% } %>

         <% if (strType.equalsIgnoreCase("Radio")) {

              try {
                  session.removeAttribute("valueVector");
                  session.removeAttribute("descVector");
              }
              catch (Exception e) {
              }

              StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
              Vector descVector = new Vector();
              while(st1.hasMoreTokens())
              {
                  String enumDesc = st1.nextToken();
                  descVector.addElement(enumDesc);
              }
              StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
              Vector valueVector = new Vector();
              while(st.hasMoreTokens())
              {
                  String str = st.nextToken();
                  valueVector.addElement(str);
              }

              session.setAttribute("descVector", descVector);
              session.setAttribute("valueVector", valueVector);
              %>

              <tiles:insert page="/secure/layouts/radioButtonLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
              <tiles:put name="isRequired" value="<%=isRequired%>" />
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="30" />
              <tiles:put name="units" value=""/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              </tiles:insert>
         <% } %>

       </TR>
    </logic:iterate>
  </tbody>
</table>

<br>

<%
}
%>
