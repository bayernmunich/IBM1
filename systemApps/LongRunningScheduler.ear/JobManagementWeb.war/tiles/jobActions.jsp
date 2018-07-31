<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="numOfColumns" classname="java.lang.String"/>
    <!-- Action section -->
    <tr valign="top">
      <td class="function-button-section"  nowrap COLSPAN="<%=numOfColumns%>">
      <table BORDER="0" CELLPADDING="0" CELLSPACING="0" role="presentation">
        <tr>
          <td class="action-button-section"  nowrap >
          
          <select id="actions" title="<bean:message key="actionInstruction"/>" name="master.action" class="textEntry" onchange="javascript:changeAction(this.form.actions)">
            <option value="job.action.select"><bean:message key="job.action.select"/></option>
            <option value="job.action.cancel"><bean:message key="job.action.cancel"/></option>
            <!--option value="job.action.forcedcancel"><bean:message key="job.action.forcedcancel"/>&nbsp;<bean:message key="zOSOnly"/></option-->
            <option value="job.action.remove"><bean:message key="job.action.remove"/></option>
            <option value="job.action.restart"><bean:message key="job.action.restart"/></option>
            <option value="job.action.resume"><bean:message key="job.action.resume"/></option>
            <option value="job.action.stop"><bean:message key="job.action.stop"/></option>
            <option value="job.action.suspend"><bean:message key="job.action.suspend"/></option>
          </select>
          </label>
          </td>
          <td class="action-button-section"  nowrap ID="suspendTimeSection" STYLE="display:none">
          
          <input type="text" title="<bean:message key="job.action.suspend"/>" id="suspendTime" name="suspendTime" class="noIndentTextEntry" size="10" value="15"/>
          
          
          <select id="suspendTimeUnit" title="<bean:message key="job.action.suspend"/>" name="suspendTimeUnit" class="textEntry">
            <option value="seconds" SELECTED="SELECTED"><bean:message key="suspendTimeSeconds"/></option>
            <option value="minutes"><bean:message key="suspendTimeMinutes"/></option>
            <option value="hours"><bean:message key="suspendTimeHours"/></option>
          </select>
          
          </td>
          <td class="action-button-section"  nowrap >
            <input type="submit" name="button.execute" value="<bean:message key="button.execute"/>" class="filter-buttons" id="button.execute" disabled/>
          </td>
        </tr>
      </table>
      </td>        
    </tr>
    <!-- End of Action section -->
