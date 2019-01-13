<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

 <xsl:strip-space elements="*"/>
 <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Transformations -->

  <xsl:template match="request">
    <request>
	  <reqname><xsl:value-of select="@name"/></reqname>
	  <reqversion><xsl:value-of select="@version"/></reqversion>
	  
      <xsl:for-each select ="arg">
        <xsl:element name="req{@name}"><xsl:value-of select="@val"/></xsl:element>
      </xsl:for-each>
	  
	  <resname><xsl:value-of select="../result/@name"/></resname>
	  <resdstsystem><xsl:value-of select="../result/dstsystem/@name"/></resdstsystem>
    </request>
  </xsl:template>

  <xsl:template match="day">
     <msday>
       <daydate>
         <xsl:call-template name="formatstdate">
           <xsl:with-param name="gdate" select="@date"/>
         </xsl:call-template>	   
	   </daydate>
       <dayweekid><xsl:value-of select="@dayweekid"/></dayweekid>
       <dayweekst><xsl:value-of select="@dayweek"/></dayweekst>
       <gyear><xsl:value-of select="substring(../@gyear,10,3)"/></gyear>
       <gymasa><xsl:value-of select="substring-before(../@name, ' ')"/></gymasa>
       <mpaksaid><xsl:value-of select="sunrise/paksa/@id"/></mpaksaid>
       <mpaksaname><xsl:value-of select="sunrise/paksa/@name"/></mpaksaname>
       <stithiindex><xsl:value-of select="sunrise/tithi/@index"/></stithiindex>
       <stithiname><xsl:value-of select="sunrise/tithi/@name"/></stithiname>
       <atithiname><xsl:value-of select="arunodaya/tithi/@name"/></atithiname>
       <arunodayatime><xsl:value-of select="arunodaya/@time"/></arunodayatime>
       <dsunrisetime><xsl:value-of select="sunrise/@time"/></dsunrisetime>
       
	   <xsl:choose>
         <xsl:when test="parana/@from !=''">
           <paranafrom><xsl:value-of select="parana/@from"/></paranafrom>
         </xsl:when>
       </xsl:choose>
       <xsl:choose>
         <xsl:when test="parana/@to !=''">
           <paranato><xsl:value-of select="parana/@to"/></paranato>
         </xsl:when>
       </xsl:choose>
       
	   <noontime><xsl:value-of select="noon/@time"/></noontime>
       <sunsettime><xsl:value-of select="sunset/@time"/></sunsettime>
	   
       <xsl:choose>
         <xsl:when test="sankranti/@time !=''">
           <sankrantitime><xsl:value-of select="sankranti/@time"/></sankrantitime>
         </xsl:when>
       </xsl:choose>
       <xsl:choose>
         <xsl:when test="sankranti/@rasi !=''">
           <sankrantirasi><xsl:value-of select="sankranti/@rasi"/></sankrantirasi>
         </xsl:when>
       </xsl:choose>
	   
       <xsl:choose>
         <xsl:when test="ksaya/@from !=''">
           <ksayafrom><xsl:value-of select="ksaya/@from"/></ksayafrom>
         </xsl:when>
       </xsl:choose>
       <xsl:choose>
         <xsl:when test="ksaya/@to !=''">
           <ksayato><xsl:value-of select="ksaya/@to"/></ksayato>
         </xsl:when>
       </xsl:choose>
	   
       <moonrise><xsl:value-of select="moon/@rise"/></moonrise>
       <moonset><xsl:value-of select="moon/@set"/></moonset>
	   
       <xsl:choose>
         <xsl:when test="dst/@offset !='0'">
           <dstoffset><xsl:value-of select="number(dst/@offset)"/></dstoffset>
         </xsl:when>
       </xsl:choose>
	   
       <vriddhisd><xsl:value-of select="vriddhi/@sd"/></vriddhisd>
       <tithielapse><xsl:value-of select="sunrise/tithi/@elapse"/></tithielapse>
       <naksatraelapse><xsl:value-of select="sunrise/naksatra/@elapse"/></naksatraelapse>
       <naksatraname><xsl:value-of select="sunrise/naksatra/@name"/></naksatraname>
       <yoganame><xsl:value-of select="sunrise/yoga/@name"/></yoganame>

       <xsl:for-each select ="caturmasya">
         <xsl:element name="dcaturmasya{count(preceding-sibling::caturmasya) + 1}">
           <xsl:value-of select="@month"/>
           <xsl:value-of select="substring(concat(@day, '_'), 1, 6)"/>
           <xsl:value-of select="substring(concat(@system, '_'), 1, 8)"/>
         </xsl:element>
       </xsl:for-each>

       <xsl:choose>
         <xsl:when test="fast/@type !=''">
           <fasttype><xsl:value-of select="fast/@type"/></fasttype>
         </xsl:when>
       </xsl:choose>
       <xsl:choose>
         <xsl:when test="fast/@mark !=''">
           <fastmark><xsl:value-of select="fast/@mark"/></fastmark>
         </xsl:when>
       </xsl:choose>

       <xsl:for-each select ="festival">
           <xsl:element name="dfestival{count(preceding-sibling::festival) + 1}"><xsl:value-of select="@name"/></xsl:element>
           <xsl:element name="dclass{count(preceding-sibling::festival) + 1}"><xsl:value-of select="@class"/></xsl:element>
       </xsl:for-each>

     </msday>
  </xsl:template>

  <xsl:template match="dstsystem">
      <xsl:apply-templates select="*"/>
  </xsl:template>

  <!-- Data -->

    <xsl:template name="monthnum">
        <xsl:param name="month"/>
        <xsl:if test="$month = 'Jan'">01</xsl:if>
        <xsl:if test="$month = 'Feb'">02</xsl:if>
        <xsl:if test="$month = 'Mar'">03</xsl:if>
        <xsl:if test="$month = 'Apr'">04</xsl:if>
        <xsl:if test="$month = 'May'">05</xsl:if>
        <xsl:if test="$month = 'Jun'">06</xsl:if>
        <xsl:if test="$month = 'Jul'">07</xsl:if>
        <xsl:if test="$month = 'Aug'">08</xsl:if>
        <xsl:if test="$month = 'Sep'">09</xsl:if>
        <xsl:if test="$month = 'Oct'">10</xsl:if>
        <xsl:if test="$month = 'Nov'">11</xsl:if>
        <xsl:if test="$month = 'Dec'">12</xsl:if>    
    </xsl:template>
	
    <xsl:template name="formatstdate">
        <xsl:param name="gdate"/>
		
        <xsl:variable name="year" select="substring($gdate,string-length(@date)-3,4)"/>
        <xsl:variable name="month" select="substring($gdate,string-length(@date)-7,3)"/>
        <xsl:variable name="day" select="format-number(substring-before($gdate, ' '),'00')"/>
		
		<xsl:variable name="monthnum">
            <xsl:call-template name="monthnum">
                <xsl:with-param name="month" select="$month"/>
            </xsl:call-template>
        </xsl:variable>
		
        <xsl:value-of select="concat($year, '-', $monthnum, '-', $day)"/>
		
    </xsl:template>

</xsl:stylesheet>
