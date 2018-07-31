<script>
function enableDisable(enableObj) {
    xjclFileObj      = document.getElementById('xjclFile');
    submitJobNameObj = document.getElementById('submitJobName');
    buttonBrowseObj  = document.getElementById('redirect.browse');

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