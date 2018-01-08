<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://github.com/joeytakeda/cv/ns" prefix="cv"/>
    <sch:pattern>
        <sch:rule context="cv:job[@from]">
            <sch:let name="fromTokens" value="tokenize(@from,'-')"/>
           
            <sch:assert test="@from and count($fromTokens) gt 1">
                ERROR: All job date ranges should include the month.
            </sch:assert>
            
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="cv:job[@to]">
            <sch:let name="toTokens" value="tokenize(@to,'-')"/>
            <sch:assert test="count($toTokens) gt 1">
                ERROR: All job date ranges should include the month.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="cv:*[@to]">
            <sch:assert test="@from">
                ERROR: You can't have an @to without an @from.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>