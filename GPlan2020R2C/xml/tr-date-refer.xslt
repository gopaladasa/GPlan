<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:strip-space elements="masa"/>
  
  <!--
  Input 1: cal-gcal-cmdline.xml (Vaisnava Calendar partially calculated)
  
  Input 2: str-translation.xml (translations of Vaisnava Calendar texts)
  
  Input 3: cal-moon-data.xml (moon rise, transit and set times)

  
  Output: res-date-refer.xml
  
  
  Tranformations:
  
  Add on day element:
  * Week number (wnum) in 'ww' format
  * Date (ddate) in 'yyyy-mm-dd' format
  * Gaurabda date (gdate as masa, paksa, tithi) in '9mmpptt' format
  * When ksaya tithi, add previous gaurabda date (pgdate as masa, paksa, tithi) in '9mmpptt' format
  * Julian Day Number (JDN)
  * Day-of-Year
  * Days-to-New-Year Countdown
  * Time of fast - '(from #start_hour#:#start_minute# till tomorrow after sunrise)' festival element (if day is suitable for ekadasi fasting)
  * 'BreakFastAfter' or 'BreakFast' translator reference festival element (if day following ekadasi fasting)
  
  Merge on day element:
  * Moon data of input 3, cal-moon-data.xml (moon rise, transit and set times, phase, charact code, translation and monthly reference)
  
  On festival element:
  Add:
  * fasttill, fasttype, fastclass, fastmark and ref (reference for translation) attributes on fasting days
  
  Change:
  * class attribute to '-8' of suitable for ekadasi fasting days
  * class attribute to '-3' of fasting no-ekadasi days
  * Translations of texts
  
  Obs: indentation of element adds by xsl:text with tab (&#x9;) and newline (&#xA;) characters: <xsl:text>&#xA;&#x9;</xsl:text>
  -->
  
  <!-- Input 2: (translations of Vaisnava Calendar texts) -->
  <xsl:variable name="with" select="'str-translation.xml'" />
  
  
  <!-- Input 3: (Moon rise, transit and set times) -->
  <xsl:variable name="moon" select="'cal-moon-data.xml'" />


  <!-- Previous year -->
  <xsl:variable name="pyear" select="number(substring(xml/request/arg[@name = 'startdate']/@val, 8, 4))"/>

  <!-- Julian Day of 1ft jan of previous year -->
  <xsl:variable name="jdpyear">
    <xsl:call-template name="JDN">
	  <xsl:with-param name="jdate" select="concat('1 Jan ', $pyear)"/>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- Julian Day of 1ft jan current year -->
  <xsl:variable name="jdcyear">
    <xsl:call-template name="JDN">
	  <xsl:with-param name="jdate" select="concat('1 Jan ', $pyear + 1)"/>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- Julian Day of 1ft jan next year -->
  <xsl:variable name="jdnyear">
    <xsl:call-template name="JDN">
	  <xsl:with-param name="jdate" select="concat('1 Jan ', $pyear + 2)"/>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- Julian Day of 1ft jan next of next year -->
  <xsl:variable name="jdn2year">
    <xsl:call-template name="JDN">
	  <xsl:with-param name="jdate" select="concat('1 Jan ', $pyear + 3)"/>
    </xsl:call-template>
  </xsl:variable>
  
  
  <!-- Julian Day of 1ft jan next of next of next year -->
  <xsl:variable name="jdn3year">
    <xsl:call-template name="JDN">
	  <xsl:with-param name="jdate" select="concat('1 Jan ', $pyear + 4)"/>
    </xsl:call-template>
  </xsl:variable>
  
  
  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  
  <!-- When matching festival: do nothing -->
  <xsl:template match="festival" />
  
  <!-- When matching fast: do nothing -->
  <xsl:template match="fast" />
  
  <!-- When matching moon: do nothing -->
  <xsl:template match="moon" />
  
  
  <!-- Transformations -->

  <xsl:template match="day">
    <xsl:copy>
      
      <!-- 
        Copy all elements and attributes of 'day', 
        except festival, fast and moon
      -->
      <xsl:apply-templates select="@* | node()"/>
      
	  
      <!-- Start Moon data -->
      <xsl:variable name="tddat">
	    <xsl:call-template name="formatstdate">
          <xsl:with-param name="sdate" select="@date"/>
        </xsl:call-template>
      </xsl:variable>
	  
      <xsl:element name="moon">       
        <xsl:attribute name="rise">
          <xsl:value-of select="document($moon)/xml/day[@ltDat = $tddat]/@ltRis"/>
        </xsl:attribute>
        <xsl:attribute name="transit">
          <xsl:value-of select="document($moon)/xml/day[@ltDat = $tddat]/@ltTrs"/>
        </xsl:attribute>
        <xsl:attribute name="set">
          <xsl:value-of select="document($moon)/xml/day[@ltDat = $tddat]/@ltSet"/>
        </xsl:attribute>
        <xsl:attribute name="phase">
          <xsl:value-of select="document($moon)/xml/day[@ltDat = $tddat]/@ltPhase"/>
        </xsl:attribute>
        <xsl:attribute name="code">
          <xsl:value-of select="document($moon)/xml/day[@ltDat = $tddat]/@ltCode"/>
        </xsl:attribute>
        <xsl:attribute name="transl">
          <xsl:value-of select="document($moon)/xml/day[@ltDat = $tddat]/@ltTransl"/>
        </xsl:attribute>
        <xsl:if test="document($moon)/xml/day[@ltDat = $tddat]/@ltMRef">
          <xsl:attribute name="ref">
            <xsl:value-of select="document($moon)/xml/day[@ltDat = $tddat]/@ltMRef"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:element>
      <!-- End Moon data -->	  
	  
	  
      <!-- Start Date References -->
      
      <!-- Add wnum (week number) in 'ww' format -->
      <xsl:text>&#xA;&#x9;</xsl:text>
      <wnum>
        <xsl:call-template name="weeknum">
          <xsl:with-param name="wdate" select="@date"/>
        </xsl:call-template>
      </wnum>
      
      <!-- Add today date in 'yyyy-mm-dd' format -->
      <xsl:text>&#xA;&#x9;</xsl:text>
      <tddate>
        <xsl:call-template name="formatstdate">
          <xsl:with-param name="sdate" select="@date"/>
        </xsl:call-template>
      </tddate>
      
      <!-- Add previous gaurabda date (pgdate as masa, paksa, tithi) in '9mmpptt' format, at ksaya gaurabda dates -->
      <xsl:if test="ksaya">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <pgdate>
          <xsl:call-template name="gdate">
            <!-- See parameters comments to tgdate template below -->
            <xsl:with-param name="gmasa" select="substring(substring-before(../@name, ' '), 1, 11)"/>
            <xsl:with-param name="gpaksa" select="sunrise/paksa/@id"/>
            <xsl:with-param name="gtithi" select="substring-before(concat(sunrise/tithi/@name, ' '), ' ')"/>
            <xsl:with-param name="previous" select="'yes'"/>
          </xsl:call-template>
        </pgdate>
      </xsl:if>
      
      <!-- Add today gaurabda date (tgdate as masa, paksa, tithi) in '9mmpptt' format -->
      <xsl:text>&#xA;&#x9;</xsl:text>
      <tgdate>
        <xsl:call-template name="gdate">          
          <!--      
            Masa (lunar month)
            
            * masa is on parent element of day, i.e.: <masa name="Purusottama-adhika Masa" gyear="Gaurabda 534">
            
            * Call 'masa name' from the child element day: ../@name
            
            * Exemple - 'Purusottama-adhika Masa' (more lengthy masa name - 11 characters - and unique with suffix):
            * substring(substring-before('Purusottama-adhika Masa', ' '), 1, 11) = 'Purusottama'
            * 'Purusottama-adhika Masa' -> 'Purusottama'
          -->
          <xsl:with-param name="gmasa" select="substring(substring-before(../@name, ' '), 1, 11)"/>
          
          <!-- 
          Paksa (lunar fortnight)
          
          * i.e: <paksa id="G" name="Gaura"/>
          
          Krishna Paksa = 'K'
          Gaura Paksa = 'G'
          -->
          <xsl:with-param name="gpaksa" select="sunrise/paksa/@id"/>
          
          <!-- Tithi (lunar day) 
          * i.e.: <sunrise time="05:05:58">
                    <tithi name="Ekadasi (suitable for fasting)" elapse="75.1" index="26"/>
            or
                  <sunrise time="05:05:25">
                    <tithi name="Dvadasi" elapse="70.7" index="27"/>
          -->
          <xsl:with-param name="gtithi" select="substring-before(concat(sunrise/tithi/@name, ' '), ' ')"/>
          <!-- If 'yes' then calculate previous tithi -->
          <xsl:with-param name="previous" select="'no'"/>
        </xsl:call-template>
      </tgdate>
      
	  
      <!-- Add Julian Day Number (JDN) -->
      <xsl:variable name="jdnumber">
        <xsl:call-template name="JDN">
          <xsl:with-param name="jdate" select="@date"/>
        </xsl:call-template>       
      </xsl:variable>
	  
      <xsl:text>&#xA;&#x9;</xsl:text>
      <jnd>
        <xsl:value-of select="$jdnumber"/>       
      </jnd>
	  
	  
	  <!-- Day-of-Year -->
      <xsl:text>&#xA;&#x9;</xsl:text>
      <doy>  
        <xsl:choose>
          <xsl:when test="$jdnumber &lt; $jdcyear">
            <xsl:value-of select="$jdnumber - $jdpyear + 1"/>
          </xsl:when>
          <xsl:when test="$jdnumber &lt; $jdnyear">
            <xsl:value-of select="$jdnumber - $jdcyear + 1"/>
          </xsl:when>
          <xsl:when test="$jdnumber &lt; $jdn2year">
            <xsl:value-of select="$jdnumber - $jdnyear + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$jdnumber - $jdn2year + 1"/>
          </xsl:otherwise>
        </xsl:choose>
      </doy>
      
	  
	  <!-- Days to New Year Countdown -->
      <xsl:text>&#xA;&#x9;</xsl:text>
      <nyc>
        <xsl:choose>
          <xsl:when test="$jdnumber &lt; $jdcyear">
            <xsl:value-of select="$jdcyear - $jdnumber - 1"/>
          </xsl:when>
          <xsl:when test="$jdnumber &lt; $jdnyear">
            <xsl:value-of select="$jdnyear - $jdnumber - 1"/>
          </xsl:when>
          <xsl:when test="$jdnumber &lt; $jdn2year">
            <xsl:value-of select="$jdn2year - $jdnumber - 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$jdn3year - $jdnumber - 1"/>
          </xsl:otherwise>
        </xsl:choose>
      </nyc>
	  
	  
      <!-- End Date References -->
      
      
      <!-- Start add festivals elements before others festivals -->
      
      <!-- Parana Start (if break ekadasi fast) -->
      <xsl:if test="parana/@from">
        
        <xsl:variable name="starthour" select="substring(parana/@from, 1, 2)" />
        
        <xsl:variable name="startminute" select="substring(parana/@from, 4, 2)" />
        
        <xsl:variable name="endthour" select="substring(parana/@to, 1, 2)" />
        
        <xsl:variable name="endtminute" select="substring(parana/@to, 4, 2)" />
        
        <xsl:variable name="bfast">
          <xsl:choose>
            <xsl:when test="parana/@to">
              <xsl:value-of select="'Break fast #start_hour#:#start_minute# - #end_hour#:#end_minute#'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'Break fast after #start_hour#:#start_minute#'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="bfastref">
          <xsl:choose>
            <xsl:when test="parana/@to">
              <xsl:value-of select="'BreakFast'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'BreakFastAfter'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="tbfast">
          <xsl:call-template name="stringtranslation">
            <xsl:with-param name="strorig" select="$bfast"/>
            <xsl:with-param name="strref" select="$bfastref"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="tbreakfast">
          <xsl:call-template name="stringreplace">
            <xsl:with-param name="strtext">
              
              <xsl:call-template name="stringreplace">
                <xsl:with-param name="strtext">
                  
                  <xsl:call-template name="stringreplace">
                    <xsl:with-param name="strtext">
                      
                      <xsl:call-template name="stringreplace">
                        <xsl:with-param name="strtext" select="$tbfast"/>
                        <xsl:with-param name="strmatch" select="'#start_hour#'"/>
                        <xsl:with-param name="strreplace" select="$starthour"/>
                      </xsl:call-template>
                  
                    </xsl:with-param>
                    <xsl:with-param name="strmatch" select="'#start_minute#'"/>
                    <xsl:with-param name="strreplace" select="$startminute"/>
                  </xsl:call-template>
                  
                </xsl:with-param>
                <xsl:with-param name="strmatch" select="'#end_hour#'"/>
                <xsl:with-param name="strreplace" select="$endthour"/>
              </xsl:call-template>
              
            </xsl:with-param>
            <xsl:with-param name="strmatch" select="'#end_minute#'"/>
            <xsl:with-param name="strreplace" select="$endtminute"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">       
          <xsl:attribute name="name"><xsl:value-of select="$tbreakfast"/></xsl:attribute>
          <xsl:attribute name="class"><xsl:value-of select="-8"/></xsl:attribute>
        </xsl:element>
      </xsl:if>
      <!-- Parana End -->
      
      <!-- End add festivals elements before others festivals -->
      
      
      <!-- Start Festivals -->
      <xsl:for-each select ="festival">
        <xsl:choose>
          
          
          <!-- Exclude Fast Today -->
          <xsl:when test="@name = '(Fast today)'">
          </xsl:when>
          
          
          <!-- Start Ekadasi -->
          <xsl:when test="contains(@name, 'Ekadasi') and not(contains(@name, 'Total fast'))">
            <!-- i.e.: 'Fasting for XYZ Ekadasi' -->
            
            <!-- Start time of fasting -->
            <xsl:variable name="starthour" select="substring(../sunrise/@time, 1, 2)" />
            
            <xsl:variable name="startminute" select="substring(../sunrise/@time, 4, 2)" />
            
            <xsl:variable name="tfasttill">
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="'(from #start_hour#:#start_minute# till tomorrow after sunrise)'"/>
                <xsl:with-param name="strref" select="'FastEkadasi'"/>
              </xsl:call-template>
            </xsl:variable>
			
            <xsl:variable name="rfasttill">
              <xsl:call-template name="stringreplace">
			    
                <xsl:with-param name="strtext">
                  <xsl:call-template name="stringreplace">
                    <xsl:with-param name="strtext" select="$tfasttill"/>
                    <xsl:with-param name="strmatch" select="'#start_hour#'"/>
                    <xsl:with-param name="strreplace" select="$starthour"/>
                  </xsl:call-template>
                </xsl:with-param>
				
                <xsl:with-param name="strmatch" select="'#start_minute#'"/>
                <xsl:with-param name="strreplace" select="$startminute"/>
              </xsl:call-template>
            </xsl:variable>		
			<!-- End time of fasting -->
			
            <xsl:variable name="ekdref">
              <xsl:value-of select="substring-after(substring-before(@name, ' Ekadasi'), 'Fasting for ')" />
            </xsl:variable>
            
            <xsl:variable name="ekdtrans">
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="$ekdref"/>
                <xsl:with-param name="strref" select="$ekdref"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name"><xsl:value-of select="$ekdtrans"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name"><xsl:value-of select="$rfasttill"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-3"/></xsl:attribute>
              <xsl:attribute name="fasttype"><xsl:value-of select="6"/></xsl:attribute>
              <xsl:attribute name="fastmark"><xsl:value-of select="'*'"/></xsl:attribute>
            </xsl:element>
          <!-- End Ekadasi -->
          
          </xsl:when>
          
		  
          <!-- Start Gaura Purnima -->
          <xsl:when test="@name = 'Gaura Purnima: Appearance of Sri Caitanya Mahaprabhu'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'CaitanyaApp'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'CaitanyaApp'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">                     
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="'(Fast till moonrise)'"/>
                  <xsl:with-param name="strref" select="'FastTMoonrise'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-3"/></xsl:attribute>
              <xsl:attribute name="fasttype"><xsl:value-of select="4"/></xsl:attribute>
              <xsl:attribute name="fastmark"><xsl:value-of select="'|'"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          <!-- End Gaura Purnima -->
          
          
          <!-- Start Rama Navami -->
          <xsl:when test="@name = 'Rama Navami: Appearance of Lord Sri Ramacandra'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'RamacandraApp'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'RamacandraApp'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">                     
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="'(Fast till sunset)'"/>
                  <xsl:with-param name="strref" select="'FastTSunset'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-3"/></xsl:attribute>
              <xsl:attribute name="fasttype"><xsl:value-of select="3"/></xsl:attribute>
              <xsl:attribute name="fastmark"><xsl:value-of select="'|'"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          <!-- End Rama Navami -->
          
          
          <!-- Start Krsna Janmastami -->
          <xsl:when test="@name = 'Sri Krsna Janmastami: Appearance of Lord Sri Krsna'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'KrsnaApp'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'KrsnaApp'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="'(Fast till midnight)'"/>
                  <xsl:with-param name="strref" select="'FastTMidnight'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-3"/></xsl:attribute>
              <xsl:attribute name="fasttype"><xsl:value-of select="5"/></xsl:attribute>
              <xsl:attribute name="fastmark"><xsl:value-of select="'|'"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          <!-- End Krsna Janmastami -->
          
          
          <!-- Start Prabhupada App -->
          <xsl:when test="@name = 'Srila Prabhupada -- Appearance'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'PrabhupadaApp'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'PrabhupadaApp'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="'(Fast till noon)'"/>
                  <xsl:with-param name="strref" select="'FastTNoon'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-3"/></xsl:attribute>
              <xsl:attribute name="fasttype"><xsl:value-of select="1"/></xsl:attribute>
              <xsl:attribute name="fastmark"><xsl:value-of select="'|'"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          <!-- End Prabhupada App -->
		  
		  
          <!-- Start Bhisma Pancaka -->
          <xsl:when test="@name = 'First day of Bhisma Pancaka'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'BhismaFirst'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'BhismaFirst'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-4"/></xsl:attribute>
            </xsl:element>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="'(Fast all period)'"/>
                  <xsl:with-param name="strref" select="'FastAllPeriod'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-4"/></xsl:attribute>
              <xsl:attribute name="fasttype"><xsl:value-of select="9"/></xsl:attribute>
              <xsl:attribute name="fastmark"><xsl:value-of select="'#'"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@name = 'Last day of Bhisma Pancaka'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'BhismaLast'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'BhismaLast'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="-4"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          <!-- End Bhisma Pancaka -->
          
          
          <!-- Start days without fast -->
          
          <xsl:when test="@name = 'Festival of Jagannatha Misra'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'JagannathaMisra'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'JagannathaMisra'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@name = 'Tulasi Jala Dan begins.'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'TulasiBeg'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'TulasiBeg'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@name = 'Tulasi Jala Dan ends.'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'TulasiEnd'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'TulasiEnd'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@name = '(Total fast, even from water, if you have broken Ekadasi)'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'TotalFast'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'TotalFast'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@name = 'Hera Pancami (4 days after Ratha Yatra)'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'Hera'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'Hera'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          
          <xsl:when test="@name = 'Return Ratha (8 days after Ratha Yatra)'">
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name">
                <xsl:call-template name="stringtranslation">
                  <xsl:with-param name="strorig" select="@name"/>
                  <xsl:with-param name="strref" select="'RathaReturn'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="ref"><xsl:value-of select="'RathaReturn'"/></xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
          </xsl:when>
          
          <xsl:otherwise>
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
              <xsl:attribute name="ref">
                <xsl:value-of select="translate(@name,'., ','||')"/>
              </xsl:attribute>
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
            </xsl:element>
          </xsl:otherwise>
          
        </xsl:choose>
      </xsl:for-each>     
       
      <xsl:if test="fast">
      </xsl:if>
      <!-- End Festivals -->
      
    </xsl:copy>
  </xsl:template>     
  
  
  <!-- ###################################### -->
  
  
  <!-- Start of Date -->

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
    <xsl:param name="sdate"/>
    
    <xsl:variable name="year" select="substring($sdate,string-length(@date)-3,4)"/>
    <xsl:variable name="month" select="substring($sdate,string-length(@date)-7,3)"/>
    <xsl:variable name="day" select="format-number(substring-before($sdate, ' '),'00')"/>
    
    <xsl:variable name="monthnum">
      <xsl:call-template name="monthnum">
        <xsl:with-param name="month" select="$month"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:value-of select="concat($year, '-', $monthnum, '-', $day)"/>
    
  </xsl:template>

  <!-- End of Date -->
  
  
  <!-- Start of Gaurabda Date -->

  <xsl:template name="masacod">
    <xsl:param name="cmasa"/>
    <xsl:if test="$cmasa = 'Visnu'">01</xsl:if>
    <xsl:if test="$cmasa = 'Madhusudana'">02</xsl:if>
    <xsl:if test="$cmasa = 'Trivikrama'">03</xsl:if>
    <xsl:if test="$cmasa = 'Vamana'">04</xsl:if>
    <xsl:if test="$cmasa = 'Sridhara'">05</xsl:if>
    <xsl:if test="$cmasa = 'Hrsikesa'">06</xsl:if>
    <xsl:if test="$cmasa = 'Padmanabha'">07</xsl:if>
    <xsl:if test="$cmasa = 'Damodara'">08</xsl:if>
    <xsl:if test="$cmasa = 'Kesava'">09</xsl:if>
    <xsl:if test="$cmasa = 'Narayana'">10</xsl:if>
    <xsl:if test="$cmasa = 'Madhava'">11</xsl:if>
    <xsl:if test="$cmasa = 'Govinda'">12</xsl:if>
    <xsl:if test="$cmasa = 'Purusottama'">13</xsl:if>
  </xsl:template>
   
  <xsl:template name="paksacod">
    <xsl:param name="cpaksa"/>
    <xsl:if test="$cpaksa = 'K'">00</xsl:if>
    <xsl:if test="$cpaksa = 'G'">01</xsl:if>    
  </xsl:template>
  
  <xsl:template name="tithicod">
    <xsl:param name="ctithi"/>
    <xsl:if test="$ctithi = 'Pratipat'">01</xsl:if>
    <xsl:if test="$ctithi = 'Dvitiya'">02</xsl:if> 
    <xsl:if test="$ctithi = 'Tritiya'">03</xsl:if> 
    <xsl:if test="$ctithi = 'Caturthi'">04</xsl:if>    
    <xsl:if test="$ctithi = 'Pancami'">05</xsl:if> 
    <xsl:if test="$ctithi = 'Sasti'">06</xsl:if>   
    <xsl:if test="$ctithi = 'Saptami'">07</xsl:if> 
    <xsl:if test="$ctithi = 'Astami'">08</xsl:if>  
    <xsl:if test="$ctithi = 'Navami'">09</xsl:if>  
    <xsl:if test="$ctithi = 'Dasami'">10</xsl:if>  
    <xsl:if test="$ctithi = 'Ekadasi'">11</xsl:if> 
    <xsl:if test="$ctithi = 'Dvadasi'">12</xsl:if> 
    <xsl:if test="$ctithi = 'Trayodasi'">13</xsl:if>   
    <xsl:if test="$ctithi = 'Caturdasi'">14</xsl:if>   
    <xsl:if test="$ctithi = 'Purnima'">15</xsl:if> 
    <xsl:if test="$ctithi = 'Amavasya'">15</xsl:if>    
  </xsl:template>
  
  <xsl:template name="pgdate">
    <xsl:param name="masacod"/>
    <xsl:param name="paksacod"/>
    <xsl:param name="tithicod"/>
  
    <xsl:variable name="tithinum">
      <xsl:choose>
        <xsl:when test="number($tithicod) &gt; 1">
          <xsl:value-of select="format-number(number($tithicod) - 1, '00')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'15'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="paksanum">
      <xsl:choose>
        <xsl:when test="number($tithicod) &gt; 1">
          <xsl:value-of select="$paksacod" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$paksacod = '01'">
              <xsl:value-of select="'00'" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'01'" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="masanum">
      <xsl:choose>
        <xsl:when test="number($tithicod) &gt; 1">
          <xsl:value-of select="$masacod" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$paksacod = '01'">
              <xsl:value-of select="$masacod" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="number($masacod) &gt; 1">
                  <xsl:value-of select="format-number(number($masacod) - 1, '00')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'12'" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:value-of select="concat(9, $masanum, $paksanum, $tithinum)"/>
  </xsl:template>
  
  <xsl:template name="gdate">
    <xsl:param name="gmasa"/>
    <xsl:param name="gpaksa"/>
    <xsl:param name="gtithi"/>
    <xsl:param name="previous"/>
    
    <xsl:variable name="masacod">
      <xsl:call-template name="masacod">
        <xsl:with-param name="cmasa" select="$gmasa"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="paksacod">
      <xsl:call-template name="paksacod">
        <xsl:with-param name="cpaksa" select="$gpaksa"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="tithicod">
      <xsl:call-template name="tithicod">
        <xsl:with-param name="ctithi" select="$gtithi"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$previous = 'yes'">
        <xsl:variable name="pgdatenum">
          <xsl:call-template name="pgdate">
            <xsl:with-param name="masacod" select="$masacod"/>
            <xsl:with-param name="paksacod" select="$paksacod"/>
            <xsl:with-param name="tithicod" select="$tithicod"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$pgdatenum"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(9, $masacod, $paksacod, $tithicod)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- End of Gaurabda Date -->
  
  
  <!-- Julian Day -->
  <!--
    Add Julian Day Number (JDN) 
    The Julian Day Number (JDN) is the integer assigned to a whole solar day in the Julian day count starting from noon Universal time, with Julian day number 0 assigned to the day starting at noon on Monday, January 1, 4713 BC, proleptic Julian calendar (November 24, 4714 BC, in the proleptic Gregorian calendar), a date at which three multi-year cycles started (which are: Indiction, Solar, and Lunar cycles) and which preceded any dates in recorded history. For example, the Julian day number for the day starting at 12:00 UT on January 1, 2000, was 2 451 545.
    The Julian date (JD) of any instant is the Julian day number plus the fraction of a day since the preceding noon in Universal Time. Julian dates are expressed as a Julian day number with a decimal fraction added. For example, the Julian Date for 00:30:00.0 UT January 1, 2013, is 2 456 293.520 833.
    Ref: https://en.wikipedia.org/wiki/Julian_day
    
    XSLT Cookbook: Solutions and Examples for 
    XML and XSLT Developers
    Page 121 
  -->  
  <xsl:template name="JDN">
    <xsl:param name="jdate"/>
    
    <xsl:variable name="mmonth">
      <xsl:call-template name="monthnum">
        <xsl:with-param name="month" select="substring($jdate, string-length($jdate) - 7, 3)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="yyear" select="substring($jdate, string-length($jdate) - 3, 4)" />  
    <xsl:variable name="dday" select="substring-before($jdate, ' ')" /> 
    
    <xsl:variable name="aa" select="floor( (14 - $mmonth) div 12)" />   
    <xsl:variable name="yy" select="$yyear + 4800 - $aa" /> 
    <xsl:variable name="mm" select="$mmonth + 12 * $aa - 3" />
    
    <xsl:value-of select="$dday + floor( (153 * $mm + 2) div 5) + 365 * $yy + floor($yy div 4) - floor($yy div 100) + floor ($yy div 400) - 32045" />
  </xsl:template>
  
  
  <!-- Week Number -->
  <!-- 
    XSLT Cookbook: Solutions and Examples for 
    XML and XSLT Developers
    Page 125 
  -->
  <xsl:template name="weeknum">
    <xsl:param name="wdate"/>

    <xsl:variable name="J">
      <xsl:call-template name="JDN">
        <xsl:with-param name="jdate" select="$wdate"/>
      </xsl:call-template>       
    </xsl:variable>
    
    <xsl:variable name="d4" select="($J + 31741 - ($J mod 7)) mod 146097 mod 36524 mod 1461"/>
    <xsl:variable name="L" select="floor($d4 div 1460)"/>
    <xsl:variable name="d1" select="(($d4 - $L) mod 365) + $L"/>

    <xsl:value-of select="format-number(floor($d1 div 7) + 1,'00')"/>
  </xsl:template>
  
  
  <!-- Start Translation -->
    
  <xsl:template name="stringtranslation">
    <xsl:param name="strorig"/>
    <xsl:param name="strref"/>
    <xsl:param name="strtype"/>
    
    <xsl:choose>
      <xsl:when test="$strref != '' ">
        <xsl:value-of select="document($with)/xml/string[@ref = $strref]/@desc"/>
      </xsl:when>
      <xsl:when test="$strtype != '' ">
        <xsl:value-of select="document($with)/xml/string[@type = $strtype]/@desc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$strorig"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- End Translation -->
  
  
  <!-- Start Replace -->
  <xsl:template name="stringreplace">
    <xsl:param name="strtext"/>
    <xsl:param name="strmatch"/>
    <xsl:param name="strreplace"/>
    
    <xsl:choose>
      <xsl:when test="$strtext = '' or $strmatch = '' ">
        <xsl:value-of select="$strtext"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(substring-before($strtext, $strmatch), $strreplace, substring-after($strtext, $strmatch))" />         
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- End Replace -->
  
  
</xsl:transform>