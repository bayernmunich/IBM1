<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



<xsl:template match="/">
  <HTML>
    <HEAD>
      <STYLE>
        BODY {font-size:70%; font-family: Arial, sans-serif; margin-right:1.5em;margin-left: 2em;}
      <!-- container for expanding/collapsing content -->
        .c  {cursor:hand}
      <!-- button - contains +/-/nbsp -->
        .b  {color:gray; font-family:sans-serif; font-weight:bold; text-decoration:none}
      <!-- element container -->
        .e  {margin-left:1em; text-indent:-1em; margin-right:1em; margin-bottom:0em;color:gray}
      <!-- comment or cdata -->
        .k  {margin-left:1em; text-indent:-1em; margin-right:1em; margin-top:0px;margin-bottom:0px;}
      <!-- tag -->
        .t  {color:gray}
      <!-- tag in xsl namespace -->
        .xt {color:gray}
      <!-- attribute in xml or xmlns namespace -->
        .ns {color:gray}
      <!-- attribute in dt namespace -->
        .dt {color:gray}
      <!-- markup characters -->
        .m  {color:gray}
      <!-- text node -->
        .tx {font-weight:bold}
      <!-- multi-line (block) cdata -->
        .db {text-indent:0px; margin-left:1em; margin-top:0px;margin-bottom:0px;
             padding-left:.3em; border-left:1px solid #CCCCCC; font:small Courier}
      <!-- single-line (inline) cdata -->
        .di {font:small Courier}
      <!-- DOCTYPE declaration -->
        .d  {color:gray}
      <!-- pi -->
        .pi {color:gray}
      <!-- multi-line (block) comment -->
        .cb {text-indent:0px; margin-left:1em; margin-top:0px; margin-bottom:0px;
             padding-left:.3em; font:small Courier; color:gray}
      <!-- single-line (inline) comment -->
        .ci {font-family:sans-serif; color:gray; }
        PRE {margin:0px; display:inline}
        B {color:black}
        DIV {color:gray}
        
        .buttons  {  font-family: Arial,Helvetica, sans-serif; font-size: 90%; margin: 1px 2px 1px 2px; border: 1px solid black; background-color:#D8D8D8; }
      </STYLE>

      <SCRIPT><![CDATA[
      
      
var isNav4, isIE, isDom;

var foropera = window.navigator.userAgent.toLowerCase();

var itsopera = foropera.indexOf("opera",0) + 1;
var itsgecko = foropera.indexOf("gecko",0) + 1;
var itsmozillacompat = foropera.indexOf("mozilla",0) + 1;
var itsmsie = foropera.indexOf("msie",0) + 1;


if (itsopera > 0){
        //thebrowser = 3;
        //alert("its opera");
        isNav4 = true
}


if (itsmozillacompat > 0){ 
        //alert("its mozilla compatible");
        if (itsgecko > 0) {
               //thebrowser = 4
               // alert("its gecko");
               isIE= true
               if(foropera.indexOf(".net") === -1){isDom = true}
               document.all = document.getElementsByTagName("*");

        }
        else if (itsmsie > 0) {
              //  alert("its msie");
               // thebrowser = 2
                isIE = true
        }
        else {
                if (parseInt(navigator.appVersion) < 5) {
                        // alert("its ns4.x")
                        //thebrowser = 1
                        isNav4 = true
                }
                else {
                        //thebrowser = 2
                        isIE = true
                }
        }
} 
      
        function showAll() 
        {
            if (isDom) { document.all = document.getElementsByTagName("*") }
            for (j=1; j< document.all.length;j++) {
                theitem = document.all[j];
                if (theitem.tagName == "DIV") { 
                    theitem.style.display = "block";
                }
                if (theitem.tagName == "IMG") {
                    if (theitem.src.indexOf("lplus.gif") > 0) {
                        theitem.src = "/ibm/console/images/lminus.gif";
                    }
                }
            }
            document.all["showbutton"].disabled = true;
            document.all["hidebutton"].disabled = false;
        }
        
        
        function hideAll() 
        {
            if (isDom) { document.all = document.getElementsByTagName("*") }
            for (j=1; j< document.all.length;j++) {
                theitem = document.all[j];
                if (theitem.tagName == "DIV") { 
                    if (theitem.id != "i1") {
                        //alert("parent: "+theitem.parentNode.id+" me: "+theitem.id);
                        if (theitem.parentNode.id != "i1") {
                            theitem.style.display = "none";
                        }
                    }
                }
                if (theitem.tagName == "IMG") {
                    if (theitem.src.indexOf("lminus.gif") > 0) {
                        theitem.src = "/ibm/console/images/lplus.gif";
                    }
                }
            }
            document.all["showbutton"].disabled = false;
            document.all["hidebutton"].disabled = true;            
            
        }
        
        

        // Function for expand/collapse link navigation
        function showHide(item) 
        {
            theimg = document.all["p"+item];
            theitem = document.all[item];
            if (isDom) {
                thelen = theitem.childNodes.length;
            } else {
                thelen = theitem.children.length;
            }
            
            if (theimg.src.indexOf("lplus.gif") > 0) {
                theimg.src = "/ibm/console/images/lminus.gif";
                for (i = 1; i < thelen; i++) {
                    if (isDom) {
                        if (i < (thelen-1)) {
                            curritem = theitem.childNodes[i+1];
                            if (curritem.innerHTML != undefined) {
                               curritem.style.display = "block";
                            }
                        }
                    } else {
                        theitem.children(i).style.display = "block";
                    }
                }

            } else {
                theimg.src = "/ibm/console/images/lplus.gif";
                for (i = 1; i < thelen; i++) {
                    if (isDom){
                        if (i < (thelen-1)) {
                            curritem = theitem.childNodes[i+1];
                            if (curritem.innerHTML != undefined) {
                               curritem.style.display = "none";
                            }
                        }
                    } else {
                        theitem.children(i).style.display = "none";
                    }
                }                                        
            }
            document.all["showbutton"].disabled = false;
            document.all["hidebutton"].disabled = false;         
        }

        // Erase bogus link info from the status window
        function h()
        {
          window.status=" ";
        }

        // Set the onclick handler
        //document.onclick = cl;
        
        
      ]]></SCRIPT>
    </HEAD>
        <BODY class="st">
           <script> 
             <xsl:comment>   <![CDATA[
                    document.write("<p><input id='showbutton' class='buttons' type='button' value='Expand All' onclick=\"javascript:showAll();return false;\">");
                    document.write("&nbsp;<input id='hidebutton' class='buttons' type='button' value='Collapse All' onclick=\"javascript:hideAll();return false;\"></p>");
                    showAll();
              ]]>   </xsl:comment>           
            </script>
            <xsl:apply-templates/>
        </BODY>

  </HTML>
</xsl:template>

<!-- Templates for each node type follows.  The output of
each template has a similar structure to enable script to
walk the result tree easily for handling user
interaction. -->
  

<!-- Template for pis not handled elsewhere -->
<xsl:template match="processing-instruction()">
  <DIV class="e">
  &#160;&lt;?<xsl:value-of select="name()"/>&#160;<xsl:value-of select="."/>?&gt;
  </DIV>
</xsl:template>


<!-- Template for attributes not handled elsewhere -->
<xsl:template match="@*" xml:space="preserve">
   <xsl:value-of select="name()" />="<i><xsl:value-of select="."/></i>"
</xsl:template>


<!-- Template for text nodes -->
<xsl:template match="text()">
  <!--<DIV class="e">
  &#160;<xsl:value-of select="."/>
  </DIV>-->
</xsl:template>

  
<!-- Template for comment nodes -->
<xsl:template match="comment()">
  <DIV>
    <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
    <xsl:attribute name="id">i<xsl:number count="*" level="any"/></xsl:attribute>
    &lt;!-- <xsl:value-of select="."/>&#160;--&gt;
  </DIV>
</xsl:template>


<!-- Template for elements not handled elsewhere (leaf nodes) -->
<xsl:template match="*">

      <DIV>
          <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
          <xsl:attribute name="id">i<xsl:number count="*" level="any"/></xsl:attribute>
          &lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*"/>/&gt;
      </DIV>

</xsl:template>
  
<!-- Template for elements with comment, pi and/or cdata children -->
<xsl:template match="*[comment() | processing-instruction()]">
  <DIV>
      <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
      <xsl:attribute name="id">i<xsl:number count="*" level="any"/></xsl:attribute>

           <SPAN style="margin-left:-1.45em">

               <A href="#" onfocus="h()">
                   <xsl:attribute name="onclick">showHide('i<xsl:number count="*" level="any"/>');return false;</xsl:attribute>
                   <xsl:attribute name="onkeypress">showHide('i<xsl:number count="*" level="any"/>');return false;</xsl:attribute>
                   <xsl:element name="img">
                       <xsl:attribute name="src">/ibm/console/images/lminus.gif</xsl:attribute>
                       <xsl:attribute name="border">0</xsl:attribute>
                       <xsl:attribute name="align">absmiddle</xsl:attribute>
                       <xsl:attribute name="alt">expand/collpase element</xsl:attribute>
                       <xsl:attribute name="id">pi<xsl:number count="*" level="any"/></xsl:attribute>
                   </xsl:element>
                </A> 
          </SPAN>
      <xsl:apply-templates/>
               <DIV>
                 <xsl:attribute name="id">endi<xsl:number count="*" level="any"/></xsl:attribute>
                 &#160;&lt;/<xsl:value-of select="name()"/>&gt;
               </DIV>
  </DIV>
</xsl:template>

<!-- Template for elements with only text children -->
<xsl:template match="*[text() and not(comment() | processing-instruction())]">
  <DIV>
          <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
          <xsl:attribute name="id">i<xsl:number count="*" level="any"/></xsl:attribute>
        &#160;&lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*"/>&gt;
	 <b><xsl:value-of select="."/></b>&lt;/<xsl:value-of select="name()"/>&gt;
  </DIV>
</xsl:template>

<!-- Template for elements with element children -->
<xsl:template match="*[*]">

<xsl:choose>
   <!--<xsl:when test="starts-with(name(),'web-app')">-->
    <xsl:when test="count(ancestor::*) = 0">
      <DIV>
          
          <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
          <xsl:attribute name="id">i<xsl:number count="*" level="any"/></xsl:attribute>

              &lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*"/>&gt;
              <xsl:apply-templates/>
               <DIV>
                 <xsl:attribute name="id">endi<xsl:number count="*" level="any"/></xsl:attribute>
                 &#160;&lt;/<xsl:value-of select="name()"/>&gt;
               </DIV>
     </DIV>
   </xsl:when>
   <xsl:otherwise>
       <DIV>
          <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
          <xsl:attribute name="id">i<xsl:number count="*" level="any"/></xsl:attribute>
           <SPAN style="margin-left:-1.45em">

               <A href="#" onfocus="h()">
                   <xsl:attribute name="onclick">showHide('i<xsl:number count="*" level="any"/>');return false;</xsl:attribute>
                   <xsl:attribute name="onkeypress">showHide('i<xsl:number count="*" level="any"/>');return false;</xsl:attribute>
                   <xsl:element name="img">
                       <xsl:attribute name="src">/ibm/console/images/lminus.gif</xsl:attribute>
                       <xsl:attribute name="border">0</xsl:attribute>
                       <xsl:attribute name="align">absmiddle</xsl:attribute>
                       <xsl:attribute name="alt">expand/collpase element</xsl:attribute>
                       <xsl:attribute name="id">pi<xsl:number count="*" level="any"/></xsl:attribute>
                   </xsl:element>
                </A> 
               &lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*"/>&gt;
           </SPAN>
               <xsl:apply-templates/>

               <DIV>
                 <xsl:attribute name="id">endi<xsl:number count="*" level="any"/></xsl:attribute>
                 &#160;&lt;/<xsl:value-of select="name()"/>&gt;
               </DIV>
      </DIV>
      <xsl:if test="count(ancestor::*) > 1">
            <!--<script>
               showHide('i<xsl:number count="*" level="any"/>');
            </script>-->
       </xsl:if>              

    </xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>

