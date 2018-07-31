<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.workclass.form.RuleBuilderInputForm"%>
<%@ page import="com.ibm.wsspi.classify.*"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

   <tiles:useAttribute id="initial" name="initial" classname="java.lang.String"/>
   <tiles:useAttribute id="type" name="type" classname="java.lang.String"/>
   <tiles:useAttribute id="prefix" name="prefix" classname="java.lang.String"/>
   
   
<%
	
   
%>
<!--        <td class="table-text"  scope="row" valign="top">
                      
            <BR/> -->
<%		
         String csrfParm = "";
         String csrfToken = (String) session.getAttribute("com.ibm.ws.console.CSRFToken");
		 if ((csrfToken != null) && (csrfToken.length() > 0))
            csrfParm = "&csrfid=" + csrfToken;
            
         if(type.equals(ClassificationDictionary.CLIENT_IPV4)){	
			if(initial.split(".",4).length != 4){
				initial = " . . . ";
			}
			String[] initial_split = initial.split("\\.",4);
%>
			<input type="text" name="<%=prefix+"_ipv4_1"%>" size="3" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv4_1"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[0]%>"></input><%="."%>
			<input type="text" name="<%=prefix+"_ipv4_2"%>" size="3" 
			onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv4_2"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[1]%>"></input><%="."%>
			<input type="text" name="<%=prefix+"_ipv4_3"%>" size="3" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv4_3"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[2]%>"></input><%="."%>
			<input type="text" name="<%=prefix+"_ipv4_4"%>" size="3" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv4_4"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[3]%>"></input>

            
<%		}
		else if(type.equals(ClassificationDictionary.CLIENT_IPV6)){	
			if(initial.split(":",6).length != 6){
				initial = " : : : : : ";
			}
			String[] initial_split = initial.split(":",6);
%>
			<input type="text" name="<%=prefix+"_ipv6_1"%>" size="4" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv6_1"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[0]%>"></input><%=":"%>
			<input type="text" name="<%=prefix+"_ipv6_2"%>" size="4" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv6_2"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[1]%>"></input><%=":"%>
			<input type="text" name="<%=prefix+"_ipv6_3"%>" size="4" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv6_3"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[2]%>"></input><%=":"%>
			<input type="text" name="<%=prefix+"_ipv6_4"%>" size="4" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv6_4"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[3]%>"></input><%=":"%>
			<input type="text" name="<%=prefix+"_ipv6_5"%>" size="4" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv6_5"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[4]%>"></input><%=":"%>
			<input type="text" name="<%=prefix+"_ipv6_6"%>" size="4" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_ipv6_6"%>='+this.value<%=csrfParm%>)"
				value="<%=initial_split[5]%>"></input>

 			
<%		}
		else if(type.equals(ClassificationDictionary.START_DATE) || type.equals(ClassificationDictionary.END_DATE)){
			String dayOfWeek="";
			String month="";
			String day="";
			String year="";
			String hours="";
			String minutes="";
			String seconds="";
			
			try{
				String[] initial_split = initial.split(" ");
				dayOfWeek = initial_split[0];
				String[] date_split = initial_split[1].split("/");
				month=date_split[0];
				day=date_split[1];
				year=date_split[2];
				String[] time_split = initial_split[2].split(":");
				hours=time_split[0];
				minutes=time_split[1];
				seconds=time_split[2];
			}catch(ArrayIndexOutOfBoundsException e){
			}%>
			<input type="text" name="<%=prefix+"_dayOfWeek"%>" size="8" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_dayOfWeek"%>='+this.value<%=csrfParm%>)"
				value="<%=dayOfWeek%>"></input><%="  "%>
			<input type="text" name="<%=prefix+"_month"%>" size="2" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_month"%>='+this.value<%=csrfParm%>)"
				value="<%=month%>"></input><%="/"%>
			<input type="text" name="<%=prefix+"_day"%>" size="2" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_day"%>='+this.value<%=csrfParm%>)"
				value="<%=day%>"></input><%="/"%>
			<input type="text" name="<%=prefix+"_year"%>" size="4" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_year"%>='+this.value<%=csrfParm%>)"
				value="<%=year%>"></input><%="  "%>
			<input type="text" name="<%=prefix+"_hours"%>" size="2" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_hours"%>='+this.value<%=csrfParm%>)"
				value="<%=hours%>"></input><%=":"%>
			<input type="text" name="<%=prefix+"_minutes"%>" size="2" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_minutes"%>='+this.value<%=csrfParm%>)"
				value="<%=minutes%>"></input><%=":"%>
			<input type="text" name="<%=prefix+"_seconds"%>" size="2" 
				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_seconds"%>='+this.value<%=csrfParm%>)"
				value="<%=seconds%>"></input>
			
			
			
		
<%		}
		else{
%>            
 			<input type="text" name="<%=prefix+"_single"%>" 
 				onchange="window.location=encodeURI('/ibm/console/RuleBuilderConditionCollection.do?Action=Update&<%=prefix+"_single"%>='+this.value<%=csrfParm%>)"
 				value="<%=initial%>"></input>
<%        }

%>
  <!--      </td> -->
       
    