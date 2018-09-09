<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://joeytakeda.github.io/ns/"
    xmlns:hcmc="http://hcmc.uvic.ca/ns"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:cv="http://joeytakeda.github.io/ns/"
    >
    
    <xsl:include href="functions.xsl"/>
    
    <xsl:template match="cv">
       <xsl:message>Creating XHTML5 CV.</xsl:message>
            <html>
                <head>
                    <title><xsl:value-of select="name"/>: CV</title>
                    <link href='https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,400,300,600' rel='stylesheet' type='text/css'/>
                    <link rel="stylesheet" href="../css/CV.css" type="text/css"/>
                </head>
                <body>
                    <h1><xsl:value-of select="name"/></h1>
                    <span class="email"><a href="mailto:{email}"><xsl:value-of select="email"/></a></span>
                    <xsl:apply-templates/>
                    <div id="revision">
                        <p>Last revision: <xsl:value-of select="format-date(current-date(),'[MNn] [D1o], [Y0001]')"/></p>
                    </div>
                </body>
                
            </html>
        
    </xsl:template>
    
<!--    We manipulate those throughout.-->
    <xsl:template match="cv/email | cv/name"/>
    
    <xsl:template match="section">
        <div class="section">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="listReferences">
        <xsl:choose>
            <xsl:when test="reference">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p>References available upon request.</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
        
    <xsl:template match="desc">
        <div class="desc">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="head">
        <h2><xsl:value-of select="upper-case(.)"/></h2>
        <hr/>
    </xsl:template>
    
    <xsl:template match="workplace | job_title | location | class | role| institution | byline">
        <div class="desc">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="supervisor">
        <div class="desc">
            Supervisor: <xsl:apply-templates/>
        </div>
    </xsl:template>
    
<!--    Suppress-->
    <xsl:template match="job/desc"/>
        
        
    <xsl:template match="publication | job | reference |degree | conference">
        <div class="item">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="award">
        <div class="award">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="list/item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
  
  <xsl:template match="@when">
      <span class="date"><xsl:value-of select="cv:formatSingleDate(.)"/></span>
  </xsl:template>
    
    <xsl:template match="@from">
        <span class="date">
            <xsl:choose>
                <xsl:when test="parent::*/@to">
                    <xsl:value-of select="cv:formatDateRange(.,parent::*/@to)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="cv:formatSingleDate(.)"/><xsl:text>–present</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="publication/title">
        <span class="title_{@level}"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="ref[@target]">
        <xsl:choose>
            <xsl:when test="@target='#me'">
                <span class="refToMe"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <a href="{@target}"><xsl:apply-templates/></a>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
<!--   suppress-->
    <xsl:template match="@to"/>
    
</xsl:stylesheet>