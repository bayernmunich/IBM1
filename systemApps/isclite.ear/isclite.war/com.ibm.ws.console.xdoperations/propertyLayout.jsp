<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PropertyDetailForm"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<tiles:useAttribute name="readOnlyView" classname="java.lang.String" />
<tiles:useAttribute name="attributeList" classname="java.util.List" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />

<bean:define id="contextId" name="<%=formName%>" property="contextId" />
<bean:define id="perspective" name="<%=formName%>" property="perspective" />

<%
try {
//System.out.println("propertyLayout:: contextId=" + contextId);
//System.out.println("propertyLayout:: perspective=" + perspective);

PropertyDetailForm propDetailForm = (PropertyDetailForm) session.getAttribute(formName);
String propName = propDetailForm.getRefId();
String propValue = propDetailForm.getValue();
//System.out.println("propertyLayout:: propName=" + propName + " propValue=" + propValue);
%>

<%
String renderReadOnlyView = "no";
if ((readOnlyView != null) && (readOnlyView.equalsIgnoreCase("yes"))) {
	renderReadOnlyView = "yes";
} else if (SecurityContext.isSecurityEnabled()) {
	//renderReadOnlyView = "yes";
	//if (request.isUserInRole("administrator")) {
	//	renderReadOnlyView = "no";
	//} else if (request.isUserInRole("configurator")) {
	//	renderReadOnlyView = "no";
	//}
}
%>

<%
//Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
//String numberOfColumns = "3";
//if (descriptionsOn.booleanValue() == false)
//  numberOfColumns = "2";  
WASProduct productInfo = new WASProduct();
%>

<%
String fieldLevelHelpTopic = "";
String fieldLevelHelpAttribute = "";
String DETAILFORM = "DetailForm";
String objectType = "";
int index = formType.lastIndexOf('.');
if (index > 0) {
	String fType = formType.substring(index + 1);
	if (fType.endsWith(DETAILFORM))
		objectType = fType.substring(0, fType.length() - DETAILFORM.length());
	else
		objectType = fType;
}
fieldLevelHelpTopic = objectType + ".detail.";
String topicKey = fieldLevelHelpTopic;
%>

<%
//  If there's no properties, don't show this section
if (attributeList.size() > 0) {
	if (renderReadOnlyView.equalsIgnoreCase("yes")) {
		String activeSubhead = "";
		int propCounterReadOnly = 0;
%>

	<logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">

	<%
		fieldLevelHelpAttribute = item.getAttribute();
		if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
			fieldLevelHelpTopic = item.getLabel();
		else
			fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;
	%>

		<tr valign="top">
		<%
		if (item.getType().equalsIgnoreCase("select")) {
			try {
				session.removeAttribute("valueVector");
				session.removeAttribute("descVector");
			} catch (Exception e) {
			}
			StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ";,");
			Vector descVector = new Vector();
			while (st1.hasMoreTokens()) {
				String enumDesc = st1.nextToken();
				descVector.addElement(enumDesc);
			}
			StringTokenizer st = new StringTokenizer(item.getEnumValues(), ";,");
			Vector valueVector = new Vector();
			while (st.hasMoreTokens()) {
				String str = st.nextToken();
				valueVector.addElement(str);
			}
			session.setAttribute("descVector", descVector);
			session.setAttribute("valueVector", valueVector);
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/submitLayout.jsp" flush="false">
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="isRequired" value="<%=item.getRequired()%>" />
				<tiles:put name="readOnly" value="true" />
				<tiles:put name="valueVector" value="<%=valueVector%>" />
				<tiles:put name="descVector" value="<%=descVector%>" />
				<tiles:put name="units" value="" />
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
				<tiles:put name="size" value="30" />
			</tiles:insert>

		<%
		} else if (item.getType().equalsIgnoreCase("Dynamicselect")) {
			try {
				session.removeAttribute("valueVector");
				session.removeAttribute("descVector");
			} catch (Exception e) {
			}
			Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
			Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());

			session.setAttribute("descVector", descriptVector);
			session.setAttribute("valueVector", valVector);
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/dynamicSelectionLayout.jsp" flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="readOnly" value="true" />
				<tiles:put name="isRequired" value="<%=item.getRequired()%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="30" />
				<tiles:put name="units" value="" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
				<tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
				<tiles:put name="isTranslatable" value="false"/>
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
			</tiles:insert>

		<%
		} else {
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/textFieldLayout.jsp" flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="isReadOnly" value="true" />
				<tiles:put name="isRequired" value="false" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="30" />
				<tiles:put name="units" value="<%=item.getUnits()%>" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
			</tiles:insert>

		<%
		}
		%>
	
		<%
		propCounterReadOnly += 1;
		%>
		</tr>
	</logic:iterate>

<%
	}
%>

