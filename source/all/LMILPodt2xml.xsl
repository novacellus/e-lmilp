<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:lmilp="http://scriptores.pl/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" version="2.0"
    exclude-result-prefixes="text office svg">
    <xsl:key name="sigla" match="tei:bibl" use="@xml:id"/>
    <xsl:key name="abbreviationes" match="tei:choice" use="tei:abbr"/>
    <!-- Elementy utworzone na potrzeby przetwarzania i inne tymczasowe znajdują się w przestzreni nazw lmilp -->
    <xsl:output indent="yes" method="xml"/>
    <!-- <xsl:strip-space elements="*"/>-->
    <xsl:preserve-space elements="lmilp:Forma tei:form tei:entryFree"/>
    <!-- Dokąd dojść w przetwarzaniu? -->
    <xsl:param name="azDo" select="'pass10'"/>
    <xsl:param name="file"/>
    <xsl:variable name="numbering_roman">
        <xsl:value-of select="'[IVX]+'"/>
    </xsl:variable>
    <xsl:variable name="numbering_greek">
        <xsl:value-of select="'[αβγδεζηθικλμνξοπρστυφχψω]'"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-stylesheet" select="'type=&quot;text/css&quot;','href=&quot;css/LMILP.css&quot;'"/>
        <xsl:variable name="pass1">
            <xsl:apply-templates select="/" mode="pass1"/>
        </xsl:variable>
        <xsl:variable name="pass2a">
            <xsl:apply-templates select="$pass1" mode="pass2a"/>
        </xsl:variable>
        <xsl:variable name="pass2b">
            <xsl:apply-templates select="$pass2a" mode="pass2b"/>
        </xsl:variable>
        <xsl:variable name="pass2c">
            <xsl:apply-templates select="$pass2b" mode="pass2c"/>
        </xsl:variable>
        <xsl:variable name="pass3">
            <xsl:apply-templates select="$pass2c" mode="pass3"/>
        </xsl:variable>
        <xsl:variable name="pass4a">
            <xsl:apply-templates select="$pass3" mode="pass4a"/>
        </xsl:variable>
        <xsl:variable name="pass4b">
            <xsl:apply-templates select="$pass4a" mode="pass4b"/>
        </xsl:variable>
        <xsl:variable name="pass4c">
            <xsl:apply-templates select="$pass4b" mode="pass4c"/>
        </xsl:variable>
        <xsl:variable name="pass5">
            <xsl:apply-templates select="$pass4c" mode="pass5"/>
        </xsl:variable>
        <xsl:variable name="pass6">
            <xsl:apply-templates select="$pass5" mode="pass6"/>
        </xsl:variable>
        <xsl:variable name="pass7">
            <xsl:apply-templates select="$pass6" mode="pass7"/>
        </xsl:variable>
        <xsl:variable name="pass8">
            <xsl:apply-templates select="$pass7" mode="pass8"/>
        </xsl:variable>
        <xsl:variable name="pass9">
            <xsl:apply-templates select="$pass8" mode="pass9"/>
        </xsl:variable>
        <xsl:variable name="pass10">
            <xsl:apply-templates select="$pass9" mode="pass10"/>
        </xsl:variable>
        <xsl:variable name="pass11">
            <xsl:apply-templates select="$pass10" mode="pass11"/>
        </xsl:variable>
        <xsl:variable name="pass12">
            <xsl:apply-templates select="$pass11" mode="pass12"/>
        </xsl:variable>
        <xsl:variable name="pass13">
            <xsl:apply-templates select="$pass12" mode="pass13"/>
        </xsl:variable>
        <xsl:variable name="pass14">
            <xsl:apply-templates select="$pass13" mode="pass14"/>
        </xsl:variable>
        <xsl:variable name="pass15">
            <xsl:apply-templates select="$pass14" mode="pass15"/>
        </xsl:variable>
        <xsl:copy-of select="$pass12">
        </xsl:copy-of>
    </xsl:template>
    <!-- Szablon kopiowania -->
    <xsl:template match="@* | node()"
        mode="pass2a pass2b pass2c pass3 pass4a pass4b pass4c pass5 pass6 pass7 pass8 pass9 pass10 pass11 pass12 pass13 pass14 pass15">
        <xsl:copy>
            <xsl:apply-templates mode="#current" select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- Pass1: kopiowanie drzewa -->
    <xsl:template match="office:text" mode="pass1">
        <tei:TEI>
            <tei:teiHeader>
                <tei:fileDesc>
                    <tei:titleStmt>
                        <tei:title>Title</tei:title>
                    </tei:titleStmt>
                    <tei:publicationStmt>
                        <tei:p>Publication Information</tei:p>
                    </tei:publicationStmt>
                    <tei:sourceDesc>
                        <tei:p>Information about the source</tei:p>
                    </tei:sourceDesc>
                </tei:fileDesc>
            </tei:teiHeader>
            <tei:text>
                <tei:body>
                    <xsl:apply-templates mode="pass1"/>
                </tei:body>
            </tei:text>
        </tei:TEI>
    </xsl:template>
    <xsl:template match="text:sequence-decl" mode="pass1"/>
    <xsl:template match="@* | node()" name="copy">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- Pass1: usuwanie automatycznych stylów -->
    <xsl:template match="*[@text:style-name]" mode="pass1">
        <xsl:choose>
            <xsl:when test="matches(@text:style-name,'T\d+')">
                <xsl:apply-templates mode="#current"/>
            </xsl:when>
            <!-- Niektóre z Haslo zostały zamienione na style T zależne od Haslo -->
            <xsl:when test="matches(@text:style-name,'P\d+')">
                <xsl:element name="lmilp:Haslo">
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="lmilp:{@text:style-name}">
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text:list-style" mode="pass1"/>
    <!-- Pass2a: Ujęcie spacji, kropek w sąsiadujący tag -->
    <xsl:template match="text()[matches(.,'^(\s+|\s*\|\s*)$')]|text()[normalize-space(.) eq ',']|node()[normalize-space(.) eq '|\W']|node()[matches(.,'^(\s*\.\s*)$')]"
        mode="pass2a">
        <xsl:if test="./preceding-sibling::*[1]">
            <xsl:element name="{name(./preceding-sibling::*[1])}">
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!-- Noty wewnątrz cytatów -->
    <xsl:template match="lmilp:Cytacja" mode="pass2b">
        <xsl:copy>
            <xsl:analyze-string select="." regex="\[\(">
                <xsl:matching-substring>
                    <xsl:text>([</xsl:text>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:analyze-string select="." regex="\)([,.\s]*)\]">
                        <xsl:matching-substring>
                            <xsl:text>]</xsl:text>
                            
                            <xsl:text>)</xsl:text>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:copy>
    </xsl:template>
    <!-- Pass2b: Noty -->
    <xsl:template match="lmilp:Kursywa" mode="pass2b">
        <xsl:choose>
            <xsl:when test="matches(.,'^\s*N\.(\s*(constr\.|glossam))*')">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'note'"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="matches(.,'^\s*Constr\.')">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'note'"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:when
                test="matches(.,'^\s*(Dicitur|Iunctur|Locut|Explicat|Syn|Iuxta|Distinguitur|Praec|Definitur|Opp|Inde|Additur)')">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'note'"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="matches(.,'^\s*(Eodem|Simili) sensu')">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'note'"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="matches(.,'^\s*Item')">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'note'"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="matches(.,'loco')">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'note'"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:when
                test="(./preceding-sibling::*[1][self::lmilp:Forma] and matches(normalize-space(.),'^s\.|et|scr\.$') ) or (./following-sibling::*[1][self::lmilp:Forma] and matches(normalize-space(.),'s\.|et|scr\.|') )">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'variants'"/>
                    <xsl:copy-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when
                        test="matches(.,'(
                        (N|Constr)\.|
                        Dicitur|Iunctur|Locut|Explicat|Syn|Iuxta|Distinguitur|Praec|
                        (Eodem|Simili) sensu|Item|Definitur|Opp|Inde
                        )', 'x')">
                        <xsl:analyze-string select="."
                            regex="^(.*)
                            (
                            (N|Constr)\.|
                            Dicitur|Iunctur|Locut|Explicat|Syn|Iuxta|Distinguitur|Praec|
                            (Eodem|Simili) sensu|Item|Definitur|Opp|Inde
                            )
                            (.*)$"
                            flags="x">
                            <xsl:matching-substring>
                                <xsl:element name="lmilp:Kursywa">
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:element>
                                <xsl:element name="tei:label">
                                    <xsl:attribute name="type" select="'note'"/>
                                    <xsl:attribute name="rend" select="'italics'"/>
                                    <xsl:value-of select="concat(regex-group(2),regex-group(5))"/>
                                </xsl:element>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Pass2c: Unifikacja stylów -->
    <xsl:template match="lmilp:Haslo" mode="pass2c">
        <xsl:copy>
            <xsl:for-each-group select="./node()|text()" group-adjacent="name()">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <xsl:for-each select=".">
                            <xsl:element name="{current-grouping-key()}">
                                <xsl:copy-of select="current-group()/node()|@*"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>

    </xsl:template>
    <!-- Pass3: Grupowanie adresów i cytacji -->
    <xsl:template match="lmilp:Haslo" mode="pass3">
        <xsl:copy>
            <xsl:for-each-group select="./node()|text()" group-starting-with="lmilp:Adres">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::lmilp:Adres]">
                        <xsl:for-each-group select="current-group()"
                            group-ending-with="lmilp:Cytacja">
                            <xsl:choose>
                                <xsl:when test="current-group()[last()][self::lmilp:Cytacja]">
                                    <xsl:element name="lmilp:grupaCytatu">
                                        <xsl:apply-templates select="current-group()"
                                            mode="#current"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()" mode="#current"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    <!-- Pass3: Rozdzielenie zlanych numeracji -->
    <xsl:template match="lmilp:Numeracja" mode="pass3">
        <xsl:analyze-string select="." regex="(\w+\.)">
            <xsl:matching-substring>
                <xsl:element name="lmilp:Numeracja">
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <!-- Pass4: Numeracja punktów -->
    <xsl:template match="*" name="grupowanieNumeracji">
        <xsl:param name="tree"/>
        <xsl:param name="type"/>
        <xsl:element name="lmilp:grupaNumeracji">
            <xsl:attribute name="type" select="$type"/>
            <xsl:apply-templates select="$tree" mode="#current"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="lmilp:Haslo" mode="pass4a">
        <xsl:copy>
            <xsl:call-template name="numeracja">
                <xsl:with-param name="tree" select="."/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="numeracja">
        <xsl:param name="tree"/>
        <!-- I, II, III-->
        <xsl:for-each-group select="$tree/node()|text()"
            group-starting-with="lmilp:Numeracja[matches(.,$numbering_roman)]">
            <xsl:choose>
                <xsl:when
                    test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_roman)]">
                    <xsl:element name="lmilp:grupaNumeracji">
                        <xsl:attribute name="type" select="'roman'"/>
                        <xsl:copy-of select="current-group()[1]"/>
                        <!-- A, B, C -->
                        <xsl:for-each-group select="current-group()[position()>1]"
                            group-starting-with="lmilp:Numeracja[matches(.,'[A-HJ-UY-Z]')]">
                            <xsl:choose>
                                <xsl:when
                                    test="current-group()[1][self::lmilp:Numeracja][matches(.,'[A-HJ-UY-Z]')]">
                                    <xsl:element name="lmilp:grupaNumeracji">
                                        <xsl:attribute name="type" select="'capital'"/>
                                        <xsl:copy-of select="current-group()[1]"/>
                                        <xsl:for-each-group select="current-group()[position()>1]"
                                            group-starting-with="lmilp:Numeracja[matches(.,'[1-9]')]">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,'[1-9]')]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'arabic'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,'[a-z]')]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,'[a-z]')]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'small'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each-group>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each-group select="current-group()"
                                        group-starting-with="lmilp:Numeracja[matches(.,'[1-9]')]">
                                        <xsl:choose>
                                            <xsl:when
                                                test="current-group()[1][self::lmilp:Numeracja][matches(.,'[1-9]')]">
                                                <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'arabic'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,'[a-z]')]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,'[a-z]')]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'small'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:for-each-group select="current-group()"
                                                  group-starting-with="lmilp:Numeracja[matches(.,'[a-z]')]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,'[a-z]')]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'small'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:for-each-group select="current-group()"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:for-each-group>

                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each-group>

                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>

                    </xsl:element>
                    <!--<xsl:for-each-group select="current-group()" group-starting-with="tei:label">
                                        <xsl:choose>
                                            <xsl:when test="current-group()[1][self::tei:label]">
                                                <xsl:element name="lmilp:grupaNumeracji">
                                                    <xsl:attribute name="type" select="'note'"/>
                                                    <xsl:copy-of select="current-group()[1]"/>
                                                    <xsl:apply-templates select="current-group()[position()>1]"
                                                        mode="#current"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:copy-of select="current-group()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each-group>-->
                    <!--<xsl:copy-of select="current-group()"/>-->

                </xsl:when>
                <xsl:otherwise>
                    <!-- A, B, C,  -->
                    <xsl:for-each-group select="current-group()"
                        group-starting-with="lmilp:Numeracja[matches(.,'[A-HJ-UY-Z]')]">
                        <xsl:choose>
                            <xsl:when
                                test="current-group()[1][self::lmilp:Numeracja][matches(.,'[A-HJ-UY-Z]')]">
                                <xsl:element name="lmilp:grupaNumeracji">
                                    <xsl:attribute name="type" select="'capital'"/>
                                    <xsl:copy-of select="current-group()[1]"/>
                                    <xsl:for-each-group select="current-group()[position()>1]"
                                        group-starting-with="lmilp:Numeracja[matches(.,'[1-9]')]">
                                        <xsl:choose>
                                            <xsl:when
                                                test="current-group()[1][self::lmilp:Numeracja][matches(.,'[1-9]')]">
                                                <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'arabic'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,'[a-z]')]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,'[a-z]')]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'small'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:copy-of select="current-group()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each-group>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- 1, 2, 3 -->
                                <xsl:for-each-group select="current-group()"
                                    group-starting-with="lmilp:Numeracja[matches(.,'[1-9]')]">
                                    <xsl:choose>
                                        <xsl:when
                                            test="current-group()[1][self::lmilp:Numeracja][matches(.,'[1-9]')]">
                                            <xsl:element name="lmilp:grupaNumeracji">
                                                <xsl:attribute name="type" select="'arabic'"/>
                                                <xsl:copy-of select="current-group()[1]"/>
                                                <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,'[a-z]')]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,'[a-z]')]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'small'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <!-- Etykiety -->
                                                  <xsl:for-each-group select="current-group()"
                                                  group-starting-with="tei:label[@type ne 'variants']">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="current-group()[1][self::tei:label[@type ne 'variants']]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'note'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:for-each-group>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- a, b, c -->
                                            <xsl:for-each-group select="current-group()"
                                                group-starting-with="lmilp:Numeracja[matches(.,'[a-z]')]">
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,'[a-z]')]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'small'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:for-each-group
                                                  select="current-group()[position()>1]"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <!-- alfa, beta, gamma -->
                                                  <xsl:for-each-group select="current-group()"
                                                  group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'greek'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:for-each-group select="current-group()"
                                                      group-starting-with="tei:label[@type ne 'variants']">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="current-group()[1][self::tei:label[@type ne 'variants']]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'note'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>

                                                  <xsl:for-each-group select="current-group()"
                                                      group-starting-with="tei:label[@type ne 'variants']">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="current-group()[1][self::tei:label[@type ne 'variants']]">
                                                  <xsl:element name="lmilp:grupaNumeracji">
                                                  <xsl:attribute name="type" select="'note'"/>
                                                  <xsl:copy-of select="current-group()[1]"/>
                                                  <xsl:apply-templates
                                                  select="current-group()[position()>1]"
                                                  mode="#current"/>
                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  <!--<xsl:copy-of select="current-group()"/>-->
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  <!--<xsl:copy-of select="current-group()"/>-->
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each-group>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each-group>

                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each-group>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    <!-- Pass4b: Porządkowanie 1) noty nieujęte w lmilp:grupaNumeracji 2) hasła z jedną definicją -->
    <xsl:template match="lmilp:Haslo" mode="pass4b">
        <xsl:copy>
            <xsl:for-each-group select="node()|text()" group-starting-with="tei:label[@type ne 'variants']">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::tei:label[@type ne 'variants']]">
                        <xsl:element name="lmilp:grupaNumeracji">
                            <xsl:attribute name="type" select="'note'"/>
                            <xsl:apply-templates select="current-group()" mode="#current"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="lmilp:grupaNumeracji" mode="pass4b">
        <xsl:copy>
            <xsl:for-each-group select="node()|text()" group-starting-with="tei:label[@type ne 'variants']">
                <xsl:choose>
                    <!-- Sprawdza czy nie jest pierwszym elementem grupy numeracji (by nie powielać numerowania) -->
                    <xsl:when
                        test="current-group()[1][self::tei:label[@type ne 'variants'][not(self::* is ./parent::lmilp:grupaNumeracji/child::*[1] ) ]]">
                        <xsl:element name="lmilp:grupaNumeracji">
                            <xsl:attribute name="type" select="'note'"/>
                            <xsl:for-each-group select="current-group()"
                                group-starting-with="lmilp:Numeracja[matches(.,$numbering_greek)]">
                                <xsl:choose>
                                    <xsl:when
                                        test="current-group()[1][self::lmilp:Numeracja][matches(.,$numbering_greek)]">
                                        <xsl:element name="lmilp:grupaNumeracji">
                                            <xsl:attribute name="type" select="'greek'"/>
                                            <xsl:copy-of select="current-group()[1]"/>
                                            <xsl:apply-templates
                                                select="current-group()[position()>1]"
                                                mode="#current"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="current-group()"
                                            mode="#current"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each-group>
                            <!--
                            <xsl:apply-templates select="current-group()" mode="#current"/>-->
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="lmilp:Haslo" mode="pass4c">
        <xsl:copy>
            <xsl:for-each-group select="node()|text()" group-starting-with="lmilp:Definicjaa">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::lmilp:Definicjaa]">
                        <xsl:element name="lmilp:grupaNumeracji">
                            <xsl:apply-templates select="current-group()" mode="#current"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <!-- Etymologia / anomalia -->
    <xsl:template match="lmilp:Haslo" mode="pass5">
        <xsl:copy>
            <!-- Grupowanie wg () -->
            <xsl:for-each-group select="./node()|text()"
                group-starting-with="node()[matches(.,'^\s*\(')] | text()[matches(.,'\s*^\(')]">
                <xsl:choose>
                    <!-- Zawiera () -->
                    <xsl:when test="current-group()[1][matches(.,'^\s*\(')]">
                        <xsl:choose>
                            <!-- Znajduje się przed jakąkolwiek definicją? -->
                            <xsl:when
                                test="current-group()[1][not(preceding-sibling::lmilp:Definicjaa|child::lmilp:Definicjaa)]">
                                <xsl:for-each-group select="current-group()"
                                    group-ending-with="node()[matches(.,'\)')] | text()[matches(.,'\)')]">
                                    <xsl:choose>
                                        <xsl:when
                                            test="current-group()[1][matches(.,'^\s*\(')] and current-group()[last()][matches(.,'\)')]">
                                            <xsl:element name="lmilp:Etymologia">
                                                <xsl:copy-of select="current-group()"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:copy-of select="current-group()"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each-group>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="current-group()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Nie zawiera () -->
                    <xsl:otherwise>
                        <xsl:for-each-group select="current-group()"
                            group-starting-with="node()[matches(.,'^\[')][not(./ancestor::lmilp:Definicjaa|ancestor-or-self::*[preceding-sibling::lmilp:Definicjaa])]">
                            <xsl:choose>
                                <!-- Zawiera [], ale nie NRSTRONY -->
                                <xsl:when
                                    test="current-group()[1][matches(.,'^\[')][not(matches(.,'^\[NR'))]">
                                    <xsl:for-each-group select="current-group()"
                                        group-ending-with="node()[matches(.,'\]')][not(./ancestor::lmilp:Definicjaa|ancestor-or-self::*[preceding-sibling::lmilp:Definicjaa])]">
                                        <xsl:choose>
                                            <xsl:when
                                                test="current-group()[last()][matches(.,'\]\s*$')]">
                                                <xsl:element name="tei:note">
                                                  <xsl:attribute name="type" select="'anomale'"/>
                                                  <xsl:copy-of select="current-group()"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:copy-of select="current-group()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each-group>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:copy-of select="current-group()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>

                    </xsl:otherwise>
                </xsl:choose>

                <!--<xsl:choose>
                    <xsl:when test="current-group()[1][matches(.,'^\(')]">
                    <nawias>
                    <xsl:copy-of select="current-group()"/>
                    </nawias>
                    <xsl:for-each-group select="current-group()"
                    group-ending-with="*[matches(.,'\)\s*$')]">
                    <xsl:choose>
                    <xsl:when test="current-group()[last()][self::*[matches(.,'\)\s*$')]]">
                    <nawias>
                    <xsl:copy-of select="current-group()"/>
                    </nawias>
                    </xsl:when>
                    <xsl:otherwise>
                    <xsl:copy-of select="current-group()"/>
                    </xsl:otherwise>
                    </xsl:choose>
                    </xsl:for-each-group>-->

                <!--
                    <xsl:for-each-group select="current-group()"
                    group-ending-with="lmilp:Cytacja">
                    <xsl:choose>
                    <xsl:when test="current-group()[last()][self::lmilp:Cytacja]">
                    <grupaCytatu>
                    <xsl:copy-of select="current-group()|@*"/>
                    </grupaCytatu>
                    </xsl:when>
                    <xsl:otherwise>
                    <xsl:copy-of select="current-group()"/>
                    </xsl:otherwise>
                    </xsl:choose>
                    
                    
                    </xsl:for-each-group>-->
                <!-- </xsl:when>
                    <xsl:otherwise>
                    <xsl:copy-of select="current-group()"/>
                    </xsl:otherwise>
                    </xsl:choose>-->

                <!--
                <xsl:for-each-group select="current-group()/node()|text()"
                    group-ending-with="lmilp:Cytacjaa"> </xsl:for-each-group>
                -->

            </xsl:for-each-group>

        </xsl:copy>
    </xsl:template>
    <!-- Wyodrębnienie definicji pl i la -->
    <xsl:template match="lmilp:Definicjaa" mode="pass6">
        <xsl:analyze-string select="." regex="(.+?)(;|\?)(.+)(\?)*">
            <xsl:matching-substring>
                <xsl:element name="lmilp:Definicjaa">
                    <xsl:attribute name="xml:lang" select="'pl'"/>
                    <xsl:value-of select="regex-group(1)"/>
                    <xsl:if test="matches( regex-group(2), '\?' )">
                        <xsl:value-of select="regex-group(2)"/>
                        <xsl:element name="tei:certainty">
                            <xsl:attribute name="degree" select="'0.5'"/>
                            <xsl:attribute name="locus" select="'value'"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                <xsl:if test="matches(regex-group(2),';')">
                    <xsl:value-of select="concat(regex-group(2),' ')"/>
                </xsl:if>
                <xsl:element name="lmilp:Definicjaa">
                    <xsl:attribute name="xml:lang" select="'la'"/>
                    <xsl:value-of select="regex-group(3)"/>
                    <xsl:value-of select="regex-group(4)"/>
                    <xsl:if test="matches( regex-group(4), '\?' )">
                        <xsl:element name="tei:certainty">
                            <xsl:attribute name="degree" select="'0.5'"/>
                            <xsl:attribute name="locus" select="'value'"/>
                        </xsl:element>
                    </xsl:if>

                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:element name="lmilp:Definicjaa">
                    <xsl:attribute name="xml:lang" select="'unknown'"/>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <!-- Dodanie gramGrp-->
    <xsl:template match="lmilp:Haslo|lmilp:grupaNumeracji|lmilp:grupaCytatu" mode="pass6">
        <xsl:copy>
            <xsl:for-each-group select="./node()" group-starting-with="lmilp:Paradygmat">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::lmilp:Paradygmat]">
                        <xsl:for-each-group select="current-group()"
                            group-ending-with="lmilp:Rodzaj">
                            <xsl:choose>
                                <xsl:when test="current-group()[last()][self::lmilp:Rodzaj]">
                                    <xsl:element name="tei:gramGrp">
                                        <xsl:apply-templates select="current-group()"
                                            mode="#current"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="current-group()[self::lmilp:Paradygmat]">
                                        <xsl:element name="tei:gramGrp">
                                            <xsl:apply-templates select="." mode="#current"/>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each
                                        select="current-group()[not(self::lmilp:Paradygmat)]">
                                        <xsl:apply-templates select="." mode="#current"/>

                                    </xsl:for-each>

                                    <!--<xsl:element name="tei:gramGrp">
                                                <xsl:apply-templates select="current-group()[lmilp:Paradygmat]" mode="#current"/>
                                            </xsl:element>        
                                            <xsl:apply-templates select="current-group() except *[lmilp:Paradygmat]" mode="#current"/>-->
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>

        </xsl:copy>
    </xsl:template>
    <!-- Korekta: adresów oddzielonych średnikiem -->
    <xsl:template match="lmilp:Adres" mode="pass7">
        <xsl:call-template name="adres_korekta">
            <xsl:with-param name="string" select="."/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="adres_korekta">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="matches(normalize-space($string),'^[,\(]')">
                <xsl:variable name="first_chars">
                    <xsl:analyze-string select="$string" regex="^(\s*[\(,])">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <xsl:variable name="new_string" select="substring-after($string,$first_chars)"/>
                <xsl:value-of select="$first_chars"/>
                <xsl:call-template name="adres_korekta">
                    <xsl:with-param name="string">
                        <xsl:value-of select="$new_string"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="matches(.,';')">
                <xsl:for-each select="tokenize(.,';')">
                    <xsl:call-template name="adres_korekta">
                        <xsl:with-param name="string" select="."/>
                    </xsl:call-template>
                    <xsl:value-of select="';'"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="matches(normalize-space($string),'supra')">
                <xsl:analyze-string select="$string" regex="(\s*supra\s*[IVX]*,*\s*\d+(,*\s*\d+)*(\s*sqq)*\s*\.*\s*)(.+|$)">
                    <xsl:matching-substring>
                            <xsl:call-template name="parse_supra">
                                <xsl:with-param name="string" select="regex-group(1)"/>
                            </xsl:call-template>
                        <xsl:if test="normalize-space(regex-group(4))">
                        <xsl:call-template name="adres_korekta">
                            <xsl:with-param name="string">
                                <xsl:value-of select="regex-group(4)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        </xsl:if>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:variable name="new_string" select="."/>
                        <xsl:if test="matches(.,'supra')">
                            <xsl:element name="lmilp:Adres">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="not(matches(.,'supra'))">
                            <xsl:call-template name="adres_korekta">
                                <xsl:with-param name="string" select="$new_string"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
                
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:element name="lmilp:Adres">
                    <xsl:value-of select="$string"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Wyodrębnienie supra z lmilp:Kursywa -->
    <xsl:template match="lmilp:Kursywa[matches(.,'supra')]" mode="pass7">
        <xsl:copy>
            <xsl:apply-templates mode="#current" select="@*"/>
            <xsl:analyze-string select="." regex="(\s*supra\s*[IVX]*,*\s*\d+(,*\s*\d+)*(\s*sqq)*\s*\.*\s*)(.+|$)">
                <xsl:matching-substring>
                    <xsl:call-template name="adres_korekta">
                        <xsl:with-param name="string">
                            <xsl:value-of select="regex-group(4)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
         <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:copy>
        
    </xsl:template>
    <!-- Parsowanie wyrażeń z "supra" -->
    <xsl:template name="parse_supra">
        <xsl:param name="string"/>
        <xsl:element name="tei:xr">
            <xsl:analyze-string select="$string" regex="(supra\s*)(([IVX]+\s*,*)*(\d+\s*,*\s*)(\d+\s*,*\s*)*(sqq*\.)*)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                    <xsl:element name="tei:ref">
                        <xsl:value-of select=" regex-group(2)"/>
                    </xsl:element>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:element>
    </xsl:template>
    <!-- Etymologia: język -->
    <xsl:template match="lmilp:Etymologia" mode="pass7">
        <xsl:variable name="content" select="."/>
        <xsl:element name="tei:etym">
            <!-- Pojedynczy wyraz -->
            <xsl:choose>
                <xsl:when test="matches($content,'(\s*\(\s*)(\w+\?*)(\s*\)\s*)')">
                    <xsl:analyze-string select="." regex="(\s*\(\s*)(\w+\?*)(\s*\)\s*)">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                            <xsl:element name="tei:mentioned">
                                <xsl:attribute name="xml:lang" select="'la'"/>
                                <xsl:value-of select="translate(regex-group(2),'?','')"/>
                                <xsl:if test="matches(regex-group(2),'\?')">
                                    <xsl:element name="tei:certainty">
                                        <xsl:attribute name="locus" select="'value'"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                            <xsl:if test="matches(regex-group(2),'\?')">
                                <xsl:text>?</xsl:text>
                            </xsl:if>
                            <xsl:value-of select="regex-group(3)"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <!-- Pojedynczy wyraz + język (Pl. cabacium):
                    - x definiuje odmianę: cla - klasyczną, med - średniowieczną
                -->
                <xsl:when
                    test="matches($content,'( \s*\(\s* )
                    ( \w+\. )\s*
                    ( \w+ )
                    ( \s*\)\s* )','x')">
                    <xsl:variable name="language">
                        <xsl:variable name="language_string">
                            <xsl:analyze-string select="$content"
                                regex="(\s*\(\s*)
                                ( \w+\. )\s*
                                ( \w+ )
                                ( \s*\)\s* )"
                                flags="x">
                                <xsl:matching-substring>
                                    <xsl:value-of select="regex-group(2)"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:variable>
                        <!-- Kody języków wg BCP 47 -->
                        <xsl:choose>
                            <xsl:when test="matches($language_string,'Pol')">
                                <xsl:value-of select="'pl-x-med'"/>
                            </xsl:when>
                            <xsl:when test="matches($language_string,'Germ')">
                                <xsl:value-of select="'de-x-med'"/>
                            </xsl:when>
                            <xsl:when test="matches($language_string,'Gall|Fr')">
                                <xsl:value-of select="'fr-x-med'"/>
                            </xsl:when>
                            <xsl:when test="matches($language_string,'Gr')">
                                <xsl:value-of select="'grc'"/>
                            </xsl:when>
                            <xsl:when test="matches($language_string,'It')">
                                <xsl:value-of select="'it-x-med'"/>
                            </xsl:when>
                            <xsl:when test="matches($language_string,'Hung')">
                                <xsl:value-of select="'hu-x-med'"/>
                            </xsl:when>
                            <xsl:when test="matches($language_string,'\d+')">
                                <xsl:value-of select="'la-x-cla'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'other'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:analyze-string select="."
                        regex="( \s*\(\s* )
                        ( \w+\. )\s*
                        ( \w+ )
                        ( \s*\)\s* )"
                        flags="x">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                            <xsl:element name="tei:lang">
                                <xsl:value-of select="regex-group(2)"/>
                                <xsl:text> </xsl:text>
                            </xsl:element>
                            <xsl:element name="tei:mentioned">
                                <xsl:attribute name="xml:lang" select="$language"/>
                                <xsl:value-of select="regex-group(3)"/>
                            </xsl:element>
                            <xsl:value-of select="regex-group(4)"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:analyze-string select="." regex="\w+">
                        <xsl:matching-substring></xsl:matching-substring>
                    </xsl:analyze-string>-->
                    <xsl:element name="tei:note">
                        <xsl:copy-of select="./(node()|text())"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>


        </xsl:element>
    </xsl:template>
    <!-- Formy graficzne -->
    <xsl:template match="lmilp:Forma/text()" mode="pass7">
        <xsl:analyze-string select="."
            regex="(
                (\s*\d\.\s*|\s*I\.\s*)*   
                (\[)*
                ( ([A-Z\|]+(-*)[A-Z\|]+\?*) ((,*\s*|\s*) (et\|s\.)* ) )+               
                (\])*
                )"
            flags="x">
            <xsl:matching-substring>
              <xsl:if test="regex-group(2)">
                    <xsl:element name="tei:label">
                        <xsl:attribute name="type" select="'homonym'"/>
                        <xsl:choose>
                            <xsl:when test="contains(regex-group(2),'I')">
                                <xsl:value-of select="'1. '"/>
                        
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="regex-group(2)"/>
                        
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>                        
                </xsl:if>
                <xsl:for-each select="regex-group(4)">
                    <xsl:element name="tei:orth">
                        <xsl:attribute name="rend" select="'case(allcaps)'"/>
                        <xsl:attribute name="type" select="'lemma'"/>
                        <xsl:if test="regex-group(3)">
                            <xsl:attribute name="type" select="'reconstructed'"/>
                            <xsl:value-of select="regex-group(3)"/>
                        </xsl:if>
                        <xsl:value-of select="regex-group(5)"/>
                        <xsl:value-of select="regex-group(8)"/>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="normalize-space(regex-group(9)) ne ''">
                            <xsl:element name="tei:label">
                                <xsl:attribute name="type" select="'variants'"/>
                                <xsl:value-of select="concat(regex-group(9),' ' )"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>                            
                            <xsl:value-of select="regex-group(9)"></xsl:value-of>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="regex-group(10)">
                        <xsl:value-of select="regex-group(10)"/>
                    </xsl:if>

                </xsl:for-each>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
               <xsl:analyze-string select="."
                    regex="(\s*
                    (et|scr\.|s\.)*
                    (\s*)
                    ( ([a-zA-Z\|\.]+)(,*) )+
                    )"
                    flags="x">
                    <xsl:matching-substring>
                        <xsl:if test="regex-group(2)">
                            <xsl:element name="tei:label">
                                <xsl:attribute name="type" select="'variants'"/>
                                        <xsl:value-of select="regex-group(2)"/>
                                      <xsl:value-of select="regex-group(3)"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:for-each select="regex-group(4)">
                            <xsl:analyze-string select="." regex="((\s|^)*(scr\.|et|s\.)(\s|$))">
                                <xsl:matching-substring>
                                    <xsl:element name="tei:label">
                                        <xsl:attribute name="type" select="'variants'"/>
                                        <xsl:value-of select="regex-group(1)"/>
                                    </xsl:element>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:if test="normalize-space(.) eq ''">
                                        <xsl:value-of select="."/>
                                    </xsl:if>
                                    <xsl:if test="normalize-space(.) ne ''">
                                        <xsl:element name="tei:orth">
                                            <xsl:attribute name="type" select="'variant'"/>
                                            <xsl:value-of select="."/>
                                        </xsl:element>
                                    </xsl:if>
                                        
                                    
                                </xsl:non-matching-substring>
                            </xsl:analyze-string> 
                            
                            <xsl:value-of select="regex-group(6)"/>
                        </xsl:for-each>
                        
                    </xsl:matching-substring>
                   
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(\s*(scr\.|et|s\.)\s*)">
                            <xsl:matching-substring>
                                <xsl:element name="tei:label">
                                    <xsl:attribute name="type" select="'variants'"/>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:element>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>                
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>        
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
        <!--        <xsl:analyze-string select="regex-group(2)" regex="(
            (scr\.|et)*
            (\s*)
            ( (\w+)(,*) )+
            )" flags="x">
            <xsl:matching-substring>
                <xsl:if test="regex-group(2)">
                    <xsl:element name="tei:label">
                        <xsl:attribute name="type" select="'variants'"/>
                        <xsl:value-of select="regex-group(2)"/>
                        <xsl:value-of select="regex-group(3)"/>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="regex-group(4)">
                    
                </xsl:for-each>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="regex-group(2)"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>-->
    </xsl:template>
    <!-- Formy graficzne: etykiety scr, et, s -->
    <xsl:template match="lmilp:Forma/lmilp:Kursywa" mode="pass7" priority="10">
        <xsl:choose>
            <xsl:when test="matches(.,'scr\.|et|s\.')">
                <xsl:element name="tei:label">
                    <xsl:attribute name="type" select="'variants'"/>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Słowniki -->
    <xsl:template match="lmilp:Slowniki" mode="pass7">
        <xsl:copy>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="not(self::text())">
                        <xsl:copy-of select="."/>        
                    </xsl:when>
                
