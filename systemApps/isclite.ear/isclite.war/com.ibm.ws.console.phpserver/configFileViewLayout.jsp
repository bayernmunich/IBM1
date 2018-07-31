<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*,com.ibm.ws.console.web.webserver.*,com.ibm.ws.console.phpserver.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
 



<tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
<tiles:useAttribute id="formName" name="formName" classname="String"/>
<tiles:useAttribute id="formAction" name="formAction" classname="String"/>
<tiles:useAttribute id="formType" name="formType" classname="String"/>
<tiles:useAttribute id="size" name="size" classname="String"/>
<tiles:useAttribute id="property" name="property" classname="String"/>


<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">


<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
  <tr valign="top"> 
          <td class="table-text"  scope="row" nowrap width="25%">
          <label  for="selectedConfigFile" TITLE="<bean:message key="edit.configuration.file.displayName"/>"><bean:message key="edit.configuration.file.displayName"/></label>
                <BR>
                <html:select property="selectedConfigFile"  size="1" >
					<html:option value="httpd.conf">httpd.conf</html:option>
					<html:option value="php.ini">php.ini</html:option>
					<html:option value="server.xml">server.xml</html:option>
				</html:select>
			
				<input type="submit" name="retrieve.config"  value="<bean:message key="retrieve.config"/>" class="buttons" id="functions" >
		  </td>		
     </tr>
</table>





<table border="0" cellpadding="0" cellspacing="0" width="100%" summary="Properties Framing Table" >

 	
  		
        <tr> 
               <td class="table-text">
                 <%

                 PHPServerEditConfigForm pForm = (PHPServerEditConfigForm) session.getAttribute("com.ibm.ws.console.phpserver.PHPServerEditConfigForm");		
                 out.println("<br><a href="+request.getContextPath()+"/navigatorCmd.do?forwardName=PHPServer.content.main>" + pForm.getTransferError());
                 out.println("</a>"); 
                 %>          

	    		
	    		
               <textarea property="configFileText" name="configFileText" styleClass="textEntryLong" rows="50"  cols="100" >
               <bean:write property="<%=property%>" name="<%=formName%>"/>
               <bean:message key="phpserver.test.textarea"/>  
               </textarea>
               <%--
               <pre>
                <bean:write property="<%=property%>" name="<%=formName%>"/>
               </pre>
               --%>
                </td>
          </tr>
</table>

        </td>
    </tr>
    <tr>
        <td class="navigation-button-section" VALIGN="top">
            <input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons" id="navigation">
            <input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons" id="navigation">
            <input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons" id="navigation">
            <%--<input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons" id="navigation">--%>
            <input type="submit" name="cancel" value="<bean:message key="button.cancel"/>" class="buttons" id="navigation">
        </td>
    </tr>
 </table>
          
</html:form>

