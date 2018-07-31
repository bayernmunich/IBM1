<%@ page import="java.util.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>

<tiles:useAttribute id="readOnly" name="readOnly"
	classname="java.lang.String" />

<%boolean val = false;
  if (readOnly != null && readOnly.equals("true"))
  	 val = true;
%>

<table width="100%" border="0" cellspacing="0" cellpadding="2" role="presentation">

	<tr>
		<td class="table-text" nowrap>
			<label FOR="enableResponseCompression" title="<bean:message key="ODR.enableResponseCompression.description"/>"> 
				<html:checkbox property="enableResponseCompression" styleId="enableResponseCompression" value="on" disabled="<%=val%>"
					onclick="enableDisable('enableResponseCompression:responseCompression');"
					onkeypress="enableDisable('enableResponseCompression:responseCompression');" />
				<bean:message key="ODR.enableResponseCompression.displayName" />
			</label>
		</td>
	</tr>

	<tr>
		<td class="complex-property" nowrap>
			<label FOR="responseCompression" title="<bean:message key="ODR.responseCompression.description"/>"> 
				<bean:message key="ODR.responseCompression.displayName" />
			</label>
			<BR>
			<html:select property="responseCompression" styleId="responseCompression">
				<html:option value="gzip">
					<bean:message key="ODR.responseCompression.gzip.displayName" />
				</html:option>
				<html:option value="deflate">
					<bean:message key="ODR.responseCompression.deflate.displayName" />
				</html:option>
				<html:option value="auto">
					<bean:message key="ODR.responseCompression.auto.displayName" />
				</html:option>
			</html:select>
		</td>
	</tr>

</table>

<SCRIPT>
	enableDisable('enableResponseCompression:responseCompression');
</SCRIPT>

