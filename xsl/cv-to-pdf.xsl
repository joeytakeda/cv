<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:cv="http://joeytakeda.github.io/ns/"
    exclude-result-prefixes="xs"
    xmlns="http://www.w3.org/1999/XSL/Format"
    xpath-default-namespace="http://joeytakeda.github.io/ns/"
    version="3.0">
    
    <xsl:include href="functions.xsl"/>
    
    <!--Decide whether or not I want to display references online-->
    <xsl:param name="displayReferences" select="'false'"/>
    <xsl:param name="displayDesc" select="'false'"/>
    <xsl:param name="compressed" select="'true'"/>
    <xsl:param name="allDates" select="'false'"/>
    <xsl:param name="date"/>
    
   
   <xsl:strip-space elements="*" />
    <xsl:preserve-space elements="conference publication"/>
    <xsl:output method="xml" indent="no"/>
    <xsl:attribute-set name="page-dims">
        <xsl:attribute name="page-height">11.00in</xsl:attribute>
        <xsl:attribute name="page-width">8.50in</xsl:attribute>
        <xsl:attribute name="margin-top">0.75in</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.75in</xsl:attribute>
        <xsl:attribute name="margin-left">0.75in</xsl:attribute>
        <xsl:attribute name="margin-right">0.75in</xsl:attribute>
    </xsl:attribute-set>
    <xsl:template match="/">
        <xsl:message>Creating FO file...</xsl:message>
       <!-- <xsl:message>
            References displayed: <xsl:value-of select="$displayReferences"/>
            Months displayed: <xsl:value-of select="$displayMonth"/>
            Descriptions displayed: <xsl:value-of select="$displayDesc"/>
        </xsl:message>-->
        <xsl:message>
           
        </xsl:message>
        
        <root font-family="CormorantGaramond">
            <layout-master-set>
                <simple-page-master  xsl:use-attribute-sets="page-dims"
                    master-name="first-page"
>
                    <region-body/>
                </simple-page-master>
                <simple-page-master master-name="rest"
                    page-height="11.00in" 
                    xsl:use-attribute-sets="page-dims"
                    margin-bottom=".4in">
          
                    <region-body region-name="xsl-region-body" margin-bottom="0.35in"/>
                    <region-after region-name="xsl-region-after" extent="0.2in"/>
                    
                </simple-page-master>
                <page-sequence-master master-name="CV">
                    <repeatable-page-master-alternatives>
                        <conditional-page-master-reference page-position="first" master-reference="first-page"/>
                        <conditional-page-master-reference 
                            page-position="rest" master-reference="rest"/>
                    </repeatable-page-master-alternatives>
                </page-sequence-master>
            </layout-master-set>
            <declarations>
                <x:xmpmeta xmlns:x="adobe:ns:meta/">
                    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                        <rdf:Description rdf:about=""
                            xmlns:dc="http://purl.org/dc/elements/1.1/">
                            <!-- Dublin Core properties go here -->
                            <dc:title><xsl:value-of select="cv/name"/>'s Curriculum Vitae</dc:title>
                            <dc:creator><xsl:value-of select="cv/name"/></dc:creator>
                            <dc:description>CV</dc:description>
                            <dc:date><xsl:value-of select="$date"/></dc:date>
                        </rdf:Description>
                        <rdf:Description rdf:about=""
                            xmlns:xmp="http://ns.adobe.com/xap/1.0/">
                            <xmp:CreatorTool>XSL-FOP.</xmp:CreatorTool>
                        </rdf:Description>
                    </rdf:RDF>
                </x:xmpmeta>
            </declarations>
            
            <page-sequence master-reference="CV">
                <static-content flow-name="xsl-region-after">
                    <block text-align="right" font-size="0.8em">
                            <retrieve-marker retrieve-class-name="section" retrieve-position="last-starting-within-page"/> | <page-number/> 
                    </block>
                </static-content>
                <flow flow-name="xsl-region-body" line-stacking-strategy="line-height">
                    <xsl:apply-templates/>
                </flow>
            </page-sequence>
        </root>
    </xsl:template>
    
    <xsl:template match="cv">
        <xsl:apply-templates select="name"/>
        <block font-size="12pt" padding-bottom=".2em">
            <xsl:for-each select="* except (name, section)">
                <xsl:apply-templates select="."/>
                <xsl:if test="position() ne last()">
                    <xsl:text> | </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </block>
        <block padding="1em 0 0 0"/>
        <xsl:apply-templates select="section"/>
    </xsl:template>
    
    <xsl:template match="email | github | phone | orcid">
        <inline>
            <xsl:choose>
                <xsl:when test="self::github">
                    <xsl:value-of select="'https://github.com/' || ."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </inline>
    </xsl:template>
    
    <!--Header stuff-->
    <xsl:template match="cv/name">
        <block font-size="20pt" padding-bottom="0.2em" font-weight="600">
            <xsl:value-of select="."/>
        </block>
    </xsl:template>
    
  <!--  <xsl:template match="cv/email">
        <xsl:choose>
            <xsl:when test="parent::cv[phone]">
                <block font-size="12pt" padding-bottom=".2em">
                    <inline><xsl:value-of select="."/></inline>
                    <xsl:for-each select="../phone, ../orcid">
                        <xsl:text> | </xsl:text>
                        <inline><xsl:value-of select="."/></inline>
                    </xsl:for-each>
                </block>
            </xsl:when>
            <xsl:otherwise>
                <block font-size="10pt">
                    <basic-link external-destination="mailto:{.}"><xsl:value-of select="."/></basic-link>
                </block>
            </xsl:otherwise>
        </xsl:choose>
        <!-\-Little HR-\->
   