<xsl:otherwise>
            <xsl:analyze-string select="." regex="((Th|Bl|Dc|NGl|BJ|S|F|L|A|Ha|H|N|K|O|W|G|B)(.))">
                <xsl:matching-substring>
                    <xsl:element name="tei:ref">
                        <xsl:attribute name="type" select="'vocabularia'"/>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:element>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:analyze-string select="." regex="\S+">
                        <xsl:matching-substring>
                            <xsl:element name="tei:note">
                                <xsl:attribute name="type" select="'vocabularia'"/>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>

                </xsl:non-matching-substring>
            </xsl:analyze-string>
</xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    <!-- Cytaty: 1) dwukropki 2) uwagi w nawiasach -->
    <xsl:template match="lmilp:Cytacja" mode="pass7">
        <xsl:for-each select="node()">
            <xsl:if test="not(self::text())">
                <xsl:apply-templates select="." mode="#current"/>
            </xsl:if>
            <xsl:if test="self::text()">
        <xsl:analyze-string select="." regex="^:\s*">
            <!-- Usunięcie dwukropka -->
            <xsl:matching-substring>
                <xsl:element name="tei:lbl">
                    <xsl:attribute name="type" select="'quote_introduction'"/>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:element name="tei:quote">
                    <!-- Uwagi w nawiasach -->
                    <xsl:analyze-string select="." regex="( \( .+ \) )" flags="x">
                        <xsl:matching-substring>
                            <xsl:element name="tei:note">
                                <xsl:attribute name="type" select="'quote_note'"/>
                                <!-- Kursywa w uwagach w nawiasach -->
                                <xsl:analyze-string select="." regex="( \[ (.+?) \] )" flags="x">
                                    <xsl:matching-substring>
                                        <xsl:element name="tei:label">
                                            <xsl:attribute name="rend" select="'italics'"/>
                                            <xsl:value-of select="regex-group(2)"/>
                                        </xsl:element>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:value-of select="."/>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>

                            </xsl:element>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:analyze-string select="." regex="( \[ (.+) \] )" flags="x">
                                <xsl:matching-substring>
                                    <xsl:element name="tei:add">
                                        <xsl:attribute name="resp" select="'#editor'"/>
                                        <xsl:attribute name="type" select="'quote_addition'"/>
                                        <xsl:value-of select="regex-group(2)"/>
                                    </xsl:element>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:analyze-string select="." regex="(«(.+?)»)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="'«'"/>
                                            <!-- Na wypadek kilku glos -->
                                            <xsl:if test="matches(regex-group(2),',')">
                                                <xsl:for-each select="tokenize(regex-group(2),',')">
                                                  <xsl:element name="tei:gloss">
                                                  <xsl:attribute name="xml:lang" select="'pl'"/>
                                                  <!-- Zastępuje 0 w zapisie glosy przez znak ø -->
                                                  <xsl:value-of
                                                  select="translate( normalize-space(.), '0', 'ø' )"
                                                  />
                                                  </xsl:element>
                                                  <xsl:if test="not(position() eq last())">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="not(matches(regex-group(2),','))">
                                                <xsl:element name="tei:gloss">
                                                  <xsl:attribute name="xml:lang" select="'pl'"/>
                                                  <xsl:value-of
                                                  select="translate( normalize-space(regex-group(2)), '0', 'ø' )"
                                                  />
                                                </xsl:element>
                                            </xsl:if>

                                            <xsl:value-of select="'»'"/>
                                        </xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <xsl:value-of select="."/>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>

                </xsl:element>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
                
            </xsl:if>
        </xsl:for-each>
    
    </xsl:template>
    <!-- pass7: Słowniki: grupowanie-->
    <xsl:template match="lmilp:Slowniki" mode="pass8">
        <xsl:element name="tei:list">
            <xsl:variable name="lemma"
                select="lower-case(string-join(./ancestor::lmilp:Haslo/tei:form[1]/tei:orth[1]/text(),''))"/>
            <xsl:attribute name="type" select="'vocabularia'"/>

            <xsl:for-each-group select="./node()"
                group-starting-with="tei:ref[@type ='vocabularia']">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::tei:ref[@type ='vocabularia']]">
                        <xsl:for-each-group select="current-group()"
                            group-ending-with="tei:note[@type ='vocabularia']">
                            <xsl:choose>
                                <xsl:when
                                    test="current-group()[last()][self::tei:note[@type ='vocabularia']]">
                                    <xsl:element name="tei:item">
                                        <xsl:apply-templates select="current-group()"
                                            mode="#current"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if
                                        test="normalize-space( string-join ( current-group()/text(), ' ' ) ) ne ''">
                                        <xsl:element name="tei:item">
                                            <xsl:apply-templates select="current-group()"
                                                mode="#current"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:when>
                    <xsl:otherwise>

                        <xsl:element name="tei:item">
                            <xsl:apply-templates select="current-group()" mode="#current"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>

        </xsl:element>
    </xsl:template>
    <!-- TEIzacja -->
    <!-- Tworzy @n lemmatu  -->
    <xsl:function name="lmilp:entry-nFromForm">
        <xsl:param name="entry" as="node()"/>
        <xsl:variable name="nameNodeBefore">
           <xsl:copy-of select="$entry//*[self::*/following::tei:orth[1][self::* is $entry/lmilp:Forma[1]/tei:orth[1]]]"/>
        </xsl:variable>
        <xsl:variable name="nameNodeItself">
            <xsl:copy-of select="$entry/lmilp:Forma[1]/tei:orth[1]"/>
        </xsl:variable>
        <xsl:variable name="nameString" select="concat(string-join ($nameNodeBefore,'') , string-join($nameNodeItself,'') )"/>
        <xsl:variable name="nameStringPurged" select="translate($nameString,'[,-\s \?]','')"/>
        <xsl:choose>
            <xsl:when test="normalize-space($nameStringPurged) eq ''">
                <xsl:value-of select="'DUBIUM'"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$nameStringPurged"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="lmilp:Forma" mode="pass8">
        <xsl:element name="tei:form">
            <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
            <!--Dodajemy eksplicytnie pos dla rzeczowników-->
            <xsl:call-template name="pos_explicit"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="lmilp:Haslo" mode="pass8">
        <!-- Usunięcie pustych haseł -->
        <xsl:if test="normalize-space(.) eq ''">
            <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
        </xsl:if>
        <xsl:if test="normalize-space(.) ne ''">
            <xsl:element name="tei:entryFree">
                <!-- Utworzenie zrozumiałej nazwy hasła -->
                <xsl:variable name="n">
                    <xsl:value-of select="lmilp:entry-nFromForm(.)"/>
                </xsl:variable>
                <xsl:attribute name="xml:id" select="generate-id()"/>
                <xsl:attribute name="n" select="$n"/>
                <xsl:if
                    test=".[not(descendant::lmilp:Definicjaa)] and .[matches(.,'[A-Z]+\s*cf\.')]">
                    <xsl:attribute name="type" select="'xref'"/>
                </xsl:if>
                <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="lmilp:Paradygmat" mode="pass8">
        <!-- Typowy paradygmat (z kreseczkami) -->
        <xsl:if test="matches(.,'-')">
            <!-- Sprawdza, czy paradygmat nie zawiera etykiety POS -->
            <xsl:choose>
                <xsl:when test="matches(.,'(adi|subst|adv|coni|onomatop|interi|pron|num|prp)\.\s*')">
                    <xsl:analyze-string select="."
                        regex="((adi|subst|adv|coni|onomatop|interi|pron|num|prp)\.\s*)">
                        <xsl:matching-substring>
                            <xsl:element name="tei:pos">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:element name="tei:iType">
                                <xsl:attribute name="declined"/>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="tei:iType">
                        <xsl:attribute name="type" select="'declined'"/>
                        <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Nietypowy paradygmat, tj. etykieta części mowy -->
        <xsl:if test="not(matches(.,'-'))">
            <xsl:element name="tei:pos">
                <xsl:attribute name="norm">
                    <xsl:choose>
                        <xsl:when test="matches(.,'subst|loco subst','i')">
                            <xsl:value-of select="'subst'"/>
                        </xsl:when>
                        <xsl:when test="matches(.,'adi|loco adi','i')">
                            <xsl:value-of select="'adi'"/>
                        </xsl:when>
                        <xsl:when test="matches(.,'adv','i')">
                            <xsl:value-of select="'adv'"/>
                        </xsl:when>
                        <xsl:when test="matches(.,'part','i')">
                            <xsl:value-of select="'participium'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="lmilp:Rodzaj" mode="pass8">
        <xsl:element name="tei:gen">
            <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="lmilp:Definicjaa" mode="pass8">
        <xsl:element name="tei:def">
            <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="lmilp:Kursywa" mode="pass8">
    <xsl:element name="tei:emph">
            <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="lmilp:grupaCytatu" mode="pass8">
        <xsl:element name="tei:cit">
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="lmilp:grupaNumeracji" mode="pass8">
        <!--Rozróznienie not i znaczeń -->
        <xsl:choose>
            <xsl:when test="*[1][self::tei:label]">
                <xsl:variable name="label" select="translate(normalize-space(lower-case(*[1][self::tei:label])),'\.\|\]\[\)\(','')"/>
                <xsl:element name="tei:note">
                    <xsl:choose>
                        <xsl:when test="matches($label, '[Cc]onstr')">
                            <xsl:attribute name="type" select="'constr'"/>    
                        </xsl:when>
                        <xsl:when test="$label eq 'glossa'">
                            <xsl:attribute name="type" select="'glossa'"/>    
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="type" select="'note'"/>
                        </xsl:otherwise>
                        </xsl:choose>
                    <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="tei:sense">
                    <xsl:attribute name="orig" select="normalize-space(./lmilp:Numeracja[1])"/>
                    <xsl:attribute name="n"
                        select="translate(normalize-space(./lmilp:Numeracja[1]),',.','')"/>
                    <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>
    <xsl:template match="lmilp:Numeracja" mode="pass8">
        <xsl:element name="tei:label">
            <xsl:attribute name="type" select="'numbering'"/>
            <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="lmilp:ZwyklyTekst" mode="pass8">
        <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
    </xsl:template>
    <!-- tei:form i tei:gramGrp -->
    <xsl:template match="tei:entryFree" mode="pass9">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:for-each-group select="node()" group-starting-with="tei:form">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::tei:form]">
                        <xsl:for-each-group select="current-group()" group-ending-with="tei:gramGrp">
                            <xsl:choose>
                                <xsl:when test="current-group()[last()][self::tei:gramGrp]">
                                    <xsl:element name="tei:form">
                                        <xsl:for-each select="current-group()">
                                            <xsl:if test=".[self::tei:form]">
                                                <xsl:copy-of select="./node()|text()"/>
                                            </xsl:if>
                                            <xsl:if test=".[not(self::tei:form)]">
                                                <xsl:copy-of select="."/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()" mode="#current"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    <!-- Rozwiązanie supra -->
    <xsl:template match="text()[matches(.,'supra')]" mode="pass10">
            <xsl:analyze-string select="." regex="(\s*supra\s*[IVX]*,*\s*\d+(,*\s*\d+)*(\s*sqq)*\s*\.*\s*)(.+|$)">
                <xsl:matching-substring>
                    <xsl:call-template name="parse_supra">
                        <xsl:with-param name="string">
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="tei:xr[@type='supra']">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
                
        </xsl:copy>
    </xsl:template>
    <!-- Związki wchodzące w skład definicji z pominięciem: haseł odsyłaczowych, punktów na listach constr. -->
    <xsl:template match="tei:entryFree//tei:sense[not(parent::tei:note[@type eq 'constr'])]|tei:note" mode="pass10">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:for-each-group select="node()|text()"
                group-adjacent="self::text()[following-sibling::tei:def or following-sibling::tei:cit] or self::tei:milestone[following-sibling::tei:def or following-sibling::tei:cit or following-sibling::tei:label[@type = 'numbering']]">
                <xsl:choose>
                    <xsl:when test="current-grouping-key() and current-group()[not(matches(normalize-space(current-group()),'^(;|,|:|\)|\()*$'))] and not(parent::entryFree[@type ='xref'])">
                        <xsl:analyze-string select="current-group()" regex="^([\)\.;,]*)(.+?)([:\(\.;,]*)$">
                            <xsl:matching-substring>
                                <xsl:if test="regex-group(1)">
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:if>
                                <xsl:element name="tei:usg">
                                    <xsl:attribute name="type" select="'colloc'"/>
                                    <xsl:value-of select="regex-group(2)"/>
                                </xsl:element>
                                <xsl:if test="regex-group(3)">
                                    <xsl:value-of select="regex-group(3)"/>
                                </xsl:if>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose></xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    <!-- Wnioskowanie -->
    <xsl:template match="tei:form" mode="pass11">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="./descendant::tei:pos">
                    <xsl:apply-templates select="node()|text()" mode="#current"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="#current"/>
                    <xsl:call-template name="pos_explicit"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    <!--<xsl:template match="tei:pos">
        <xsl:attribute name="norm" select="normalize-space(translate(.,'\.',''))"/>
        <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
    </xsl:template>-->
    <xsl:template name="pos_explicit">
        <xsl:variable name="lemma">
            <xsl:sequence select="descendant::tei:orth"/>
        </xsl:variable>
        <xsl:variable name="paradigm">
            <xsl:sequence
                select="normalize-space(string-join((descendant::tei:iType|descendant::lmilp:Paradygmat), ' '))"/>
        </xsl:variable>
        <!-- Rzeczownik: podstawa - rodzaj -->
        <xsl:choose>
            <xsl:when test="descendant::tei:gen|descendant::lmilp:Rodzaj">
                <xsl:element name="tei:pos">
                    <xsl:attribute name="norm" select="'subst'"/>
                </xsl:element>
                <xsl:call-template name="iType_explicit">
                    <xsl:with-param name="pos" select="'subst'"/>
                    <xsl:with-param name="paradigm" select="$paradigm"/>
                    <xsl:with-param name="lemma" select="$lemma"/>
                    <xsl:with-param name="gender"
                        select="descendant::tei:gen|descendant::lmilp:Rodzaj"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="matches($paradigm,'^-(ae|arum|ii|i|us|ei)\s$')">
                <xsl:element name="tei:pos">
                    <xsl:attribute name="norm" select="'subst'"/>                    
                </xsl:element>
                <xsl:call-template name="iType_explicit">
                    <xsl:with-param name="pos" select="'subst'"/>
                    <xsl:with-param name="paradigm" select="$paradigm"/>
                    <xsl:with-param name="lemma" select="$lemma"/>
                    <xsl:with-param name="gender"
                        select="descendant::tei:gen|descendant::lmilp:Rodzaj"/>
                </xsl:call-template>
            </xsl:when>
            <!--Czasownik: 1) czy na -o, 2) czy paradygmat -->
            <xsl:when
                test="some $form in $lemma satisfies (matches(normalize-space($form),'o(r)*$','i')) and matches( $paradigm, '^-(a|e|i)*r(e|i)(\W|$)' )">
                <xsl:element name="tei:pos">
                    <xsl:attribute name="norm" select="'v'"/>
                </xsl:element>
                <xsl:call-template name="iType_explicit">
                    <xsl:with-param name="pos" select="'v'"/>
                    <xsl:with-param name="paradigm" select="$paradigm"/>
                    <xsl:with-param name="lemma" select="$lemma[1]"/>
                </xsl:call-template>
            </xsl:when>
            <!-- Przymiotnik: 1) czy paradygmat 2) czy lemma-->
            <xsl:when test="matches($paradigm,'a\W+um')">
                <xsl:element name="tei:pos">
                    <xsl:attribute name="norm" select="'adi'"/>
                </xsl:element>
                <xsl:call-template name="iType_explicit">
                    <xsl:with-param name="pos" select="'adi'"/>
                    <xsl:with-param name="paradigm" select="$paradigm"/>
                    <xsl:with-param name="lemma" select="$lemma"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="matches($paradigm,'^-e$')">
                <xsl:element name="tei:pos">
                    <xsl:attribute name="norm" select="'adi'"/>
                </xsl:element>
                <xsl:call-template name="iType_explicit">
                    <xsl:with-param name="pos" select="'adi'"/>
                    <xsl:with-param name="paradigm" select="$paradigm"/>
                    <xsl:with-param name="lemma" select="$lemma"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="matches($paradigm,'^-is')">
                <xsl:element name="tei:pos">
                    <xsl:attribute name="norm" select="'adi'"/>
                </xsl:element>
                <xsl:call-template name="iType_explicit">
                    <xsl:with-param name="pos" select="'adi'"/>
                    <xsl:with-param name="paradigm" select="$paradigm"/>
                    <xsl:with-param name="lemma" select="$lemma"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="iType_explicit">
        <xsl:param name="paradigm"/>
        <xsl:param name="lemma"/>
        <xsl:param name="pos"/>
        <xsl:param name="gender"/>
        <xsl:choose>
            <xsl:when test="$pos eq'subst'">
                <xsl:choose>
                    <!-- 1. deklinacja -->
                    <xsl:when test="matches($paradigm,'ae$')">
                        <xsl:element name="tei:iType">
                            <xsl:attribute name="norm"
                                select="concat('1-a-ae-',translate($gender,'.',''))"/>
                        </xsl:element>
                    </xsl:when>
                    <!-- 2. deklinacja -->
                    <xsl:when test="matches($paradigm,'i$')">
                        <xsl:choose>
                            <xsl:when test="matches($lemma,'(i)*us$')">
                                <xsl:if test="matches($lemma,'ius','i')">
                                    <xsl:element name="tei:iType">
                                        <xsl:attribute name="norm" select="'2-ius-ii-m'"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="matches($lemma,'[^i]us','i')">
                                    <xsl:element name="tei:iType">
                                        <xsl:attribute name="norm"
                                            select="concat('2-us-i-',translate($gender,'.',''))"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="matches($lemma,'(e|i)*r$','i')">
                                <xsl:choose>
                                    <xsl:when test="matches($paradigm,'-eri$','i')">
                                        <xsl:element name="tei:iType">
                                            <xsl:attribute name="norm" select="'2-er-eri-m'"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="matches($paradigm,'-ri$','i')">
                                        <xsl:element name="tei:iType">
                                            <xsl:attribute name="norm" select="'2-er-ri-m'"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="matches($lemma,'ir$','i')">
                                        <xsl:element name="tei:iType">
                                            <xsl:attribute name="norm" select="'2-r-ri-m'"/>
                                        </xsl:element>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="matches($lemma,'um$','i')">
                                <xsl:element name="tei:iType">
                                    <xsl:attribute name="norm" select="'2-um-i-n'"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="tei:iType">
                                    <xsl:attribute name="norm" select="concat('2-',$paradigm)"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- 3. deklinacja -->
                    <xsl:when test="matches($paradigm,'is$','i')">
                        <xsl:element name="tei:iType">
                            <xsl:attribute name="norm"
                                select="concat('3-', lower-case( substring($lemma, string-length($lemma)-2 ) ),'-is-',translate($gender,'.','') )"
                            />
                        </xsl:element>
                    </xsl:when>
                    <!-- 4. deklinacja -->
                    <xsl:when test="matches($paradigm,'^-us$','i')">
                        <xsl:choose>
                            <xsl:when test="matches($lemma,'u$','i')">
                                <xsl:element name="tei:iType">
                                    <xsl:attribute name="norm" select="'4-u-us-n'"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="matches($lemma,'us$','i')">
                                <xsl:element name="tei:iType">
                                    <xsl:attribute name="norm"
                                        select="concat('4-us-us-', translate($gender,'.','') )"/>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <!-- 5. deklinacja -->
                    <xsl:when test="matches($paradigm,'^-ei$','i')">
                        <xsl:element name="tei:iType">
                            <xsl:attribute name="norm"
                                select="concat('5-es-ei-', translate($gender,'.','') )"/>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$pos eq 'v'">
                <xsl:choose>
                    <!-- Regularne czasowniki -->
                    <xsl:when test="matches($lemma,'o$','i')">
                        <!-- 1. koniugacja -->
                        <xsl:if test="matches($paradigm,'^-are','i')">
                            <xsl:element name="tei:iType">
                                <xsl:attribute name="norm" select="'1-o-are'"/>
                            </xsl:element>
                        </xsl:if>
                        <!-- 2. i 3. koniugacja -->
                        <xsl:if test="matches($paradigm,'^-ere')">
                            <xsl:choose>
                                <!-- 2. koniugacja -->
                                <xsl:when test="matches($lemma,'eo$')">
                                    <xsl:element name="tei:iType">
                                        <!-- 2. koniugacja: regularne -->
                                        <xsl:if test="not(matches($paradigm,' sum'))">
                                            <xsl:attribute name="norm" select="'2-eo-ere'"/>
                                        </xsl:if>
                                        <!-- 2. kongiugacja: semideponentia -->
                                        <xsl:if test="matches($paradigm,' sum')">
                                            <xsl:attribute name="norm" select="'2sd-eo-sum'"/>
                                        </xsl:if>
                                        <xsl:attribute name="norm" select="'2-eo-re'"/>
                                    </xsl:element>
                                </xsl:when>
                                <!-- 3. koniugacja -->
                                <xsl:when test="matches($lemma,'[^ei]o$','i')">
                                    <xsl:element name="tei:iType">
                                        <xsl:if test="not(matches($paradigm,' sum'))">
                                            <xsl:attribute name="norm" select="'3-o-ere'"/>
                                        </xsl:if>
                                        <!-- 3. kongiugacja: semideponentia -->
                                        <xsl:if test="matches($paradigm,' sum')">
                                            <xsl:attribute name="norm" select="'3sd-o-sum'"/>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:when>
                                <!-- 3. koniugacja -io -->
                                <xsl:when test="matches($lemma,'io$','i')">
                                    <xsl:element name="tei:iType">
                                        <xsl:attribute name="norm" select="'3-io-ere'"/>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                        <!-- 4. koniugacja -->
                        <xsl:if test="matches($paradigm,'^-ire')">
                            <xsl:element name="tei:iType">
                                <xsl:attribute name="norm" select="'4-io-ire'"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:when>
                    <!-- Deponentia i semideponentia -->
                    <xsl:when test="matches($lemma,'or$','i')">
                        <xsl:element name="tei:iType">
                            <xsl:attribute name="norm">
                                <!-- 1. koniugacja: deponentia -->
                                <xsl:if
                                    test="matches($lemma,'or$','i') and matches($paradigm,'atus')">
                                    <xsl:value-of select="'1d-or-sum'"/>
                                </xsl:if>
                                <!-- 2. koniugacja: deponentia -->
                                <xsl:if test="matches($lemma,'eor$','i')">
                                    <xsl:value-of select="'2d-eor-sum'"/>
                                </xsl:if>
                                <!-- 3. koniugacja: deponentia -->
                                <xsl:if
                                    test="matches($lemma,'or$','i') and not(matches($paradigm,'atus'))">
                                    <xsl:value-of select="'3d-or-sum'"/>
                                </xsl:if>
                                <!-- 3. koniugacja: deponentia -->
                                <xsl:if test="matches($lemma,'ior$','i')">
                                    <xsl:value-of select="'4d-ior-sum'"/>
                                </xsl:if>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>

            </xsl:when>

            <xsl:when test="$pos eq 'adi'">
                <xsl:choose>
                    <!-- 1/2. Deklinacja -->
                    <xsl:when test="matches($paradigm,'^-\w*a','i')">
                        <xsl:element name="tei:iType">
                            <!-- bonus, a, um -->
                            <xsl:if test="matches($lemma,'us$','i')">
                                <xsl:attribute name="norm" select="'12-us-a_um'"/>
                            </xsl:if>
                            <!-- liber, libera, liberum -->
                            <xsl:if test="matches($lemma,'er$','i')">
                                <xsl:if test="matches($paradigm,'-era')">
                                    <xsl:attribute name="norm" select="'12-er-era_erum'"/>
                                </xsl:if>
                                <xsl:if test="matches($paradigm,'-ra')">
                                    <xsl:attribute name="norm" select="'12-er-ra_rum'"/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:element>
                    </xsl:when>
                    <!-- 3. Deklinacja -->
                    <xsl:when test="matches($paradigm,'is$')">
                        <!-- 3. Deklinacja: acer, acris, acre -->
                        <xsl:choose>
                            <xsl:when test="matches($lemma,'er$','i')">
                                <xsl:element name="tei:iType">
                                    <xsl:attribute name="norm" select="'33-er-is_e'"/>
                                </xsl:element>
                            </xsl:when>
                            <!-- 3. Deklinacja: felix, felicis -->
                            <xsl:when
                                test="not(matches($lemma,'er$','i')) and not(matches($paradigm,'^-e'))">
                                <xsl:element name="tei:iType">
                                    <xsl:attribute name="norm"
                                        select="concat('31-', lower-case(substring($lemma,string-length($lemma)-1)),'-is')"
                                    />
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="tei:iType">
                                    <xsl:attribute name="norm" select="'alia'"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- 3. Deklinacja: gravis, grave -->
                    <xsl:when test="matches($paradigm,'^-e')">
                        <xsl:element name="tei:iType">
                            <xsl:attribute name="norm" select="'32-is-is_e'"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="tei:iType">
                            <xsl:attribute name="norm" select="'alia'"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="tei:iType">
                    <xsl:attribute name="norm" select="'alia'"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Biblio: opracowanie siglów zawartych w tagu lmilp:Adres w pass8 -->
    <xsl:template name="biblio">
        <!-- Sąsiednie siglum na potrzeby ib./id. -->
        <xsl:variable name="siglum_ib">
            <xsl:if
                test="preceding::lmilp:Adres[not(matches(normalize-space(.),'^(I|i)(b|d)\.'))][1]">
                <xsl:variable name="string"
                    select="preceding::lmilp:Adres[not(matches(normalize-space(.),'^(I|i)(b|d)\.'))][1]"/>
                <xsl:analyze-string select="$string" regex="(.+)( ( pp*|fol ) \. )" flags="x">
                    <xsl:matching-substring>
                        <xsl:analyze-string select="regex-group(1)" regex="\[NRSTRONY:\s*\d+\]|\|">
                            <xsl:non-matching-substring>
                                <xsl:variable name="siglum_origin" select="normalize-space(translate(.,' ',''))"/>
                                <xsl:choose>
                                    <xsl:when test="key('sigla',$siglum_origin,doc('fontes/fontes.xml'))">
                                        <xsl:value-of select="$siglum_origin"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- Analizuje raz jeszcze wyjściowy łańcuch, by oddzielić oznaczenie tomu -->
                                        <xsl:analyze-string select="$siglum_origin"
                                            regex="^(.+)(\s[IVX]+\s*.*)$">
                                            <xsl:matching-substring>
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="key('sigla',normalize-space(translate(regex-group(1),'[ \*\|]','')),doc('fontes/fontes.xml'))">
                                                        <xsl:value-of
                                                            select="normalize-space(translate(regex-group(1),'[ \*]','')),'#',normalize-space(translate(regex-group(2),'[ \*]',''))"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of
                                                            select="."/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:matching-substring>
                                            
                                        </xsl:analyze-string>
                                    </xsl:otherwise>    
                                </xsl:choose>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:matching-substring>
                </xsl:analyze-string>
                
            </xsl:if>
        </xsl:variable>
        <xsl:element name="tei:bibl">
            <xsl:analyze-string select="."
                regex="(
            (.+)
            ( ( pp*|fol ) \. )
            ( \s* ( (\d+|[IVXCL]+) (a|b) | \d+ ) \s* )
            ( (,\s*)(v\.\s*)(\d+) )*
            ( \s* ( ,\s* | \( )* )*
            ( ( ( saec | a )+ \.+ \s* ( \d+ | [IVX]+ ( \s ( in|ex|med )\. )* ) ) )*
            (.+)*
            )"
                flags="x">
                <xsl:matching-substring>
                    <!-- Siglum -->
                    <xsl:element name="tei:ref">
                        <!-- Znormalizowana wartość siglum jako odnośnik do indeksu -->
                        <xsl:variable name="siglum_target">
                            <xsl:variable name="siglum_norm">
                                <xsl:if test="not ( matches (regex-group(2),'^\s*(I|i)(b|d)\.') )">
                                    <xsl:analyze-string select="regex-group(2)" regex="\[NRSTRONY:\s*\d+\]">
                                        <xsl:non-matching-substring>
                                            <!--<xsl:variable name="joined-strings" select="string-join(.)"/>-->
                                            <!--<xsl:value-of select="concat('aa',.,'bb')"></xsl:value-of>-->
                                            <xsl:variable name="siglum_origin" select="normalize-space(translate(.,' \*\|',''))"/>
                                            <xsl:choose>
                                                <xsl:when test="key('sigla',$siglum_origin,doc('fontes/fontes.xml'))">
                                                    <xsl:value-of select="concat('fons:',$siglum_origin)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- Analizuje raz jeszcze wyjściowy łańcuch, by oddzielić oznaczenie tomu -->
                                                    <xsl:analyze-string select="normalize-space(translate(.,'\*\|',''))"
                                                    regex="^(.+)(\s+[IVX]+(\s.*)*)$">
                                                        <xsl:matching-substring>
                                                        <xsl:choose>
                                                            <xsl:when
                                                                test="key('sigla',normalize-space(translate(regex-group(1),'[ \*]\|','')),doc('fontes/fontes.xml'))">
                                                                <xsl:value-of
                                                                    select="concat('fons:',normalize-space(translate(regex-group(1),'[ \*]\|','')),'#',normalize-space(translate(regex-group(2),'[ \*]','')))"
                                                                />
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="concat('fons:',normalize-space(translate(regex-group(1),'[ \*]','')),'#unknown#',normalize-space(translate(regex-group(2),'[ \*]\|','')))"
                                                                />
                                                                <!--<xsl:value-of
                                                                    select="concat('fons:',$siglum_origin,'#unknown')"/>-->
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:matching-substring>
                                                        <xsl:non-matching-substring>
                                                        <xsl:value-of
                                                            select="concat($siglum_origin,'#unknown')"/>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                                </xsl:otherwise>    
                                            </xsl:choose>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                </xsl:if>
                                <xsl:if test="matches (regex-group(2),'^\s*(I|i)(b|d)\.')">
                                            <xsl:value-of select="concat('fons:',$siglum_ib)"/>
                                </xsl:if>
                            </xsl:variable>
                            
                            <xsl:value-of select="$siglum_norm"/>
                            <!-- Znormalizowana wartość siglum ib./id. -->
                            <!--<xsl:choose>
                                <xsl:when test="key('sigla',$siglum_norm,doc('fontes/fontes.xml'))">
                                    <xsl:value-of select="concat('fons:',$siglum_norm)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                   
                                    <xsl:analyze-string select="$siglum_norm"
                                        regex="^(.+)(\s[IVX]+\s*.*)$">
                                        <xsl:matching-substring>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="key('sigla',normalize-space(translate(regex-group(1),'[ \*]','')),doc('fontes/fontes.xml'))">
                                                  <xsl:value-of
                                                  select="concat('fons:',normalize-space(translate(regex-group(1),'[ \*]','')),'#',normalize-space(translate(regex-group(2),'[ \*]','')))"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="concat('fons:',$siglum_norm,'#unknown')"/>

                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <xsl:value-of
                                                select="concat('fons:',$siglum_norm,'#unknown')"/>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                </xsl:otherwise>
                            </xsl:choose>
                        --></xsl:variable>

                        <xsl:attribute name="type" select="'siglum'"/>
                        <xsl:attribute name="target">
                            <xsl:value-of select="$siglum_target"/>
                        </xsl:attribute>
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:element>
                    <!-- Numer strony/folium -->
                    <xsl:element name="tei:biblScope">
                        <!-- Rodzaj numeracji: strona (pp) lub folium (fol) -->
                        <xsl:attribute name="type"
                            select="if ( matches(regex-group(3), 'p') ) then ( 'pp' ) else ( if ( matches(regex-group(3), 'fol')) then ('fol') else ('other') )"/>
                        <!--Znormalizowany numer strony/folium-->
                        <xsl:attribute name="n" select="normalize-space(regex-group(5))"/>
                        <xsl:value-of select="concat( regex-group(3), regex-group(5) )"/>
                    </xsl:element>
                    <xsl:if test="regex-group(9)">
                        <xsl:value-of select="regex-group(10)"/>
                        <xsl:element name="tei:biblScope">
                            <xsl:attribute name="type" select="'v'"/>
                            <xsl:attribute name="n" select="translate(regex-group(12),',','')"/>
                            <xsl:value-of select="concat(regex-group(11),regex-group(12))"/>
                        </xsl:element>
                    </xsl:if>
                    <!-- Data -->
                    <xsl:value-of select="regex-group(14)"/>
                    <xsl:element name="tei:time">
                        <xsl:value-of select="regex-group(15)"/>
                    </xsl:element>
                    <xsl:value-of select="concat(regex-group(20),regex-group(21))"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:element>
    </xsl:template>
    <!-- Obróbka etykiet - przypisanie rozwiązań w spisie skrótów -->
    <xsl:template
        match="tei:ref[@type='vocabularia']|tei:def|tei:emph|tei:label[@type ne 'numbering']|tei:biblScope|tei:time"
        mode="pass11" priority="10">
        <xsl:if test="self::tei:label[@type eq 'note']">
            <xsl:copy>
                <xsl:attribute name="type" select="'note'"/>
                <xsl:call-template name="label_target">
                    <xsl:with-param name="type" select="'note'"/>
                </xsl:call-template>
            </xsl:copy>
        </xsl:if>
        <xsl:if test="not(self::tei:label[@type eq 'note'])">
            <xsl:call-template name="label_target"/>
        </xsl:if>
        
    </xsl:template>
    <xsl:template name="label_target">
    <xsl:param name="type" required="no"/>
        <xsl:variable name="nextNodeBeginsWithPoint">
            <xsl:if test="matches(./following::node()[1],'^\.')">
                <xsl:value-of select="'TRUE'"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="self::tei:ref[@type='vocabularia']">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current"/>
                    <xsl:attribute name="target">
                        <xsl:choose>
                            <xsl:when
                                test="key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))">
                                <xsl:value-of
                                    select="concat('abbr:',key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/@xml:id)"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('abbr:','unknown')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="node()|@*|text()" mode="#current"/>
                </xsl:copy>
            </xsl:when>
            <!-- Zawarte w definicjach -->
            <xsl:when test="self::tei:def[matches(.,'(^|\s)\w+\.')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current"/>
                    <xsl:for-each select="node()|text()">
                        <xsl:choose>
                            <xsl:when test=".[not(self::text())]">
                                <xsl:copy-of select="."/>
                            </xsl:when>
                            <xsl:when test=".[self::text()]">
                                <xsl:analyze-string select="." regex="((\s|\W|^)(\w+\.))">
                                    <xsl:matching-substring>
                                        <xsl:choose>
                                            <xsl:when test="key('abbreviationes',normalize-space(regex-group(3)),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'dom']">
                                                <xsl:element name="tei:usg">
                                                  <xsl:attribute name="norm"
                                                  select="lmilp:nor_pun(.)"/>
                                                  <xsl:attribute name="type" select="'dom'"/>
                                                  <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                  <xsl:value-of select="regex-group(1)"/>
                                                </xsl:element>
                                            </xsl:when>
                                           
                                            <!-- Zawiera nazwę domeny (astr. itp.)? -->
                                            <xsl:when
                                                test=" key('abbreviationes',lower-case( normalize-space(regex-group(3)) ),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case( normalize-space(.) ), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'dom']">
                                                <xsl:element name="tei:usg">
                                                    <xsl:attribute name="norm"
                                                        select="lower-case(lmilp:nor_pun(.))"/>
                                                    <xsl:attribute name="type" select="'dom'"/>
                                                    <xsl:attribute name="target"
                                                        select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <!-- Zawiera nazwę pos? -->
                                            <xsl:when
                                                test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'pos']">
                                                <xsl:element name="tei:label">
                                                    <xsl:attribute name="norm"
                                                        select="lower-case(lmilp:nor_pun(.))"/>
                                                    <xsl:attribute name="type" select="'pos'"/>
                                                    <xsl:attribute name="target"
                                                        select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'label']">
                                                <xsl:element name="tei:label">
                                                    <xsl:attribute name="norm"
                                                        select="lower-case(lmilp:nor_pun(.))"/>
                                                    <xsl:attribute name="type" select="'label'"/>
                                                    <xsl:attribute name="target"
                                                        select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="key('abbreviationes',normalize-space(regex-group(3)),doc('fontes/abbreviationes.xml'))">
                                                        <xsl:element name="tei:label">
                                                            <xsl:attribute name="type"
                                                                select="key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/tei:abbr/@type"/>
                                                            <xsl:attribute name="target"
                                                                select="concat('abbr:',key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                            <xsl:value-of select="regex-group(1)"/>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:element name="tei:emph">
                                                            <xsl:value-of select="."/>
                                                        </xsl:element>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                            
                                           
                                        </xsl:choose>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:value-of select="."/>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>
            <!-- Zawarte w elementach kursywnych -->
            <xsl:when test="self::tei:emph[contains(.,'.')]">
                <xsl:for-each select="node()|text()">
                    <xsl:choose>
                        <xsl:when test=".[not(self::text())]">
                            <xsl:copy-of select="."/>
                        </xsl:when>
                        <xsl:when test=".[self::text()]">
                            <!-- Zachowujemy oryginalną nazwę elementu, by użyć dla non-matching -->
                            <xsl:variable name="orig" select="name(parent::*)"/>
                            <xsl:analyze-string select="." regex="((\s|\W|^)(\w+\.))">
                                <xsl:matching-substring>
                                    <xsl:choose>
                                        <!-- Zawiera nazwę domeny (astr. itp.)? -->
                                        <xsl:when
                                            test=" key('abbreviationes',lower-case( normalize-space(regex-group(3)) ),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case( normalize-space(.) ), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'dom']">
                                            <xsl:element name="tei:usg">
                                                <xsl:attribute name="norm"
                                                  select="lower-case(lmilp:nor_pun(.))"/>
                                                <xsl:attribute name="type" select="'dom'"/>
                                                <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <!-- Zawiera nazwę pos? -->
                                        <xsl:when
                                            test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'pos']">
                                            <xsl:element name="tei:label">
                                                <xsl:attribute name="norm"
                                                  select="lower-case(lmilp:nor_pun(.))"/>
                                                <xsl:attribute name="type" select="'pos'"/>
                                                <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when
                                            test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'label']">
                                            <xsl:element name="tei:label">
                                                <xsl:attribute name="norm"
                                                  select="lower-case(lmilp:nor_pun(.))"/>
                                                <xsl:attribute name="type" select="'label'"/>
                                                <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="key('abbreviationes',normalize-space(regex-group(3)),doc('fontes/abbreviationes.xml'))">
                                                  <xsl:element name="tei:label">
                                                  <xsl:attribute name="type"
                                                  select="key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/tei:abbr/@type"/>
                                                  <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                  <xsl:value-of select="regex-group(1)"/>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:element name="tei:emph">
                                                  <xsl:value-of select="."/>
                                                  </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                        <xsl:element name="{$orig}">
                                            <xsl:value-of select="."/>
                                        </xsl:element>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>

            </xsl:when>
            <!-- Zawarte w label -->
            <xsl:when test="self::tei:label[contains(.,'.')]">
                <xsl:for-each select="node()|text()">
                    <xsl:choose>
                        <xsl:when test=".[not(self::text())]">
                            <!--<xsl:copy-of select="."/>-->
                            <xsl:call-template name="label_target"/>
                        </xsl:when>
                        <xsl:when test=".[self::text()]">
                            <!-- Zachowujemy oryginalną nazwę elementu, by użyć dla non-matching -->
                            <xsl:variable name="orig" select="name(parent::*)"/>
                            <xsl:analyze-string select="." regex="((\s|\W|^)(\w+\.)\s*)">
                                <xsl:matching-substring>
                                    <xsl:choose>
                                        <!-- Zawiera nazwę domeny (astr. itp.)? -->
                                        <xsl:when
                                            test=" key('abbreviationes',lower-case( normalize-space(regex-group(3)) ),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case( normalize-space(.) ), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'dom']">
                                            <xsl:element name="tei:usg">
                                                <xsl:attribute name="norm"
                                                  select="lower-case(lmilp:nor_pun(.))"/>
                                                <xsl:attribute name="type" select="'dom'"/>
                                                <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <!-- Zawiera nazwę pos? -->
                                        <xsl:when
                                            test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'pos']">
                                            <xsl:element name="tei:label">
                                                <xsl:attribute name="norm"
                                                  select="lower-case(lmilp:nor_pun(.))"/>
                                                <xsl:attribute name="type" select="'pos'"/>
                                                <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when
                                            test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'label']">
                                            <xsl:element name="tei:label">
                                                <xsl:attribute name="norm"
                                                  select="lower-case(lmilp:nor_pun(.))"/>
                                                <xsl:attribute name="type" select="'label'"/>
                                                <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="key('abbreviationes',normalize-space(regex-group(3)),doc('fontes/abbreviationes.xml'))">
                                                  <xsl:element name="tei:label">
                                                  <xsl:attribute name="type"
                                                  select="key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/tei:abbr/@type"/>
                                                  <xsl:attribute name="target"
                                                  select="concat('abbr:',key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                  <xsl:value-of select="regex-group(1)"/>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:if test="$type eq 'note'">
                                                      <xsl:value-of select="."/>
                                                  </xsl:if>
                                                    <xsl:if test="not($type eq 'note')">
                                                        <xsl:element name="tei:label">
                                                            <xsl:attribute name="type" select="'label'"/>
                                                            <xsl:value-of select="."/>
                                                        </xsl:element>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:if test="$type eq 'note'">
                                        <xsl:value-of select="."/>
                                    </xsl:if>
                                    <xsl:if test="not($type eq 'note')">
                                        <xsl:element name="{$orig}">
                                            <xsl:value-of select="."/>
                                        </xsl:element>
                                    </xsl:if>
                                    
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <!-- Fol., p. -->
            <xsl:when test="self::tei:biblScope|self::tei:time">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current"/>
                    <xsl:analyze-string select="." regex="((\s|\W|^)(\w+\.))">
                        <xsl:matching-substring>
                            <xsl:choose>
                                <xsl:when
                                    test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'biblScope']">
                                    <xsl:element name="tei:label">
                                        <xsl:attribute name="type" select="'biblScope'"/>
                                        <xsl:attribute name="target"
                                            select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                        <xsl:value-of select="regex-group(1)"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                <xsl:when test="self::tei:emph[not(contains(.,'.'))] and $nextNodeBeginsWithPoint eq 'TRUE'">
                    <xsl:for-each select="node()|text()">
                        <xsl:choose>
                            <xsl:when test=".[not(self::text())]">
                                <xsl:copy-of select="."/>
                            </xsl:when>
                            <xsl:when test=".[self::text()]">
                                <!-- Zachowujemy oryginalną nazwę elementu, by użyć dla non-matching -->
                                <xsl:variable name="orig" select="name(parent::*)"/>
                                <xsl:analyze-string select="concat(.,'.')" regex="((\s|\W|^)(\w+\.))">
                                    <xsl:matching-substring>
                                        <xsl:choose>
                                            <!-- Zawiera nazwę domeny (astr. itp.)? -->
                                            <xsl:when
                                                test=" key('abbreviationes',lower-case( normalize-space(regex-group(3)) ),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case( normalize-space(.) ), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'dom']">
                                                <xsl:element name="tei:usg">
                                                    <xsl:attribute name="norm"
                                                        select="lower-case(lmilp:nor_pun(.))"/>
                                                    <xsl:attribute name="type" select="'dom'"/>
                                                    <xsl:attribute name="target"
                                                        select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <!-- Zawiera nazwę pos? -->
                                            <xsl:when
                                                test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'pos']">
                                                <xsl:element name="tei:label">
                                                    <xsl:attribute name="norm"
                                                        select="lower-case(lmilp:nor_pun(.))"/>
                                                    <xsl:attribute name="type" select="'pos'"/>
                                                    <xsl:attribute name="target"
                                                        select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="key('abbreviationes',lower-case(normalize-space(regex-group(3))),doc('fontes/abbreviationes.xml'))  and key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml') )[tei:abbr/@type eq 'label']">
                                                <xsl:element name="tei:label">
                                                    <xsl:attribute name="norm"
                                                        select="lower-case(lmilp:nor_pun(.))"/>
                                                    <xsl:attribute name="type" select="'label'"/>
                                                    <xsl:attribute name="target"
                                                        select="concat('abbr:',key('abbreviationes', lower-case(normalize-space(.)), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="key('abbreviationes',normalize-space(regex-group(3)),doc('fontes/abbreviationes.xml'))">
                                                        <xsl:element name="tei:label">
                                                            <xsl:attribute name="type"
                                                                select="key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/tei:abbr/@type"/>
                                                            <xsl:attribute name="target"
                                                                select="concat('abbr:',key('abbreviationes', normalize-space(.), doc('fontes/abbreviationes.xml'))/@xml:id)"/>
                                                            <xsl:value-of select="regex-group(1)"/>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:element name="tei:emph">
                                                            <xsl:value-of select="."/>
                                                        </xsl:element>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:element name="{$orig}">
                                            <xsl:value-of select="."/>
                                        </xsl:element>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    
                </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>    
                </xsl:choose>
                
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Pozbawia spacji i punktuacji -->
    <xsl:function name="lmilp:nor_pun">
        <xsl:param name="string"/>
        <xsl:value-of select="translate( normalize-space($string), '[., ]', '' )"/>
    </xsl:function>
    
    <xsl:template match="lmilp:Adres[parent::lmilp:grupaCytatu]" mode="pass12">
        <xsl:if test="matches(.,'^\s*')">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:call-template name="biblio"/>
        <xsl:if test="matches(.,'\s*$')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="lmilp:Adres[not(parent::lmilp:grupaCytatu)]" mode="pass12">
        <xsl:if test="matches(.,'^\s*')">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:element name="tei:cit">
            <xsl:attribute name="type" select="'inline'"/>
            <xsl:call-template name="biblio"/>
        </xsl:element>
        <xsl:if test="matches(.,'\s*$')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- Numery stron i wierszy -->
    <xsl:template match="node()/text()" mode="pass13">
        <xsl:analyze-string select="." regex="\|">
            <xsl:matching-substring>
                <xsl:element name="tei:milestone">
                    <xsl:attribute name="unit" select="'lb'"/>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="\[*NRSTRONY:\s*(\d+)\]*">
                    <xsl:matching-substring>
                        <xsl:element name="tei:milestone">
                            <xsl:attribute name="unit" select="'page'"/>
                            <xsl:attribute name="n" select="regex-group(1)"/>
                            <xsl:attribute name="xml:id" select="concat('v',$file,'.',regex-group(1))"/>
                        </xsl:element>
                        <xsl:element name="tei:milestone">
                            <xsl:attribute name="unit" select="'lb'"/>
                        </xsl:element>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <!-- Zliczanie liczby wierszy -->
    <xsl:template match="tei:milestone[@unit eq 'lb']" mode="pass14">
        <xsl:copy>
            <!-- Sprawdza xml:id strony -->
            <xsl:variable name="this_page_id" select="normalize-space(./preceding::tei:milestone[@unit eq 'page'][1]/@xml:id)"/>
            <!-- Sprawdza numer strony -->
            <xsl:variable name="this_page" select="./preceding::tei:milestone[@unit eq 'page'][1]/position()"/>
            <!-- Zlicza numer wiersza -->
            <xsl:variable name="self">
                <xsl:number level="any" from="tei:milestone[@unit eq 'page'][position() = $this_page]" count="tei:milestone[@unit eq 'lb']"/>
            </xsl:variable>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat( $this_page_id, '.', $self)"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <!-- Wyodrębnianie grup kolokacji-->
    <xsl:template match="tei:sense" mode="pass15">
        <xsl:copy>            
            <xsl:attribute name="orig" select="@orig"/>
            <xsl:attribute name="n" select="@n"/>
            <xsl:for-each-group select="node()|text()" 
                group-starting-with="tei:label[@target='abbr:sq.label'][preceding-sibling::*[normalize-space(.) ne ''][1][self::tei:label[@type='numbering']]]">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::tei:label[@target='abbr:sq.label'][preceding-sibling::*[normalize-space(.) ne ''][1][self::tei:label[@type='numbering']]]]">
                        <xsl:for-each-group select="current-group()" group-ending-with="tei:cit|tei:note">
                            <xsl:choose>
                                <xsl:when test="current-group()[last()][self::tei:cit|self::tei:note] and current-group()[1][self::tei:label[@target='abbr:sq.label']]">
                                    <xsl:element name="tei:gramGrp">
                                        <xsl:call-template name="extractPrepositionalColloc">
                                            <xsl:with-param name="tree">
                                                <xsl:apply-templates select="current-group()[position() lt last()]" mode="#current"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:apply-templates select="current-group()[position() = last()]" mode="#current"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                            <xsl:when test="current-group()[1][self::tei:label[@target='abbr:sq.label']]">
                                                <xsl:element name="tei:gramGrp">
                                                    <xsl:call-template name="extractPrepositionalColloc">
                                                        <xsl:with-param name="tree">
                                                            <xsl:apply-templates select="current-group()" mode="#current"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:element>
                                            </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="current-group()" mode="#current"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="pass15" select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each-group>
                
        </xsl:copy>
    </xsl:template>
    <xsl:template name="extractPrepositionalColloc">
        <xsl:param name="tree"/>
        <!--<tree><xsl:copy-of select="$tree"/></tree>
        -->
        <xsl:for-each select="$tree/node()">
            <xsl:choose>
                <xsl:when test="self::text()[preceding-sibling::*[normalize-space(.) ne ''][1][self::tei:label[@target='abbr:sq.label']]]">
                    <xsl:analyze-string select="." regex="(\s*\w+\s*)">
                        <xsl:matching-substring>
                            <xsl:element name="tei:gram">
                                <xsl:attribute name="type" select="'collocPrep'"/>
                                <xsl:attribute name="norm" select="normalize-space(regex-group(1))"/>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:element>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
                
        </xsl:for-each>
     
        <!--<xsl:copy>
            <xsl:apply-templates select="$tree"/>
        </xsl:copy>-->
        <!--
        <xsl:for-each select=""></xsl:for-each>-->
        <!--//tei:sense/tei:gramGrp/tei:label[@target='abbr:sq.label']/following-sibling::text()[normalize-space(.) ne ''][1]
        <tei:gramGrp>
            <tei:label norm="sq" type="label" target="abbr:sq.label">sq.</tei:label> sub <tei:label norm="c" type="label" target="abbr:c.label">c.</tei:label>
            <tei:label type="gram" target="abbr:abl.gram"> abl.</tei:label>
            <tei:emph> </tei:emph>
        </tei:gramGrp>-->
    </xsl:template>
    <!-- Wyodrębnia przyimek z sekwencji: sq. ... -->
        
</xsl:stylesheet>
<!--<regex>
    1:<xsl:value-of select="regex-group(1)"/>
    2:<xsl:value-of select="regex-group(2)"/>
    3:<xsl:value-of select="regex-group(3)"/>
    4:<xsl:value-of select="regex-group(4)"/>
    5:<xsl:value-of select="regex-group(5)"/>
    6:<xsl:value-of select="regex-group(6)"/>
    7:<xsl:value-of select="regex-group(7)"/>
    8:<xsl:value-of select="regex-group(8)"/>
    9:<xsl:value-of select="regex-group(9)"/>
    10:<xsl:value-of select="regex-group(10)"/>
    11:<xsl:value-of select="regex-group(11)"/>
    12:<xsl:value-of select="regex-group(12)"/>
    13:<xsl:value-of select="regex-group(13)"/>
    14:<xsl:value-of select="regex-group(14)"/>
    15:<xsl:value-of select="regex-group(15)"/>
    16:<xsl:value-of select="regex-group(16)"/>
    17:<xsl:value-of select="regex-group(17)"/>
    18:<xsl:value-of select="regex-group(18)"/>
    19:<xsl:value-of select="regex-group(19)"/>
</regex>-->