<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, (C) COPYRIGHT International Business Machines Corp. 2008 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator,java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="selectUri" classname="java.lang.String" />
<tiles:useAttribute name="openImage" classname="java.lang.String" />
<tiles:useAttribute name="closedImage" classname="java.lang.String" />
<tiles:useAttribute name="parameterName" classname="java.lang.String" />
<tiles:useAttribute name="collectionForm" classname="java.lang.String"/>
<tiles:useAttribute name="searchLabelKey" classname="java.lang.String"/>
<tiles:useAttribute name="searchInLabelKey" classname="java.lang.String"/>
<tiles:useAttribute name="searchWithStringLabelKey" classname="java.lang.String"/>
<tiles:useAttribute name="goLabelKey" classname="java.lang.String"/>

<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />

<tiles:useAttribute id="searchList" name="searchList" classname="java.util.List" />

          
<bean:define id="quickSearchState" name="<%=collectionForm%>" property="quickSearchState" scope="session"/>
<bean:define id="searchPattern"    name="<%=collectionForm%>" property="searchPattern" scope="session"/>
<bean:define id="searchFilter"     name="<%=collectionForm%>" property="searchFilter"scope="session"/>

<%--
//collectionForm: <%=collectionForm%><BR>
//<%=collectionForm%>.getQuickSearchState: <%=quickSearchState%><BR>
//<%=collectionForm%>.getSearchPattern: <%=searchPattern%><BR>
//<%=collectionForm%>.getSearchFilter: <%=searchFilter%><BR>
--%>

<%
   String hRef = "";
   if (selectUri.indexOf('?') != -1)
      hRef = selectUri + "&" + parameterName + "=" + quickSearchState;
   else
      hRef = selectUri + "?" + parameterName + "=" + quickSearchState;
%>
<SCRIPT>
// Added because Mozilla wants to use the TBODY and table-row-group to show/hide table rows
if (isDom) {
    showString = "table-row-group";
} else {
    showString = "inline";
}
function showHideFilter() {
    var filterTableImg = document.getElementById ("filterTableImg");
    
    if (filterTableImg.src.indexOf("wtable_filter_row_show") > 0) {
        disFilter = showString;
        filterTableImg.src = "<%=request.getContextPath()%>/images/wtable_filter_row_hide.gif";
        filterTableImg.title = "<bean:message key="hide.filter" />";
    } else {
        filterTableImg.src = "<%=request.getContextPath()%>/images/wtable_filter_row_show.gif";
        filterTableImg.title = "<bean:message key="show.filter" />";
        disFilter = "none";
    }

    document.getElementById("filterControls").style.display = disFilter;
}


function clearFilter(theForm) {
    //document.getElementById("searchFilter").value = "";
    elements = document.getElementsByName("searchPattern");
    for(var i = 0; i<elements.length; i++){
    	elements.item(i).value="*";
    }
    elements = document.getElementsByName("unused");
    for(var i = 0; i<elements.length; i++){
    	elements.item(i).value="*";
    }
    //document.getElementById("searchPattern").value = "*";
    //document.getElementById("searchAction").click();
    elForm = document.getElementById(theForm);
    iscDeselectAll(theForm);
    //elForm.submit();
    document.getElementById("searchAction").click();
}

function onenter(e, theForm) {
    var keyCodeChar  
      
	if (e && e.which){
        e = e;
        keyCodeChar = e.which;
    }
    else{
        e = event;
        keyCodeChar = e.keyCode;
    }
    
    if (keyCodeChar == 13){
		document.getElementById("searchAction").click();
        return false;
    }
	else{
		return true;
    }
}


var SELECTEDFilter = "";
var firstCol = "";
<%

        List savsearchList = new ArrayList();
        int colcount = 0;
		Iterator iterSearchList = searchList.iterator();
		while (iterSearchList.hasNext())
		{
			String tempString = (String)iterSearchList.next();
			String[] splitString = tempString.split(":");
			String optionText = splitString[0];
			String optionValue = null;
			if (splitString.length > 1){
				optionValue = splitString[1];
			}
            if (optionValue != null) {
                savsearchList.add(colcount,tempString);
            }
            if (colcount == 0) {
%>
firstCol = "<%=optionValue%>";
<%

            }
			if (searchFilter.equals(optionValue))
			{
%>
SELECTEDFilter = "<%=optionValue%>";
<%
			}
            colcount = colcount+1;
		}

        session.setAttribute("searchList",savsearchList);
        session.setAttribute("quickSearchState",quickSearchState);
        session.setAttribute("searchPattern",searchPattern);
        session.setAttribute("searchFilter",searchFilter);
        
%>
</SCRIPT>

