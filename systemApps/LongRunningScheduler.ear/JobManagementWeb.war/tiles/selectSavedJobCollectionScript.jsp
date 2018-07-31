
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<script>
function clearFilter(theForm) {
    document.getElementById("sortDirection").selectedIndex = 0;
    document.getElementById("jobNameFilter").value = "%";
    document.getElementById("button.go").click();
}

function selectJob() {
    document.getElementById("button.select").disabled = false;
}
</script>
