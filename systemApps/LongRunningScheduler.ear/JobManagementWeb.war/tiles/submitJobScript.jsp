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

function enableDisableDateTime() {
    delaySubmit            = document.getElementById('delaySubmit');
    startDateYearObj       = document.getElementById('startDateYearUp');
    startDateYearUpObj     = document.getElementById('startDateYearDown');
    startDateYearDownObj   = document.getElementById('startDateYear');
    startDateMonthObj      = document.getElementById('startDateMonth');
    startDateDayObj        = document.getElementById('startDateDay');
    startDateLabelObj      = document.getElementById('startDateLabel');
    startTimeHourObj       = document.getElementById('startTimeHour');
    startTimeHourUpObj     = document.getElementById('startTimeHourUp');
    startTimeHourDownObj   = document.getElementById('startTimeHourDown');
    startTimeMinuteObj     = document.getElementById('startTimeMinute');
    startTimeMinuteUpObj   = document.getElementById('startTimeMinuteUp');
    startTimeMinuteDownObj = document.getElementById('startTimeMinuteDown');
    startTimeSecondObj     = document.getElementById('startTimeSecond');
    startTimeSecondUpObj   = document.getElementById('startTimeSecondUp');
    startTimeSecondDownObj = document.getElementById('startTimeSecondDown');
    startTimeLabelObj      = document.getElementById('startTimeLabel');
    if (delaySubmit.checked) {
        startDateYearObj.disabled       = false;
        startDateYearUpObj.disabled     = false;
        startDateYearDownObj.disabled   = false;
        startDateMonthObj.disabled      = false;
        startDateDayObj.disabled        = false;
        startTimeHourObj.disabled       = false;
        startTimeHourUpObj.disabled     = false;
        startTimeHourDownObj.disabled   = false;
        startTimeMinuteObj.disabled     = false;
        startTimeMinuteUpObj.disabled   = false;
        startTimeMinuteDownObj.disabled = false;
        startTimeSecondObj.disabled     = false;
        startTimeSecondUpObj.disabled   = false;
        startTimeSecondDownObj.disabled = false;
        startDateLabelObj.disabled      = false;
        startTimeLabelObj.disabled      = false;
        document.images['startDateYearUp'].src     = 'images/upbutton.gif';
        document.images['startDateYearDown'].src   = 'images/downbutton.gif';
        document.images['startTimeHourUp'].src     = 'images/upbutton.gif';
        document.images['startTimeHourDown'].src   = 'images/downbutton.gif';
        document.images['startTimeMinuteUp'].src   = 'images/upbutton.gif';
        document.images['startTimeMinuteDown'].src = 'images/downbutton.gif';
        document.images['startTimeSecondUp'].src   = 'images/upbutton.gif';
        document.images['startTimeSecondDown'].src = 'images/downbutton.gif';
    } else {
        startDateYearObj.disabled       = true;
        startDateYearUpObj.disabled     = true;
        startDateYearDownObj.disabled   = true;
        startDateMonthObj.disabled      = true;
        startDateDayObj.disabled        = true;
        startTimeHourObj.disabled       = true;
        startTimeHourUpObj.disabled     = true;
        startTimeHourDownObj.disabled   = true;
        startTimeMinuteObj.disabled     = true;
        startTimeMinuteUpObj.disabled   = true;
        startTimeMinuteDownObj.disabled = true;
        startTimeSecondObj.disabled     = true;
        startTimeSecondUpObj.disabled   = true;
        startTimeSecondDownObj.disabled = true;
        startDateLabelObj.disabled      = true;
        startTimeLabelObj.disabled      = true;
        document.images['startDateYearUp'].src     = 'images/upbuttondisabled.gif';
        document.images['startDateYearDown'].src   = 'images/downbuttondisabled.gif';
        document.images['startTimeHourUp'].src     = 'images/upbuttondisabled.gif';
        document.images['startTimeHourDown'].src   = 'images/downbuttondisabled.gif';
        document.images['startTimeMinuteUp'].src   = 'images/upbuttondisabled.gif';
        document.images['startTimeMinuteDown'].src = 'images/downbuttondisabled.gif';
        document.images['startTimeSecondUp'].src   = 'images/upbuttondisabled.gif';
        document.images['startTimeSecondDown'].src = 'images/downbuttondisabled.gif';
    }
}
</script>
<%@ include file="/tiles/dateTimeScript.jspf" %>