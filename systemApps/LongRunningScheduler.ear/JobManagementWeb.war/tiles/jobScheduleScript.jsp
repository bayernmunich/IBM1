<%@ page language="java" import="java.util.HashMap,java.util.Iterator,com.ibm.ws.batch.jobmanagement.web.forms.JobScheduleDetailForm"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<bean:define id="detailForm" name="JobScheduleDetailForm"/>
<%
    JobScheduleDetailForm df = (JobScheduleDetailForm) detailForm;
    HashMap props = df.getProps();
%>
<script>
function enableDisableSelectJob() {

    submitBy = document.getElementsByName("submitBy");
    if (document.getElementById("updateJob").checked) {
<% if (props.size() > 1) { 
       for (Iterator iterator = props.keySet().iterator(); iterator.hasNext(); ) {
           String key = (String) iterator.next();
%>
        document.getElementById("property.<%=key%>").disabled = true;
<%
       }
%>
        document.getElementById("subProps").disabled  = true;
<%
   }
%>
        document.getElementById("selectJob").disabled = false;
        submitBy[0].disabled = false;
        submitBy[1].disabled = false;
        if (submitBy[0].checked) {
            document.getElementById('xjclFile').disabled      = false;
            document.getElementById('jobName').disabled       = true;
            document.getElementById('button.browse').disabled = true;
        } else {
            document.getElementById('xjclFile').disabled      = true;
            document.getElementById('jobName').disabled       = false;
            document.getElementById('button.browse').disabled = false;
        }
    } else {
<% if (props.size() > 1) { 
%>
        document.getElementById("subProps").disabled  = false;
<%
       for (Iterator iterator = props.keySet().iterator(); iterator.hasNext(); ) {
           String key = (String) iterator.next();
%>
        document.getElementById("property.<%=key%>").disabled = false;
<%
       }
   }
%>
        submitBy[0].disabled = true;
        submitBy[1].disabled = true;
        document.getElementById('xjclFile').disabled      = true;
        document.getElementById('jobName').disabled       = true;
        document.getElementById('button.browse').disabled = true;
        document.getElementById("selectJob").disabled = true;
    }
}

function enableDisable(enableObj) {
    xjclFileObj      = document.getElementById('xjclFile');
    submitJobNameObj = document.getElementById('jobName');
    buttonBrowseObj  = document.getElementById('button.browse');

    if (enableObj == 'xjclFile') {
        xjclFileObj.disabled      = false;
        submitJobNameObj.disabled = true;
        buttonBrowseObj.disabled  = true;
    } else {
        xjclFileObj.disabled      = true;
        submitJobNameObj.disabled = false;
        buttonBrowseObj.disabled  = false;
    }
}

</script>
<%@ include file="/tiles/dateTimeScript.jspf" %>