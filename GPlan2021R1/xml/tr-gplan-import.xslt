<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:strip-space elements="masa"/>

    <!--
    Input 1: res-holidays-merge.xslt (Vaisnava Calendar complete merged with user holidays, events and celebrations)
    )
    
    Input 2: str-translation.xml (translations of Vaisnava Calendar texts)
    
    
    Output: calendar-re.xml (data format for GPlan import)
    
    
    Tranformations: 
    
    * request elements and attributes transformed into request elements
    
    * day elements and attributes transformed into msday elements
	
	* Add name of week day
    
	* Add name of month
	
    * Add fastmark to msday
  -->

  <xsl:variable name="with" select="'str-translation.xml'" />
  
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Transformations -->

  <xsl:template match="request">
    <xsl:text>&#xA;  </xsl:text>
    <request>
      <xsl:text>&#xA;    </xsl:text>
      <reqname><xsl:value-of select="@name"/></reqname>
      
      <xsl:text>&#xA;    </xsl:text>
      <reqversion><xsl:value-of select="@version"/></reqversion>
      
      <xsl:for-each select ="arg">
        <xsl:text>&#xA;    </xsl:text>
        <xsl:element name="req{@name}"><xsl:value-of select="@val"/></xsl:element>
      </xsl:for-each>
      
      <xsl:text>&#xA;    </xsl:text>
      <resname><xsl:value-of select="../result/@name"/></resname>
      
      <xsl:text>&#xA;    </xsl:text>
      <resdstsystem><xsl:value-of select="../result/dstsystem/@name"/></resdstsystem>
      
    <xsl:text>&#xA;  </xsl:text>
    </request>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="day">
    <xsl:variable name="dststring">
	  <xsl:value-of select="dst/@offset" />
    </xsl:variable>
	
    <xsl:variable name="dstsec">
	  <xsl:value-of select="number($dststring) * '3600'" />
    </xsl:variable>
    
	
    <xsl:text>&#xA;</xsl:text>
    <msday>
      
      <xsl:text>&#xA;    </xsl:text>
      <date><xsl:value-of select="tddate"/></date>
      
      <xsl:text>&#xA;    </xsl:text>
      <doy><xsl:value-of select="doy"/></doy>
      
      <xsl:text>&#xA;    </xsl:text>
      <nyc><xsl:value-of select="nyc"/></nyc>
      
      <xsl:text>&#xA;    </xsl:text>
      <xsl:variable name="strmonth" select="substring(@date,string-length(@date)-7,3)"/>
      <month><xsl:value-of select="document($with)/xml/string[@ref = $strmonth]/@desc"/></month>
	  
      <xsl:text>&#xA;    </xsl:text>
      <wnum><xsl:value-of select="wnum"/></wnum>
      
      <xsl:text>&#xA;    </xsl:text>
      <weekday><xsl:value-of select="document($with)/xml/string[@ref = current()/@dayweek]/@desc"/></weekday>
      
      <xsl:text>&#xA;    </xsl:text>
      <gyear><xsl:value-of select="substring(../@gyear,10,3)"/></gyear>
	  
      <xsl:text>&#xA;    </xsl:text>
      <masa><xsl:value-of select="substring-before(../@name, ' ')"/></masa>
	  
      <xsl:text>&#xA;    </xsl:text>
      <paksa><xsl:value-of select="sunrise/paksa/@name"/><xsl:text> Paksa</xsl:text></paksa>
      
      <xsl:text>&#xA;    </xsl:text>
      <tnum><xsl:value-of select="sunrise/tithi/@index"/></tnum>
      
      <xsl:text>&#xA;    </xsl:text>
      <tithi><xsl:value-of select="substring-before(concat(sunrise/tithi/@name, ' '), ' ')"/><xsl:text> Tithi</xsl:text></tithi>
      
      <xsl:text>&#xA;    </xsl:text>
      <arunodayatithi><xsl:value-of select="arunodaya/tithi/@name"/></arunodayatithi>
      
      <xsl:text>&#xA;    </xsl:text>
      <vriddhi><xsl:value-of select="vriddhi/@sd"/></vriddhi>
	  
      <xsl:choose>
        <xsl:when test="$dststring != '' ">
          <xsl:text>&#xA;    </xsl:text>
          <dstoffset><xsl:value-of select="$dststring"/></dstoffset>
        </xsl:when>
      </xsl:choose>
	  
      <xsl:choose>
        <xsl:when test="ksaya/@from !='' ">
          <xsl:text>&#xA;    </xsl:text>
          <ksayafrom>
            <xsl:call-template name="timefix">
              <xsl:with-param name="dsttime" select="ksaya/@from" />
              <xsl:with-param name="dstsec" select="$dstsec" />
            </xsl:call-template>
          </ksayafrom>
        </xsl:when>
      </xsl:choose>
	  
      <xsl:choose>
        <xsl:when test="ksaya/@to !='' ">
          <xsl:text>&#xA;    </xsl:text>
          <ksayato>
            <xsl:call-template name="timefix">
              <xsl:with-param name="dsttime" select="ksaya/@to" />
              <xsl:with-param name="dstsec" select="$dstsec" />
            </xsl:call-template>
          </ksayato>
        </xsl:when>
      </xsl:choose>
	  
      <xsl:choose>
        <xsl:when test="sankranti/@time !='' ">
          <xsl:text>&#xA;    </xsl:text>
          <sankrantitime>
            <xsl:call-template name="timefix">
              <xsl:with-param name="dsttime" select="sankranti/@time" />
              <xsl:with-param name="dstsec" select="$dstsec" />
            </xsl:call-template>
          </sankrantitime>
        </xsl:when>
      </xsl:choose>
	  
      <xsl:choose>
        <xsl:when test="sankranti/@rasi !=''">
          <xsl:text>&#xA;    </xsl:text>
          <sankrantirasi><xsl:value-of select="sankranti/@rasi"/></sankrantirasi>
        </xsl:when>
      </xsl:choose>
      
      <xsl:text>&#xA;    </xsl:text>
	  <arunodaya>
        <xsl:call-template name="timefix">
	      <xsl:with-param name="dsttime" select="arunodaya/@time" />
	      <xsl:with-param name="dstsec" select="$dstsec" />
        </xsl:call-template>
	  </arunodaya>
	  
      <xsl:text>&#xA;    </xsl:text>
	  <sunrise>
        <xsl:call-template name="timefix">
	      <xsl:with-param name="dsttime" select="sunrise/@time" />
	      <xsl:with-param name="dstsec" select="$dstsec" />
        </xsl:call-template>
      </sunrise>
	  
      <xsl:choose>
        <xsl:when test="parana/@from !=''">
          <xsl:text>&#xA;    </xsl:text>
          <paranafrom>
            <xsl:call-template name="timefix">
              <xsl:with-param name="dsttime" select="parana/@from" />
              <xsl:with-param name="dstsec" select="$dstsec" />
            </xsl:call-template>
          </paranafrom>
        </xsl:when>
      </xsl:choose>
	  
      <xsl:choose>
        <xsl:when test="parana/@to !=''">
          <xsl:text>&#xA;    </xsl:text>
          <paranato>
            <xsl:call-template name="timefix">
              <xsl:with-param name="dsttime" select="parana/@to" />
              <xsl:with-param name="dstsec" select="$dstsec" />
            </xsl:call-template>
          </paranato>
        </xsl:when>
      </xsl:choose>
	  
      <xsl:text>&#xA;    </xsl:text>
	  <noon>
        <xsl:call-template name="timefix">
	      <xsl:with-param name="dsttime" select="noon/@time" />
	      <xsl:with-param name="dstsec" select="$dstsec" />
        </xsl:call-template>
      </noon>
	  
      <xsl:text>&#xA;    </xsl:text>
	  <sunset>
        <xsl:call-template name="timefix">
	      <xsl:with-param name="dsttime" select="sunset/@time" />
	      <xsl:with-param name="dstsec" select="$dstsec" />
        </xsl:call-template>
      </sunset>
	  
	  
      <xsl:text>&#xA;    </xsl:text>
      <moonrise><xsl:value-of select="moon/@rise"/></moonrise>
	  
      <xsl:text>&#xA;    </xsl:text>
      <moontransit><xsl:value-of select="moon/@transit"/></moontransit>
	  
      <xsl:text>&#xA;    </xsl:text>
      <moonset><xsl:value-of select="moon/@set"/></moonset>
      
      <xsl:text>&#xA;    </xsl:text>
      <moonphase><xsl:value-of select="moon/@phase"/></moonphase>
      
      <xsl:text>&#xA;    </xsl:text>
      <mooncode><xsl:value-of select="moon/@code"/></mooncode>
      
      <xsl:text>&#xA;    </xsl:text>
      <moontransl><xsl:value-of select="moon/@transl"/></moontransl>
      
      <xsl:text>&#xA;    </xsl:text>
      <moonref><xsl:value-of select="moon/@ref"/></moonref>
      
	  
      <xsl:text>&#xA;    </xsl:text>
      <tithielapse><xsl:value-of select="sunrise/tithi/@elapse"/></tithielapse>
	  
      <xsl:text>&#xA;    </xsl:text>
      <naksatraelapse><xsl:value-of select="sunrise/naksatra/@elapse"/></naksatraelapse>
	  
      <xsl:text>&#xA;    </xsl:text>
      <naksatra><xsl:value-of select="sunrise/naksatra/@name"/></naksatra>
	  
      <xsl:text>&#xA;    </xsl:text>
      <yoga><xsl:value-of select="sunrise/yoga/@name"/></yoga>
      
      <xsl:choose>
        <xsl:when test="fast/@type">
          <xsl:text>&#xA;    </xsl:text>
          <fasttype><xsl:value-of select="fast/@type"/></fasttype>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#xA;    </xsl:text>
          <fasttype>&#160;</fasttype>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:choose>
        <xsl:when test="fast/@mark">
          <xsl:text>&#xA;    </xsl:text>
          <fastmark><xsl:value-of select="fast/@mark"/></fastmark>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#xA;    </xsl:text>
          <fastmark>&#160;</fastmark>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:for-each select ="festival">
        <xsl:text>&#xA;    </xsl:text>
        <xsl:element name="festival{count(preceding-sibling::festival) + 1}">
          <xsl:value-of select="@name"/>
        </xsl:element>
        <xsl:text>&#xA;    </xsl:text>        
        <xsl:element name="class{count(preceding-sibling::festival) + 1}">
          <xsl:value-of select="@class"/>
        </xsl:element>
      </xsl:for-each>
      
	  
      <xsl:if test="festival/@ref">
        <xsl:text>&#xA;    </xsl:text>
        <xsl:element name="festivalref">
          <xsl:for-each select="festival">
		    <xsl:if test="@ref">
              <xsl:value-of select="@ref"/>
              <xsl:if test="position() != last()">
                <xsl:text>|</xsl:text>
              </xsl:if>
			</xsl:if>
          </xsl:for-each>		
        </xsl:element>
      </xsl:if>
	  
      <xsl:for-each select ="caturmasya">
        <xsl:text>&#xA;    </xsl:text>
        <xsl:element name="caturmasya{count(preceding-sibling::caturmasya) + 1}">
          <xsl:value-of select="concat(@month, substring(concat(@day, '_'), 1, 5), substring(concat(@system, '_'), 1, 8))"/>
        </xsl:element>
      </xsl:for-each>
	        
     </msday>
     <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="dstsystem">
      <xsl:apply-templates select="*"/>
  </xsl:template>
  
  
  <xsl:template name="timefix">
    <xsl:param name="dsttime"/>
    <xsl:param name="dstsec"/>
    
    <xsl:choose>
      <xsl:when test="$dstsec &gt; '0' ">
        <xsl:variable name="fromhours"   select="substring($dsttime, 1, 2)" />
        <xsl:variable name="fromminutes" select="substring($dsttime, 4, 2)" />
        <xsl:variable name="fs" select="substring($dsttime, 7, 2)" />
	    
	    <xsl:variable name="fromseconds">
          <xsl:choose>
            <xsl:when test="$fs != '' ">
		      <xsl:value-of select="$fs" />
            </xsl:when>
            <xsl:otherwise>
		      <xsl:value-of select="'0'" />
            </xsl:otherwise>
          </xsl:choose>
	    </xsl:variable>
	    
        <xsl:variable name="fromsec" select="($fromhours * 3600) + ($fromminutes * 60) + ($fromseconds)" />
        
        <xsl:variable name="sec" select="$fromsec - $dstsec" />
        <xsl:variable name="h" select="floor($sec div '3600')" />
        <xsl:variable name="r" select="$sec mod '3600' "/>
        <xsl:variable name="m" select="floor($r div '60')" />
        <xsl:variable name="s" select="$r mod '60'"/>
        
        <xsl:variable name="tohours"   select="format-number($h, '00')" />
        <xsl:variable name="tominutes" select="format-number($m, ':00')" />
        <xsl:variable name="toseconds" select="format-number($s, ':00')" />
	    
        <xsl:choose>
          <xsl:when test="$fs != '' ">
            <xsl:value-of select="concat($tohours, $tominutes, $toseconds)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($tohours, $tominutes)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
	  
      <xsl:otherwise>
        <xsl:value-of select="$dsttime"/>
      </xsl:otherwise>
	  
    </xsl:choose>

  </xsl:template>
  
  
</xsl:stylesheet>
