<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 2005-2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>  <%-- LIDB2303A --%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.workclass.util.Constants"%>
<%@ page import="com.ibm.ws.console.workclass.util.MatchRuleUtils"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.classify.*"%>
<%@ page import="com.ibm.ws.classify.definitions.*"%>
<%@ page import="com.ibm.wsspi.classify.*"%>
<%@ page import="com.ibm.wsspi.expr.*"%>
<%@ page import="com.ibm.wsspi.expr.operand.*"%>
<%@ page import="com.ibm.wsspi.expr.core.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>


<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<%String contextId = null;%>
<logic:notEmpty name="<%=formName%>" property="contextId">
<bean:define id="contextId_new" name="<%=formName%>" property="contextId" type="java.lang.String"/>
<%contextId = contextId_new;%>
</logic:notEmpty>
<bean:define id="perspective" name="<%=formName%>" property="perspective"/>
<bean:define id="type" name="<%=formName%>" property="conditionType" type="String"/>

<% org.apache.struts.util.MessageResources messages = (org.apache.struts.util.MessageResources)pageContext.getServletContext().getAttribute(org.apache.struts.action.Action.MESSAGES_KEY); %>

<%
Operand[] operands = MatchRuleUtils.listClassificationOperands(request);
Operand operand = null;
for(int i=0; i<operands.length; i++){
       if(operands[i].getName().equals(type)){
              operand = operands[i];
              break;
       }
}

if (operand == null) {
    operand = operands[0];
}
%>

<script language="JavaScript">

function operandNameChange() {
	var selectedOperand = document.forms[0].selectedOperand.value;
	window.location = encodeURI("/ibm/console/RuleBuilderConditionDetail.do?operand=" + encodeURI(selectedOperand) + "&OperandChanged=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function updateOperand(){
	var simpleInput = document.getElementById("simpleMatchInput");
	var btwnInput = document.getElementById("betweenMatchInput")
	var inInput = document.getElementById("inMatchInput");

<% if (!(operand instanceof BooleanOperand)) { %>
		var operator = document.forms[0].operator.value;
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
<% } %>
}
</script>

<%
String contextType=(String)request.getAttribute("contextType");
String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;

com.ibm.ws.console.workclass.form.RuleBuilderConditionForm form = (com.ibm.ws.console.workclass.form.RuleBuilderConditionForm) request.getSession().getAttribute(formName);
String expression = (String) request.getSession().getAttribute(Constants.KEY_GENERATED_EXPRESSION);
if (expression == null){
	expression = "";
}

java.util.ArrayList attributeList_ext =  new java.util.ArrayList();
//for(int i=0;i<attributeList.size(); i++)
//     attributeList_ext.add(attributeList.get(i));

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.form";
IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType,extensionId);

IExtension[] extensions;
try{
	extensions= registry.getExtensions(extensionId,ic);
}catch(Exception e){
	extensions=null;
}

if(extensions!=null && extensions.length>0){
    if(contextId!=null && contextId!="nocontext"){
        props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
    }

    props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName); // LIDB2303A

    attributeList_ext = FieldSelector.getFields(extensions,attributeList_ext,props,(String)perspective);
}
attributeList_ext = FieldSelector.getCategories(extensions,attributeList_ext,(String)perspective);

pageContext.setAttribute("attributeList_ext",attributeList_ext);
%>

<%  String renderReadOnlyView = "no";
if (SecurityContext.isSecurityEnabled()) {
    renderReadOnlyView = "yes";
    if (request.isUserInRole("administrator")) {
        renderReadOnlyView = "no";
    }
    else if (request.isUserInRole("configurator")) {
        renderReadOnlyView = "no";
    } 
}

%>

<%
   //Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
   //String numberOfColumns = "3";
   //if (descriptionsOn.booleanValue() == false)
   //  numberOfColumns = "2";
   WASProduct productInfo = new WASProduct();

   String fieldLevelHelpTopic = "";
   String fieldLevelHelpAttribute = "";
   String DETAILFORM = "DetailForm";
   String objectType = "";
   int index = formType.lastIndexOf ('.');
   if (index > 0)
   {
      String fType = formType.substring (index+1);
      if (fType.endsWith (DETAILFORM))
         objectType = fType.substring (0, fType.length()-DETAILFORM.length());
      else
         objectType = fType;
   }
   fieldLevelHelpTopic = objectType+".detail.";
   String topicKey = fieldLevelHelpTopic;