<%
	if (renderReadOnlyView.equalsIgnoreCase("no")) {
		String activeSubhead = "";
		int propCounter = 0;
%>

	<logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">

	<%
		fieldLevelHelpAttribute = item.getAttribute();
		if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
			fieldLevelHelpTopic = item.getLabel();
		else
			fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;
	%>


		<tr valign="top">

		<%
			String isRequired = item.getRequired();
			String strType = item.getType();
			String isReadOnly = item.getReadOnly();
			//System.out.println("propertyLayout:: type=" + strType);
		%>

		<%
		if (strType.equalsIgnoreCase("Text")) {
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/textFieldLayout.jsp" flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="name" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
				<tiles:put name="isRequired" value="<%=isRequired%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="30" />
				<tiles:put name="units" value="<%=item.getUnits()%>" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
			</tiles:insert>
			
		<%
		} else if (strType.equalsIgnoreCase("TextMedium")) {
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/textFieldLayout.jsp" flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
				<tiles:put name="isRequired" value="<%=isRequired%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="60" />
				<tiles:put name="units" value="<%=item.getUnits()%>" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
			</tiles:insert>
			
		<%
		} else if (strType.equalsIgnoreCase("TextLong")) {
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/textFieldLayout.jsp" flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
				<tiles:put name="isRequired" value="<%=isRequired%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="90" />
				<tiles:put name="units" value="<%=item.getUnits()%>" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
			</tiles:insert>
						
		<%
		} else if (strType.equalsIgnoreCase("checkbox")) {
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/checkBoxLayout.jsp" flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
				<tiles:put name="isRequired" value="<%=isRequired%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="30" />
				<tiles:put name="units" value="<%=item.getUnits()%>" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
			</tiles:insert>
						
		<%
		} else if (strType.equalsIgnoreCase("select")) {
			try {
				session.removeAttribute("valueVector");
				session.removeAttribute("descVector");
			} catch (Exception e) {
			}

			StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
			Vector descVector = new Vector();
			while (st1.hasMoreTokens()) {
				String enumDesc = st1.nextToken();
				descVector.addElement(enumDesc);
			}
			StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
			Vector valueVector = new Vector();
			while (st.hasMoreTokens()) {
				String str = st.nextToken();
				valueVector.addElement(str);
			}

			session.setAttribute("descVector", descVector);
			session.setAttribute("valueVector", valueVector);
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/submitLayout.jsp" flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="readOnly" value="<%=isReadOnly%>" />
				<tiles:put name="isRequired" value="<%=isRequired%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="30" />
				<tiles:put name="units" value="" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
			</tiles:insert>
			
		<%
		} else if (strType.equalsIgnoreCase("Dynamicselect")) {
			try {
				session.removeAttribute("valueVector");
				session.removeAttribute("descVector");
			} catch (Exception e) {
			}
			//System.out.println("enumValues=" + item.getEnumValues() + " enumDesc=" + item.getEnumDesc());
			Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
			Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());

			session.setAttribute("descVector", descriptVector);
			session.setAttribute("valueVector", valVector);
		%>
			<tiles:insert page="/com.ibm.ws.console.xdoperations/dynamicSelectionLayout.jsp"
				flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="readOnly" value="<%=isReadOnly%>" />
				<tiles:put name="isRequired" value="<%=isRequired%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="30" />
				<tiles:put name="units" value="" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
				<tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
				<tiles:put name="isTranslatable" value="false"/>
			</tiles:insert>
			
		<%
		} else if (strType.equalsIgnoreCase("Radio")) {
			try {
				session.removeAttribute("valueVector");
				session.removeAttribute("descVector");
			} catch (Exception e) {
			}

			StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
			Vector descVector = new Vector();
			while (st1.hasMoreTokens()) {
				String enumDesc = st1.nextToken();
				descVector.addElement(enumDesc);
			}
			StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
			Vector valueVector = new Vector();
			while (st.hasMoreTokens()) {
				String str = st.nextToken();
				valueVector.addElement(str);
			}

			session.setAttribute("descVector", descVector);
			session.setAttribute("valueVector", valueVector);
		%>

			<tiles:insert page="/com.ibm.ws.console.xdoperations/radioButtonLayout.jsp"
				flush="false">
				<tiles:put name="property" value="<%=item.getAttribute()%>" />
				<tiles:put name="propName" value="<%=propName%>" />
				<tiles:put name="propValue" value="<%=propValue%>" />
				<tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
				<tiles:put name="isRequired" value="<%=isRequired%>" />
				<tiles:put name="label" value="<%=item.getLabel()%>" />
				<tiles:put name="size" value="30" />
				<tiles:put name="units" value="" />
				<tiles:put name="desc" value="<%=item.getDescription()%>" />
				<tiles:put name="bean" value="<%=formName%>" />
			</tiles:insert>
		<%
		}
		%>

		<%
		propCounter += 1;
		%>
		</tr>
	</logic:iterate>
<%
	}
}
%>

<%
} catch (Throwable e) {
	e.printStackTrace();
}
%>

