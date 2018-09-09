<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://joeytakeda.github.io/ns/"
    xmlns:hcmc="http://hcmc.uvic.ca/ns"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:cv="http://joeytakeda.github.io/ns/"
    >
    
    <xsl:include href="functions.xsl"/>
    
    <xsl:param name="date"/>
    <xsl:output method="xml" encoding="UTF-8" normalization-form="NFC" indent="yes" exclude-result-prefixes="#all"/>
    
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction><xsl:text>&#x0a;</xsl:text>
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction><xsl:text>&#x0a;</xsl:text>
        <TEI xml:id="CV">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title><xsl:value-of select="//cv/name"/>'s Curriculum Vitae</title>
                    </titleStmt>
                    <publicationStmt>
                        <p> Last generated <xsl:value-of select="$date"/>.</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Born digital, but generated using XSLT.</p>
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <particDesc>
                        <person xml:id="me">
                            <persName>
                                <name><xsl:value-of select="//cv/name"/></name>
                                <email><xsl:value-of select="email"/></email>
                                <xsl:if test="website">
                                    <ptr target="{website}"/>
                                </xsl:if>
                            </persName>
                        </person>
                    </particDesc>
                </profileDesc>
            </teiHeader>
            <text>
                <body>
                    <listPerson>
                        <person sameAs="#me">
                            <xsl:apply-templates select="//section"/>
                        </person>
                    </listPerson>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="section">
        <xsl:apply-templates select="node()[not(self::head)]"/>
    </xsl:template>
    
    <xsl:template match="degree">
            <education>
                <xsl:copy-of select="@to | @from | @when"/>
                <xsl:value-of select="name"/> in <xsl:value-of select="discipline"/> at <placeName><xsl:value-of select="institution"/></placeName>.</education>
        
      
    </xsl:template>
  
  <xsl:template match="listJobs | listDegrees">
      <xsl:apply-templates/>
  </xsl:template>
    
    
    <xsl:template match="listPublications | listConferences">
        <listBibl>
            <xsl:apply-templates select="parent::*/head"/>
            <xsl:apply-templates/>
        </listBibl>
    </xsl:template>
 
    
    
    <xsl:template match="head">
        <head><xsl:apply-templates/></head>
    </xsl:template>
    
     
    <xsl:template match="publication | conference">
        <bibl><xsl:apply-templates/></bibl>
    </xsl:template>

    
    <xsl:template match="ref">
        <ref><xsl:copy-of select="@*"/><xsl:apply-templates/></ref>
    </xsl:template>
    
    <xsl:template match="title">
        <title><xsl:copy-of select="@*"/><xsl:apply-templates/></title>
    </xsl:template>
    
    
    <xsl:template match="job">
        <occupation type="{if (ancestor::section[@type='service']) then 'unpaid' else 'paid'}">
            <xsl:copy-of select="@from | @to |@when"/>
            <xsl:variable name="string" as="xs:string+">
                <xsl:choose>
                    <xsl:when test="class"><xsl:value-of select="role"/> for <xsl:value-of select="class"/>.</xsl:when>
                    <xsl:otherwise><xsl:value-of select="job_title"/> at <xsl:value-of select="workplace"/>.</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <p><xsl:value-of select="normalize-space(string-join($string,''))"/></p>
        </occupation>
    </xsl:template>
    
    <xsl:template match="listReferences[not(reference)]">
        <note>References available by request.</note>
    </xsl:template>
    <!--Suppress-->
    <xsl:template match="references | email |name"/>
    
    <xsl:function name="cv:getDateFromElement" as="element(tei:date)">
        <xsl:param name="el" as="element()"/>
        <date>
            <xsl:copy-of select="$el/@*"/>
            <xsl:choose>
                <xsl:when test="$el[@when]">
                   <xsl:value-of select="$el/@when"/>
                </xsl:when>
                <xsl:when test="$el[@to] and $el[@from]">
                        <xsl:value-of select="concat($el/@from,'-',$el/@to)"/>
                </xsl:when>
                <xsl:when test="$el[@from] and $el[not(@to)]">
                    <xsl:attribute name="to" select="$date"/>
                    <xsl:value-of select="$el/@from"/> to present.
                </xsl:when>
            </xsl:choose>
        </date>
    </xsl:function>
    
    
    
    <xsl:template match="*[starts-with(local-name(.),'list')]" priority="-1">
        <note>
            <list>
                <xsl:apply-templates select="parent::*/head"/>
                <xsl:apply-templates/>
            </list> 
        </note>
    </xsl:template>
    
    <xsl:template match="*[starts-with(local-name(.),'list')][not(self::listPublications | self::listConferences)]/*" priority="-1">
        <item>
            <xsl:apply-templates/><xsl:if test="@to | @from | @when"> (<xsl:copy-of select="cv:getDateFromElement(.)"/>)</xsl:if>
        </item>
    </xsl:template>
    

</xsl:stylesheet>