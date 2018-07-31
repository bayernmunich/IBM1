<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2007 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%double multiplier = ((java.lang.Double)session.getAttribute("multiplier")).doubleValue();%>

<style type="text/css">

/* Tabs, shared classes */
.customWASDojoTabLayout .dijitTabPaneWrapper {
	background:#fff;
	border:1px solid #88a4d7;
	margin: 0;
	padding: 0;
}

.customWASDojoTabLayout .dijitTab {
	line-height:normal;
	margin-right:8px;	/* space between one tab and the next in top/bottom mode */
	/*padding:0px;*/
	/*border:1px solid #88a4d7;*/
	background:#d1d9ec url("dojo/dijit/themes/tundra/images/tabEnabled.png") repeat-x;
	
	/* Taken from dojo 0.4 custom WAS style*/
	color: #006699; 
	font-size:<%=(65*multiplier)%>%;
	font-family: Verdana, sans-serif; 
	font-weight:normal; 
	border-bottom: 1px solid #88a4d7;
	border-right: 1px solid #88a4d7;
	border-top: 1px solid #88a4d7; 
	border-left: 1px solid #88a4d7; 
	padding-left: 7px;
	padding-right: 7px;
	padding-top: 4px;
	padding-bottom: 5px;
	text-align: left;
	
}

.customWASDojoTabLayout .dijitTabInnerDiv {
	padding:0px 0px 0px 0px;
	/**padding:6px 8px 5px 9px;**/
}

.dijitTabSpacer {
	font-size: 1px;
}

/* checked tab*/
.customWASDojoTabLayout .dijitTabChecked {
	/* the selected tab (with or without hover) */
	background-color:#fff;
	/* border-color: #88a4d7; */
	background-image:none;
	background-position : 0 -150px;

	/* Taken from dojo 0.4 custom WAS style*/
	color: #000000; 
	font-size:<%=(65*multiplier)%>%;
	font-family: Verdana, sans-serif; 
	font-weight:normal; 
	border-bottom: 1px solid #fff;
	border-right: 1px solid #88a4d7;
	border-top: 1px solid #88a4d7;
	border-left: 1px solid #88a4d7;
	padding-left: 7px;
	padding-right: 7px;
	padding-top: 4px;
	padding-bottom: 5px;
	text-align: left;
}

/* hovered tab */
.customWASDojoTabLayout .dijitTabHover {
	color: #006699;
	border-bottom: 0px solid #fff;
	border-top-color:#88a4d7;
	border-left-color:#88a4d7;
	border-right-color:#88a4d7;
	background:#d1d9ec url("dojo/dijit/themes/tundra/images/tabHover.gif") repeat-x;
}

.customWASDojoTabLayout .dijitTabCheckedHover {
	color: inherit;
	border-bottom: 1px solid #fff;
	border-right: 1px solid #88a4d7;
	border-top: 1px solid #88a4d7; 
	border-left: 1px solid #88a4d7;
	background:#fff;
}

.customWASDojoTabLayout .dijitTab .dijitClosable .closeNode {
	/* Inline-block */
	display:-moz-inline-box;		/* FF2 */
	display:inline-block;			/* webkit and FF3 */
	#zoom: 1; /* set hasLayout:true to mimic inline-block */
	#display:inline; /* don't use .dj_ie since that increases the priority */
	vertical-align:top;
	width: 1em;
	height: 1em;
	padding: 0;
	margin: 0;
}

.customWASDojoTabLayout .dijitTab .dijitClosable .closeImage {
	background: url("dojo/dijit/themes/tundra/images/tabClose.png") no-repeat right top;
	width: 12px;
	height: 12px;
}

.customWASDojoTabLayout .dijitTab .dijitTabButtonSpacer {
	height: 12px;
	width: 1px;
}

.dj_ie6 .dijitTab .dijitClosable .closeImage {
	background-image:url("dojo/dijit/themes/tundra/images/tabClose.gif");
}

.customWASDojoTabLayout .dijitTabCloseButton .dijitClosable .closeImage {
	background-image : url("dojo/dijit/themes/tundra/images/tabClose.png");
}
.dj_ie6 .customWASDojoTabLayout .dijitTabCloseButton .dijitClosable .closeImage {
	background-image : url("dojo/dijit/themes/tundra/images/tabClose.gif");
}

.customWASDojoTabLayout .dijitTabCloseButtonHover .dijitClosable .closeImage {
	background-image : url("dojo/dijit/themes/tundra/images/tabCloseHover.png");
}
.dj_ie6 .customWASDojoTabLayout .dijitTabCloseButtonHover .dijitClosable .closeImage {
	background-image : url("dojo/dijit/themes/tundra/images/tabCloseHover.gif");
}