<!-\-       <block><leader leader-pattern="rule" leader-length="100%" rule-style="solid" rule-thickness=".5pt"/></block>-\->
    </xsl:template>-->
    
    <!--Suppress, if necessary-->
 <!--   <xsl:template match="cv/phone"/>
    -->
    
    <xsl:template match="section">
        <block keep-together.within-page="auto">
            
            <xsl:apply-templates/>
            <xsl:if test="parent::cv and head">
                <block>
                    <marker marker-class-name="section">
                        <xsl:value-of select="string(head)"/>
                    </marker>
                </block>
            </xsl:if>
        </block>
    </xsl:template>
    
    <!--Each section-->
    
    <xsl:template match="cv/section/head">
        <block-container keep-with-next.within-page="always" keep-together.within-page="always" page-break-before="auto" page-break-after="avoid" page-break-inside="avoid" margin-bottom="0.5em">
            <block>
                <marker marker-class-name="section">
                    <xsl:value-of select="string(.)"/>
                </marker>
            </block>
            <block font-weight="600" font-size="16pt" margin-top="0.3em" padding-top="0.5em" keep-together.within-page="always">
                <xsl:value-of select="upper-case(.)"/>
                <block>
                    <marker marker-class-name="section">
                        <xsl:value-of select="string(.)"/>
                    </marker>
                </block>
            </block>
            <block margin-top="-0.5em" keep-together.within-page="always">
                <leader leader-pattern="rule" leader-length="97.5%" rule-style="solid" rule-thickness=".5pt"/>
            </block>
        </block-container>
    </xsl:template>
    
    <xsl:template match="section/section/head">
        <block-container
            keep-with-next.within-page="always"
            keep-together.within-page="always"
            page-break-before="auto"
            page-break-after="avoid" page-break-inside="avoid"
            margin-top="0.4em"
            margin-bottom="0.3em">
            <block font-weight="700"
                font-size="13pt" 
                padding-top="0.3em" padding-bottom="0.1em" text-decoration="underline" keep-together.within-page="always">
                <xsl:value-of select="."/>
            </block>
