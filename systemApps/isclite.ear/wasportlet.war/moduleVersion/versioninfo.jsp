<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2009 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>
<%@ page language="java" contentType="text/plain; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.ibm.websphere.product.WASDirectory"%>
<%@ page import="com.ibm.isc.api.platform.ProductInfo"%>   <%-- F904.6_20487.14 --%>
<%
	WASDirectory wd = new WASDirectory(System.getProperty("was.install.root"));
	String version = wd.getVersion(ProductInfo.ID_BASE);
	if (version == null)
		version = wd.getVersion(ProductInfo.ID_ND);
	if (version == null)
		version = wd.getVersion(ProductInfo.ID_EXPRESS);
	if (version == null)
		version = wd.getVersion(ProductInfo.ID_EMBEDDED_EXPRESS);
	if (version == null)
		version = "unknown";
%>
<%=version%>