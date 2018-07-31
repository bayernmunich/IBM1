<?xml version="1.0"?>

<!--THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
5724-I63, 5724-H88(C) COPYRIGHT International Business Machines Corp., 1997, 2008
All Rights Reserved * Licensed Materials - Property of IBM
US Government Users Restricted Rights - Use, duplication or disclosure
restricted by GSA ADP Schedule Contract with IBM Corp.-->

<xsl:stylesheet version="1.0"
       xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="button.collapse" select="'Collapse all'"/>
<xsl:param name="button.expand" select="'Expand all'"/>

<xsl:template match="/">
<HTML lang="en-US">

 <STYLE>
        #ddContainer {font-size:70%; font-family: Verdana, sans-serif; margin-right:1.5em; margin-left: 2em;}
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
        B {color:black; font-size: 95%}
        DIV {color:gray; font-size: 95%}
 </STYLE>

<div id="ddContainer">
     <xsl:apply-templates/>
</div>

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
    <xsl:attribute name="id">commenttem<xsl:number count="*" level="any"/></xsl:attribute>
    &lt;!-- <xsl:value-of select="."/>&#160;--&gt;
  </DIV>
</xsl:template>


<!-- Template for elements not handled elsewhere (leaf nodes) -->
<xsl:template match="*">

      <DIV>
          <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
          <xsl:attribute name="id">ddItem<xsl:number count="*" level="any"/></xsl:attribute>
          &lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*"/>/&gt;
      </DIV>

</xsl:template>

<!-- Template for elements with comment, pi and/or cdata children -->
<xsl:template match="*[comment() | processing-instruction()]">
  <DIV>
      <xsl:attribute name="style">font-size:<xsl:value-of select="(count(ancestor::*) * 3) + 95"/>%;margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
      <xsl:attribute name="id">ddItem<xsl:number count="*" level="any"/></xsl:attribute>

           <SPAN style="margin-left:-1.45em">

               <A href="#" onfocus="h()">
                   <xsl:attribute name="onclick">showHide('<xsl:number count="*" level="any"/>');return false;</xsl:attribute>
                   <xsl:attribute name="onkeypress">if (event.keyCode == 13) {showHide('<xsl:number count="*" level="any"/>');return false;}</xsl:attribute>
                   <xsl:element name="img">
                       <xsl:attribute name="src">/ibm/console/images/lminus.gif</xsl:attribute>
                       <xsl:attribute name="border">0</xsl:attribute>
                       <xsl:attribute name="align">absmiddle</xsl:attribute>
                       <xsl:attribute name="alt">expand/collpase element</xsl:attribute>
                       <xsl:attribute name="id">imgddItem<xsl:number count="*" level="any"/></xsl:attribute>
                   </xsl:element>
                </A>
          </SPAN>
      <xsl:apply-templates/>
               <DIV>
                 <xsl:attribute name="style">font-size:<xsl:value-of select="(count(ancestor::*) * 3) + 95"/>%;<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
                 <xsl:attribute name="id">enddItem<xsl:number count="*" level="any"/></xsl:attribute>
                 &#160;&lt;/<xsl:value-of select="name()"/>&gt;
               </DIV>
  </DIV>
</xsl:template>

<!-- Template for elements with only text children -->
<xsl:template match="*[text() and not(comment() | processing-instruction())]">
  <DIV>
          <xsl:attribute name="style">font-size:<xsl:value-of select="(count(ancestor::*) * 3) + 95"/>%;margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
          <xsl:attribute name="id">ddItem<xsl:number count="*" level="any"/></xsl:attribute>
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
          <xsl:attribute name="id">ddItem<xsl:number count="*" level="any"/></xsl:attribute>

              &lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*"/>&gt;
              <xsl:apply-templates/>
               <DIV>
                 <xsl:attribute name="style">font-size:<xsl:value-of select="(count(ancestor::*) * 3) + 95"/>%;<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
                 <xsl:attribute name="id">endddItem<xsl:number count="*" level="any"/></xsl:attribute>
                 &#160;&lt;/<xsl:value-of select="name()"/>&gt;
               </DIV>
     </DIV>
   </xsl:when>
   <xsl:otherwise>
       <DIV>
          <xsl:attribute name="style">margin-left:<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
          <xsl:attribute name="id">ddItem<xsl:number count="*" level="any"/></xsl:attribute>
           <SPAN style="margin-left:-1.45em">

               <A href="#" onfocus="h()">
                   <xsl:attribute name="onclick">showHide('<xsl:number count="*" level="any"/>');return false;</xsl:attribute>
                   <xsl:attribute name="onkeypress">if (event.keyCode == 13) {showHide('<xsl:number count="*" level="any"/>');return false;}</xsl:attribute>
                   <xsl:element name="img">
                       <xsl:attribute name="src">/ibm/console/images/lminus.gif</xsl:attribute>
                       <xsl:attribute name="border">0</xsl:attribute>
                       <xsl:attribute name="align">absmiddle</xsl:attribute>
                       <xsl:attribute name="alt">expand/collpase element</xsl:attribute>
                       <xsl:attribute name="id">imgddItem<xsl:number count="*" level="any"/></xsl:attribute>
                   </xsl:element>
                </A>
               &lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*"/>&gt;
           </SPAN>
               <xsl:apply-templates/>

               <DIV>
                 <xsl:attribute name="style">font-size:<xsl:value-of select="(count(ancestor::*) * 3) + 95"/>%;<xsl:value-of select="count(ancestor::*)"/>em</xsl:attribute>
                 <xsl:attribute name="id">endddItem<xsl:number count="*" level="any"/></xsl:attribute>
                 &#160;&lt;/<xsl:value-of select="name()"/>&gt;
               </DIV>
      </DIV>
      <xsl:if test="count(ancestor::*) > 1">
            <!--<script>
               showHide('ddItem<xsl:number count="*" level="any"/>');
            </script>-->
       </xsl:if>

    </xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>

