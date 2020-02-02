<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  
  <!--
    Input 1: res-gcal-complements.xml (Vaisnava Calendar partially calculated by GCal merged with calendar of personalities and events by gaurabda dates, and adjusts and complements - in other words: complete Vaisnava Calendar)
    )
    
    Input 2: cal-holidays-list.xml (file with holidays, events and celebrations of Gaurabda Planner - GPlan, customized by the user and on user language)
    
    
    Output: res-holidays-merge.xml
    
	
    Tranformation: 
	
	* Input 1 & Input 2 merge using date reference (tgdate)
      Note:
        Holidays (festival@class = -9) on start of festival elements list
        Another events (festival@class != -9) on finish of festival elements list
	
	* Set child fast element on day element, based on class end fastmark attributes of children festivals of element day of both inputs

  -->
  
  
  <!-- Input 2 -->
  <xsl:variable name="with" select="'cal-holidays-list.xml'" />

  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="festival" />
  
  
  <xsl:template match="day">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      
      <xsl:variable name="holidays" select="document($with)/xml/day[tddate=current()/tddate]/." />
      
	  <!-- Holidays (festival@class = -9) on start of festival elements list -->
      <xsl:for-each select="$holidays/*">
        <xsl:if test="name()!='tddate' and @class='-9'">
          <xsl:text>&#xA;&#x9;</xsl:text>
          <xsl:copy-of select="." />
        </xsl:if>
      </xsl:for-each>
      
      <xsl:for-each select="festival">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:copy-of select="." />
      </xsl:for-each>
      
	  <!-- Another events (festival@class != -9) on finish of festival elements list -->
      <xsl:for-each select="$holidays/*">
        <xsl:if test="name()!='tddate' and @class!='-9'">
          <xsl:text>&#xA;&#x9;</xsl:text>
          <xsl:copy-of select="." />
        </xsl:if>
      </xsl:for-each>
      
	  
      <xsl:if test="festival or $holidays">
		        
		<!-- Day class -->
        <xsl:variable name="holiday" select="$holidays/festival[@class='-9']/." />
        <xsl:variable name="fasts" select="festival[@fastclass='-3']/." />
        <xsl:variable name="ekadasi" select="festival[@fastmark='*']/." />
        <xsl:variable name="fast" select="festival[@fastmark='|']/." />
        <xsl:variable name="feast" select="festival[@class='-2']/." />
        <xsl:variable name="event" select="$holidays/festival[@class='9']/." />
        <xsl:variable name="other" select="festival/@class/." />
		
        <xsl:variable name="dayclass">
          <xsl:choose>
            <xsl:when test="$holiday and ($fasts or $ekadasi)">
              <xsl:value-of select="'S'"/>
            </xsl:when>
            <xsl:when test="$ekadasi and $fast">
              <xsl:value-of select="'K'"/>
            </xsl:when>
            <xsl:when test="$holiday">
              <xsl:value-of select="'H'"/>
            </xsl:when>
            <xsl:when test="$ekadasi">
              <xsl:value-of select="'E'"/>
            </xsl:when>
            <xsl:when test="$fast">
              <xsl:value-of select="'P'"/>
            </xsl:when>
            <xsl:when test="$feast">
              <xsl:value-of select="'F'"/>
            </xsl:when>
            <xsl:when test="$event or $other">
              <xsl:value-of select="'C'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
		
		<!-- Fast mark -->
        <xsl:variable name="mark">
          <xsl:choose>
            <xsl:when test="$fasts or $ekadasi">
              <xsl:value-of select="'*'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
		
		
        <xsl:if test="$dayclass != '' or $mark != '' ">
          <xsl:text>&#xA;&#x9;</xsl:text>
          <xsl:element name="fast">
            <xsl:if test="$dayclass != '' ">
		      <xsl:attribute name="type"><xsl:value-of select="$dayclass"/></xsl:attribute>
		    </xsl:if>
		    <xsl:if test="$mark != '' ">
              <xsl:attribute name="mark"><xsl:value-of select="$mark"/></xsl:attribute>
		    </xsl:if>
          </xsl:element>
        </xsl:if>
        
      </xsl:if>
	  
    </xsl:copy>
  </xsl:template>
  
</xsl:transform>