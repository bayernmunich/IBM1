<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page contentType="text/html; charset=Cp1252" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.classify.*"%>
<%@ page import="com.ibm.ws.classify.definitions.*"%>
<%@ page import="com.ibm.wsspi.classify.*"%>
<%@ page import="com.ibm.wsspi.expr.operand.*"%>


<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="operand" classname="Operand" />
<tiles:useAttribute name="rowindex" classname="java.lang.String" />
<tiles:useAttribute name="refId" classname="java.lang.String" />

<!-- Added to support custom expression vs. normal expression. -->
<tiles:useAttribute name="inButtonPropertyName" ignore="true" classname="java.lang.String" />
<%
	if (refId == null) refId = "";
	if (inButtonPropertyName == null) { inButtonPropertyName = "installAction"; } 
	String setRowIndex = "setRowIndex('"+rowindex+"')";
	String newInValue = "newInValue"+refId;
	String selectedInValues = "selectedInValues"+refId;

	String otheradd = "otheradd" + refId;
	String otherremove = "otherremove" + refId;
%>

<table role="presentation">
  <tr>
<%  String fieldSize="30";
	if ((operand.getName().equals(ClassificationDictionary.CLIENT_IPV6)) || (operand.getName().equals(ClassificationDictionary.SERVER_IPV6))) {
	 	fieldSize="50";
	}

	if (operand.getSelectableValues() != null && operand.getSelectableValues().length > 0) {
   		com.ibm.wsspi.expr.operand.SelectableValue[] values = operand.getSelectableValues(); %>
        <td class="table-text">
          <label for="<%=newInValue%>" title="<bean:message key="workclass.rulebuilder.newInValue.label.desc"/>">
        	<bean:message key="workclass.rulebuilder.newInValue.label" /><br/>        	
	        <html:select name="<%=formName%>" property="newInValue" styleId="<%=newInValue%>">
                       <% for (int i=0; i < values.length; i++) {
                            String val = values[i].getName(); 
                            String displayText = values[i].getDisplayName(request.getLocale());
                            if (!val.equals("")) {  %>
                	        <html:option value="<%=val%>"><%=displayText%></html:option>
    			         <% } else { %>
                      	    <html:option value="<%=val%>"><bean:message key="none.text"/></html:option>
                         <%  } %>
                       <% } %>
            </html:select>
          </label>
        </td>        		
<%  } else { 
		String newInValueId = "newInValue" + refId;
%>
	    <tiles:insert page="/com.ibm.ws.console.xdcore/textFieldLayout.jsp" flush="false">
			<tiles:put name="property" value="newInValue" />
			<tiles:put name="isReadOnly" value="false" />
			<tiles:put name="isRequired" value="true" />
			<tiles:put name="label" value="rule.builder.newInValue" />
			<tiles:put name="size" value="<%=fieldSize%>" />
			<tiles:put name="bean" value="<%=formName%>" />
			<tiles:put name="units" value=""/>
			<tiles:put name="desc" value="rule.builder.newInValue.desc"/>
			<tiles:put name="propId" value="<%=newInValueId %>" />
		</tiles:insert>
<%  }%>
	    <td class="table-text">
		  <table role="presentation">
			<tr>
			  <td valign="top" class="wizard-step-text">
			    <html:submit property="<%=inButtonPropertyName%>" styleId="<%=otheradd%>" styleClass="buttons"  onclick="<%=setRowIndex%>">
              	  <bean:message key="rule.builder.add.button"/>
 	  	        </html:submit>
			  </td>
			</tr>
			<tr>
			  <td valign="top" class="wizard-step-text">
			    <html:submit property="<%=inButtonPropertyName%>" styleId="<%=otherremove%>" styleClass="buttons"  onclick="<%=setRowIndex%>">
              	  <bean:message key="rule.builder.remove.button"/>
 	  	        </html:submit>
			  </td>
			</tr>
		  </table>
		</td>
		<td class="table-text">
		  <bean:define id="inputList" name="<%=formName%>" property="inputList" type="java.util.List"/>
		  <label for="<%=selectedInValues%>" title="<bean:message key="rule.builder.inlist.desc"/>">
	  	    <bean:message key="rule.builder.inlist" /><br/>
		    <html:select name="<%=formName%>" property="selectedInValues" multiple="true" size="3" styleId="<%=selectedInValues%>">
<%          Iterator i = inputList.iterator();
		    while (i.hasNext()) {
			  String next = (String) i.next(); %>
			  <html:option value="<%=next%>"><%=next%></html:option>
<%		    } %>
		    </html:select>
		</label>
	  </td>
	</tr>
  </table>