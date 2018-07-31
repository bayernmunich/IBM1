<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ page import="com.ibm.ws.console.hmm.form.HMMDetailForm,com.ibm.ws.xd.config.hmm.TimeConstraint" %>

   <tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<%
String FORM_NAME = "HMMDetailForm";
HMMDetailForm form = (HMMDetailForm)session.getAttribute(FORM_NAME);
java.util.ArrayList timeConstraints = form.getProhibitedRestartTimes();
pageContext.setAttribute("timeConstraints", timeConstraints);
boolean isReadOnly = readOnly.equalsIgnoreCase("true");
java.util.Locale locale = request.getLocale();
// defect 280264
boolean isSundayFirstDayOfWeek = (java.util.Calendar.getInstance(locale).getFirstDayOfWeek()==java.util.Calendar.SUNDAY);
%>
<script>
var IS_READ_ONLY = <%=readOnly%>;
var IS_SUNDAY_FIRST_DAY_OF_WEEK = <%=isSundayFirstDayOfWeek%>;
</script>
<script type="text/javascript" language="JavaScript" src="<%=request.getContextPath()%>/com.ibm.ws.console.hmm/timeConstraints.js"></script>
<style>
	.tcRow{ background-color: #F7F7F7; font-size:70%; border-width:1px; border-color:white; font-family:Arial,Helvetica,sans-serif; white-space:nowrap; text-align:center; vertical-align:middle;}	
	.column-head-name{padding-left: .35em; font-family: Arial,Helvetica, sans-serif; font-size:70.0%;font-weight:bold; text-align: center; color: #000000; background-color: #BBCEDB;}
	.framing-table { background-color: #767776; border-width:1px; border-style:solid; border-color:white; background-image: none; }
</style>

<!-- time constraints table -->
	<table id="outsideTcTable" role="presentation">
		<%if(!isReadOnly){%>
			<tr>			
				<td colspan="7">
					<input type="button" class="buttons" value="<bean:message key="button.add"/>" onClick="addConstraint()" />
					<input type="button" class="buttons" value="<bean:message key="button.remove"/>" onClick="removeConstraints()" />
				</td>
			</tr>
		<%}%>
		<tr>
			<td>
				<table id="timeConstraints" class="framing-table" cellspacing="1" cellpadding="2" border="2">
					<tbody id="tcBody">
					<%
						String num, startHour, endHour, startMinute, endMinute, start, end, selectedText;
						String monText, tuesText, wedText, thursText, friText, satText, sunText;
						if (!isReadOnly || timeConstraints.size() > 0){				
					%>
						<tr>
							<th class="column-head-name">
								<div class="hidden"><bean:message key="select.text"/></div>
							</th>
							<th align="center" class="column-head-name"><bean:message key="timeconstraints.start"/></th>
							<th align="center" class="column-head-name"><bean:message key="timeconstraints.end"/></th>
							<% if (isSundayFirstDayOfWeek) { %>
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.sunday"/></th>
							<% } %>
								
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.monday"/></th>
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.tuesday"/></th>
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.wednesday"/></th>
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.thursday"/></th>
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.friday"/></th>
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.saturday"/></th>
								
							<% if (!isSundayFirstDayOfWeek) { %>
								<th align="center" class="column-head-name"><bean:message key="timeconstraints.sunday"/></th>
							<% } %>
						</tr>
					<% } %>

						<logic:iterate name="timeConstraints" indexId="ctr" id="tc" type="com.ibm.ws.xd.config.hmm.TimeConstraint">
						<%
							num = "";
							startHour = "00";
							endHour = "01";
							startMinute="00";
							endMinute="01";
							start = tc.getStartTime();
							end = tc.getEndTime();
							int colon = start.indexOf(":");
							if (colon != -1){
								startHour = start.substring(0, colon);
								startMinute = start.substring(colon+1);
							}
							colon = end.indexOf(":");
							if (colon != -1){
								endHour = end.substring(0, colon);
								endMinute = end.substring(colon+1);
							}
							monText = tc.isMonday() ? " CHECKED " : "";
							tuesText = tc.isTuesday() ? " CHECKED " : "";
							wedText = tc.isWednesday() ? " CHECKED " : "";
							thursText = tc.isThursday() ? " CHECKED " : "";
							friText = tc.isFriday() ? " CHECKED " : "";
							satText = tc.isSaturday() ? " CHECKED " : "";
							sunText = tc.isSunday() ? " CHECKED " : "";
						%>
							<tr>
								<% if (!isReadOnly) { %>
									<td class="tcRow">
									    <label class="hidden" for="constraint[<%=ctr%>].remove" title="<bean:message key="timeconstraints.remove"/>"><bean:message key="timeconstraints.remove" /></label>
										<input type="checkbox" name="constraint[<%=ctr%>].remove" id="constraint[<%=ctr%>].remove">
									</td>
									<td class="tcRow" style="padding-left:7px;">
									    <label class="hidden" for="constraint[<%=ctr%>].startHour" title="<bean:message key="timeconstraints.start"/>"><bean:message key="timeconstraints.start" /></label>
										<select name="constraint[<%=ctr%>].startHour" id="constraint[<%=ctr%>].startHour">
											<% for (int i = 0; i < 24; i++){ num=""; if (i < 10) num = "0"; num = num + i; selectedText = (num.equals(startHour) ? " SELECTED " : "");%>
												<option value="<%=num%>" <%=selectedText%> ><%=num%></option>
											<%}%>										
										</select>
										<span style="font-size:170%">:</span>
									    <label class="hidden" for="constraint[<%=ctr%>].startMinute" title="<bean:message key="timeconstraints.start"/>"><bean:message key="timeconstraints.start" /></label>
										<select name="constraint[<%=ctr%>].startMinute" id="constraint[<%=ctr%>].startMinute">
											<% for (int i = 0; i < 60; i++){ num=""; if (i < 10) num = "0"; num = num + i; selectedText = (num.equals(startMinute) ? " SELECTED " : "");%>
												<option value="<%=num%>" <%=selectedText%> ><%=num%></option>
											<%}%>										
										</select>
									</td>
									<td class="tcRow" style="padding-left:7px;">
									    <label class="hidden" for="constraint[<%=ctr%>].endHour" title="<bean:message key="timeconstraints.end"/>"><bean:message key="timeconstraints.end" /></label>
										<select name="constraint[<%=ctr%>].endHour" id="constraint[<%=ctr%>].endHour">
											<% for (int i = 0; i < 24; i++){ num=""; if (i < 10) num = "0"; num = num + i; selectedText = (num.equals(endHour) ? " SELECTED " : "");%>
												<option value="<%=num%>" <%=selectedText%> ><%=num%></option>
											<%}%>										
										</select>
										<span style="font-size:170%">:</span>
									    <label class="hidden" for="constraint[<%=ctr%>].endMinute" title="<bean:message key="timeconstraints.end"/>"><bean:message key="timeconstraints.end" /></label>
										<select name="constraint[<%=ctr%>].endMinute" id="constraint[<%=ctr%>].endMinute">
											<% for (int i = 0; i < 60; i++){ num=""; if (i < 10) num = "0"; num = num + i; selectedText = (num.equals(endMinute) ? " SELECTED " : "");%>
												<option value="<%=num%>" <%=selectedText%> ><%=num%></option>
											<%}%>										
										</select>
									</td>	
			                        <% if (isSundayFirstDayOfWeek) { %>
										<td class="tcRow" style="padding-left:7px;">
											<label class="hidden" for="constraint[<%=ctr%>].sunday" title="<bean:message key="timeconstraints.sunday"/>"><bean:message key="timeconstraints.sunday" /></label>
											<input type="checkbox" name="constraint[<%=ctr%>].sunday" id="constraint[<%=ctr%>].sunday" <%=sunText%> />
										</td>
										<td class="tcRow">
											<label class="hidden" for="constraint[<%=ctr%>].monday" title="<bean:message key="timeconstraints.monday"/>"><bean:message key="timeconstraints.monday" /></label>
											<input type="checkbox" name="constraint[<%=ctr%>].monday" id="constraint[<%=ctr%>].monday" <%=monText%> />
										</td>
									<% } else { %>
										<td class="tcRow" style="padding-left:7px;">
											<label class="hidden" for="constraint[<%=ctr%>].monday" title="<bean:message key="timeconstraints.monday"/>"><bean:message key="timeconstraints.monday" /></label>
											<input type="checkbox" name="constraint[<%=ctr%>].monday" id="constraint[<%=ctr%>].monday" <%=monText%> />
										</td>
									<% } %>
									<td class="tcRow">
										<label class="hidden" for="constraint[<%=ctr%>].tuesday" title="<bean:message key="timeconstraints.tuesday"/>"><bean:message key="timeconstraints.tuesday" /></label>
										<input type="checkbox" name="constraint[<%=ctr%>].tuesday" id="constraint[<%=ctr%>].tuesday" <%=tuesText%> />
									</td>		
									<td class="tcRow">
										<label class="hidden" for="constraint[<%=ctr%>].wednesday" title="<bean:message key="timeconstraints.wednesday"/>"><bean:message key="timeconstraints.wednesday" /></label>
										<input type="checkbox" name="constraint[<%=ctr%>].wednesday" id="constraint[<%=ctr%>].wednesday" <%=wedText%> />
									</td>
									<td class="tcRow">
										<label class="hidden" for="constraint[<%=ctr%>].thursday" title="<bean:message key="timeconstraints.thursday"/>"><bean:message key="timeconstraints.thursday" /></label>
										<input type="checkbox" name="constraint[<%=ctr%>].thursday" id="constraint[<%=ctr%>].thursday" <%=thursText%> />
									</td>
									<td class="tcRow">
										<label class="hidden" for="constraint[<%=ctr%>].friday" title="<bean:message key="timeconstraints.friday"/>"><bean:message key="timeconstraints.friday" /></label>
										<input type="checkbox" name="constraint[<%=ctr%>].friday" id="constraint[<%=ctr%>].friday" <%=friText%> />
									</td>
									<td class="tcRow">
										<label class="hidden" for="constraint[<%=ctr%>].saturday" title="<bean:message key="timeconstraints.saturday"/>"><bean:message key="timeconstraints.saturday" /></label>
										<input type="checkbox" name="constraint[<%=ctr%>].saturday" id="constraint[<%=ctr%>].saturday" <%=satText%> />
									</td>
                                   	<% if (!isSundayFirstDayOfWeek) { %>
                                        <td class="tcRow">
										    <label class="hidden" for="constraint[<%=ctr%>].sunday" title="<bean:message key="timeconstraints.sunday"/>"><bean:message key="timeconstraints.sunday" /></label>
                                            <input type="checkbox" name="constraint[<%=ctr%>].sunday" id="constraint[<%=ctr%>].sunday" <%=sunText%> />
                                        </td>
                                   	<% } %>
								<% } else { %>
									<td class="tcRow">
									    <label class="hidden" for="constraint[<%=ctr%>].remove" title="<bean:message key="timeconstraints.remove"/>"><bean:message key="timeconstraints.remove" /></label>
										<input type="checkbox" name="constraint[<%=ctr%>].remove" id="constraint[<%=ctr%>].remove">
									</td>
									<td class="tcRow" style="padding-left:7px;">
										<%=startHour%>:<%=startMinute%>
									</td>
									<td class="tcRow" style="padding-left:7px;">
										<%=endHour%>:<%=endMinute%>
									</td>	
			                        <% if (isSundayFirstDayOfWeek) { %>
                                    	<td class="tcRow" style="padding-left:7px;"><%if(tc.isSunday()){%>X<%}%></td>
                                        <td class="tcRow"><%if(tc.isMonday()){%>X<%}%></td>
                                    <% } else { %> 
                                    	<td class="tcRow" style="padding-left:7px;"><%if(tc.isMonday()){%>X<%}%></td>
                                    <% } %>
                                    
		                        	<td class="tcRow"><%if(tc.isTuesday()){%>X<%}%></td>		
                                    <td class="tcRow"><%if(tc.isWednesday()){%>X<%}%></td>
                                    <td class="tcRow"><%if(tc.isThursday()){%>X<%}%></td>
                                    <td class="tcRow"><%if(tc.isFriday()){%>X<%}%></td>
                                    <td class="tcRow"><%if(tc.isSaturday()){%>X<%}%></td>
                                    
			                        <% if (!isSundayFirstDayOfWeek) { %>
                                        <td class="tcRow"><%if(tc.isSunday()){%>X<%}%></td>
                                    <% } %>
								<%}%>
							</tr>
						</logic:iterate>
					</tbody>	
				</table>
			</td>
		</tr>
	</table>
<script>
	addConstraint(); //add one blank level (usability request)
</script>






