<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://github.com/joeytakeda/cv/ns"
    xmlns:hcmc="http://hcmc.uvic.ca/ns"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:cv="http://github.com/joeytakeda/cv/ns"
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
                        <title>Joseph Takeda's CV</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Published on <ref target="http://joeytakeda.github.io">joeytakeda.github.io</ref>. Last generated <xsl:value-of select="$date"/>.</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Born digital; source: <ref target="../xml/CV.xml">CV.xml</ref></p>
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <particDesc>
                        <person xml:id="me">
                            <persName>
                                <name>Joseph Takeda</name>
                            </persName>
                        </person>
                    </particDesc>
                </profileDesc>
            </teiHeader>
            <text>
                <body>
                    <listPerson>
                        <person sameAs="#me">
                            <persName>
                                <surname>Takeda</surname>
                                <forename>Joseph</forename>
                                <forename>Joey</forename>
                                <email><xsl:value-of select="email"/></email>
                            </persName>
                            <xsl:apply-templates/>
                        </person>
                    </listPerson>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
  
    
    <!-- Education -->
    <xsl:template match="education">
       <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="degree">
        <education>
            <xsl:copy-of select="@to | @from | @when"/>
            <xsl:value-of select="degree_name"/> in <xsl:value-of select="discipline"/> at <placeName><xsl:value-of select="institution"/></placeName>.
        </education>
    </xsl:template>
    
    <xsl:template match="awards">
        <note>
            <p>Awards received:
            <list xml:id="CV_awards">
                <xsl:apply-templates/>
            </list>
        </p>
        </note>
    </xsl:template>
    
    <xsl:template match="awards/award">
        <item><xsl:value-of select ="."/> (<xsl:copy-of select="cv:getDateFromElement(.)"/>)</item>
    </xsl:template>
    
    <xsl:template match="publications | conferences">
        <listBibl xml:id="CV_{local-name()}">
            <xsl:apply-templates/>
        </listBibl>
    </xsl:template>
    
    <xsl:template match="publication | conference">
        <bibl><xsl:apply-templates/></bibl>
    </xsl:template>
    
<!--    I borrow elements from TEI/bibl structure for publication and conference,
    so I just need to switch the namespace.-->
    <xsl:template match="publication/* | conference/*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="employment | service | teaching">
        <occupation xml:id="CV_{local-name()}">
            <note> 
                <list>
                    <xsl:apply-templates/>
                </list>
            </note>
        </occupation>
    </xsl:template>
    
    <xsl:template match="job">
        <item>
            <xsl:choose>
                <xsl:when test="parent::teaching">
                    <p>Taught <xsl:value-of select="class"/> in the role of <xsl:value-of select="role"/> (<xsl:copy-of select="cv:getDateFromElement(.)"/>).</p>
                </xsl:when>
                <xsl:otherwise>
                    <p><xsl:value-of select="job_title"/> at <xsl:value-of select="workplace"/>.<xsl:if test="supervisor">Supervised by <xsl:value-of select="supervisor"/>.</xsl:if> (<xsl:copy-of select="cv:getDateFromElement(.)"/>)</p>
                </xsl:otherwise>
            </xsl:choose>
           
        </item>
    </xsl:template>
    
    <!--Suppress-->
    <xsl:template match="head | references | email |name"/>
    
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
    
    

</xsl:stylesheet>