<%@ page contentType="text/html; charset=Cp1252" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.classify.*"%>
<%@ page import="com.ibm.ws.classify.definitions.*"%>
<%@ page import="com.ibm.ws.console.workclass.util.MatchRuleUtils"%>
<%@ page import="com.ibm.wsspi.classify.*"%>
<%@ page import="com.ibm.wsspi.expr.operand.*"%>

<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="operand" classname="Operand" />

<table><tr>

<%         	
            String fieldSize="30";
		    if((operand.getName() == ClassificationDictionary.CLIENT_IPV6) || (operand.getName() == ClassificationDictionary.SERVER_IPV6)){	
			 	fieldSize="50";
			}

			if(operand.getSelectableValues() != null && operand.getSelectableValues().length > 0){
        		SelectableValue[] values = operand.getSelectableValues();
        	%>
<td class="table-text">
        	 <label title="<bean:message key="workclass.rulebuilder.newInValue.label.desc"/>">
        		<bean:message key="workclass.rulebuilder.newInValue.label" /><br/>
        	
	            <html:select name="<%=formName%>" property="newInValue">
                <%
                     for (int i=0; i < values.length; i++)
                     {
                     	String val = values[i].getName();
                     %>
					  	<html:option value="<%=val%>"><%=val%></html:option>
<%					 }
				                %>
                </html:select>
             </label>
</td>        		
        	<%
        	}
        	else{
        	%>

<tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
<tiles:put name="property" value="newInValue" />
<tiles:put name="isReadOnly" value="false" />
<tiles:put name="isRequired" value="true" />
<tiles:put name="label" value="workclass.rulebuilder.newInValue.label" />
<tiles:put name="size" value="<%=fieldSize%>" />
<tiles:put name="bean" value="<%=formName%>" />
<tiles:put name="units" value=""/>
<tiles:put name="desc" value="workclass.rulebuilder.newInValue.label.desc"/>
</tiles:insert>
<%}%>

<td class="table-text">
<table>
<tr><td><input type="submit" name="add" value="<bean:message key="workclass.button.add"/>" class="buttons_other" /></td></tr>
<tr><td><input type="submit" name="remove" value="<bean:message key="workclass.button.remove"/>" class="buttons_other"/></td></tr>
</table>
</td>
<td class="table-text">
<bean:define id="inputList" name="<%=formName%>" property="inputList" type="java.util.List"/>
<label title="<bean:message key="workclass.rulebuilder.inlist.label.desc"/>">
	<bean:message key="workclass.rulebuilder.inlist.label" /><br/>

<html:select name="<%=formName%>" property="selectedInValues" multiple="true" size="3">
	<%
		Iterator i = inputList.iterator();
		while(i.hasNext()){
			String next = (String) i.next();%>
			<html:option value="<%=next%>"><%=next%></html:option>
<%		}
	%>
</html:select>
</label>
</td>
</tr></table>