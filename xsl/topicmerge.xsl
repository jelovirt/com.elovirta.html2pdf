<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <xsl:template match="/dita-merge">
    <dita>
      <xsl:comment>cover</xsl:comment>
      <!-- cover -->
      <xsl:comment>TOC</xsl:comment>
      <!-- TOC -->
      <xsl:apply-templates select="*[contains(@class, ' map/map ')]" mode="toc"/>
      <xsl:comment>content</xsl:comment>
      <!-- content -->
      <xsl:apply-templates select="*[contains(@class, ' map/map ')]"/>
    </dita>
  </xsl:template>

  <!-- TOC -->

  <xsl:template match="node() | @*" mode="toc" priority="-10">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="processing-instruction('ditaot')[. = ('gentext', 'genshortdesc')]" mode="toc" priority="10"/>

  <!-- Content -->

  <xsl:key name="topic" match="*[contains(@class, ' topic/topic ')]" use="@id"/>

  <xsl:template match="*[contains(@class, ' map/map ')]">
    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' map/topicref ')][exists(@href)]">
    <xsl:variable name="id" select="substring-after(@href, '#')" as="xs:string?"/>
    <xsl:variable name="topic" select="key('topic', $id)" as="element()?"/>
    <xsl:apply-templates select="$topic">
      <xsl:with-param name="topicref-current" select="."/>
      <xsl:with-param name="topicref-children" select="*[contains(@class, ' map/topicref ')]"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' map/topicref ')][empty(@href)]">
    <xsl:variable name="topicmeta" select="*[contains(@class, ' map/topicmeta ')]" as="element()?"/>
    <topic class="- topic/topic " id="{generate-id()}" outputclass="{name()}">
      <title class="- topic/title ">
        <xsl:choose>
          <xsl:when test="$topicmeta/*[contains(@class, ' map/linktext ')]">
            <xsl:apply-templates select="$topicmeta/*[contains(@class, ' map/linktext ')]/node()"/>
          </xsl:when>
          <xsl:when test="$topicmeta/*[contains(@class, ' map/navtitle ')]">
            <xsl:apply-templates select="$topicmeta/*[contains(@class, ' map/navtitle ')]/node()"/>
          </xsl:when>
          <xsl:when test="@navtitle">
            <xsl:value-of select="@navtitle"/>
          </xsl:when>
        </xsl:choose>
      </title>
      <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]"/>
    </topic>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/topic ')]">
    <xsl:param name="topicref-current" as="element()?"/>
    <xsl:param name="topicref-children" as="element()*"/>
    <xsl:copy>
      <xsl:attribute name="outputclass" select="name($topicref-current)"/>
      <xsl:apply-templates select="node() | @*"/>
      <xsl:apply-templates select="$topicref-children"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node() | @*" priority="-10">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
