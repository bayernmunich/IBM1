<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.middlewareapps.form.MiddlewareAppsCollectionForm"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
   <tiles:useAttribute id="isReadOnly" name="isReadOnly" classname="java.lang.String"/>


   <bean:define id="bean" name="<%=formBean%>"/>

   <% Vector valueVector = (Vector)session.getAttribute("valueVector");
      Vector descVector = (Vector)session.getAttribute("descVector"); %>

            <LABEL for="<%=property%>">
            <html:select property="<%=property%>" name="<%=formBean%>" styleId="<%=property%>" >
                <%
                     for (int i=0; i < valueVector.size(); i++)
                     {
                         String val = (String) valueVector.elementAt(i);
                         String descript = (String) descVector.elementAt(i);
                         descript=descript.trim();
                                                         if (!descript.equals("")) {

                                                 %>
                                                                <html:option value="<%=val%>"><bean:message key="<%=descript%>"/></html:option>
                                                 <%
                                                         } else {
                                                         %>
                                                                <html:option value="<%=val%>"><bean:message key="none.text"/></html:option>

                                                         <%
                                                                 }
                     }
                %>
            </html:select>
            </LABEL>