String selectedOperand = form.getSelectedOperand();
Collection operandNames = form.getOperands();
pageContext.setAttribute("operandNamesBean", MatchRuleUtils.getOperandsCollection(request));
String operandDownChanged = "operandNameChange()";
%>
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" focus="operator">
<html:hidden property="action"/>
<table class="framing-table" border="0" cellpadding="5" cellspacing="0" width="100%" summary="Properties Table" >
	<tr>
		<td class="table-text">
			<table>
				<tbody>
				<tr>
						<label title="<bean:message key="rulebuilder.operand.label.desc"/>">
							<bean:message key="rulebuilder.operand.label" />
						</label><br />
						<html:select size="1" value="<%=selectedOperand%>" property="notUsed" styleId="selectedOperand"
							onchange="<%=operandDownChanged%>">
						<html:options name="operandNamesBean" labelProperty="operands" />
						</html:select>
				</tr>
        	<%


         String fieldSize="30";
         if ((operand.getName().equals(ClassificationDictionary.CLIENT_IPV6)) || (operand.getName().equals(ClassificationDictionary.SERVER_IPV6))) {	
		 	fieldSize="50";
		 }
%>			<tbody id="appendableInputl"><%
			FieldName[] fieldnames = operand.getFieldNames();
            if(fieldnames != null && fieldnames.length > 0){ 
            	for (int i_fn=0; i_fn<fieldnames.length; i_fn++) {
    				String appendValueName = "appendValue"+i_fn;
            		if (i_fn<5) {
            			SelectableValue[] selectablevalues = fieldnames[i_fn].getSelectableValues();
            			if (selectablevalues != null && selectablevalues.length > 0) {%>
            				<tr>
            				  <td class="table-text" scope="row" valign="top">
		            		    <html:select property="<%=appendValueName%>" name="<%=formName%>" size="1" styleId="<%=appendValueName%>"><%
		            			   	 for (int i_sv=0; i_sv<selectablevalues.length; i_sv++) { %>
		            			       	<html:option value="<%=selectablevalues[i_sv].getName()%>">
		            			       		<%=selectablevalues[i_sv].getDisplayName(request.getLocale())%>
		            			       	</html:option><%
		            			     }%>
		            			</html:select>
	            			  </td>
            			    </tr><%
            			} else {%>
            				<tr>
            				  <td class="table-text" scope="row" valign="top">
            					<% String desc = "rule.builder.appendvalue.desc"; %>
				                <label  for="<%=appendValueName%>" title="<bean:message key="<%=desc%>"/>">
				                	<%=fieldnames[i_fn].getDisplayName(request.getLocale())%>
				                	<br />
									<html:text property="<%=appendValueName%>" 
										name="<%=formName%>" 
										size="<%=fieldSize%>" 
										styleId="<%=appendValueName%>" 
										styleClass="textEntry"
										title="<%=messages.getMessage(request.getLocale(),desc)%>"/>
				                </label>
				              </td>
	            			</tr> <%           				
            			}
            		}
            	}
            
            
            
            } %>
			</tbody>

<%          if (!(operand instanceof BooleanOperand)) {%>
			<tr>
<%			  com.ibm.wsspi.expr.core.Identifier[] operators = Protocols.findLanguage(operand.getName()).getOperatorNames(operand);
              Vector operatorValueVector = new Vector();
	          //DialectOperator[] operators = operand.getOperators();
			  for (int i=0; i<operators.length; i++) {
		  	       operatorValueVector.add(operators[i]);
	          } %>
		      <td class="table-text">
			    <table>
			      <tr>
				    <td class="table-text" valign="top">
				      <label title="<bean:message key="rulebuilder.operator.label.desc"/>">
               		    <bean:message key="rulebuilder.operator.label" />
				  	    <br/>
					    <html:select name="<%=formName%>" property="operator" styleId="operator" onchange="updateOperand()" onfocus="updateOperand()">
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
<%			} else {
				//if the operator property is not executed add this hidden property
%>			    <input type="hidden" name="operator" value=""/> <%
			}
%>

			    <!-- Start operand input -->
			   	<tr>
					<td class="table-text">
    					<table>
			    			<tbody id="simpleMatchInput">
    						<tr valign="top">
<%          if(operand.getSelectableValues() != null && operand.getSelectableValues().length > 0){
        		SelectableValue[] values = operand.getSelectableValues(); %>
			    				<td class="table-text">        		
									<label title="<bean:message key="workclass.rulebuilder.simpleMatch.label.desc"/>">
        								<bean:message key="workclass.rulebuilder.simpleMatch.label" /><br/>
					            		<html:select name="<%=formName%>" property="simpleMatch">
                <%   for (int i=0; i < values.length; i++) {
                        String val = values[i].getName(); %>
									  		<html:option value="<%=val%>"><%=val%></html:option>
<%                   }        %>
										</html:select>
									</label>
			    				</td>									
<%			} else{ %>    			
									<tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
										<tiles:put name="property" value="simpleMatch" />
										<tiles:put name="isReadOnly" value="false" />
										<tiles:put name="isRequired" value="true" />
										<tiles:put name="label" value="workclass.rulebuilder.simpleMatch.label" />
										<tiles:put name="size" value="<%=fieldSize%>" />
										<tiles:put name="bean" value="<%=formName%>" />
										<tiles:put name="units" value=""/>
										<tiles:put name="desc" value="workclass.rulebuilder.simpleMatch.label.desc"/>
									</tiles:insert>
<%			} %>    				

    						</tr>
				    		</tbody>
    						<tbody id="betweenMatchInput">
							<tr>
								<td class="table-text">
									<table>
										<tr>
