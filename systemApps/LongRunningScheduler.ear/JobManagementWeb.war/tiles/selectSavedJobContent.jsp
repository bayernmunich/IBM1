<%@ page language="java" import="com.ibm.ws.batch.jobmanagement.web.forms.AbstractDetailForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="collectionName" classname="java.lang.String"/>
<tiles:useAttribute name="filterSection"  classname="java.lang.String"/>
<tiles:useAttribute name="propertyList"   classname="java.util.List"/>

        <tr>
          <td>

          <form name="<%=collectionName%>" method="post" action="/jmc/selectSavedJob.do" id="<%=collectionName%>" ENCTYPE="multipart/form-data">

          <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" CLASS="framing-table" role="presentation">
                <tbody>
            <!-- Buttons Section -->
            <tr valign="top">
              <td class="function-button-section"  nowrap COLSPAN="<%=propertyList.size()+1%>">
                <A HREF="javascript:showHideFilter()" tabindex="1" CLASS="expand-task">
                    <IMG id="filterTableImg" align="top" SRC="images/wtable_filter_row_show.gif" title="<bean:message key="showFilterFunction"/>" alt="<bean:message key="showFilterFunction"/>" BORDER="0" ALIGN="texttop"> 
                </A>
                <A HREF="javascript:clearFilter('<%=collectionName%>')" tabindex="1" CLASS="expand-task">
                    <IMG  id="clearFilterImg" align="top" SRC="images/wtable_clear_filters.gif" title="<bean:message key="clearFilterValues"/>" alt="<bean:message key="clearFilterValues"/>" BORDER="0" ALIGN="texttop"/> 
                </A>
              </td>
            </tr>
            <!-- End of Buttons Section -->
			</tbody>
			</table>
			<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" CLASS="framing-table">
            <!--  Header Section -->
            <TR>
              <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
                <bean:message key="select"/>
              </TH>
<%
    for (int i = 0; i < propertyList.size(); i++) {
        String property = (String) propertyList.get(i);
%>
              <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="20%" ID="<%=property%>">
                <bean:message key="<%=property%>"/>
              </TH>
<%
    }
%>
            </TR>
            <!--  End of Header Section -->

            <tiles:insert component="<%=filterSection%>" beanScope="request">
              <tiles:put name="collectionName" value="<%=collectionName%>"/>
              <tiles:put name="numOfColumns"   value="<%=Integer.toString(propertyList.size()+1)%>"/>
            </tiles:insert>


          <!--  Rows Section -->
<%  int r = 0; %>
          <logic:iterate id="detailForm" name="<%=collectionName%>" property="contents">
            <TR CLASS="table-row">

<%
    AbstractDetailForm df = (AbstractDetailForm) detailForm;

    for (int i = 0; i < propertyList.size(); i++) {
        String property = (String) propertyList.get(i);

%>
            <bean:define id="propertyValue"  name="detailForm" property="<%=property%>" type="java.lang.String"/>
<%
        String propertyLink = propertyValue;
        if (df.isPropertyNeedConvertToCharset(property)) {
            propertyLink  = JMCUtils.urlEncode(propertyValue);
            propertyValue = JMCUtils.convertToCharset(propertyValue, response.getCharacterEncoding());
        }

        if (i == 0) {
%>
              <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                  <input type="radio" TITLE='Select: <%=propertyValue%>' name="selectedObjectIds" value="<%=propertyLink%>"" id="selectId<%= r %>" onclick="javascript:selectJob();">
              </TD>
<%    
        }
%>
      	      <TD VALIGN="top"  class="collection-table-text" headers="<%=property%>">
<%      if (df.isPropertyNeedTranslate(property, propertyValue)) { %>
                <bean:message key="<%=propertyValue%>"/>
<%      } else { %>
                <%=propertyValue%>
<%      } %>
              </TD>
<%
    }
    r++;
%>
            </TR>
          </logic:iterate>
          <!--  End of Rows Section -->

          <tiles:insert component="/tiles/blocking.jsp" beanScope="request">
            <tiles:put name="collectionName" value="<%=collectionName%>"/>
            <tiles:put name="numOfColumns"   value="<%=Integer.toString(propertyList.size()+1)%>"/>
          </tiles:insert>

          </TABLE>
          <br>
          <input type="submit" name="button.select" value="<bean:message key="button.select"/>"     class="buttons" id="button.select" disabled>
          <input type="submit" name="button.cancel" value="<bean:message key="job.action.cancel"/>" class="buttons" id="button.cancel">
          </form>
          </td>
        </tr>
