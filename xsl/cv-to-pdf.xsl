<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:cv="http://joeytakeda.github.io/ns/"
    exclude-result-prefixes="xs"
    xmlns="http://www.w3.org/1999/XSL/Format"
    xpath-default-namespace="http://joeytakeda.github.io/ns/"
    version="2.0">
    
    <xsl:include href="functions.xsl"/>
    
    <!--Decide whether or not I want to display references online-->
    <xsl:param name="displayReferences" select="'false'"/>
    <xsl:param name="displayDesc" select="'false'"/>
    <xsl:param name="date"/>
    
    
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
                <simple-page-master master-name="A4-portrait"
                    page-height="11.00in" page-width="8.50in" margin-top=".85in" margin-bottom=".85in" margin-left="1in" margin-right="1in">
                    <region-body/>
                </simple-page-master>
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
            
            <page-sequence master-reference="A4-portrait">
                <flow flow-name="xsl-region-body">
                    <xsl:apply-templates/>
                </flow>
            </page-sequence>
        </root>
    </xsl:template>
    
    <!--Header stuff-->
    <xsl:template match="cv/name">
        <block font-size="26pt" font-weight="600">
            <xsl:value-of select="."/>
        </block>
    </xsl:template>
    
    <xsl:template match="cv/email">
        <xsl:choose>
            <xsl:when test="parent::cv[phone]">
                <block-container font-size="10pt">
                    <block padding-bottom=".2em"><xsl:value-of select="."/></block>
                    <block><xsl:value-of select="parent::cv/phone"/></block>
                </block-container>
            </xsl:when>
            <xsl:otherwise>
                <block font-size="10pt">
                    <basic-link external-destination="mailto:{.}"><xsl:value-of select="."/></basic-link>
                </block>
            </xsl:otherwise>
        </xsl:choose>
        <!--Little HR-->
        <block padding="1em 0 0 0"/>
<!--       <block><leader leader-pattern="rule" leader-length="100%" rule-style="solid" rule-thickness=".5pt"/></block>-->
    </xsl:template>
    
    <!--Suppress, if necessary-->
    <xsl:template match="cv/phone"/>
    
    
    <xsl:template match="section">
        <block>
            <xsl:apply-templates/>
        </block>
    </xsl:template>
    
    
    
    <!--Each section-->
    
    <xsl:template match="head">
        <block font-weight="600" font-size="16pt" padding=".6em 0 0 0" keep-with-next.within-page="always">
            <xsl:value-of select="upper-case(.)"/>
        </block>
        <block padding="-.75em 0 0 0" margin-bottom=".5em" keep-with-next.within-page="always"><leader leader-pattern="rule" leader-length="97.5%" rule-style="solid" rule-thickness=".5pt"/></block>
    </xsl:template>
    
    <!--Make these tables-->
    <xsl:template match="*[self::listDegrees | self::listAwards | self::listJobs]">
        <!--Switch for if the dates should be on the left 
            or right-->
        <xsl:variable name="dateCol" select="2"/>
        <table table-layout="fixed" width="100%">
            <xsl:variable name="dateColWidth">
                <xsl:choose>
                    <xsl:when test="$dateCol=1">
                        <xsl:value-of select="if (descendant::*[@to or @from]) then 18 else 14.5"/>
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
                    <xsl:with-param name="dateCol" select="$dateCol"/>
                </xsl:apply-templates>
            </table-body>
        </table>
    </xsl:template>
    
   
    <!--Table rows-->
    <xsl:template match="award | degree | job">
        <xsl:param name="dateCol"/>
        <table-row page-break-inside="avoid">
            <xsl:variable name="content">
                <table-cell>
                    <block padding-top="{if (self::award) then .1 else .25}em" padding-right=".5em" padding-bottom="{if (self::award) then .1 else .25}em">
                        <xsl:apply-templates/>
                    </block>
                </table-cell>
            </xsl:variable>
              <xsl:variable name="dateCell">
                  <table-cell>
                    <block padding=".1em 0" text-align="left">
                        <inline text-align="left">
                            <xsl:choose>
                                <xsl:when test="@when">
                                   <xsl:value-of select="cv:formatSingleDate(@when)"/>
                                </xsl:when>
                                <xsl:when test="@to and @from and not(expected[matches(@locus,'(to)|(from)')])">
                                    <xsl:value-of select="cv:formatDateRange(@from,@to)"/>
                                </xsl:when>
                                <xsl:when test="@to and @from and expected[matches(@locus,'(from)|(to)')]">
                                    <xsl:value-of select="cv:formatSingleDate(@from)"/>–<xsl:value-of select="cv:formatSingleDate(@to)"/><inline font-size="90%"> (expected)</inline>
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
    </xsl:template>
    
    <xsl:template match="degree/name | discipline | institution | class | role | instructor | workplace">
        <block>
            <xsl:apply-templates/>
        </block>
    </xsl:template>
    
    <xsl:template match="job_title">
        <block>
         <!--   <xsl:text>Job title: </xsl:text>--><xsl:apply-templates/>
        </block>
    </xsl:template>
    
    <xsl:template match="supervisor">
<!--        <block>
            <xsl:text>Supervisor</xsl:text><xsl:if test="contains(.,' and ')">s</xsl:if>: <xsl:apply-templates/>
        </block>-->
    </xsl:template>
    
    <xsl:template match="job/desc">
        <xsl:if test="$displayDesc='true'">
            <block text-align="justify" margin-right="1em" margin-left="1em" padding-top=".3em">
                <xsl:apply-templates/>
            </block>
        </xsl:if>
    </xsl:template>
    
    <!--    Publications and conferences are formatted differently-->
    <xsl:template match="listPublications | listConferences">
        <block>
            <xsl:apply-templates/>
        </block>
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
    

    <xsl:template match="title[@level='a']">
        <xsl:text>“</xsl:text>
            <xsl:apply-templates mode="#current"/>
            <xsl:if test="following::*|text()[1][self::text()] and matches(following::text()[1], '^[,\.]') and not(child::*[self::title[@level='a']][not(following-sibling::text())]) or not(following-sibling::*)">
                <xsl:value-of select="substring(following::text()[1], 1, 1)"/>
            </xsl:if>
        <xsl:text>”</xsl:text>
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
            <xsl:when test="ancestor::workplace">
                <!--Don't make workplace links in PDFs-->
                <xsl:apply-templates/>
            </xsl:when>
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
    
<!--    TODO: Templates for references-->
    
    
    
   
</xsl:stylesheet>