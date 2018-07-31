<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>  <%-- LIDB2303A --%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.xdcore.form.RuleDetailForm"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.classify.*"%>
<%@ page import="com.ibm.ws.classify.definitions.*"%>
<%@ page import="com.ibm.wsspi.classify.*"%>
<%@ page import="com.ibm.wsspi.expr.operand.*"%>
<%@ page import="com.ibm.wsspi.expr.core.*"%>
<%@ page import="com.ibm.wsspi.odr.OdrManagerFactory.*"%>
<%@ page import="com.ibm.wsspi.expr.Language.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<!-- helpfile.txt key for rule quick help -->
<tiles:useAttribute name="quickHelpTopic" classname="java.lang.String" ignore="true"/>

<!-- Webui plugin id -->
<tiles:useAttribute name="quickPluginId" classname="java.lang.String" ignore="true" />

<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="detailFormType" ignore="true" classname="java.lang.String" />
<tiles:useAttribute name="actionHandler" classname="java.lang.String" />
<tiles:useAttribute name="rowindex" ignore="true" classname="java.lang.String" />
<tiles:useAttribute name="refId" classname="java.lang.String" />
<!-- Form attribute used to set and get the rule. -->
<tiles:useAttribute name="rule" classname="java.lang.String" />
<tiles:useAttribute name="customOperands" ignore="true" classname="java.lang.String" />
   <%
   org.apache.struts.util.MessageResources messages = (org.apache.struts.util.MessageResources)pageContext.getServletContext().getAttribute(org.apache.struts.action.Action.MESSAGES_KEY);
   %>


<%
	RuleDetailForm detailForm = (RuleDetailForm)request.getSession().getAttribute("Rule_"+refId);
	Operand co = null;
	boolean isSingleRule = false;

	if (rowindex == null || rowindex == "") {
		rowindex = "0";
		isSingleRule = true;
	}
	
	if (detailForm != null && detailFormType != null) {
		pageContext.setAttribute(detailFormType,detailForm); %>
		<bean:define id="formAction" value="<%=detailFormType%>" />
<%  } %>
		<bean:define id="operands" name="<%=formAction%>" property="operands" type="ArrayList" />
		<bean:define id="operand" name="<%=formAction%>" property="selectedOperand" />
               <bean:define id="selectedAppendValue0" name="<%=formAction%>" property="appendValue0" type="String" />
               <bean:define id="selectedAppendValue1" name="<%=formAction%>" property="appendValue1" type="String" />
               <bean:define id="selectedAppendValue2" name="<%=formAction%>" property="appendValue2" type="String" />
               <bean:define id="selectedAppendValue3" name="<%=formAction%>" property="appendValue3" type="String" />
    <%  if (customOperands != null) {  %>
		<bean:define id="operands" name="<%=formAction%>" property="customOperands" type="ArrayList" />
		<bean:define id="operand" name="<%=formAction%>" property="selectedCustomOperand" />
	<% } %>


<%
//System.out.println("Print operands");

for (java.util.Iterator i = operands.iterator(); i.hasNext();) {
		Operand c = (Operand)i.next();
		//System.out.println("operand: " + c.getName());
	}
%>


<%
	for (java.util.Iterator i = operands.iterator(); i.hasNext();) {
		Operand c = (Operand)i.next();
		if (operand.equals(c.getName()) || operand.equals("")) {
			co = c;
			break;
		}
	}

   String appendableInput = "appendableInput"+refId;
   String simpleMatchInput = "simpleMatchInput"+refId;
   String betweenMatchInput = "betweenMatchInput"+refId;
   String inMatchInput = "inMatchInput"+refId;
   String betweenUpperBoundMatch = "betweenUpperBoundMatch"+refId;
%>

