<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="numOfColumns" classname="java.lang.String"/>
    <!-- Action section -->
    <tr valign="top">
      <td class="function-button-section"  nowrap COLSPAN="<%=numOfColumns%>">
      <table BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <tr>
          <td class="action-button-section"  nowrap >
            <input type="submit" name="button.cancel.schedule" value="<bean:message key="job.schedule.action.cancel"/>" class="filter-buttons" id="button.cancel.schedule"/>
          </td>
        </tr>
      </table>
      </td>        
    </tr>
    <!-- End of Action section -->
