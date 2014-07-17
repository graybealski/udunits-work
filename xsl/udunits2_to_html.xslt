<?xml version="1.0" encoding="utf-8"?>

<!-- Style sheet to convert UDUNITS XML files to HTML files -->
<!-- Will convert any of the 6 units files into the same table format -->
<!-- Initial version by John Graybeal 2014.02.16 -->

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>

<!-- Main template match section -->
<xsl:template match="/">
<!-- Use the comments in the header of each file to determine which file it is -->
<xsl:variable name="udunits_topic"> 
    <xsl:choose> 
        <xsl:when test="contains(comment(),'Units accepted for use')">Accepted SI Units</xsl:when> 
        <xsl:when test="contains(comment(),'SI base units')">SI Base Units</xsl:when> 
        <xsl:when test="contains(comment(),'Units not accepted for use with the SI')">Non-SI 'Common' Units</xsl:when> 
        <xsl:when test="contains(comment(),'SI derived units with special names and symbols')">Special SI-Derived Units</xsl:when> 
        <xsl:when test="contains(comment(),'SI prefixes')">SI Prefixes</xsl:when> 
    </xsl:choose>
</xsl:variable>

<html>
  <head>
  <title>UDUNITS (<xsl:copy-of select="$udunits_topic" />) Displayed in HTML</title>
  </head>
  <body>
    <h2 style="text-align:center">UDUNITS Table for <xsl:copy-of select="$udunits_topic" /></h2>
    <h3>Introduction</h3>
    <p>The information in the table below comes from the <xsl:copy-of select="$udunits_topic" /> XML file in the UDUNITS pacakge. It was automatically created using an XSL style sheet.</p>
    <!-- 2.0 only: <p>This XSLT transform was applied <xsl:value-of  select="current-dateTime()"/>.</p> -->
    <p><strong>Original Description</strong></p>
    <p>The following information is a copy of the comments at the top of that XML file:
    <blockquote style="white-space:pre;"><xsl:value-of select="comment()" /></blockquote></p>
    <h3><xsl:copy-of select="$udunits_topic" /> UDUNITS Table</h3>
    <table border="1">
      <tr bgcolor="#9EE6DE">
<!-- The column order pairs the names columns, and symbols columns, and puts comments near their subjects -->
        <th>Unit Name</th>
        <th>Aliased Names</th>
        <th>Unit Definition</th>
        <th>Unit Comments</th>
        <th>Unit Symbol</th>
        <th>Aliased Symbols</th>
        <th>Alias Comments</th>
      </tr>
      <!-- For each unit-system element, look for the matches in the rest of the templates -->
      <xsl:for-each select="unit-system">
        <xsl:apply-templates/>
      </xsl:for-each>
    </table>
  </body>
  </html>

</xsl:template>

<!-- Comments at the top level almost always introduce a new section of entries -->
<xsl:template match="comment()">
    <tr>
      <td colspan="7" style="background-color:#eeeeee"><xsl:value-of select="."/></td>
    </tr>
</xsl:template>

<xsl:template match="unit">    
	<tr>
	  <td><xsl:value-of select="name/singular"/> 
      <!-- there is just one case where there are two names; otherwise always one -->
        <xsl:if test="name/plural">  {plural} 
          <xsl:value-of select="name/plural" />
        </xsl:if>
      </td>
	  <td><xsl:for-each select="aliases/name/singular">
			 <xsl:value-of select="." />
			 <xsl:if test="position() != last()">  <!-- put commas in between aliases -->
				<xsl:text>, </xsl:text>
			 </xsl:if>
          </xsl:for-each>
          <!-- if there are plural entries, preface them in the list -->
          <xsl:if test="aliases/name/plural"> {plurals}</xsl:if>
          <xsl:for-each select="aliases/name/plural">
			 <xsl:value-of select="." />
			 <xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			 </xsl:if>
          </xsl:for-each>
	  </td>
	  <td><xsl:value-of select="def"/></td>
      <!-- comments here usually are about the unit -->
	  <td><xsl:value-of select="comment()" />
          <xsl:if test="dimensionless">   <!-- if unit is dimensionless, note it in comment -->
             <xsl:text> Unit is dimensionless</xsl:text>
          </xsl:if>
      </td>
	  <td><xsl:value-of select="symbol"/></td>
	  <td><xsl:for-each select="aliases/symbol">
			 <xsl:value-of select="." />
			 <xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			 </xsl:if>  
		  </xsl:for-each>
	  </td>
      <!-- any comments in the aliases element are captured here -->
	  <td><xsl:for-each select="aliases">   <!-- multiple aliases can each have comments -->
			 <xsl:value-of select="comment()" />
		  </xsl:for-each>
	  </td>
	</tr>
</xsl:template>

<!-- prefixes require special handling, they use 'value' instead of 'def' element -->
<xsl:template match="prefix">    
	<tr>
	  <td><xsl:value-of select="name"/></td>
      <!-- there are no aliases in prefixes, but include processing in case -->
	  <td><xsl:for-each select="aliases/name/singular">
			 <xsl:value-of select="." />
			 <xsl:if test="position() != last()">  <!-- put commas in between aliases -->
				<xsl:text>, </xsl:text>
			 </xsl:if>
          </xsl:for-each>
          <!-- if there are plural entries, preface them in the list -->
          <xsl:if test="aliases/name/plural"> {plurals}</xsl:if>
          <xsl:for-each select="aliases/name/plural">
			 <xsl:value-of select="." />
			 <xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			 </xsl:if>
          </xsl:for-each>
      </td> 
	  <td><xsl:value-of select="value"/></td>
	  <td><xsl:for-each select="comment()">
            <xsl:value-of select="." />
            <xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			 </xsl:if>  
		  </xsl:for-each>
      </td>
	  <td><xsl:for-each select="symbol">
			 <xsl:value-of select="." />
			 <xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			 </xsl:if>  
		  </xsl:for-each>
	  </td>
      <!-- there are no aliases in prefixes, but include processing in case -->
	  <td><xsl:for-each select="aliases/symbol">
			 <xsl:value-of select="." />
			 <xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			 </xsl:if>  
		  </xsl:for-each>
	  </td>
      <!-- any comments within an aliases element are captured here -->
	  <td><xsl:for-each select="aliases">   
			 <xsl:value-of select="comment()" />
		  </xsl:for-each>
	  </td>
	</tr>
</xsl:template>

</xsl:stylesheet>