<!--            <block margin-top="-0.5em" keep-together.within-page="always">
                <leader leader-pattern="rule" leader-length="97.5%" rule-style="solid" rule-thickness=".5pt"/>
            </block>-->
        </block-container>
    </xsl:template>
    
    <!--Make these tables-->
    <xsl:template match="*[self::listDegrees | self::listAwards | self::listJobs |  self::listPublications | self::listConferences]" priority="2">
        <xsl:choose>
            <xsl:when test="self::listPublications or self::listConferences and not($allDates = 'true')">
            <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <!--Switch for if the dates should be on the left 
            or right-->
                <xsl:variable name="dateCol" select="1"/>
                
                <table table-layout="fixed" width="100%" page-break-before="avoid">
                    <xsl:variable name="dateColWidth">
                        <xsl:choose>
                            <xsl:when test="$dateCol=1">
                                <xsl:value-of select="if (descendant::*[@to or @from]) then 24 else 16"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="22"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <table-column column-number="{$dateCol}" column-width="{$dateColWidth}%"/>
                    <table-column column-number="{if ($dateCol=1) then 2 else 1}" column-width="{98-$dateColWidth}%"/>
                    <table-body>
                        <xsl:apply-templates select="node()[not(self::head)]">
                            <xsl:sort select="(@to, @when, date/@to, date/@when, current-date())[1] ! cv:castToDate(.)" order="descending"/>
                            <xsl:sort select="(@from, date/@from, date/@when, current-date())[1] ! cv:castToDate(.)" order="descending"/>
                            <xsl:with-param name="dateCol" select="$dateCol"/>
                        </xsl:apply-templates>
                    </table-body>
                </table>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--    Publications and conferences are formatted differently-->
    <xsl:template match="listPublications | listConferences">
        <block>
            <xsl:apply-templates/>
        </block>
    </xsl:template>
    
    
   <xsl:template match="date">
       <xsl:apply-templates/>
   </xsl:template>
   
    <!--Table rows-->
    <xsl:template match="award | degree | job | publication | conference" priority="2">
        <xsl:param name="dateCol"/>
        <xsl:choose>
            <xsl:when test="self::publication or self::conference and not($allDates = 'true')">
                <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <table-row page-break-inside="avoid">
                    <xsl:variable name="content">
                        <table-cell>
                            <xsl:element name="block">
                                <xsl:attribute name="padding-top" select="if (self::award[not(hi)]) then .1 else .25 || 'em'"/>
                                <xsl:attribute name="padding-bottom" select="if (self::award[not(hi)]) then .1 else .25 || 'em'"/>
                                <xsl:choose>
                                    <xsl:when test="publication | conference">
                                        <xsl:next-match/>
                                    </xsl:when>
                                    <xsl:when test="child::* and (every $t in child::text() satisfies not(matches(.,'\S')))">
                                        <xsl:apply-templates select="*"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </table-cell>
                    </xsl:variable>
                    <xsl:variable name="dateCell">
                        <xsl:variable name="yearRex" select="'^(\d+)(-.+)?$'"/>
                        <table-cell>
                            <block padding=".1em 0" text-align="left">
                                <inline text-align="left">
                                    <xsl:choose>
                                        <xsl:when test="not(@*) and child::date">
                                            <xsl:variable name="year" select="replace(child::date/@when, $yearRex, '$1')"/>
                                            <xsl:value-of select="$year"/>
                                        </xsl:when>
                                        <xsl:when test="@to and @from and expected[matches(@locus,'(from)|(to)')]">
                                            <xsl:value-of select="cv:formatSingleDate(@from)"/>–<xsl:value-of select="cv:formatSingleDate(@to)"/><inline font-size="90%"> (expected)</inline>
                                        </xsl:when>
                                        <xsl:when test="ancestor::section[@type='service']">
                                            
                                            <xsl:variable name="fyear" select="replace(@from, $yearRex, '$1')"/>
                                            <xsl:variable name="tyear" select="replace(@to, $yearRex,'$1')"/>
                                            <xsl:variable name="wyear" select="replace(@when, $yearRex,'$1')"/>
                                            <xsl:choose>
                                                <xsl:when test="@to and @from">
                                                    <xsl:value-of 
                                                        select="cv:formatDateRange($fyear, $tyear)"/>
                                                </xsl:when>
                                                <xsl:when test="@from">
                                                    <xsl:value-of select="cv:formatSingleDate($fyear)"/>
                                                    <xsl:text>–present</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="cv:formatSingleDate($wyear)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="self::degree and (@to and @from)">
                                            <xsl:value-of select="cv:formatSingleDate(@to)"/>
                                        </xsl:when>
                                        <xsl:when test="@when">
                                            <xsl:value-of select="cv:formatSingleDate(@when)"/>
                                        </xsl:when>
                                        <xsl:when test="@to and @from">
                                            <xsl:value-of select="cv:formatDateRange(@from,@to)"/>
                                        </xsl:when>
                                        <xsl:when test="@from">
                                            <xsl:value-of select="cv:formatSingleDate(@from)"/><xsl:text>–present</xsl:text>
                                        </xsl:when>
                                    </xsl:choose>
                                    
                                </inline>
                            </block>
                        </table-cell>
                    </xsl:variable>
                    
                    <xsl:choose>
                        <xsl:when test="$dateCol=1">
                            <xsl:copy-of select="$dateCell"/>
                            <xsl:copy-of select="$content"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="$content"/>
                            <xsl:copy-of select="$dateCell"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </table-row>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    
    
    <xsl:template match="degree/name | discipline | institution | class | role | instructor | workplace | job_title">
        <xsl:choose>
            <xsl:when test="$compressed = 'true'">
                <inline>
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::*[not(self::expected)]"><xsl:text>, </xsl:text></xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="font-weight">700</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </inline>
            </xsl:when>
            <xsl:otherwise>
                <block>
                    <xsl:apply-templates/>
                </block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="locus"/>
    
    <xsl:template match="supervisor">