<script language="JavaScript">
function operandNameChange<%=refId%>(rowindex) {
	var selectedOperand = document.forms[0].selectedOperand<%=refId%>.value;
	var appendWith = document.forms[0].appendWith<%=refId%>.value;
	var selectedOperator = "";
	<% if (!(co instanceof BooleanOperand)) { %>
		selectedOperator = document.forms[0].selectedOperator<%=refId%>.value;
	<% }%>
	
	var rule = rule = document.forms[0].<%=rule%>[rowindex];
	if (rule == null)
		rule = document.forms[0].<%=rule%>;
		
	rule = rule.value
	window.location = encodeURI("/ibm/console/<%=actionHandler%>.do?operand=" + selectedOperand +"&operator=" + selectedOperator + "&appendWith=" + appendWith + "&rule=" + rule + "&refId=<%=refId%>" + "&appendValue0=" + "&appendValue1=" + "&appendValue2=" + "&appendValue3=" + "&appendValue4="
		  + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function appendValueNameChange<%=refId%>(rowindex) {
	var selectedOperand = document.forms[0].selectedOperand<%=refId%>.value;
	var selectedAppendValue0 = document.forms[0].appendValue0<%=refId%>.value;
	var selectedAppendValue1 = document.forms[0].appendValue1<%=refId%>.value;
	var selectedAppendValue2 = document.forms[0].appendValue2<%=refId%>.value;
	var selectedAppendValue3 = document.forms[0].appendValue3<%=refId%>.value;
	var appendWith = document.forms[0].appendWith<%=refId%>.value;
	var selectedOperator = "";
	<% if (!(co instanceof BooleanOperand)) { %>
		selectedOperator = document.forms[0].selectedOperator<%=refId%>.value;
	<% }%>
	
	var rule = rule = document.forms[0].<%=rule%>[rowindex];
	if (rule == null)
		rule = document.forms[0].<%=rule%>;
		
	rule = rule.value
	window.location = encodeURI("/ibm/console/<%=actionHandler%>.do?operand=" + selectedOperand + "&operator=" + selectedOperator + "&appendWith=" + appendWith + "&rule=" + rule + "&refId=<%=refId%>" + "&appendValue0=" + selectedAppendValue0 + "&appendValue1=" + selectedAppendValue1 + "&appendValue2=" + selectedAppendValue2 + "&appendValue3=" + selectedAppendValue3
		  + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function updateOperand<%=refId%>(){
	var simpleInput = document.getElementById("<%=simpleMatchInput%>");
	var btwnInput = document.getElementById("<%=betweenMatchInput%>");
	var inInput = document.getElementById("<%=inMatchInput%>");
	var selectedOperator = document.getElementById("selectedOperator<%=refId%>");
	
	var appendValue0 = document.getElementById("fakeappendValue0<%=refId%>");
	if (appendValue0 != null)
		appendValue0.style.display="none";
		
	var appendValue1 = document.getElementById("fakeappendValue1<%=refId%>");
	if (appendValue1 != null)
		appendValue1.style.display="none";
		
	var appendValue2 = document.getElementById("fakeappendValue2<%=refId%>");
	if (appendValue2 != null)
		appendValue2.style.display="none";
		
	var appendValue3 = document.getElementById("fakeappendValue3<%=refId%>");
	if (appendValue3 != null)
		appendValue3.style.display="none";
		
	var appendValue4 = document.getElementById("fakeappendValue4<%=refId%>");
	if (appendValue4 != null)
		appendValue4.style.display="none";
	
	<% if (!(co instanceof BooleanOperand)) { %>
		var operator = document.forms[0].selectedOperator<%=refId%>.value;
		selectedOperator.style.display="";
		if(operator=="<%=ClassificationDictionary.BETWEEN%>"){
			simpleInput.style.display="none";
			btwnInput.style.display="";
			inInput.style.display="none";
		}
		else if(operator=="<%=ClassificationDictionary.IN%>" || operator=="LIKEIN"){
			simpleInput.style.display="none";
			btwnInput.style.display="none";
			inInput.style.display="";
		}
		else if(operator=="<%=ClassificationDictionary.IS_NOT_NULL%>" || operator=="<%=ClassificationDictionary.IS_NULL%>"){
			simpleInput.style.display="none";
			btwnInput.style.display="none";
			inInput.style.display="none";
		}
		else{
			simpleInput.style.display="";
			btwnInput.style.display="none";
			inInput.style.display="none";
		}
	<% } else {%>
		simpleInput.style.display="none";
		btwnInput.style.display="none";
		inInput.style.display="none";
		selectedOperator.style.display="none";
	<% } %>
}
</script>



<table cellpadding="0" cellspacing="0" border="0" class="wasPortlet">
  <tr>
    <td class="wpsPortletTitle"><b>
      <label title="<bean:message key="rule.edit.link.subexpression"/>">
        <bean:message key="rule.edit.link.subexpression"/>
      </label>
	</b></td>
    <td class="wpsPortletTitleControls">
		<% if (quickHelpTopic !=null && quickHelpTopic.length()>0 && quickPluginId !=null && quickPluginId.length()>0) {%>
          <a href="/ibm/help/index.jsp?topic=/<%=quickPluginId%>/<%=quickHelpTopic%>" target="_blank">
              <img id="<bean:message key="menu.help"/>"
              	title="<bean:message key="menu.help"/>"
              	src="<%=request.getContextPath()%>/images/title_help.gif"
              	alt="<bean:message key="menu.help"/>"
              	border="0" align="absmiddle" 
              	class="wpsPortletTitleIcon"/>
          </a>
	    <%}%>
    </td>
  </tr>

  <tr>
    <td class="wpsPortletArea" colspan="3">
		<table class="framing-table" border="0" cellpadding="5" cellspacing="0" role="presentation">
		  <tr>
		    <td class="table-text">
 		      <% String appendWith = "appendWith"+refId; %>
		      <label for="<%=appendWith%>" title="<bean:message key="rule.builder.appendwith.desc"/>">
			    <bean:message key="rule.builder.appendwith"/><br/>
		        <html:select property="appendWith" name="<%=formAction%>" size="1" styleId="<%=appendWith%>">
		          <html:option value="or">or</html:option>
		          <html:option value="and">and</html:option>
		        </html:select>
		      </label>
		    </td>
		  </tr>
		  <tr>
		    <td class="table-text">
		      <fieldset>
		        <legend title="<bean:message key="rule.edit.link.subexpression"/>">
				  <bean:message key="rule.edit.link.subexpression"/>		                	
		 	    </legend>
		 	    
				<%
					String styleId = "selectedOperand"+refId;
					String operandNameChange = "operandNameChange"+refId+"('"+rowindex+"')";
				%>
				<table role="presentation">
				  <tbody>
					<tr>
					 <td class="table-text">
					  <label for="<%=styleId%>" title="<bean:message key="rule.builder.operand.label.desc"/>">
						<bean:message key="rule.builder.operand.label" />
					  </label>
					  <br />
		
		              <% if (customOperands != null) {
		              		//System.out.println("custom operands populating");
		              %>
				              <html:select name="<%=formAction%>" property="selectedCustomOperand" size="1" styleId="<%=styleId%>" onchange="<%=operandNameChange%>">
				                  <logic:iterate id="dropDownItem" name="<%=formAction%>" property="customOperands">
				                  <% Operand cOperand = (Operand) dropDownItem;
				                     String value = dropDownItem.toString();
				                     String displayText = cOperand.getDisplayName(request.getLocale());
				                     if (!value.equals("")) {  %>
				            	        <html:option value="<%=value%>"><%=displayText%></html:option>
							      <% } else { %>
				                  	    <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
				                  <%  } %>
				                  </logic:iterate>
				              </html:select>
		              <%  } else { %>
		
				              <html:select name="<%=formAction%>" property="selectedOperand" size="1" styleId="<%=styleId%>" onchange="<%=operandNameChange%>">
				                  <logic:iterate id="dropDownItem" name="<%=formAction%>" property="operands">
				                  <% Operand cOperand = (Operand) dropDownItem;
				                     String value = dropDownItem.toString();
				                     String displayText = cOperand.getDisplayName(request.getLocale());
				                     if (!value.equals("")) {  %>
				            	        <html:option value="<%=value%>"><%=displayText%></html:option>
							      <% } else { %>
				                  	    <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
				                  <%  } %>
				                  </logic:iterate>
				              </html:select>
		
		              <% } %>
		
		
		             </td>
					</tr>
			      </tbody>
		<%          String fieldSize="30";
		            if ((operand.equals(ClassificationDictionary.CLIENT_IPV6)) || (operand.equals(ClassificationDictionary.SERVER_IPV6)) ) {	
		             	fieldSize="50";
		            }
		
		%>			<tbody id="<%=appendableInput%>"><%
					FieldName[] fieldnames = co.getFieldNames();
					String desc = "rule.builder.appendvalue.desc";
		            //appendValue0
		            String appendValueName = "appendValue0";	
		            int i_fn = 0;
		            if (fieldnames != null && fieldnames.length > i_fn) {
						SelectableValue[] selectablevalues = fieldnames[i_fn].getSelectableValues();
                                               //
					        String appendValueNameChange = "appendValueNameChange"+refId+"('"+rowindex+"')";
                                               // if this is the last one then don't the onclick change
                                               if (fieldnames.length == (i_fn + 1))
					           appendValueNameChange = "";

				   		if (selectablevalues != null && selectablevalues.length > 0) {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
                                                           <%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
                                                           <br />
					       		    <html:select property="<%=appendValueName%>" name="<%=formAction%>" size="1" styleId="<%=appendValueName+refId%>" onchange="<%=appendValueNameChange%>"><%
					       			   	 for (int i_sv=0; i_sv<selectablevalues.length; i_sv++) { %>
					       			       	<html:option value="<%=selectablevalues[i_sv].getName()%>">
					       			       		<%=selectablevalues[i_sv].getDisplayName(request.getLocale())%>
					       			       	</html:option><%
					       			     }%>
					       			</html:select>
					       		</label>
				   			  </td>
						    </tr><%
						} else {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
				                	<%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
				                	<br />
								
									<html:text property="<%=appendValueName%>"
										name="<%=formAction%>"
										size="<%=fieldSize%>"
										styleId="<%=appendValueName+refId%>"
										styleClass="textEntry"
										title="<%=messages.getMessage(request.getLocale(),desc)%>"/>
				                </label>
				              </td>
				   			</tr> <%
						}
		            } else {
		            	String id = "fake"+appendValueName+refId;%>
		            	<tr><td>
					        <label class="hidden" for="<%=id%>">
							<html:text property="<%=appendValueName%>"
								name="<%=formAction%>"
								size="<%=fieldSize%>"
								styleId="<%=id%>"
								styleClass="textEntry"/>
							</label>
						</td></tr>		
					<% }

		            //appendValue1
		            appendValueName = "appendValue1";	
		            i_fn = 1;
		            if (fieldnames != null && fieldnames.length > i_fn) {
						SelectableValue[] selectablevalues = fieldnames[i_fn].getSelectableValues();
                                               //
					        String appendValueNameChange = "appendValueNameChange"+refId+"('"+rowindex+"')";
                                               // if this is the last one then don't the onclick change
                                               if (fieldnames.length == (i_fn + 1))
					           appendValueNameChange = "";
                                               //
                                               SelectableValue previousSelectedSelectableValue = null;
                                               SelectableValue[] previousSelectableValues = fieldnames[i_fn-1].getSelectableValues();
                                               if (previousSelectableValues != null && previousSelectableValues.length > 0) {
                                                  FieldName[] previousFieldName1 = previousSelectableValues[0].getFieldNames();
                                                  if (previousFieldName1 != null && previousFieldName1.length > 0) {
                                                     SelectableValue[] previousSelectableValues1 = previousFieldName1[0].getSelectableValues();
                                                     if (previousSelectableValues1 != null && previousSelectableValues1.length > 0) {
                                                        if (selectedAppendValue0 != null && selectedAppendValue0.length() > 0) {
                                                           for (int i_sv=0; i_sv<previousSelectableValues.length; i_sv++) {
                                                              if (previousSelectableValues[i_sv].getName().equals(selectedAppendValue0)) {
                                                                 previousSelectedSelectableValue = previousSelectableValues[i_sv];
                                                                 break;
                                                              }
                                                           }
                                                        }
                                                        if (previousSelectedSelectableValue == null) { // default to the first one
                                                           previousSelectedSelectableValue = previousSelectableValues[0];
                                                        }
                                                        previousFieldName1 = previousSelectedSelectableValue.getFieldNames();
                                                        selectablevalues = previousFieldName1[0].getSelectableValues();
                                                     }
                                                  }
                                               }
                                               //
				   		if (selectablevalues != null && selectablevalues.length > 0) {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
                                                           <%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
                                                           <br />
					       		    <html:select property="<%=appendValueName%>" name="<%=formAction%>" size="1" styleId="<%=appendValueName+refId%>" onchange="<%=appendValueNameChange%>"><%
					       			   	 for (int i_sv=0; i_sv<selectablevalues.length; i_sv++) { %>
					       			       	<html:option value="<%=selectablevalues[i_sv].getName()%>">
					       			       		<%=selectablevalues[i_sv].getDisplayName(request.getLocale())%>
					       			       	</html:option><%
					       			     }%>
					       			</html:select>
					       		</label>
				   			  </td>
						    </tr><%
						} else {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
				                	<%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
				                	<br />
								
									<html:text property="<%=appendValueName%>"
										name="<%=formAction%>"
										size="<%=fieldSize%>"
										styleId="<%=appendValueName+refId%>"
										styleClass="textEntry"
										title="<%=messages.getMessage(request.getLocale(),desc)%>"/>
				                </label>
				              </td>
				   			</tr> <%
						}
		            } else {
		            	String id = "fake"+appendValueName+refId;%>
		            	<tr><td>
					        <label class="hidden" for="<%=id%>">
								<html:text property="<%=appendValueName%>"
									name="<%=formAction%>"
									size="<%=fieldSize%>"
									styleId="<%=id%>"
									styleClass="textEntry"/>
							</label>
						</td></tr>
					<% }
		
		            //appendValue2
		            appendValueName = "appendValue2";
		            i_fn = 2;
		            if (fieldnames != null && fieldnames.length > i_fn) {
						SelectableValue[] selectablevalues = fieldnames[i_fn].getSelectableValues();
                                               //
					        String appendValueNameChange = "appendValueNameChange"+refId+"('"+rowindex+"')";
                                               // if this is the last one then don't the onclick change
                                               if (fieldnames.length == (i_fn + 1))
					           appendValueNameChange = "";
                                               //
                                               SelectableValue previousSelectedSelectableValue = null;
                                               SelectableValue[] previousSelectableValues = fieldnames[i_fn-1].getSelectableValues();
                                               if (previousSelectableValues != null && previousSelectableValues.length > 0) {
                                                  FieldName[] previousFieldName1 = previousSelectableValues[0].getFieldNames();
                                                  if (previousFieldName1 != null && previousFieldName1.length > 0) {
                                                     SelectableValue[] previousSelectableValues1 = previousFieldName1[0].getSelectableValues();
                                                     if (previousSelectableValues1 != null && previousSelectableValues1.length > 0) {
                                                        if (selectedAppendValue1 != null && selectedAppendValue1.length() > 0) {
                                                           for (int i_sv=0; i_sv<previousSelectableValues.length; i_sv++) {
                                                              if (previousSelectableValues[i_sv].getName().equals(selectedAppendValue1)) {
                                                                 previousSelectedSelectableValue = previousSelectableValues[i_sv];
                                                                 break;
                                                              }
                                                           }
                                                        }
                                                        if (previousSelectedSelectableValue == null) { // default to the first one
                                                           previousSelectedSelectableValue = previousSelectableValues[0];
                                                        }
                                                        previousFieldName1 = previousSelectedSelectableValue.getFieldNames();
                                                        selectablevalues = previousFieldName1[0].getSelectableValues();
                                                     }
                                                  }
                                               }
                                               //
				   		if (selectablevalues != null && selectablevalues.length > 0) {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
                                                           <%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
                                                           <br />
					       		    <html:select property="<%=appendValueName%>" name="<%=formAction%>" size="1" styleId="<%=appendValueName+refId%>" onchange="<%=appendValueNameChange%>"><%
					       			   	 for (int i_sv=0; i_sv<selectablevalues.length; i_sv++) { %>
					       			       	<html:option value="<%=selectablevalues[i_sv].getName()%>">
					       			       		<%=selectablevalues[i_sv].getDisplayName(request.getLocale())%>
					       			       	</html:option><%
					       			     }%>
					       			</html:select>
					       		</label>
				   			  </td>
						    </tr><%
						} else {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
				                	<%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
				                	<br />
								
									<html:text property="<%=appendValueName%>"
										name="<%=formAction%>"
										size="<%=fieldSize%>"
										styleId="<%=appendValueName+refId%>"
										styleClass="textEntry"
										title="<%=messages.getMessage(request.getLocale(),desc)%>"/>
				                </label>
				              </td>
				   			</tr> <%
						}
		            } else {
		            	String id = "fake"+appendValueName+refId;%>
		            	<tr><td>
					        <label class="hidden" for="<%=id%>">
							<html:text property="<%=appendValueName%>"
								name="<%=formAction%>"
								size="<%=fieldSize%>"
								styleId="<%=id%>"
								styleClass="textEntry"/>
							</label>
						</td></tr>
					<% }
		
		            //appendValue3
		            appendValueName = "appendValue3";
		            i_fn = 3;
		            if (fieldnames != null && fieldnames.length > i_fn) {
						SelectableValue[] selectablevalues = fieldnames[i_fn].getSelectableValues();
                                               //
					        String appendValueNameChange = "appendValueNameChange"+refId+"('"+rowindex+"')";
                                               // if this is the last one then don't the onclick change
                                               if (fieldnames.length == (i_fn + 1))
					           appendValueNameChange = "";
                                               //
                                               SelectableValue previousSelectedSelectableValue = null;
                                               SelectableValue[] previousSelectableValues = fieldnames[i_fn-1].getSelectableValues();
                                               if (previousSelectableValues != null && previousSelectableValues.length > 0) {
                                                  FieldName[] previousFieldName1 = previousSelectableValues[0].getFieldNames();
                                                  if (previousFieldName1 != null && previousFieldName1.length > 0) {
                                                     SelectableValue[] previousSelectableValues1 = previousFieldName1[0].getSelectableValues();
                                                     if (previousSelectableValues1 != null && previousSelectableValues1.length > 0) {
                                                        if (selectedAppendValue2 != null && selectedAppendValue2.length() > 0) {
                                                           for (int i_sv=0; i_sv<previousSelectableValues.length; i_sv++) {
                                                              if (previousSelectableValues[i_sv].getName().equals(selectedAppendValue2)) {
                                                                 previousSelectedSelectableValue = previousSelectableValues[i_sv];
                                                                 break;
                                                              }
                                                           }
                                                        }
                                                        if (previousSelectedSelectableValue == null) { // default to the first one
                                                           previousSelectedSelectableValue = previousSelectableValues[0];
                                                        }
                                                        previousFieldName1 = previousSelectedSelectableValue.getFieldNames();
                                                        selectablevalues = previousFieldName1[0].getSelectableValues();
                                                     }
                                                  }
                                               }
                                               //
				   		if (selectablevalues != null && selectablevalues.length > 0) {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
                                                           <%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
                                                           <br />
					       		    <html:select property="<%=appendValueName%>" name="<%=formAction%>" size="1" styleId="<%=appendValueName+refId%>" onchange="<%=appendValueNameChange%>"><%
					       			   	 for (int i_sv=0; i_sv<selectablevalues.length; i_sv++) { %>
					       			       	<html:option value="<%=selectablevalues[i_sv].getName()%>">
					       			       		<%=selectablevalues[i_sv].getDisplayName(request.getLocale())%>
					       			       	</html:option><%
					       			     }%>
					       			</html:select>
					       		</label>
				   			  </td>
						    </tr><%
						} else {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
				                	<%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
				                	<br />
								
									<html:text property="<%=appendValueName%>"
										name="<%=formAction%>"
										size="<%=fieldSize%>"
										styleId="<%=appendValueName+refId%>"
										styleClass="textEntry"
										title="<%=messages.getMessage(request.getLocale(),desc)%>"/>
				                </label>
				              </td>
				   			</tr> <%
						}
		            } else {
		            	String id = "fake"+appendValueName+refId;%>
		            	<tr><td>
					        <label class="hidden" for="<%=id%>">
							<html:text property="<%=appendValueName%>"
								name="<%=formAction%>"
								size="<%=fieldSize%>"
								styleId="<%=id%>"
								styleClass="textEntry"/>
							</label>
						</td></tr>
					<% }

		            //appendValue4
		            appendValueName = "appendValue4";
		            i_fn = 4;
		            if (fieldnames.length > i_fn) {
						SelectableValue[] selectablevalues = fieldnames[i_fn].getSelectableValues();
                                               //
					        String appendValueNameChange = "appendValueNameChange"+refId+"('"+rowindex+"')";
                                               // if this is the last one then don't the onclick change
                                               if (fieldnames.length == (i_fn + 1))
					           appendValueNameChange = "";
                                               //
                                               SelectableValue previousSelectedSelectableValue = null;
                                               SelectableValue[] previousSelectableValues = fieldnames[i_fn-1].getSelectableValues();
                                               if (previousSelectableValues != null && previousSelectableValues.length > 0) {
                                                  FieldName[] previousFieldName1 = previousSelectableValues[0].getFieldNames();
                                                  if (previousFieldName1 != null && previousFieldName1.length > 0) {
                                                     SelectableValue[] previousSelectableValues1 = previousFieldName1[0].getSelectableValues();
                                                     if (previousSelectableValues1 != null && previousSelectableValues1.length > 0) {
                                                        if (selectedAppendValue3 != null && selectedAppendValue3.length() > 0) {
                                                           for (int i_sv=0; i_sv<previousSelectableValues.length; i_sv++) {
                                                              if (previousSelectableValues[i_sv].getName().equals(selectedAppendValue3)) {
                                                                 previousSelectedSelectableValue = previousSelectableValues[i_sv];
                                                                 break;
                                                              }
                                                           }
                                                        }
                                                        if (previousSelectedSelectableValue == null) { // default to the first one
                                                           previousSelectedSelectableValue = previousSelectableValues[0];
                                                        }
                                                        previousFieldName1 = previousSelectedSelectableValue.getFieldNames();
                                                        selectablevalues = previousFieldName1[0].getSelectableValues();
                                                     }
                                                  }
                                               }
                                               //
				   		if (selectablevalues != null && selectablevalues.length > 0) {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
                                                           <%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
                                                           <br />
					       		    <html:select property="<%=appendValueName%>" name="<%=formAction%>" size="1" styleId="<%=appendValueName+refId%>" onchange="<%=appendValueNameChange%>"><%
					       			   	 for (int i_sv=0; i_sv<selectablevalues.length; i_sv++) { %>
					       			       	<html:option value="<%=selectablevalues[i_sv].getName()%>">
					       			       		<%=selectablevalues[i_sv].getDisplayName(request.getLocale())%>
					       			       	</html:option><%
					       			     }%>
					       			</html:select>
					       		</label>
				   			  </td>
						    </tr><%
						} else {%>
							<tr>
							  <td class="table-text" valign="top">
				                <label for="<%=appendValueName+refId%>" title="<bean:message key="<%=desc%>"/>">
				                	<%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
				                	<br />
								
									<html:text property="<%=appendValueName%>"
										name="<%=formAction%>"
										size="<%=fieldSize%>"
										styleId="<%=appendValueName+refId%>"
										styleClass="textEntry"
										title="<%=messages.getMessage(request.getLocale(),desc)%>"/>
				                </label>
				              </td>
				   			</tr> <%
						}
		            } else {
		            	String id = "fake"+appendValueName+refId;%>
		            	<tr><td>
					        <label class="hidden" for="<%=id%>">
								<html:text property="<%=appendValueName%>"
									name="<%=formAction%>"
									size="<%=fieldSize%>"
									styleId="<%=id%>"
									styleClass="textEntry"/>
							</label>
						</td></tr>
					<% } %>
		
					</tbody>
		<%          if (!(co instanceof BooleanOperand)) {%>
					<tr>
		<%			
						com.ibm.wsspi.expr.core.Identifier[] operators ;
						if (customOperands != null) {
							//operators = SIPRulesConsoleUtils.getClusterLangOperators(co);
							com.ibm.wsspi.expr.Language cDefLang = com.ibm.wsspi.odr.OdrManagerFactory.getManager().getClusterDefinitionLanguage();
							operators = cDefLang.getOperators(co);
							
						} else {
							operators = Protocols.findLanguage(co.getName()).getOperatorNames(co);
						}		

		              Vector operatorValueVector = new Vector();
			          //DialectOperator[] operators = operand.getOperators();
					  for (int i=0; i<operators.length; i++) {
				  	       operatorValueVector.add(operators[i]);
			          } %>
				      <td class="table-text">
					    <table role="presentation">
					      <tr>
						    <td class="table-text" valign="top">
						  	  <%
						  	     styleId = "selectedOperator"+refId;
						  	     String updateOperand = "updateOperand"+refId+"()";
						  	  %>
						      <label for="<%=styleId%>" title="<bean:message key="rule.builder.operator.desc"/>">
		               		    <bean:message key="rule.builder.operator" />
						  	    <br/>
							    <html:select name="<%=formAction%>" property="selectedOperator" styleId="<%=styleId%>" onchange="<%=updateOperand%>" >
		<%                      for (int i=0; i < operatorValueVector.size(); i++) {
		                    	    Identifier val = (Identifier) operatorValueVector.get(i);
		                    	    String valToDisplay="";
						     	    try {
						     		  valToDisplay=val.getDisplayName(request.getLocale())+" ("+val.getName()+")";
						     		  if (valToDisplay == null) {
						     			  valToDisplay=val.getName();
						     		  }
						     	    } catch(Exception e) {
						     		  valToDisplay=val.getName();
						     	    } %>
							        <html:option value="<%=val.getName()%>">
						  		      <%=valToDisplay%>
							        </html:option>
		<%	                    } %>
						        </html:select>
						      </label>				
						    </td>
					      </tr>
				   	    </table>
				  	  </td>
				    </tr>
		<%			} else {%>
						<%
						  	     styleId = "selectedOperator"+refId;
						%>
						<tr class="hidden"><td>
							<label class="hidden" for="<%=styleId%>" title="<bean:message key="rule.builder.operator.desc"/>">
		               		    <bean:message key="rule.builder.operator" />
		                	</label>
							<input name="selectedOperator" type="text" size="<%=fieldSize%>" value="" class="textEntry" id="<%=styleId%>" />
						</td></tr>
		<% 			} %>
				<!-- Start operand input -->
				<tr>	
				  <td class="table-text">
		    		<table role="presentation">
					  <tbody id="<%=simpleMatchInput%>">
		    			<tr valign="top">
		<% 				if (co.getSelectableValues() != null && co.getSelectableValues().length > 0) {
		        		   SelectableValue[] values = co.getSelectableValues(); %>
					       <td class="table-text">        		
						     <label for="<%=simpleMatchInput%>" title="<bean:message key="rule.builder.value.desc"/>">
		        			   <bean:message key="rule.builder.value" /><br/>
							   <html:select name="<%=formAction%>" property="simpleMatch" styleId="<%=simpleMatchInput%>">
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
		<%			    } else{ %>    			
							<tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
								<tiles:put name="property" value="simpleMatch" />
								<tiles:put name="isReadOnly" value="false" />
								<tiles:put name="isRequired" value="true" />
								<tiles:put name="label" value="rule.builder.value" />
								<tiles:put name="size" value="<%=fieldSize%>" />
								<tiles:put name="bean" value="<%=formAction%>" />
								<tiles:put name="units" value=""/>
								<tiles:put name="desc" value="rule.builder.value.desc"/>
							</tiles:insert>
		<%			    } %>
		    			</tr>
					  </tbody>		
		    		  <tbody id="<%=betweenMatchInput%>">
						<tr>
						  <td class="table-text">
							<table role="presentation">
							  <tr>
		<%         	          if (co.getSelectableValues() != null && co.getSelectableValues().length > 0) {
		          		          SelectableValue[] values = co.getSelectableValues(); %>
								<td class="table-text">
		  						  <label for="<%=betweenMatchInput%>" title="<bean:message key="rule.builder.lowerbound.desc"/>">
									<bean:message key="rule.builder.lowerbound" />
					            	<html:select name="<%=formAction%>" property="betweenLowerBoundMatch" styleId="<%=betweenMatchInput%>"><br/>
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
		<%       			  }	else { %> 			
								<tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
									<tiles:put name="property" value="betweenLowerBoundMatch" />
									<tiles:put name="isReadOnly" value="false" />
									<tiles:put name="isRequired" value="true" />
									<tiles:put name="label" value="rule.builder.lowerbound" />
									<tiles:put name="size" value="<%=fieldSize%>" />
									<tiles:put name="bean" value="<%=formAction%>" />
									<tiles:put name="units" value=""/>
									<tiles:put name="desc" value="rule.builder.lowerbound.desc"/>
								</tiles:insert>
		<%         			  } %>  	
							  </tr>
							  <tr align="center">
								<td class="table-text"  valign="top" align="center">
								  <span align="center">
									<bean:message key="rule.builder.between.and"/>
								  </span>			
								</td>
							  </tr>
							 <tr>
		<%                   if (co.getSelectableValues() != null && co.getSelectableValues().length > 0) {
		                 		SelectableValue[] values = co.getSelectableValues(); %>
							   <td class="table-text">
								 <label for="<%=betweenUpperBoundMatch%>" title="<bean:message key="rule.builder.upperbound.desc"/>">
								   <bean:message key="rule.builder.upperbound" /><br/>
								   <html:select name="<%=formAction%>" property="betweenUpperBoundMatch" styleId="<%=betweenUpperBoundMatch%>">
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
		<%        	        } else{ %>
								<tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
									<tiles:put name="property" value="betweenUpperBoundMatch" />
									<tiles:put name="isReadOnly" value="false" />
									<tiles:put name="isRequired" value="true" />
									<tiles:put name="label" value="rule.builder.upperbound" />
									<tiles:put name="size" value="<%=fieldSize%>" />
									<tiles:put name="bean" value="<%=formAction%>" />
									<tiles:put name="units" value=""/>
									<tiles:put name="desc" value="rule.builder.upperbound"/>
								</tiles:insert>   				
		<%      			} %>
							</tr>
						  </table>
						</td>    			
					  </tr>
					</tbody>
					<tbody id="<%=inMatchInput%>">
		    		  <tr>
					    <td class="table-text">
			    		  <tiles:insert page="/com.ibm.ws.console.xdcore/inInputLayout.jsp" flush="false">
					    	<tiles:put name="formName" value="<%=formAction%>"/>
		    				<tiles:put name="operand" value="<%=co%>"/>
		    				<tiles:put name="rowindex" value="<%=rowindex%>"/>
		    				<tiles:put name="refId" value="<%=refId%>"/>
		    			  </tiles:insert>
					    </td>
		    		  </tr>
					</tbody>
					  <tr>
					    <td valign="top" class="wizard-step-text" colspan="2">
		                  <%
		                     String setRowIndex = "";
		                     if (!isSingleRule)
		                        setRowIndex = "setRowIndex('"+rowindex+"')";
		                  %>
		            	  <html:submit property="installAction" styleId="other7" styleClass="buttons_other" onclick="<%=setRowIndex%>">
		              	    <bean:message key="rule.builder.generate.button"/>
		 	  	          </html:submit>
						</td>
					  </tr>
					  <tr>
						  <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
							<tiles:put name="property" value="subexpression" />
						    <tiles:put name="isReadOnly" value="no" />
						    <tiles:put name="isRequired" value="no" />
						    <tiles:put name="label" value="rule.builder.subexpression" />
						    <tiles:put name="desc" value="rule.builder.subexpression.desc" />
							<tiles:put name="size" value="50" />
							<tiles:put name="units" value=""/>
						    <tiles:put name="bean" value="<%=formAction%>" />
						  </tiles:insert>
					  </tr>
					  <tr>
					    <td valign="top" class="wizard-step-text">
		            	  <html:submit property="installAction" styleId="other8" styleClass="buttons_other" onclick="<%=setRowIndex%>">
		              	    <bean:message key="rule.builder.append.button"/>
		 	  	          </html:submit>
						</td>
						<td  class="table-text" nowrap>
		                  [ <a href="#" onclick="showHideSection('ruleBuilder<%=refId%>', '<%=refId%>')" onkeypress="showHideSection('ruleBuilder<%=refId%>', '<%=refId%>')">
							 <bean:message key="rule.edit.link.subexpression.close"/></a> ]
						</td>
					  </tr>
					</table>
				  </td>
				</tr>
			  </table>
			  </fieldset>
			</td>
		  </tr>
		</table>
	</td>
  </tr>
</table>



<script language="JavaScript">
	updateOperand<%=refId%>();
</script>