<%
        	if(operand.getSelectableValues() != null && operand.getSelectableValues().length > 0){
        		SelectableValue[] values = operand.getSelectableValues();
        	%>
											<td class="table-text">
												<label title="<bean:message key="workclass.rulebuilder.lowerBoundMatch.label.desc"/>">
													<bean:message key="workclass.rulebuilder.lowerBoundMatch.label" />
									            	<html:select name="<%=formName%>" property="betweenLowerBoundMatch"><br/>
                <%
                     for (int i=0; i < values.length; i++)
                     {
                     	String val = values[i].getName();
                     %>
												  		<html:option value="<%=val%>"><%=val%></html:option>
<%					 } %>
									                </html:select>
												</label>
											</td>      		
<%			}	else { %> 			
											<tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
												<tiles:put name="property" value="betweenLowerBoundMatch" />
												<tiles:put name="isReadOnly" value="false" />
												<tiles:put name="isRequired" value="true" />
												<tiles:put name="label" value="workclass.rulebuilder.lowerBoundMatch.label" />
												<tiles:put name="size" value="<%=fieldSize%>" />
												<tiles:put name="bean" value="<%=formName%>" />
												<tiles:put name="units" value=""/>
												<tiles:put name="desc" value="workclass.rulebuilder.lowerBoundMatch.label.desc"/>
											</tiles:insert>
<%			}%>  				
										</tr>
										<tr align="center">
											<td class="table-text"  scope="row" valign="top" align="center">
												<span align="center">
													<bean:message key="workclass.rulebuilder.between.and.label"/>
												</span>			
											</td>
										</tr>
										<tr>
<%
        	if(operand.getSelectableValues() != null && operand.getSelectableValues().length > 0){
        		SelectableValue[] values = operand.getSelectableValues();
        	%>
											<td class="table-text">
												<label title="<bean:message key="workclass.rulebuilder.upperBoundMatch.label.desc"/>">
													<bean:message key="workclass.rulebuilder.upperBoundMatch.label" /><br/>
													<html:select name="<%=formName%>" property="betweenUpperBoundMatch">
                <%
                     for (int i=0; i < values.length; i++)
                     {
                     	String val = values[i].getName();
                     %>
														<html:option value="<%=val%>"><%=val%></html:option>
<%					 } %>
													</html:select>
        		
												</label>
											</td>
<%        	} else{ %>    			
											<tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
												<tiles:put name="property" value="betweenUpperBoundMatch" />
												<tiles:put name="isReadOnly" value="false" />
												<tiles:put name="isRequired" value="true" />
												<tiles:put name="label" value="workclass.rulebuilder.upperBoundMatch.label" />
												<tiles:put name="size" value="<%=fieldSize%>" />
												<tiles:put name="bean" value="<%=formName%>" />
												<tiles:put name="units" value=""/>
												<tiles:put name="desc" value="workclass.rulebuilder.upperBoundMatch.label.desc"/>
											</tiles:insert>   				
<%			}%>
										</tr>
									</table>
								</td>    			
				    		</tr>
			    			</tbody>
			    			<tbody id="inMatchInput">
    						<tr>
			    				<td class="table-text">
	    							<tiles:insert page="/com.ibm.ws.console.workclass/inInputLayout.jsp" flush="false">
			    						<tiles:put name="formName" value="<%=formName%>"/>
    									<tiles:put name="operand" value="<%=operand%>"/>
    								</tiles:insert>
			    				</td>
    						</tr>
			    			</tbody>
							<tr>
								<td class="navigation-button-section" nowrap VALIGN="top">
    								<input type="submit" name="buildsubexpression" value="<bean:message key="workclass.matchrule.button.rulebuilder"/>" class="buttons" id="navigation" />
								</td>
							</tr>  
							<tr>	
								<td class="table-text" nowrap VALIGN="top">
								    <br />
									<fieldset>
						               	<legend title="<bean:message key="workclass.matchrule.generate.subexpression.description"/>">
							               	<bean:message key="workclass.matchrule.generate.subexpression.label"/>
							            </legend>					
							            
										<label title="<bean:message key="workclass.matchrule.subexpression.description"/>">
    		           						<bean:message key="workclass.matchrule.subexpression.label" />
    		           						<br />
	    		                            <input type="text" size="50" nowrap valign="top" value="<%=expression%>" class="textEntry" />
										</label>
									</fieldset>
    	                        </td>
    	                        <!-- 
								<td class="table-text" nowrap VALIGN="top">
									<html:textarea property="expression" name="<%=formName%>" cols="50" rows="1" styleClass="textEntry" styleId="expression">
									</html:textarea>
								</td>
								-->
							</tr>							      			
				    	</table>
			    	</td>
			    </tr>	
			</table>
		</td>
	</tr>
</table>
</html:form>

<script language="JavaScript">
	updateOperand();
</script>
