<%@ page language="java" import="com.ibm.ws.batch.jobmanagement.web.forms.SavedJobDetailForm"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>

<bean:define id="detailForm" name="SavedJobDetailForm"/>
<bean:define id="backAction" name="SavedJobDetailForm" property="backAction" type="java.lang.String"/>
<%
    SavedJobDetailForm df = (SavedJobDetailForm) detailForm;
    String jobXjcl = df.getJobXjcl(response.getCharacterEncoding());
%>
  <tr>
    <td>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" CLASS="framing-table">

      <!-- Action section
      <tr valign="top">
        <td class="function-button-section"  nowrap>
        <table BORDER="0" CELLPADDING="0" CELLSPACING="0">
          <tr>
            <td class="action-button-section"  nowrap >
              <input type="submit" name="button.download" value="<bean:message key="button.download"/>" class="filter-buttons" id="button.download"/>
            </td>
          </tr>
        </table>
        </td>        
      </tr>
      End of Action section -->

      <tr> 
        <td class="table-text">
        
        <textarea title="<bean:message key="savedJobViewTitle"/>" wrap="off" rows="50" cols="100" class="log-text" id="jobXjcl" >
<%=jobXjcl%>
        </textarea>
        
        </td>
      </tr>

    </TABLE>
    </td>
  </tr>

  <tr>
    <td class="navigation-button-section" VALIGN="top">
    <form name="SavedJobDetailForm" method="post" action="<%=backAction%>">
      <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="back"/>" class="buttons" id="navigation">
    </form>
    </td>
  </tr>
