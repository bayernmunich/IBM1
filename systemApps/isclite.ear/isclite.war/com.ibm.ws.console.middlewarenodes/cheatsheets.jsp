<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.websphere.product.*,java.util.Locale,org.apache.struts.util.MessageResources,org.apache.struts.action.Action,com.ibm.ws.console.core.*,com.ibm.ws.console.core.Constants"%>

<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.item.NavigatorItem"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>



<%
	java.util.ArrayList navigatorList_ext =  new java.util.ArrayList();
	
	String cheatsheetsDir = "cheatsheets";
	
	String currentLocale = "en";
	String[] availableLocales = com.ibm.ws.console.core.Constants.LOCALES;
	Locale locale = (Locale) session.getAttribute (org.apache.struts.Globals.LOCALE_KEY);
	
	if (locale.toString().startsWith("en") || locale.toString().equals("C"))
	{
		currentLocale = availableLocales [0];
	}
	else
	{
		for (int i = 1; i < availableLocales.length; i++)
		{
			if (locale.toString().equals(availableLocales[i]))
			{
				currentLocale = availableLocales [i];
				break;
			}
			else
			{
				if (locale.toString().startsWith(availableLocales[i]))
				{
					currentLocale = availableLocales [i];
					break;
				}
			}
		}
	}
	
	String contextType=(String)request.getAttribute("contextType");		
	IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();	
	String extensionId = "com.ibm.websphere.wsc.cheatsheet";
	IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType, extensionId);	
	IExtension[] extensions = registry.getExtensions(extensionId, ic);	

	%>
    
    <DIV CLASS="desctext">

        <bean:message key="cheatsheets.desc"/>
    <%
	if (extensions != null && extensions.length == 0) {
	   %>
        <bean:message key="cheatsheets.desc.noplugins"/>
       <%
	} 

	%>
        <bean:message key="cheatsheets.desc.getmore"/>
    </DIV>
    
    <%--<DIV STYLE="overflow:auto;height:75px">--%>
    <DIV>
    
    <%


	for (int i=0; extensions != null && i < extensions.length; i++) 
	{
	    IConfigurationElement[] elements = extensions[i].getConfigurationElements();
	    String pluginId = ((Extension)extensions[i]).getParentDescriptor().getUniqueIdentifier();	   
	    for (int j=0; elements != null && j < elements.length; j++) 
	    {	    	
	    	IConfigurationElement[] children = elements[j].getChildren();	    
        	for (int k=0; children != null && k < children.length; k++) 
        	{
        		StringBuffer sheetPath = new StringBuffer();
			//sheetPath.append(request.getContextPath());
			sheetPath.append("/secure/console.jsp?cheatSheetURI=");	
        		
        		NavigatorItem item = new NavigatorItem();
			if(children[k].getName().equalsIgnoreCase("categoryDefinition"))
			{
				item.setLink("");
				item.setValue(children[k].getAttributeValue("id")+":"+children[k].getAttributeValue("parent"));
				if(children[k].getAttributeValue("icon") != null) 
				{
					item.setIcon(children[k].getAttributeValue("icon")+":"+children[k].getAttributeValue("weight"));
			        }
				else
				{
					item.setIcon(":"+children[k].getAttributeValue("weight"));
				}
				if(children[k].getAttributeValue("role") != null)
					item.setTooltip(children[k].getAttributeValue("label")+":"+children[k].getAttributeValue("role"));
				else
					item.setTooltip(children[k].getAttributeValue("label"));
				navigatorList_ext.add(item);
			}
			
			else if(children[k].getName().equals("cheatsheet"))
                                {
                                        IConfigurationElement[] category = children[k].getChildren("category");
                                        String categoryName = "";
                                        if(category != null && category.length == 1)
                                        {
                                             categoryName = category[0].getAttributeValue("id");
                                        }

                                        String sheetURI = children[k].getAttributeValue("sheetURI");
                                        sheetPath.append(pluginId);
                                        sheetPath.append("/");
                                        sheetPath.append(cheatsheetsDir);
                                        sheetPath.append("/");
                                        sheetPath.append(currentLocale);
                                        sheetPath.append("/");
										sheetPath.append(sheetURI);   
                                        item.setLink(sheetPath.toString());
                                        
                                        
                                        item.setValue(children[k].getAttributeValue("id")+":"+categoryName);                    
                                        if(children[k].getAttributeValue("icon") != null)
                                        {
                                                item.setIcon(children[k].getAttributeValue("icon")+":"+children[k].getAttributeValue("weight"));
                                        }
                                        else
                                        {
                                                item.setIcon(":"+children[k].getAttributeValue("weight"));
                                        }                       
                                        
                                        item.setTooltip(children[k].getAttributeValue("label"));                                                        
                                        navigatorList_ext.add(item);
                                }        		
        	}
	    }
	}
	java.util.ArrayList navigatorList_sort =  NavigatorHelper.getSortedNavigatorList(navigatorList_ext);	
%>

                        <UL CLASS="nav-child">
<%

    List topLevelItems = new ArrayList();
    List staticTree = new ArrayList();
    staticTree.add("admin_domain");
    List staticTreeLevels = new ArrayList();
    int level = 0;
    staticTreeLevels.add(new Integer(level)); 
    int parIndex = 0;
    int counter = 0;
    String strlevel = "";
    String priorPar = "";
    int priorlevel = 1;
    for(int p = 0; p < navigatorList_sort.size(); p++)
    {
        NavigatorItem item = (NavigatorItem)navigatorList_sort.get(p);
        
        String targetString = "detail";
        String taskClass = "main-task";
        String groupClass = "nav-child-container";
    
        String parentId = item.getParentId();
        if (parentId.equals("root")) {
            parentId = "admin_domain";
        }
        String link = item.getLink();
        if (link.equals("") == false && link.startsWith("http://") == false) {
            link = request.getContextPath()+link;
        }
        String icon = item.getIcon();
        if (icon.equals("")) {
            icon = request.getContextPath()+"/images/onepix.gif";
        }
        else {
            if (icon.startsWith("//")) {
                icon = icon.substring(1);
            }
            else {
                if (icon.startsWith("/")) {
                    icon = request.getContextPath()+icon;
                }
                else {
                    icon = request.getContextPath()+"/"+icon;
                }
            }
        }

        if (!link.equals("")) {
        
%>                      

                        <LI CLASS="navigation-bullet">
                        <a href="<%=link%>" style="text-decoration:none" >
                        <bean:message key='<%=item.getTooltip()%>'/>
                        </a>
                        </LI>


  <%
	
		
		}
	}
  %>
                        </UL>
                        
    </DIV>
