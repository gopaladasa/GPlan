<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  
  <!--
    Input1 : res-gcal-merge.xml (Vaisnava Calendar partially calculated by GCal merged with calendar of personalities and events by gaurabda dates)
    
    Input 2: str-translation.xml (translations of Vaisnava Calendar texts)
    
    
    Output: res-gcal-complements.xml
    
    
    Tranformations:
    
    * For each ekadasi day, if fast for personality, then change each 'Fast till noon' attribute name of each element festival of the day, to "Fast till noon, feast tomorrow". (for confirm current ekasasi day, check if sunrise/tithi/@name contents 'suitable for fasting')
    
    * For each ekadasi day, if on next day have festival with fast, for each fast of next day add, on ekadasi day, "Fast till noon for 'fastsubject', feast tomorrow". (use julian day (JND) element for identification of day following ekadasi)
    
    * For each day following ekadasi day, if festival with fast, change 'Fast till noon' for 'Fasting was done yesterday, today is feast'. (use parana/@from attribute for check if current day is following ekadasi)
    
    * Caturmasya (fasting vrata) text
    
    * Sankranti (vedic sign of the zodiac) text
    
    * Vriddhi tithi(extensive tithi) indication on second day of tithi
    
    * Ksaya tithi (suppressed tithi) indication
	
	* First day of masa indication
	
	* Last day of masa indication
	
	* At first day of Purusottama-adhika Masa indication of 'Caturmasya is not observed during Purusottama Adhika Masa)'
    
	* At first day of next masa after Purusottama-adhika Masa indication of 'Nth Month of Caturmasya continues'
	
	* Beginning of Seasons (Ritu)
	
    * Translations of texts
  -->  
  
  
  <!-- Input 2: (translations of Vaisnava Calendar texts) -->
  <xsl:variable name="with" select="'str-translation.xml'" />
  
  <xsl:variable name="days" select="//xml/result/masa/day/." />
  
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="festival" />
  
  
  <xsl:template match="day">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      
	  <!-- Start Festivals -->
      <xsl:variable name="ekadasiref">
        <xsl:choose>
          <xsl:when test="contains(sunrise/tithi/@name, '(suitable for fasting)')">
            <xsl:value-of select="'yes'" />
          </xsl:when>
          <xsl:when test="parana/@from">
            <xsl:value-of select="'parana'" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'no'" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="njnd" select="jnd + 1" />
      
      <xsl:variable name="nday">
        <xsl:choose>
          <xsl:when test="ekadasiref = 'yes'">
            <xsl:value-of select="//xml/result/masa/day[jnd = $njnd]/." />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:for-each select="festival">
        <xsl:choose>
          <xsl:when test="$ekadasiref = 'yes'">
            <!-- If ekadasi day, then... -->
            <xsl:choose>
              <xsl:when test="@fastsubject">
                <!-- 
                  If fast on ekadasy day, change 
                  'Fast till noon' name of festival element to 
                  "Fast till noon for 'fastsubject', with feast tomorrow"
                -->
                <xsl:variable name="FeastTomorrow">
                  <xsl:call-template name="stringtranslation">
                    <xsl:with-param name="strorig" select="'(Fasting till noon for #name#, with feast tomorrow)'"/>
                    <xsl:with-param name="strref" select="'FeastTomorrow'"/>
                  </xsl:call-template>
                </xsl:variable>
                                
                <xsl:text>&#xA;&#x9;</xsl:text>
                <xsl:element name="festival">       
                  <xsl:attribute name="name">
                    <xsl:value-of select="$FeastTomorrow"/>
                  </xsl:attribute>
                  <xsl:if test="@ref">
                    <xsl:attribute name="ref"><xsl:value-of select="@ref"/></xsl:attribute>
                  </xsl:if> 
                  <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
                  <xsl:attribute name="fasttill"><xsl:value-of select="@fasttill"/></xsl:attribute>
                  <xsl:attribute name="fasttype"><xsl:value-of select="@fasttype"/></xsl:attribute>
                  <xsl:attribute name="fastmark"><xsl:value-of select="@fastmark"/></xsl:attribute>
                </xsl:element>
              </xsl:when>
              
              <xsl:otherwise>
                <!-- 
                  If not @fastsubject, preserve festival 
                  element and attributes as it is
                -->
                <xsl:text>&#xA;&#x9;</xsl:text>
                  <xsl:element name="festival">       
                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                    <xsl:if test="@ref">
                      <xsl:attribute name="ref"><xsl:value-of select="@ref"/></xsl:attribute>
                    </xsl:if> 
                    <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
                    <xsl:if test="@fasttill">
                      <xsl:attribute name="fasttill"><xsl:value-of select="@fasttill"/></xsl:attribute>
                    </xsl:if> 
                    <xsl:if test="@fasttype">
                      <xsl:attribute name="fasttype"><xsl:value-of select="@fasttype"/></xsl:attribute>
                    </xsl:if> 
                    <xsl:if test="@fastmark">
                      <xsl:attribute name="fastmark"><xsl:value-of select="@fastmark"/></xsl:attribute>
                    </xsl:if>
                  </xsl:element>
              </xsl:otherwise>
            </xsl:choose>           
          </xsl:when>
          
          <xsl:when test="$ekadasiref = 'parana'">
            <!-- 
              If today have parana (fast break hour) 
              in day elements, then yesterday was ekadasi 
            -->
            <xsl:choose>              
              <xsl:when test="@fastsubject">
                <!-- 
                  If fast for any personality then change 
                  'Fast today' for 
                  'Fasting was done yesterday, today is feast' 
                -->
                <xsl:text>&#xA;&#x9;</xsl:text>
                <xsl:element name="festival">       
                  <xsl:attribute name="name">
                    <xsl:call-template name="stringtranslation">
                      <xsl:with-param name="strorig" select="'(Fasting was done yesterday, today is feast)'"/>
                      <xsl:with-param name="strref" select="'FeastToday'"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:if test="@ref">
                    <xsl:attribute name="ref"><xsl:value-of select="'FeastToday'"/></xsl:attribute>
                  </xsl:if> 
                  <xsl:attribute name="class"><xsl:value-of select="'-2'"/></xsl:attribute>
                  <xsl:attribute name="fastsubject"><xsl:value-of select="@fastsubject"/></xsl:attribute>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <!-- 
                  If not @fastsubject, preserve festival 
                  element and attributes as it is
                -->
                <xsl:text>&#xA;&#x9;</xsl:text>
                <xsl:element name="festival">       
                  <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                  <xsl:if test="@ref">
                    <xsl:attribute name="ref"><xsl:value-of select="@ref"/></xsl:attribute>
                  </xsl:if> 
                  <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
                  <xsl:if test="@fasttill">
                    <xsl:attribute name="fasttill"><xsl:value-of select="@fasttill"/></xsl:attribute>
                  </xsl:if> 
                  <xsl:if test="@fasttype">
                    <xsl:attribute name="fasttype"><xsl:value-of select="@fasttype"/></xsl:attribute>
                  </xsl:if> 
                  <xsl:if test="@fastmark">
                    <xsl:attribute name="fastmark"><xsl:value-of select="@fastmark"/></xsl:attribute>
                  </xsl:if>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- 
              If not ekadasi day, nor is parana day, then 
              preserve festival element and attributes as it is
            -->
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
              <xsl:if test="@ref">
                <xsl:attribute name="ref"><xsl:value-of select="@ref"/></xsl:attribute>
              </xsl:if> 
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
              <xsl:if test="@fasttill">
                <xsl:attribute name="fasttill">
                  <xsl:call-template name="stringtranslation">
                    <xsl:with-param name="strorig" select="@fasttill"/>
                    <xsl:with-param name="strtype" select="@fasttype"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:if> 
              <xsl:if test="@fasttype">
                <xsl:attribute name="fasttype"><xsl:value-of select="@fasttype"/></xsl:attribute>
              </xsl:if> 
              <xsl:if test="@fastmark">
                <xsl:attribute name="fastmark"><xsl:value-of select="@fastmark"/></xsl:attribute>
              </xsl:if> 
            </xsl:element>           
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <!-- End Festivals -->
	  
	  
      <!--
        If current day is ekadasi, if on next day have festival with fast, for each fast of next day, add, on ekadasi day, "Fast till noon for 'fastsubject', with feast tomorrow".
      -->
      <xsl:if test="$ekadasiref = 'yes'">
        <xsl:variable name="nnjnd" select="jnd + 1" />
        <xsl:variable name="nnday" select="//xml/result/masa/day[jnd = $nnjnd]/." />
        
        <xsl:for-each select="$nnday/festival">
          <xsl:if test="@fastsubject">
          
            <xsl:variable name="FeastForTomorrow">
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="'(Fasting till noon for #name#, with feast tomorrow)'"/>
                <xsl:with-param name="strref" select="'FeastForTomorrow'"/>
              </xsl:call-template>
            </xsl:variable>
          
            <xsl:variable name="TranslFeastForTomorrow">
              <xsl:call-template name="stringreplace">
                <xsl:with-param name="strtext" select="$FeastForTomorrow"/>
                <xsl:with-param name="strmatch" select="'#name#'"/>
                <xsl:with-param name="strreplace" select="@fastsubject"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:text>&#xA;&#x9;</xsl:text>
            <xsl:element name="festival">       
              <xsl:attribute name="name"><xsl:value-of select="$TranslFeastForTomorrow"/></xsl:attribute>
              <xsl:if test="@ref">
                <xsl:attribute name="ref"><xsl:value-of select="@ref"/></xsl:attribute>
              </xsl:if> 
              <xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
              <xsl:attribute name="fasttype"><xsl:value-of select="@fasttype"/></xsl:attribute>
              <xsl:attribute name="fastmark"><xsl:value-of select="@fastmark"/></xsl:attribute>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>                   
      </xsl:if>
      
	  
      <!-- Start of First day of masa -->
      <xsl:if test="count(preceding-sibling::*) + 1 = 1">
        
        <xsl:variable name="masa1" select="substring-before(../@name, ' ')"/>
        
        <xsl:variable name="masa1compl">
          <xsl:choose>
            <xsl:when test="contains(../@name, '(Second half)')">
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="'#masa# masa (Second half)'"/>
                <xsl:with-param name="strref" select="'SecondHalf'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="fdmasa">
          <xsl:call-template name="stringtranslation">
            <xsl:with-param name="strorig" select="'First day of #masa# masa'"/>
            <xsl:with-param name="strref" select="'FirstMasaDay'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="tmasa1">
          <xsl:call-template name="stringtranslation">
            <xsl:with-param name="strorig" select="$masa1"/>
            <xsl:with-param name="strref" select="$masa1"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="tfdmasa">
          <xsl:choose>
            <xsl:when test="$masa1compl != '' ">
              <xsl:call-template name="stringreplace">
                <xsl:with-param name="strtext" select="$masa1compl"/>
                <xsl:with-param name="strmatch" select="'#masa#'"/>
                <xsl:with-param name="strreplace" select="$tmasa1"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="stringreplace">
                <xsl:with-param name="strtext" select="$fdmasa"/>
                <xsl:with-param name="strmatch" select="'#masa#'"/>
                <xsl:with-param name="strreplace" select="$tmasa1"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">        
          <xsl:attribute name="name"><xsl:value-of select="$tfdmasa"/></xsl:attribute>
        </xsl:element>
        
      </xsl:if>
      <!-- End of First day of masa -->   
      
      <!-- Star of first day of Purusottama-adhika Masa -->
      <xsl:if test="count(preceding-sibling::*) + 1 = 1 and ../@name = 'Purusottama-adhika Masa'">
      
        <xsl:variable name="jdnCtmStart">
          <xsl:value-of select="$days[../@gyear = current()/../@gyear and caturmasya/@day = 'first' and caturmasya/@month = '1' and caturmasya/@system = 'EKADASI']/jnd" />
        </xsl:variable>
        
        <xsl:variable name="jdnCtmEnd">
          <xsl:value-of select="$days[../@gyear = current()/../@gyear and caturmasya/@day = 'last' and caturmasya/@month = '4' and caturmasya/@system = 'PRATIPAT']/jnd" />
        </xsl:variable>
      
        <xsl:if test="jnd &gt; $jdnCtmStart and jnd &lt; $jdnCtmEnd ">
          <xsl:text>&#xA;&#x9;&#x9;</xsl:text>
          <xsl:element name="festival">        
            <xsl:attribute name="name">
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="'(Caturmasya is not observed during Purusottama Adhika Masa)'"/>
                <xsl:with-param name="strref" select="'NotCaturmasya'"/>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>

      </xsl:if>
      <!-- End of first day of Purusottama-adhika Masa -->    
      
      <!-- Star of first day of next masa after Purusottama-adhika Masa -->
      <xsl:if test="count(preceding-sibling::*) + 1 = 1 and ../preceding-sibling::*[1]/@name = 'Purusottama-adhika Masa'">
        
        <xsl:variable name="maxCtmMonth">
          <xsl:for-each select="$days[../@gyear = current()/../@gyear and jnd &lt; current()/jnd and caturmasya/@day = 'first' and caturmasya/@system = 'PRATIPAT']/caturmasya/@month">
            <xsl:sort select="." data-type="number" order="descending"/>
            <xsl:if test="position() = 1">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
                
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">        
          <xsl:attribute name="name">
            <xsl:call-template name="stringtranslation">
              <xsl:with-param name="strorig" select="'Month of Caturmasya continues'"/>
              <xsl:with-param name="strref" select="concat($maxCtmMonth, 'cont_')"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:element>
      
      </xsl:if>
      <!-- End of first day of next masa after Purusottama-adhika Masa -->
      
	  
      <!-- If caturmasya then add caturmasya text festival -->
      <xsl:for-each select ="caturmasya">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">
          <xsl:attribute name="name">
		    
            <!-- i.e.: '1first' -> 'First month of Caturmasya begins' -->
            <xsl:call-template name="stringtranslation">
              <xsl:with-param name="strorig" select="''"/>
              <xsl:with-param name="strref" select="concat(@month, substring(concat(@day, '_'), 1, 5))"/>
            </xsl:call-template>
			
            <xsl:if test="@day = 'first'">			
              <xsl:text> </xsl:text>
              <!-- i.e.: '1fast_' -> '(green leafy vegetable fast for one month)' -->
              <xsl:call-template name="stringtranslation">
                <xsl:with-param name="strorig" select="''"/>
                <xsl:with-param name="strref" select="concat(@month, 'fast_')"/>
              </xsl:call-template>
            </xsl:if>
			
            <xsl:text> </xsl:text>
            <!-- i.e.: 'EKADASI_' -> '[EKADASI SYSTEM]' -->
            <xsl:call-template name="stringtranslation">
              <xsl:with-param name="strorig" select="''"/>
              <xsl:with-param name="strref" select="substring(concat(@system, '_'), 1, 8)"/>
            </xsl:call-template>
			
          </xsl:attribute>
          <xsl:attribute name="class"><xsl:value-of select="-5"/></xsl:attribute>
        </xsl:element>
      </xsl:for-each>
      
      
      <!-- If sankranti then add sankranti text festival -->
      <xsl:if test="sankranti">
	    
        <!-- Sankranti rasi -->
        <xsl:variable name="skrasi" select="sankranti/@rasi"/>
	
        <!-- Sankranti time -->
        <xsl:variable name="sktime" select="sankranti/@time"/>
        
        <!-- Sankranti day -->
		<xsl:variable name="sktoday" select="tddate" />
		
        <!-- Sankranti previous day - Get yesterday date -->
		<xsl:variable name="pjnd" select="jnd - 1" />
        <xsl:variable name="skyesterday" select="//xml/result/masa/day[jnd = $pjnd]/tddate"/>
        
        <xsl:variable name="sktext">
          <xsl:call-template name="SankrantiRs">
            <xsl:with-param name="sankrantirasi" select="$skrasi"/>
            <xsl:with-param name="sankrantitime" select="$sktime"/>
            <xsl:with-param name="sankrantitoday" select="$sktoday"/>
            <xsl:with-param name="sankrantiyesterday" select="$skyesterday"/>
          </xsl:call-template>
		</xsl:variable>
        
		<xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">
          <xsl:attribute name="name"><xsl:value-of select="$sktext"/></xsl:attribute>
        </xsl:element>
        
      </xsl:if>
      
      
      <!-- Start of Season -->      
	  <xsl:if test="count(preceding-sibling::*) + 1 = 1">
	    
        <xsl:variable name="masa2" select="substring-before(../@name, ' ')"/>
        
        <xsl:variable name="tseason">
          <xsl:call-template name="mseason">
            <xsl:with-param name="rt" select="$masa2"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$tseason != '' ">
          <xsl:text>&#xA;&#x9;</xsl:text>
          <xsl:element name="festival">        
            <xsl:attribute name="name">
		      <xsl:call-template name="stringtranslation">
			    <xsl:with-param name="strorig" select="''"/>
			    <xsl:with-param name="strref" select="$tseason"/>
		      </xsl:call-template>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
		
      </xsl:if>
	  
      <!-- End If Season -->
      
      
      <!-- If Vriddhi tithi (duplicate - second day of Tithi) -->
      <xsl:if test="vriddhi/@sd = 'yes' ">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">        
          <xsl:attribute name="name">
            <xsl:call-template name="stringtranslation">
              <xsl:with-param name="strorig" select="'[extensive tithi (vriddhi) - second day of tithi]'"/>
              <xsl:with-param name="strref" select="'Vriddhi'"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
      
      
      <!-- Start of Last day of masa -->        
      <xsl:if test="position() = last() - 1">
      
        <xsl:variable name="masa2" select="substring-before(../@name, ' ')"/>
        
        <xsl:variable name="tmasa2">
          <xsl:call-template name="stringtranslation">
            <xsl:with-param name="strorig" select="$masa2"/>
            <xsl:with-param name="strref" select="$masa2"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="ldmasa">
          <xsl:call-template name="stringtranslation">
            <xsl:with-param name="strorig" select="'Last day of #masa# masa'"/>
            <xsl:with-param name="strref" select="'LastMasaDay'"/>
          </xsl:call-template>
        </xsl:variable>
                
        <xsl:variable name="tldmasa">
          <xsl:call-template name="stringreplace">
            <xsl:with-param name="strtext" select="$ldmasa"/>
            <xsl:with-param name="strmatch" select="'#masa#'"/>
            <xsl:with-param name="strreplace" select="$tmasa2"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">        
          <xsl:attribute name="name"><xsl:value-of select="$tldmasa"/></xsl:attribute>
        </xsl:element>
      </xsl:if>
      <!-- End of Last day of masa -->      
	  
	  
      <!-- If Ksaya tithi (very short, suppressed tithi) -->
      <xsl:if test="ksaya">
        <xsl:variable name="rksaya">
	      <xsl:call-template name="ksayatithi">
		    <xsl:with-param name="starthour" select="substring(ksaya/@from, 1, 2)"/>
		    <xsl:with-param name="startminute" select="substring(ksaya/@from, 4, 2)"/>
		    <xsl:with-param name="endhour" select="substring(ksaya/@to, 1, 2)"/>
		    <xsl:with-param name="endminute" select="substring(ksaya/@to, 4, 2)"/>
		    <xsl:with-param name="tithiindex" select="number(sunrise/tithi/@index)"/>
	      </xsl:call-template>
        </xsl:variable>
	  
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:element name="festival">       
          <xsl:attribute name="name"><xsl:value-of select="$rksaya"/></xsl:attribute>
        </xsl:element>
      </xsl:if>
      <!-- End Ksaya tithi (very short, suppressed tithi) -->     
      
    </xsl:copy>
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
  
  
  <!-- Start Multireplace -->
    <xsl:template name="multireplace">
      <xsl:param name="text"/>
      <xsl:param name="ref"/>
      <xsl:param name="match1"/>
      <xsl:param name="replace1"/>
      <xsl:param name="match2"/>
      <xsl:param name="replace2"/>
      <xsl:param name="match3"/>
      <xsl:param name="replace3"/>
      <xsl:param name="match4"/>
      <xsl:param name="replace4"/>
      <xsl:param name="match5"/>
      <xsl:param name="replace5"/>
      
      <xsl:variable name="translation">
        <xsl:call-template name="stringtranslation">
          <xsl:with-param name="strorig" select="$text"/>
          <xsl:with-param name="strref" select="$ref"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:call-template name="stringreplace">
        <xsl:with-param name="strtext">
          
          <xsl:call-template name="stringreplace">
            <xsl:with-param name="strtext">
              
              <xsl:call-template name="stringreplace">
                <xsl:with-param name="strtext">
                  
                  <xsl:call-template name="stringreplace">
                    <xsl:with-param name="strtext">
                      
                      <xsl:call-template name="stringreplace">
                        <xsl:with-param name="strtext" select="$translation"/>
                        <xsl:with-param name="strmatch" select="$match1"/>
                        <xsl:with-param name="strreplace" select="$replace1"/>
                      </xsl:call-template>
                      
                    </xsl:with-param>
                    <xsl:with-param name="strmatch" select="$match2"/>
                    <xsl:with-param name="strreplace" select="$replace2"/>
                  </xsl:call-template>
                  
                </xsl:with-param>
                <xsl:with-param name="strmatch" select="$match3"/>
                <xsl:with-param name="strreplace" select="$replace3"/>
              </xsl:call-template>
              
            </xsl:with-param>
            <xsl:with-param name="strmatch" select="$match4"/>
            <xsl:with-param name="strreplace" select="$replace4"/>
          </xsl:call-template>
          
        </xsl:with-param>
        <xsl:with-param name="strmatch" select="$match5"/>
        <xsl:with-param name="strreplace" select="$replace5"/>
      </xsl:call-template>
	</xsl:template>
  <!-- End Multireplace -->
  
  
  <!-- Start Tithi seguence -->
  <xsl:template name="strtithi">
    <xsl:param name="tt"/>
    <xsl:if test="$tt = 1 or $tt = 16">pratipat</xsl:if>
    <xsl:if test="$tt = 2 or $tt = 17">dvitiya</xsl:if>
    <xsl:if test="$tt = 3 or $tt = 18">tritiya</xsl:if>
    <xsl:if test="$tt = 4 or $tt = 19">caturthi</xsl:if>
    <xsl:if test="$tt = 5 or $tt = 20">pancami</xsl:if>
    <xsl:if test="$tt = 6 or $tt = 21">sasti</xsl:if>
    <xsl:if test="$tt = 7 or $tt = 22">saptami</xsl:if>
    <xsl:if test="$tt = 8 or $tt = 23">astami</xsl:if>
    <xsl:if test="$tt = 9 or $tt = 24">navami</xsl:if>
    <xsl:if test="$tt = 10 or $tt = 25">dasami</xsl:if>
    <xsl:if test="$tt = 11 or $tt = 26">ekadasi</xsl:if>
    <xsl:if test="$tt = 12 or $tt = 27">dvadasi</xsl:if>
    <xsl:if test="$tt = 13 or $tt = 28">trayodasi</xsl:if>
    <xsl:if test="$tt = 14 or $tt = 29">caturdasi</xsl:if>
    <xsl:if test="$tt = 15">amavasya</xsl:if>
    <xsl:if test="$tt = 30">purnima</xsl:if>
  </xsl:template>
  <!-- End Tithi seguence -->
  
  
  <!-- Start Indian Season -->
  <xsl:template name="mseason">
    <xsl:param name="rt"/>
    <xsl:if test="$rt = 'Visnu' ">Vasanta</xsl:if>
    <xsl:if test="$rt = 'Trivikrama' ">Grishma</xsl:if>
    <xsl:if test="$rt = 'Sridhara' ">Varsha</xsl:if>
    <xsl:if test="$rt = 'Padmanabha' ">Sharad</xsl:if>
    <xsl:if test="$rt = 'Kesava' ">Hemanta</xsl:if>
    <xsl:if test="$rt = 'Madhava' ">Shishira</xsl:if>
  </xsl:template>
  <!-- End Indian Season -->
  
  
  <!-- Star Sankranti Rasi -->
  <xsl:template name="SankrantiRs">
    <xsl:param name="sankrantirasi"/>
    <xsl:param name="sankrantitime"/>
    <xsl:param name="sankrantitoday"/>
    <xsl:param name="sankrantiyesterday"/>
    
    <!-- Sankranti hour -->
    <xsl:variable name="skthour" select="substring($sankrantitime, 1, 2)"/>
    
    <!-- Sankranti minute -->
    <xsl:variable name="sktminute" select="substring($sankrantitime, 4, 2)"/>
    
    <!-- Sankranti day -->
    <xsl:variable name="sankrantiday">
      <xsl:choose>
        <!-- If hour in sankranti/@time > 12h (noon), then day is yesterday -->
        <xsl:when test="number($skthour) &gt; 12">
          <!-- Get yesterday date -->
          <xsl:value-of select="$sankrantiyesterday"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Get current date -->
          <xsl:value-of select="$sankrantitoday" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	
    <xsl:variable name="sktday" select="substring($sankrantiday, 9, 2)"/>
	
	<!-- Sankranti month -->
    <xsl:variable name="sktmonth">
      <xsl:call-template name="stringtranslation">
        <xsl:with-param name="strorig" select="''"/>
        <xsl:with-param name="strref" select="substring($sankrantiday, 6, 2)"/>
      </xsl:call-template>
    </xsl:variable>
	
    <xsl:call-template name="multireplace">
      <xsl:with-param name="text" select="''"/>
      <!-- Sankranti Rasi - i.e.: 'Mesa' => 'Mesa Sankranti (Sun enters Aries on #dd# #MM#, #hh#:#mm#)' -->
      <xsl:with-param name="ref" select="$sankrantirasi"/>
      
      <xsl:with-param name="match1" select="'#MM#'"/>
      <xsl:with-param name="replace1" select="$sktmonth"/>
      
      <xsl:with-param name="match2" select="'#dd#'"/>
      <xsl:with-param name="replace2" select="$sktday"/>
      
      <xsl:with-param name="match3" select="'#hh#'"/>
      <xsl:with-param name="replace3" select="$skthour"/>
      
      <xsl:with-param name="match4" select="'#mm#'"/>
      <xsl:with-param name="replace4" select="$sktminute"/>
    </xsl:call-template>
  </xsl:template>
  <!-- End Sankranti Rasi -->
  
  
  <!-- Start Ksaya Tithi -->
  <xsl:template name="ksayatithi">
    <xsl:param name="starthour"/>
    <xsl:param name="startminute"/>
    <xsl:param name="endhour"/>
    <xsl:param name="endminute"/>
    <xsl:param name="tithiindex"/>
    
    <xsl:variable name="ktithi">
      <xsl:choose>
        <xsl:when test="$tithiindex = 1">
          <xsl:value-of select="30"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$tithiindex - 1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="stithi">
      <xsl:call-template name="strtithi">
        <xsl:with-param name="tt" select="$ktithi"/>
      </xsl:call-template>
    </xsl:variable>
          
    <xsl:call-template name="multireplace">
      <xsl:with-param name="text" select="'[suppressed tithi (ksaya) - #tt# tithi from #start_hour#:#start_minute# yesterday to #end_hour#:#end_minute# today]'"/>
      <xsl:with-param name="ref" select="'Ksaya'"/>
      
      <xsl:with-param name="match1" select="'#tt#'"/>
      <xsl:with-param name="replace1" select="$stithi"/>
      
      <xsl:with-param name="match2" select="'#start_hour#'"/>
      <xsl:with-param name="replace2" select="$starthour"/>
      
      <xsl:with-param name="match3" select="'#start_minute#'"/>
      <xsl:with-param name="replace3" select="$startminute"/>
      
      <xsl:with-param name="match4" select="'#end_hour#'"/>
      <xsl:with-param name="replace4" select="$endhour"/>
      
      <xsl:with-param name="match5" select="'#end_minute#'"/>
      <xsl:with-param name="replace5" select="$endminute"/>
    </xsl:call-template>
  </xsl:template>
  <!-- End Ksaya Tithi -->
    
</xsl:transform>
