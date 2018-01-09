<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns:cv="http://github.com/joeytakeda/cv/ns"
    version="3.0">

    
    <xsl:function name="cv:formatSingleDate">
        <xsl:param name="string"/>
       <!-- <xsl:message>Formatting this date <xsl:value-of select="$string"/></xsl:message>-->
        <xsl:variable name="dateTokens" select="cv:getDateTokens($string)"/>
        <xsl:variable name="tCount" select="count($dateTokens)"/>
        
        <xsl:choose>
      
            <!--When we want to display the month AND we have a year and month-->
            <xsl:when test="$tCount gt 1">
                <xsl:variable name="month" select="$dateTokens[2]"/>
              
                <xsl:variable name="monthAbbr">
                    <!--Following Chicago style-->
                    <xsl:choose>
                        <xsl:when test="$month='01'">Jan</xsl:when>
                        <xsl:when test="$month='02'">Feb</xsl:when>
                        <xsl:when test="$month='03'">Mar</xsl:when>
                        <xsl:when test="$month='04'">Apr</xsl:when>
                        <xsl:when test="$month='05'">May</xsl:when>
                        <xsl:when test="$month='06'">June</xsl:when>
                        <xsl:when test="$month='07'">July</xsl:when>
                        <xsl:when test="$month='08'">Aug</xsl:when>
                        <xsl:when test="$month='09'">Sept</xsl:when>
                        <xsl:when test="$month='10'">Oct</xsl:when>
                        <xsl:when test="$month='11'">Nov</xsl:when>
                        <xsl:when test="$month='12'">Dec</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="out">
                    <xsl:value-of select="$monthAbbr"/><xsl:if test="$tCount=3"><xsl:text> </xsl:text><xsl:value-of select="$dateTokens[3]"/><xsl:text>,</xsl:text></xsl:if><xsl:text> </xsl:text><xsl:value-of select="$dateTokens[1]"/>
                </xsl:variable>
               <xsl:value-of select="$out"/>
            </xsl:when>
            <xsl:when test="$tCount=1">
                <xsl:value-of select="$dateTokens[1]"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="cv:formatDateRange">
        <xsl:param name="string1" as="xs:string"/>
        <xsl:param name="string2" as="xs:string"/>
       <!-- <xsl:message>Testing range: <xsl:value-of select="$string1"/> and <xsl:value-of select="$string2"/></xsl:message>-->
        <xsl:variable name="date1" select="cv:formatSingleDate($string1)"/>
        <xsl:variable name="date2" select="cv:formatSingleDate($string2)"/>
        <xsl:variable name="date1Tokens" select="cv:getDateTokens($string1)"/>
        <xsl:variable name="date2Tokens" select="cv:getDateTokens($string2)"/>
        <xsl:variable name="year1" select="$date1Tokens[1]"/>
        <xsl:variable name="year2" select="$date2Tokens[1]"/>
    <!--    <xsl:message>date1: <xsl:value-of select="$date1"/> / year1: <xsl:value-of select="$year1"/></xsl:message>
        <xsl:message>date2: <xsl:value-of select="$date2"/> / year2: <xsl:value-of select="$year2"/></xsl:message>-->
<!--        <xsl:message>Does year1 = year 2? <xsl:value-of select="$year1=$year2"/></xsl:message>-->
        <xsl:choose>
            <xsl:when test="$year1=$year2">
                <xsl:value-of select="normalize-space(substring-before($date1,$year1))"/><xsl:text>–</xsl:text><xsl:value-of select="$date2"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$date1"/><xsl:text>–</xsl:text><xsl:value-of select="$date2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="cv:getDateTokens">
        <xsl:param name="string"/>
        <xsl:sequence select="tokenize($string,'-')"/>
    </xsl:function>
</xsl:stylesheet>