<!--        <block>
            <xsl:text>Supervisor</xsl:text><xsl:if test="contains(.,' and ')">s</xsl:if>: <xsl:apply-templates/>
        </block>-->
    </xsl:template>
    
    <xsl:template match="job/desc">
        <xsl:if test="$displayDesc='true'">
            <block text-align="justify" 
                margin-right="1em" margin-left="1em" padding-top=".3em" padding-right="1.5em">
                <xsl:apply-templates/>
            </block>
        </xsl:if>
    </xsl:template>
    

    
    <xsl:template match="publication | conference">
        <block padding-bottom=".5em" margin-left="1.5em" text-indent="-1.5em" margin-right="3em" text-align="justify" page-break-inside="avoid">
            <xsl:apply-templates/>
        </block>
    </xsl:template>
    
    <xsl:template match="title[@level='m']">
        <inline font-style="italic">
            <xsl:apply-templates/>
        </inline>
    </xsl:template>
    
    <xsl:template match="hi[@rend='bold']">
        <inline font-weight="700">
            <xsl:apply-templates/>
        </inline>
    </xsl:template>
    

    <xsl:template match="title[@level='a']">
        <xsl:variable name="lq" select="('“', '‘')"/>
        <xsl:variable name="rq" select="('”','’')"/>
        <xsl:variable name="level" select="(count(ancestor::title[@level='a']) mod 2) + 1"/>
        <inline>
            <inline><xsl:value-of select="$lq[$level]"/></inline>
            <inline>
                <xsl:apply-templates mode="#current"/>
                <!--<xsl:if test="following::*|text()[1][self::text()] and matches(following::text()[1], '^[,\.]') and not(child::*[self::title[@level='a']][not(following-sibling::text())]) or not(following-sibling::*)">
                    <xsl:value-of select="substring(following::text()[1], 1, 1)"/>
                </xsl:if>-->
            </inline>
            <inline keep-with-previous.within-line="always"><xsl:value-of select="$rq[$level]"/></inline>
        </inline>
    </xsl:template>
    

    <xsl:template match="text()[not(ancestor::title[@level='a'])][preceding::text()[1][ancestor::title[@level='a']]][matches(., '^[,\.]')]">
        <xsl:value-of select="substring(., 2)"/>
    </xsl:template>
    

    
    <xsl:template match="ref[@target]">
        <xsl:variable name="dest" select="if (@type='local') then replace(concat('https://joeytakeda.github.io/',@target),'\.\./','') else @target"/>
        <xsl:choose>
<!--            When's a string referring to me, then bold it (usually in presentations/conferences)-->
            <xsl:when test="@target='#me'">
                <inline font-weight="600">
                    <xsl:apply-templates/>
                </inline>
            </xsl:when>
<!--            <xsl:when test="ancestor::workplace">
                <!-\-Don't make workplace links in PDFs-\->
                <xsl:apply-templates/>
            </xsl:when>-->
<!--            Otherwise, link outwards. -->
            <xsl:otherwise>
                <basic-link external-destination="{$dest}" text-decoration="underline">
                    <xsl:apply-templates/>
                </basic-link>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    <xsl:template match="listReferences">
        <block>
            <xsl:apply-templates select="head"/>
            <xsl:choose>
                <xsl:when test="$displayReferences='true'">
                    <!--Then we'll import them externally, I think-->
                    <!--<xsl:for-each select="reference">
                        <block padding-top=".6em">
                            <block><xsl:value-of select="name"/></block>
                            <block><xsl:value-of select="role"/></block>
                            <block><xsl:value-of select="email"/></block>
                            <block><xsl:value-of select="phone"/></block>
                        </block>
                    </xsl:for-each>-->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>References available upon request.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </block>
    </xsl:template>
    
    <xsl:template match="list">
        <list-block provisional-distance-between-starts="0.6em">
            <xsl:apply-templates select="item"/>
        </list-block>
        
    </xsl:template>
    
    <xsl:template match="list/item">
        <list-item>
            <list-item-label>
                <block>•</block>
            </list-item-label>
            <list-item-body start-indent="body-start()">
                <block>
                    <xsl:apply-templates/>
                </block>
            </list-item-body>
        </list-item>
    </xsl:template>
    
    <xsl:template match="ptr">
        <basic-link external-destination="{@target}" text-decoration="underline">
            <xsl:value-of select="@target"/>
        </basic-link>
    </xsl:template>
    
<!--    TODO: Templates for references-->
    
    
    
   
</xsl:stylesheet>