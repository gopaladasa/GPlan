<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  
  <!--
    Input 1: res-date-refer.xml (Vaisnava Calendar partially calculated by GCal with date references adds)
    
    Input 2: cal-pers-events.xml (file with personality, events and dates of Vaishnava Calendar not calculated by GCal in command line mode.
    
    Input 3: str-translation.xml (translations of Vaisnava Calendar texts)
    
    
    Output: res-gcal-merge.xml
    
    
    Tranformations: 
    
    * Input 1 & Input 2 merge using gaurabda dates references (tgdate and pgdate)
    
    * Translations of Input 2 texts
  -->
  
  <!-- Input 2 -->
  <xsl:variable name="cal" select="'cal-pers-events.xml'" />
  
  <!-- Input 3: (translations of Vaisnava Calendar texts) -->
  <xsl:variable name="transl" select="'str-translation.xml'" />
  
  
  <!-- Identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="day">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      
      <!-- 
        If pgdate then ksaya (suppressed) previous tithi (gaurabda day).
        In this case, then add festivals of previous lunar day 
        (previous gaurabda tithi date) on this day (if any).
        -->
      <xsl:if test="current()/pgdate">
        <xsl:variable name="pfestivals" select="document($cal)/xml/day[tgdate = current()/pgdate]/." />
        <xsl:for-each select="$pfestivals/*">
		  <xsl:call-template name="AddFestival">
			<xsl:with-param name="name" select="@name"/>
			<xsl:with-param name="ref" select="@ref"/>
			<xsl:with-param name="class" select="@class"/>
			<xsl:with-param name="fastsubject" select="@fastsubject"/>
			<xsl:with-param name="fasttill" select="@fasttill"/>
			<xsl:with-param name="fasttype" select="@fasttype"/>
			<xsl:with-param name="fastmark" select="@fastmark"/>
		  </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      
      <!-- 
        If vriddhi/@sd='yes' then vriddhi (duplicate, extended) 
        tithi gaurabda day. In this case, then does not duplicate 
        festivals (does nothing) on this vriddhi tithi day.
        In vriddhi/@sd='no', add all festivals (if any) of 
        current gaurabda date.
        -->
      <xsl:if test="current()/vriddhi/@sd='no'">
        <xsl:variable name="festivals" select="document($cal)/xml/day[tgdate = current()/tgdate]/." />
        <xsl:for-each select="$festivals/*">
		  <xsl:call-template name="AddFestival">
			<xsl:with-param name="name" select="@name"/>
			<xsl:with-param name="ref" select="@ref"/>
			<xsl:with-param name="class" select="@class"/>
			<xsl:with-param name="fastsubject" select="@fastsubject"/>
			<xsl:with-param name="fasttill" select="@fasttill"/>
			<xsl:with-param name="fasttype" select="@fasttype"/>
			<xsl:with-param name="fastmark" select="@fastmark"/>
		  </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      
    </xsl:copy>
  </xsl:template>
  
  
  <!-- Start AddFestival -->
  <xsl:template name="AddFestival">
    <xsl:param name="name"/>
    <xsl:param name="ref"/>
    <xsl:param name="class"/>
    <xsl:param name="fastsubject"/>
    <xsl:param name="fasttill"/>
    <xsl:param name="fasttype"/>
    <xsl:param name="fastmark"/>
    
          <xsl:if test="name()!='tgdate'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="$name"/>
                  <xsl:with-param name="strref" select="$ref"/>
                </xsl:call-template>
              </xsl:attribute>            
              <xsl:attribute name="ref">
                <xsl:choose>
                  <xsl:when test="$ref != '' ">
                    <xsl:value-of select="$ref"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="translate($name,'., ','||')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="class">
			    <xsl:value-of select="$class"/>
			  </xsl:attribute>
              <xsl:if test="$fastsubject != '' ">
                <xsl:attribute name="fastsubject">
				  <xsl:value-of select="$fastsubject"/>
				</xsl:attribute>
              </xsl:if> 
              <xsl:if test="$fasttill != '' ">
                <xsl:attribute name="fasttill">
                  <xsl:call-template name="stringtranslation">
                    <xsl:with-param name="strorig" select="$fasttill"/>
                    <xsl:with-param name="strtype" select="$fasttype"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:if> 
              <xsl:if test="$fasttype != '' ">
                <xsl:attribute name="fasttype">
				  <xsl:value-of select="$fasttype"/>
				</xsl:attribute>
              </xsl:if> 
              <xsl:if test="$fastmark != '' ">
                <xsl:attribute name="fastmark">
				  <xsl:value-of select="$fastmark"/>
				</xsl:attribute>
              </xsl:if>
            </xsl:element>
          </xsl:if>
    
  </xsl:template>
  <!-- End AddFestival -->
  
  
  <!-- Start Translation -->
  <xsl:template name="stringtranslation">
    <xsl:param name="strorig"/>
    <xsl:param name="strref"/>
    <xsl:param name="strtype"/>
    
    <xsl:choose>
      <xsl:when test="$strref != '' ">
        <xsl:value-of select="document($transl)/xml/string[@ref = $strref]/@desc"/>
      </xsl:when>
      <xsl:when test="$strtype != '' ">
        <xsl:value-of select="document($transl)/xml/string[@type = $strtype]/@desc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$strorig"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  <!-- End Translation -->
  
  
</xsl:transform>