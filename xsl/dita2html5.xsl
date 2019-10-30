<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opentopic="http://www.idiominc.com/opentopic" xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  version="2.0" exclude-result-prefixes="xs opentopic opentopic-index xs">

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5Impl.xsl"/>

  <xsl:output method="html" encoding="UTF-8" indent="no" doctype-system="about:legacy-compat" omit-xml-declaration="yes"/>

  <xsl:variable name="input.map" select="/dita/*[contains(@class, ' map/map ')]" as="element()"/>

  <xsl:template match="*" mode="root_element">
    <xsl:variable name="cover" select="*[@outputclass = 'cover']" as="element()?"/>
    <xsl:variable name="map" select="*[contains(@class, ' map/map ')]" as="element()?"/>
    <xsl:variable name="index" select="opentopic-index:index.groups" as="element()?"/>
    <html>
      <xsl:call-template name="setTopicLanguage"/>
      <xsl:apply-templates select="." mode="chapterHead"/>
      <body>
        <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
        <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>
        <xsl:apply-templates select="$cover" mode="cover"/>
        <xsl:apply-templates select="$map" mode="gen-user-sidetoc"/>
        <main xsl:use-attribute-sets="main">
          <xsl:apply-templates select="* except ($cover, $map, $index)" mode="addContentToHtmlBodyElement"/>
        </main>
        <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="generateCssLinks">
    <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}" />
  </xsl:template>

  <xsl:template match="*" mode="cover">
    <header class="cover">
      <h1>
        <xsl:apply-templates select="*[contains(@class, ' topic/title ')]/node()"/>
      </h1>
      <p>Draft</p>
    </header>
  </xsl:template>

  <xsl:template match="*" mode="addAttributesToHtmlBodyElement">
    <!-- Already put xml:lang on <html>; do not copy to body with commonattributes -->
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass" mode="add-ditaval-style"/>
    <xsl:if test="@outputclass">
      <xsl:attribute name="class" select="@outputclass"/>
    </xsl:if>
    <!--
    <xsl:if test="self::dita">
      <xsl:if test="*[contains(@class, ' topic/topic ')][1]/@outputclass">
        <xsl:attribute name="class" select="*[contains(@class, ' topic/topic ')][1]/@outputclass"/>
      </xsl:if>
    </xsl:if>
    -->
    <xsl:call-template name="setid"/>
    <xsl:apply-templates select="." mode="addAttributesToBody"/>
  </xsl:template>

  <xsl:template match="*" mode="addContentToHtmlBodyElement">
    <article xsl:use-attribute-sets="article">
      <!--
      <xsl:attribute name="aria-labelledby">
        <xsl:apply-templates
          select="
            *[contains(@class, ' topic/title ')] |
            self::dita/*[1]/*[contains(@class, ' topic/title ')]"
          mode="return-aria-label-id"/>
      </xsl:attribute>
      -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
      <xsl:apply-templates/>
      <xsl:call-template name="gen-endnotes"/>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </article>
  </xsl:template>
  
  <xsl:template match="opentopic-index:formatted-value |
                       opentopic-index:index.entry" priority="10"/>

</xsl:stylesheet>
