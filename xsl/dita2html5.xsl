<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opentopic="http://www.idiominc.com/opentopic" xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  version="2.0" exclude-result-prefixes="xs opentopic opentopic-index xs">

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5Impl.xsl"/>

  <xsl:output method="html" encoding="UTF-8" indent="no" doctype-system="about:legacy-compat" omit-xml-declaration="yes"/>

  <xsl:variable name="input.map" select="/dita/*[contains(@class, ' map/map ')]" as="element()"/>

  <xsl:template match="*" mode="root_element">
    <html>
      <xsl:call-template name="setTopicLanguage"/>
      <xsl:apply-templates select="." mode="chapterHead"/>
      <body>
        <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
        <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>
        <xsl:apply-templates select="." mode="cover"/>
        <xsl:apply-templates select="." mode="gen-user-sidetoc"/>
        <main xsl:use-attribute-sets="main">
          <xsl:apply-templates select="* except (*[contains(@class, ' map/map ')], opentopic-index:index.groups)"
            mode="addContentToHtmlBodyElement"/>
        </main>
        <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="*" mode="cover">
    <header class="cover">
      <h1>
        <xsl:for-each select="*[contains(@class, ' map/map ')]">
          <xsl:choose>
            <xsl:when test="*[contains(@class, ' topic/title ')]">
              <xsl:apply-templates select="*[contains(@class, ' topic/title ')]/node()"/>
            </xsl:when>
            <xsl:when test="@title">
              <xsl:value-of select="@title"/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </h1>
    </header>
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

</xsl:stylesheet>
