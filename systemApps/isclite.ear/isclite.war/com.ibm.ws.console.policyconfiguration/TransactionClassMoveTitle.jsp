<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page language="java" import="java.util.regex.Pattern,com.ibm.ws.console.core.form.AbstractDetailForm,org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>

<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>



<tiles:useAttribute name="objectTypeImage" classname="java.lang.String" />
<tiles:useAttribute name="collectionLink" classname="java.lang.String" />
<tiles:useAttribute name="includeLink" classname="java.lang.String" />
<tiles:useAttribute name="titleKey" classname="java.lang.String" />
<tiles:useAttribute name="instanceDetails" classname="java.lang.String"/>
<tiles:useAttribute name="instanceDescription" classname="java.lang.String"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="displayName" classname="java.lang.String" />
<bean:define id="perspective" name="<%= formName %>" property="perspective"/>

<bean:define id="newapply" name="<%= formName %>" property="action"/>
<% String theaction = "" + newapply + ""; %>

<bean:define id="cntxt" name="<%= formName %>"/>
<%
String thecontext = "";
String theref = "";
String saveref = "";
String theresource = "";
String saveres = "";
try
{
        AbstractDetailForm bean = (AbstractDetailForm) cntxt;
        thecontext = bean.getContextId();
        saveref = bean.getRefId();
        theref = (String)session.getAttribute("theref");
        saveres = bean.getResourceUri();
        theresource = (String)session.getAttribute("theresource");

} catch (Exception e) { }

        if (thecontext != null) {
                session.setAttribute("thecontext",thecontext);
                session.setAttribute("theref",saveref);
                session.setAttribute("theresource",saveres);
        } else {
                thecontext = (String)session.getAttribute("thecontext");
                theref = (String)session.getAttribute("theref");
                theresource = (String)session.getAttribute("theresource");
        }
%>


    
    
<a name="important"></a>
<ibmcommon:detectLocale/>
<ibmcommon:errors/>

<a name="title"></a>

<%

// defect 126608

  String image = "";
  String pluginId = "";
  String pluginRoot = "";

  boolean addTag = false;
  if (objectTypeImage != "")
  {
     int index = objectTypeImage.indexOf ("pluginId=");
     if (index >= 0)
     {
        pluginId = objectTypeImage.substring (index + 9);
        addTag = true;
        if (index != 0)
           objectTypeImage = objectTypeImage.substring (0, index);
        else
           objectTypeImage = "";
     }
     else
     {
        index = objectTypeImage.indexOf ("pluginContextRoot=");
        if (index >= 0)
        {
           pluginRoot = objectTypeImage.substring (index + 18);
           addTag = true;
           if (index != 0)
              objectTypeImage = objectTypeImage.substring (0, index);
           else
              objectTypeImage = "";
        }
     }
  }
  if (addTag)
  {


%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<%
  }
%>

<%
   String fieldLevelHelpTopic = "";
   String DETAILFORM = "DetailForm";
   String objectType = "";
   int index = formName.lastIndexOf ('.');
   if (index > 0)
   {
      String fType = formName.substring (index+1);
      if (fType.endsWith (DETAILFORM))
         objectType = fType.substring (0, fType.length()-DETAILFORM.length());
      else
         objectType = fType;
      fieldLevelHelpTopic = objectType+".move";
   }
   else if (formName.endsWith (DETAILFORM)) {
           objectType = formName.substring(0, formName.length()-DETAILFORM.length());
           fieldLevelHelpTopic = objectType + ".move";
   }
   else
       fieldLevelHelpTopic = formName;

