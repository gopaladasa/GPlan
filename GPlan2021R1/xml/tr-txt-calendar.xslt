<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
  
  <xsl:strip-space elements="*"/>

  <!--
    Input 1: calendar-re.xml (Vaisnava Calendar complete merged with user holidays, events and celebrations)
    )
    
    Input 2: cal-moon-data.xml (moon calendar with city, latitude, longitude and timezone)
	
    Input 3: str-translation.xml (translations of Vaisnava Calendar texts)
    
    Output: calendar.txt (data format for text print)
    
  -->
  
  
  <xsl:variable name="moon" select="'cal-moon-data.xml'" />
  
  <xsl:variable name="translation" select="'str-translation.xml'" />
  
  
  <xsl:variable name="gcalversion" select="//xml/request/reqversion" />
  <xsl:variable name="tz" select="substring-before(//xml/request/resdstsystem, ' ')" />
  
  <xsl:variable name="city" select="document($moon)/xml/loc/@city"/>
  <xsl:variable name="long" select="document($moon)/xml/loc/@long"/>
  <xsl:variable name="lat" select="document($moon)/xml/loc/@lat"/>
  
  
  <xsl:variable name="mcheader1" select="document($translation)/xml/string[@ref = 'mcheader1' ]/@desc" />
  <xsl:variable name="mcheader2" select="document($translation)/xml/string[@ref = 'mcheader2' ]/@desc" />
  <xsl:variable name="mcheader3" select="document($translation)/xml/string[@ref = 'mcheader3' ]/@desc" />
  
  
  <xsl:template match="request">
  </xsl:template>
  
  
  <xsl:template match="masa">
    
	<xsl:choose>
      <!-- Start of First Masa -->
      <xsl:when test="count(preceding-sibling::*) = 0">
        <!-- Nothing -->
      </xsl:when>
	  <!-- End of First Masa -->
	  
      <!-- Start of Last Masa -->
      <xsl:when test="position() = last() ">
        <!-- Nothing -->
      </xsl:when>
	  <!-- End of Last Masa -->
	  
	  <!-- Start of all another masa -->
      <xsl:otherwise>
        <xsl:text>                            </xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="@gyear"/>
        <xsl:text>	  </xsl:text>
        <xsl:value-of select="$gcalversion"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>                            </xsl:text>
	    <xsl:value-of select="$city"/>
	    <xsl:text> (</xsl:text>
	    <xsl:value-of select="$lat"/>
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="$long"/>
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="$tz"/>
	    <xsl:text>)</xsl:text>
        <xsl:text>&#xA;</xsl:text>
	    <xsl:value-of select="$mcheader1"/>
        <xsl:text>&#xA;</xsl:text>
	    <xsl:value-of select="$mcheader2"/>
        <xsl:text>&#xA;</xsl:text>
	    <xsl:value-of select="$mcheader3"/>
        <xsl:text>&#xA;</xsl:text>
	    
		
	    <xsl:for-each select="msday">
	      <xsl:variable name="strdate">
	        <xsl:variable name="dt" select="date" />
			
            <xsl:variable name="tm">
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="''"/>
                <xsl:with-param name="strref" select="substring($dt, 6, 2)" />
              </xsl:call-template>
            </xsl:variable>
			
		    <xsl:value-of select="concat(substring($dt, 9, 2), ' ', $tm, ' ', substring($dt, 1, 4))" />
          </xsl:variable>
	    
          <xsl:variable name="strweekday">
	        <xsl:variable name="wid" select="weekday" />
			
            <xsl:variable name="tw">
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="''"/>
                <xsl:with-param name="strref" select="$wid" />
              </xsl:call-template>
            </xsl:variable>
			
	        <xsl:variable name="wrep" select="3 - string-length($tw)" />
			
	        <xsl:value-of select="concat($tw, substring('   ', 1, $wrep))" />
          </xsl:variable>
	      
	      <xsl:variable name="strtithi">
	        <xsl:variable name="ttnm" select="substring-before(tithi, ' ')" />
	        <xsl:variable name="nrep" select="10 - string-length($ttnm)" />
	        <xsl:value-of select="concat($ttnm, substring('          ', 1, $nrep))" />
          </xsl:variable>
          
	      <xsl:variable name="stryoga">
	        <xsl:variable name="yg" select="yoga" />
	        <xsl:variable name="yrep" select="10 - string-length($yg)" />
	        <xsl:value-of select="concat($yg, substring('          ', 1, $yrep))" />
          </xsl:variable>
          
	      <xsl:variable name="strnaksatra">
	        <xsl:variable name="nst" select="naksatra" />
	        <xsl:variable name="krep" select="16 - string-length($nst)" />
	        <xsl:value-of select="concat($nst, substring('                ', 1, $krep))" />
          </xsl:variable>
		  
		  
	      <xsl:value-of select="$strdate"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$strweekday"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(paksa, 1, 1)"/>
		  <xsl:text> </xsl:text>
          <xsl:value-of select="$strtithi"/>
          <xsl:value-of select="$stryoga"/>
          <xsl:value-of select="$strnaksatra"/>
		  
		  
          <xsl:value-of select="substring(arunodaya, 1, 5)"/>
		  <xsl:text>|</xsl:text>
          <xsl:value-of select="substring(sunrise, 1, 5)"/>
		  <xsl:text>|</xsl:text>
          <xsl:value-of select="substring(noon, 1, 5)"/>
		  <xsl:text>|</xsl:text>
          <xsl:value-of select="substring(sunset, 1, 5)"/>
		  <xsl:text>  </xsl:text>
		  
          <xsl:value-of select="substring(moonrise, 1, 5)"/>
		  <xsl:text>|</xsl:text>
          <xsl:value-of select="substring(moontransit, 1, 5)"/>
		  <xsl:text>|</xsl:text>
          <xsl:value-of select="substring(moonset, 1, 5)"/>
		  <xsl:text>   </xsl:text>
		  
          <xsl:value-of select="fastmark"/>
		
		  <xsl:text>&#xA;</xsl:text>
		
          <xsl:for-each select="*[starts-with(local-name(), 'festival') and not(starts-with(local-name(),'festivalref'))]">
			<xsl:text>                  </xsl:text>
            <xsl:variable name="ftvl" select="." />
            <xsl:choose>
              <xsl:when test="contains($ftvl, ' [')">
			    <!-- i.e.: "Vasanta Ritu - indian subcontinent Spring season [Vishnu (Chaitra) and Madhusudana (Vaishakha) months]" -->
                <xsl:value-of select="substring-before($ftvl, ' [')"/>
				<xsl:text>&#xA;</xsl:text>
			    <xsl:text>                  </xsl:text>
				<xsl:value-of select="concat('[', substring-after($ftvl, ' ['))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$ftvl"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#xA;</xsl:text>
          </xsl:for-each>
		  
        </xsl:for-each>
	    
	    <xsl:text>&#xA;</xsl:text>
	    <xsl:text>&#xA;</xsl:text>
	    
      </xsl:otherwise>
	  <!-- End of all another masam -->
	  
    </xsl:choose>
	
  </xsl:template>
    
	
  <!-- Start Translation -->
    
  <xsl:template name="stringtranslation">
    <xsl:param name="strorig"/>
    <xsl:param name="strref"/>
    <xsl:param name="strtype"/>
    
    <xsl:choose>
      <xsl:when test="$strref != '' ">
        <xsl:value-of select="document($translation)/xml/string[@ref = $strref]/@desc"/>
      </xsl:when>
      <xsl:when test="$strtype != '' ">
        <xsl:value-of select="document($translation)/xml/string[@type = $strtype]/@desc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$strorig"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- End Translation -->
  
  
</xsl:stylesheet>