/* ================================ */
/* top tabs */
.customWASDojoTabLayout .dijitTabContainerTop-tabs {
	margin-bottom: -1px;
	border-color: #88a4d7;
}

/* top container */
.customWASDojoTabLayout .dijitTabContainerTop-container {
	border-top: none;
}

/* checked tabs */
.customWASDojoTabLayout .dijitTabContainerTop-tabs .dijitTabChecked {
	border-bottom-color:white;
}

/* strip */
.customWASDojoTabLayout .dijitTabContainerTopStrip {
	border-top-color:1px solid #fff;
	border-left-color:1px solid #fff;
	border-right-color:1px solid #fff;
	border-bottom-color:1px solid #88a4d7;
	padding-top: 2px;
	padding-right: 3px;
}

.customWASDojoTabLayout .dijitTabContainerTopStrip {
	background: #fff;
}

/* ================================ */
/* bottom tabs */
.customWASDojoTabLayout .dijitTabContainerBottom-tabs {
	margin-top: -1px;
	border-color: #88a4d7;
}

/* bottom container */
.customWASDojoTabLayout .dijitTabContainerBottom-container {
	border-bottom: none;
}

/* checked tabs */
.customWASDojoTabLayout .dijitTabContainerBottom-tabs .dijitTabChecked {
	border-top-color:white;
}

/* strip */
.customWASDojoTabLayout .dijitTabContainerBottomStrip {
	padding-bottom: 2px;
	padding-left: 3px;	
	border: 1px solid #88a4d7;
}

.customWASDojoTabLayout .dijitTabContainerBottomStrip {
	background: #88a4d7;
}

/* top/bottom strip */
.customWASDojoTabLayout .dijitTabContainerBottom-spacer,
.customWASDojoTabLayout .dijitTabContainerTop-spacer {
	height: 0px;
	border-top: 1px solid #88a4d7;
	background: #fff;
}


/* ================================ */
/* right tabs */
.customWASDojoTabLayout .dijitTabContainerRight-tabs {
	margin-left: -1px;
	border-color: #88a4d7;
}

/* right container */
.customWASDojoTabLayout .dijitTabContainerRight-container {
	border-right: none;
}

/* checked tabs */
.customWASDojoTabLayout .dijitTabContainerRight-tabs .dijitTabChecked {
	border-left-color:white;
}

/* strip */
.customWASDojoTabLayout .dijitTabContainerRightStrip {
	padding-right: 2px;
	padding-top: 3px;	
	border: 1px solid #88a4d7;
}

.customWASDojoTabLayout .dijitTabContainerRightStrip {
	background: #88a4d7;
}

/* ================================ */
/* left tabs */
.customWASDojoTabLayout .dijitTabContainerLeft-tabs {
	margin-right: -1px;
	border-color: #88a4d7;
}

/* left conatiner */
.customWASDojoTabLayout .dijitTabContainerLeft-container {
	border-left: none;
}

/* checked tabs */
.customWASDojoTabLayout .dijitTabContainerLeft-tabs .dijitTabChecked {
	border-right-color:white;
}

/* strip */
.customWASDojoTabLayout .dijitTabContainerLeftStrip {
	padding-left: 2px;
	padding-top: 3px;	
	border: 1px solid #88a4d7;
}

.customWASDojoTabLayout .dijitTabContainerLeftStrip {
	background: #88a4d7;
}

/* ================================ */
/* left/right tabs */
.customWASDojoTabLayout .dijitTabContainerLeft-tabs .dijitTab,
.customWASDojoTabLayout .dijitTabContainerRight-tabs .dijitTab {
	margin-right:0px;
	margin-bottom:4px;	/* space between one tab and the next in left/right mode */
}

/* left/right tabstrip */
.customWASDojoTabLayout .dijitTabContainerLeft-spacer,
.customWASDojoTabLayout .dijitTabContainerRight-spacer {
	width: 0px;
	border-left: 1px solid #88a4d7;
	background: #fff;
}


/* ================================ */

/* this resets the tabcontainer stripe when within a contentpane */
.customWASDojoTabLayout .dijitTabContainerTop-dijitContentPane .dijitTabContainerTop-tabs {
	border-left: 0px solid #88a4d7;
	border-top: 0px solid #88a4d7;
	border-right: 0px solid #88a4d7;
	padding-top: 0px;
	padding-left: 0px;	
}

</style>