%>




        <%

       ServletContext servletContext = (ServletContext)pageContext.getServletContext();
       MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
       String moveTo = messages.getMessage(request.getLocale(),"serviceclass.move.title");
       String newbutton = messages.getMessage(request.getLocale(),"button.new");
       String addbutton = messages.getMessage(request.getLocale(),"button.add");
       String theName = messages.getMessage(request.getLocale(),displayName);

        %>


        <% String patternString; %>

        <bean:define id="description" name="<%= formName %>" property="<%=instanceDetails%>"/>

        <% patternString="" + description + ""; %>

        <% if (patternString.equals("")) { %>

        <%
               patternString = theName;
        }
        %>





        <%


        String altprior = "";
        String priorpage = "";
        String dbcsprior = "";
        String reconpage = "";
        String newbasestring = "";
        String newqstring = "";
        if (request.getHeader("Referer") == null){
                priorpage = "badURL";
        }
        else {
                priorpage = request.getHeader("Referer");
        }

        Pattern splitter1 = Pattern.compile("\\?");
        Pattern splitter2 = Pattern.compile("&");
        int firstQ = priorpage.indexOf("?");

        if (firstQ > -1) {
               newqstring = priorpage.substring(firstQ+1);
               newbasestring = priorpage.substring(0,firstQ);
        }

        if (priorpage.indexOf("contextId") > -1) {

                //String[] constructURL1 = splitter1.split(priorpage);
                String[] constructURL2 = splitter2.split(newqstring);
                int constructURLlen = constructURL2.length;

                for (int z=0;z<constructURLlen;z++) {
                        if (constructURL2[z].indexOf("contextId") > -1) {
                                reconpage = "contextId="+thecontext;
                                if (thecontext != null) {
                                       if (z == 0) {
                                               dbcsprior = reconpage;
                                       } else {
                                               dbcsprior = dbcsprior + "&" + reconpage;
                                       }
                                } else {
                                       if (z == 0) {
                                               dbcsprior = constructURL2[z];
                                       } else {
                                               dbcsprior = dbcsprior + "&" + constructURL2[z];
                                       }
                               }                                    
                        } else if (constructURL2[z].indexOf("refId") > -1) {
                                reconpage = "refId="+theref;
                                if (theref != null) {
                                       if (z == 0) {
                                               dbcsprior = reconpage;
                                       } else {
                                               dbcsprior = dbcsprior + "&" + reconpage;
                                       }
                                } else {
                                       if (z == 0) {
                                               dbcsprior = constructURL2[z];
                                       } else {
                                               dbcsprior = dbcsprior + "&" + constructURL2[z];
                                       }
                               }                                    
                                   

                        } else if (constructURL2[z].indexOf("perspective") > -1) {
                                reconpage = "perspective="+request.getParameter("perspective");
                                if (request.getParameter("perspective") != null) {
                                       if (z == 0) {
                                               dbcsprior = reconpage;
                                       } else {
                                               dbcsprior = dbcsprior + "&" + reconpage;
                                       }
                                } else {
                                       if (z == 0) {
                                               dbcsprior = constructURL2[z];
                                       } else {
                                               dbcsprior = dbcsprior + "&" + constructURL2[z];
                                       }
                               }                                    

                        } else if (constructURL2[z].indexOf("resourceUri") > -1) {
                                reconpage = "resourceUri="+theresource;
                                if (request.getParameter("resourceUri") != null) {
                                       if (z == 0) {
                                               dbcsprior = reconpage;
                                       } else {
                                               dbcsprior = dbcsprior + "&" + reconpage;
                                       }
                                } else {
                                       if (z == 0) {
                                               dbcsprior = constructURL2[z];
                                       } else {
                                               dbcsprior = dbcsprior + "&" + constructURL2[z];
                                       }
                               }                                    

                         } else  {
                                if (z == 0) {
                                        dbcsprior = constructURL2[z];
                                } else {
                                        dbcsprior = dbcsprior + "&" + constructURL2[z];
                                }
                        }

                }

                dbcsprior = newbasestring + "?" + dbcsprior;
                priorpage = dbcsprior;

        }


        String qstring = request.getQueryString();
        String reqMethod = request.getMethod();
        String urlString = request.getRequestURI();


        if (qstring != null) {

                String resourceUri = "&resourceUri="+request.getParameter("resourceUri");
                String contextId = "&contextId="+thecontext;
                String aperspective = "&perspective="+request.getParameter("perspective");
                String refId = "&refId="+request.getParameter("refId");

                urlString = request.getRequestURI() + "?" + request.getQueryString();


                if (priorpage.indexOf(".do?")>-1) {
                        altprior = request.getRequestURI() + "?EditAction=true"+ refId + contextId + resourceUri + aperspective;
                } else {
                        altprior = priorpage + "?EditAction=true"+ refId + contextId + resourceUri + aperspective;
                }

        }




        //////////////  Zero out breadcrumb pages to watch for ///////////////////////////
        int isnavigator = priorpage.indexOf("/ibm/console/secure/navigator.jsp");
        int isbanner = priorpage.indexOf("/ibm/console/secure/banner.jsp");
        int islogon = priorpage.indexOf("/ibm/console/secure/logon.do");
        int islogoff = priorpage.indexOf("/ibm/console/secure/logoff.do");
        int isclustertree = priorpage.indexOf("ClusterTopology.content.main");
        int ismessages = priorpage.indexOf("status.jsp");
        if (ismessages == -1) {
                ismessages = priorpage.indexOf("statusTray.do");
        }

        int ismessagedetail = priorpage.indexOf("events.content.main");
        if (ismessagedetail == -1) {
                ismessagedetail = priorpage.indexOf("configproblems.content.main");
        }

        int isreturnfrommessage = priorpage.indexOf("eventCollection.do");
        if (isreturnfrommessage == -1) {
                isreturnfrommessage = priorpage.indexOf("configProbCollection.do");
        }
        //////////////////////////////////////////////////////////////////////////////////



        ////////////////// Node and Server browsing pages ////////////////////////////////
        int isServerBrowse = urlString.indexOf("browseServersAction=");
        int isNodeBrowse =  urlString.indexOf("browseNodesAction=");
        //////////////////////////////////////////////////////////////////////////////////



        //////////////////  Pages to pop breadcrumb to same page /////////////////////////
        int isFilterToggle = urlString.indexOf("quickSearchState=");
        int isPrefsToggle =  urlString.indexOf("show=");
        int isScopeToggle =  urlString.indexOf("scopeShow=");

        //////////////////////////////////////////////////////////////////////////////////


        //out.println("<P>Detail Priorpage: "+priorpage+"</P>");
        //out.println("<P>Altprior: "+altprior+"</P>");
        //out.println("Early priorpage:" + session.getAttribute("goodpriorpage"));


        int counter;
        int counter1;
        int counter2;
        int counter3;
        int counter4;
        String backbutton;
        int tmpcount;

        int newlen = 0;
        String status = "push";
        int bclen = 15;

        String[] bclinksT = { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" };
        String[] bcnamesT = { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" };
        String[] bcpageidT = { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" };


        // If the referer is navigator||banner||logoff||clustertree, then zero out arrays - leave logon off detail title
        if ((isnavigator > -1) || (isbanner > -1) || (islogoff > -1) || (isclustertree > -1)) {
                session.setAttribute("bcnames", bcnamesT);
                session.setAttribute("bclinks", bclinksT);
                session.setAttribute("bcpageid", bcpageidT);

                session.setAttribute("thecontext","");
                session.setAttribute("theref","");
                session.setAttribute("theresource","");

                session.removeAttribute("goodpriorpage");

        }

        bclinksT = (String[])session.getAttribute("bclinks");
        bcnamesT = (String[])session.getAttribute("bcnames");
        bcpageidT = (String[])session.getAttribute("bcpageid");

        int oldlen = 0;
        for (counter1=0; counter1<bclen; counter1++) {
                if (bcnamesT[counter1].equals("")) {
                        oldlen = counter1;
                        break;
                }
        }



  //  Determine Status

        // Pop on New object
        if (theaction.equalsIgnoreCase("New")) {
                if (bcnamesT[oldlen-1].equals(newbutton)) {
                        status = "pop";
                        newlen = oldlen-1;
                        for (counter2=newlen; counter2<bclen; counter2++) {
                                bcnamesT[counter2] = "";
                                bcpageidT[counter2] = "";
                                if (newlen != counter2) {
                                        bclinksT[counter2] = "";
                                }
                        }

                } 
                if (!reqMethod.equalsIgnoreCase("get")) {
                        patternString = newbutton;
                }
        // Pop on Add object
        } else if (theaction.equalsIgnoreCase("Add")) {
                if (bcnamesT[oldlen-1].equals(addbutton)) {
                        status = "pop";
                        newlen = oldlen-1;
                        for (counter2=newlen; counter2<bclen; counter2++) {
                                bcnamesT[counter2] = "";
                                bcpageidT[counter2] = "";
                                if (newlen != counter2) {
                                        bclinksT[counter2] = "";
                                }
                        }
                } 
                if (!reqMethod.equalsIgnoreCase("get")) {
                        patternString = addbutton;
                }
        // Examine whether its a toggled page
        } else if ((isFilterToggle > 0) || (isPrefsToggle > 0) || (isScopeToggle > 0)) {
            if ((isServerBrowse < 0) && (isNodeBrowse < 0)) {
                status = "pop";
                if (oldlen > 0) {
                    newlen = oldlen - 1;
                } else {
                    newlen = oldlen;
                }
            }

        // Examine breadcrumb to determine if need to Pop
        } else {
            for (counter1=0; counter1<oldlen; counter1++) {
    
                if (fieldLevelHelpTopic.equals(bcpageidT[counter1]))  { 
                    //|| (patternString.equals(bcnamesT[counter1]))) {

                        newlen = counter1;
                        for (counter2=newlen; counter2<bclen; counter2++) {
                                bcnamesT[counter2] = "";
                                bcpageidT[counter2] = "";
                                if (newlen != counter2) {
                                        bclinksT[counter2] = "";
                                }
                        }

                        status = "pop";
                        //out.println("popped at "+counter1+", Name is "+fieldLevelHelpTopic);
                        break;
                       // }
                }

            }

        }





        if (status.equals("pop")) {
                ////////// Popped back 1 or more pages ////////////////////
                //if (oldlen-newlen > 1) {
                //}

                ///////// Popped to the same page /////////////////////////
                if (oldlen-newlen == 1) {

                        //out.println("Same pop from "+oldlen+" to "+newlen+"<br>"+priorpage);


                        if (((bclinksT[newlen].indexOf(".do?EditAction=true") < 0) && (bclinksT[newlen].indexOf(".do?forwardName=") < 0)) && (bclinksT[newlen].indexOf(".do?action=") < 0) && (bclinksT[newlen].indexOf(".do?perspective=") < 0) && (bclinksT[newlen].indexOf("scopeShow=") < 0) && (bclinksT[newlen].indexOf("quickSearchState=") < 0) && (bclinksT[newlen].indexOf("show=") < 0)) {
                                if (((priorpage.indexOf(".do?EditAction=true") > -1) || (priorpage.indexOf(".do?forwardName=") > -1)) || (priorpage.indexOf(".do?action=") > -1) || (priorpage.indexOf(".do?perspective=") > -1) || (priorpage.indexOf("scopeShow=") > -1) || (priorpage.indexOf("quickSearchState=") > -1) || (priorpage.indexOf("show=") > -1)) {
                                        bclinksT[newlen] = priorpage;
                                } else if (((altprior.indexOf(".do?EditAction=true") > -1) || (altprior.indexOf(".do?forwardName=") > -1)) || (altprior.indexOf(".do?action=") > -1) || (altprior.indexOf(".do?perspective=") > -1) || (altprior.indexOf("scopeShow=") > -1) || (altprior.indexOf("quickSearchState=") > -1) || (altprior.indexOf("show=") > -1)) {
                                        bclinksT[newlen] = altprior;
                                } else {
                                        bclinksT[newlen] = "badURL";
                                }
                        } else {
                                //out.println("fell out back");
                        }

                } else {
                   //out.println("big pop");
                }

        } else {

                newlen = oldlen;
                //////// Pushed a page onto the stack ////////////////////

                //out.println("pushed to "+newlen+"<br>Priorpage: "+priorpage+"<br>"+altprior);

                if (newlen >=1) {

                        if (((bclinksT[newlen-1].indexOf(".do?EditAction=true") < 0) && (bclinksT[newlen-1].indexOf(".do?forwardName=") < 0)) && (bclinksT[newlen-1].indexOf(".do?action=") < 0) && (bclinksT[newlen-1].indexOf(".do?perspective=") < 0) && (bclinksT[newlen-1].indexOf("scopeShow=") < 0) && (bclinksT[newlen-1].indexOf("quickSearchState=") < 0) && (bclinksT[newlen-1].indexOf("show=") < 0)) {
                                if (((priorpage.indexOf(".do?EditAction=true") > -1) || (priorpage.indexOf(".do?forwardName=") > -1)) || (priorpage.indexOf(".do?action=") > -1) || (priorpage.indexOf(".do?perspective=") > -1) || (priorpage.indexOf("scopeShow=") > -1) || (priorpage.indexOf("quickSearchState=") > -1) || (priorpage.indexOf("show=") > -1)) {
                                        bclinksT[newlen-1] = priorpage;
                                        //out.println("branch1 pushed to "+newlen+"<br>Priorpage: "+priorpage+"<br>"+altprior);
                                } else if (((altprior.indexOf(".do?EditAction=true") > -1) || (altprior.indexOf(".do?forwardName=") > -1)) || (altprior.indexOf(".do?action=") > -1) || (altprior.indexOf(".do?perspective=") > -1) || (altprior.indexOf("scopeShow=") > -1) || (altprior.indexOf("quickSearchState=") > -1) || (altprior.indexOf("show=") > -1)) {
                                        bclinksT[newlen-1] = altprior;
                                        //out.println("branch2 pushed to "+newlen+"<br>Priorpage: "+priorpage+"<br>"+altprior);
                                } else {
                                        bclinksT[newlen-1] = "badURL";
                                        //out.println("branch3 pushed to "+newlen+"<br>Priorpage: "+priorpage+"<br>"+altprior);
                                }
                        }
                } else {
                        if (((bclinksT[newlen].indexOf(".do?EditAction=true") < 0) && (bclinksT[newlen].indexOf(".do?forwardName=") < 0)) && (bclinksT[newlen].indexOf(".do?action=") < 0) && (bclinksT[newlen].indexOf(".do?perspective=") < 0) && (bclinksT[newlen].indexOf("scopeShow=") < 0) && (bclinksT[newlen].indexOf("quickSearchState=") < 0) && (bclinksT[newlen].indexOf("show=") < 0)) {
                                if (((priorpage.indexOf(".do?EditAction=true") > -1) || (priorpage.indexOf(".do?forwardName=") > -1)) || (priorpage.indexOf(".do?action=") > -1) || (priorpage.indexOf(".do?perspective=") > -1) || (priorpage.indexOf("scopeShow=") > -1) || (priorpage.indexOf("quickSearchState=") > -1) || (priorpage.indexOf("show=") > -1)) {
                                        bclinksT[newlen] = priorpage;
                                } else if (((altprior.indexOf(".do?EditAction=true") > -1) || (altprior.indexOf(".do?forwardName=") > -1)) || (altprior.indexOf(".do?action=") > -1) || (altprior.indexOf(".do?perspective=") > -1) || (altprior.indexOf("scopeShow=") > -1) || (altprior.indexOf("quickSearchState=") > -1) || (altprior.indexOf("show=") > -1)) {
                                        bclinksT[newlen] = altprior;
                                } else {
                                        bclinksT[newlen] = "badURL";
                                }
                        }
                }



            ///////  Now do the back button check /////////////////////
            for (counter1=0; counter1<oldlen; counter1++) {
    
                   backbutton = bclinksT[counter1];
                   tmpcount = counter1 + 1;
    
                    for (counter3=tmpcount; counter3<bclen; counter3++) {
                            //out.println("<p>comparing "+counter3+" to "+counter1);
                            if (bclinksT[counter3].equals(backbutton)) {
    
                                    for (counter4=tmpcount; counter4<bclen; counter4++) {
                                            bcnamesT[counter4] = "";
                                            bcpageidT[counter4] = "";
                                            if (tmpcount != counter4) {
                                                    bclinksT[counter4] = "";
    
                                            }
                                    }
                                    status = "pop";
                                    //out.println("Back button popped at "+tmpcount);
                                    newlen = tmpcount;
                                    break;
    
                            }
                    }
                    if (status.equals("pop")) {
                            break;
                    }
    
            }



        }





 /*      if (newlen >= 1) {

                if ((ismessagedetail < 0) && (ismessages < 0) && (isreturnfrommessage < 0)) {
                        out.println("<H3 id='bread-crumb'>");
                        for (counter1=0; counter1<newlen; counter1++) {
                                if (bclinksT[counter1].indexOf("badURL") < 0) {
                                        out.println("<a href='" + bclinksT[counter1] + "'>" + bcnamesT[counter1] + "</a> > ");
                                } else {
                                        out.println(bcnamesT[counter1] + " > ");
                                }
                        }
                        out.println("</H3>");
                }

        }*/





        %>



        <%
        if ((ismessagedetail > -1) || (ismessages > -1) || (isreturnfrommessage > -1)) {
                session.setAttribute("bcnames", bcnamesT);
                session.setAttribute("bclinks", bclinksT);
                session.setAttribute("bcpageid", bcpageidT);

        }

        else {

                bcnamesT[newlen] = patternString;
                bcpageidT[newlen] = fieldLevelHelpTopic;
                session.setAttribute("bcnames", bcnamesT);
                session.setAttribute("bclinks", bclinksT);
                session.setAttribute("bcpageid", bcpageidT);

        }

        %>


       <H1 id="bread-crumb">

        <%
                        out.println(moveTo);
        %>


        </H1>





   <p class="instruction-text">
      <bean:message key='<%=instanceDescription%>'/>
      <ibmcommon:info image="help.additional.information.image" topic="<%=fieldLevelHelpTopic%>"/>
   </p>




<%

        if (session.getAttribute("traceOptionValuesMap") != null) {
                session.removeAttribute("traceOptionValuesMap");
                session.removeAttribute("traceGroupsMap");
        }

%>



<a name="main"></a>

