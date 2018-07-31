<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<tiles:definition
    id="date.field"
    page="/tiles/dateField.jsp">
    <tiles:put name="startDate"  value="" />
    <tiles:put name="disabled"   value="" />
    <tiles:put name="required"   value="true" />
    <tiles:put name="labelStyle" value="" />
</tiles:definition>

<tiles:definition
    id="time.field"
    page="/tiles/timeField.jsp">
    <tiles:put name="startTime"  value="" />
    <tiles:put name="disabled"   value="" />
    <tiles:put name="required"   value="true" />
    <tiles:put name="labelStyle" value="" />
</tiles:definition>