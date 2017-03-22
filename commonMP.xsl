<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="UTF-8"/>
    
    <!--Путь к справочникам отсчитывается относительно основного шаблона-->
    <xsl:param name="urlPrefixDict" select="'TP_v03/'"/>
    <!--Переменные-->
    <xsl:variable name="maxRows" select="number(56)"/>
    
    <xsl:template match="MP">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="ru">
            <head>
                <title>Межевой план</title>
                <meta name="Content-Style-Type" content="text/css"/>
                <script type="text/javascript" src="https://d3js.org/d3.v4.min.js"/>
                <style type="text/css">
                    body{color:#000;font-family:times new roman, arial, sans-serif;text-align:center}
                    table{border:0px; width:180mm; margin-left:auto; margin-right:auto; border-collapse:collapse;empty-cells:show}
                   
                    span.center{text-align:center}
                    div.title1{text-align:right;padding-right:10px;font-size:100%}
                    div.title2{margin-left:auto;margin-right:auto;font-size:100%;text-align:center;}
                    div.left{text-align:left;font-size:100%}
                    div.center{text-align:center;font-size:100%}
                    div.procherk{vertical-align:top;width:100%}
                    span.undestroke{padding-left:4px;padding-right:4px;border-bottom:1px solid #000}
                    object{width: 100%; height: 920px;}
                    embed{width: 100%; height: 920px;}
                    
                    th{
                    color:#000;
                    font-family:times new roman, arial, sans-serif;
                    font-size:10pt;
                    font-weight:400;
                    text-align:center;
                    }
                    td{
                    color:#000;
                    font-family:times new roman, arial, sans-serif;
                    font-size:10pt;
                    font-weight:400;
                    text-align:center;
                    }                    
                    .tbl_container{
                    width:100%;
                    border-collapse:collapse;
                    border:0px;
                    padding:1px
                    }
                    .tbl_section_sheet{
                    border:3px double #000;
                    padding:1px;
                    margin-bottom:-3px;
                    }
                    .tbl_section_sheet_header{
                    border-left-width: 3px;
                    border-left-style: double;
                    border-right-width: 3px;
                    border-right-style: double;
                    border-top-width: 3px;
                    border-top-style: double;
                    padding:1px;
                    margin-bottom:-1px;
                    }
                    .tbl_section_sheet_data{
                    border-left-width: 3px;
                    border-left-style: double;
                    border-right-width: 3px;
                    border-right-style: double;
                    border-bottom-width: 3px;
                    border-bottom-style: double;
                    padding:1px;
                    }                    
                    .tbl_section_sheet th, .tbl_section_sheet td, 
                    .tbl_section_sheet_header th, .tbl_section_sheet_header td, 
                    .tbl_section_sheet_data th, .tbl_section_sheet_data td{
                    border:1px solid #000;
                    vertical-align:middle;
                    margin:0;
                    padding:3px 3px;
                    }
                    .tbl_section_sheet_header th.col5mm,.tbl_section_sheet_header td.col5mm,
                    .tbl_section_sheet_data th.col5mm,.tbl_section_sheet_data td.col5mm
                    {width: 5mm}
                    .tbl_section_sheet_header th.col105mm,.tbl_section_sheet_header td.col105mm,
                    .tbl_section_sheet_data th.col105mm,.tbl_section_sheet_data td.col105mm{width: 105mm}
                    .tbl_section_sheet_data th.col300px,.tbl_section_sheet_data td.col300px{width: 300px}
                    .tbl_section_sheet_data th.col400px,.tbl_section_sheet_data td.col400px{width: 400px}
                    .tbl_section_sheet_header th.left,.tbl_section_sheet_header td.left,
                    .tbl_section_sheet_data th.left,.tbl_section_sheet_data td.left{text-align:left}
                    
                    .tbl_section_sheet th.left,.tbl_section_sheet td.left{text-align:left}
                    .tbl_section_sheet th.vtop,.tbl_section_sheet td.vtop{vertical-align:top}
                    .tbl_section_sheet th.vborder0,.tbl_section_sheet td.vborder0{border-left: 0px;border-right: 0px;}
                    .tbl_section_sheet th.gborder0,.tbl_section_sheet td.gborder0{border-bottom: 0px;border-top: 0px;}
                    .tbl_section_sheet th.col5mm,.tbl_section_sheet td.col5mm{width: 5mm}
                    .tbl_section_sheet th.col200px,.tbl_section_sheet td.col200px{width: 200px}
                    .tbl_section_sheet th.col300px,.tbl_section_sheet td.col300px{width: 300px}
                    .tbl_section_sheet th.col400px,.tbl_section_sheet td.col400px{width: 400px}
                    DIV.conclusion{width: 668px; overflow: scroll;}
                </style>
                <style type="text/css">
                    rect{
                    fill:none;
                    pointer-events:all;                    
                    }
                    .points{
                    fill:green;
                    stroke:black;
                    }
                    .polylines{
                    fill:none;
                    stroke:black;
                    stroke-width:0.5;
                    }
                    .polygons{
                    fill:gray;
                    stroke:none;
                    stroke-width:0.1;
                    mix-blend-mode: color-dodge;
                    }
                </style>
                <style type="text/css">
                    input{
                    width: 95%;
                    margin: 0;
                    border: 0px solid #C0C0C0;
                    border-bottom: 0px solid #B0B0B0;
                    padding: 4px;
                    font-size: 10pt;
                    font-family: times new roman, arial, sans-serif;
                    font-weight: 400;
                    line-height: 10pt;                        
                    }
                    #date_center {
                    text-align: center;
                    text-decoration: underline;
                    }
                    a.plan{
                    text-decoration: none;
                    }
                </style>
            </head>
            <body>
                <table>
                    <tbody>
                        <tr>
                            <th class="vtop">
                                <table class="tbl_container">
                                    <tbody>
                                        <tr>
                                            <th>
                                                <div>
                                                    <xsl:apply-templates select="GeneralCadastralWorks"/>
                                                    <xsl:apply-templates select="InputData"/>
                                                </div>
                                            </th>
                                        </tr>
                                    </tbody>
                                </table>
                            </th>
                        </tr>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="GeneralCadastralWorks">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'МЕЖЕВОЙ ПЛАН'"/>
        </xsl:call-template>
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Общие сведения о кадастровых работах'"/>
        </xsl:call-template>
        <table class="tbl_section_sheet">
            <tbody>
                <tr>
                    <th class="left gborder0">
                        <b>1. Межевой план подготовлен в результате выполнения кадастровых работ в связи с:</b>
                    </th>
                </tr>
                <tr>
                    <td class="left gborder0">
                        <xsl:value-of select="Reason"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_sheet">
            <tbody>
                <tr>
                    <th class="left gborder0">
                        <b>2. Цель кадастровых работ:</b>
                    </th>
                </tr>
                <tr>
                    <td class="left gborder0">
                        <xsl:choose>
                            <xsl:when test="Purpose">
                                <xsl:value-of select="Purpose"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="procherk"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_sheet">
            <tbody>
                <tr>
                    <th class="left gborder0">
                        <b>3. Сведения о заказчике кадастровых работ:</b>
                    </th>
                </tr>
                <tr>
                    <td class="left gborder0"> 
                        <xsl:for-each select="Clients/Client">            
                            <xsl:choose>
                                <xsl:when test="Person">
                                    <xsl:call-template name="fio">
                                        <xsl:with-param name="familyName"
                                            select="Person/FamilyName"/>
                                        <xsl:with-param name="firstName"
                                            select="Person/FirstName"/>
                                        <xsl:with-param name="patronymic"
                                            select="Person/Patronymic"/>
                                    </xsl:call-template>
                                    <xsl:choose>
                                        <xsl:when test="Person/SNILS">
                                            <xsl:value-of select="Person/SNILS"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="Person/Address"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="Organization">
                                    <xsl:call-template name="tIdentify">
                                        <xsl:with-param name="identify" select="Organization"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="Governance">
                                    <xsl:call-template name="tIdentify">
                                        <xsl:with-param name="identify" select="Governance"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="ForeignOrganization">
                                    <xsl:call-template name="tIdentify">
                                        <xsl:with-param name="identify" select="Governance"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="Governance/Country"/>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="position() != last()">
                                <xsl:value-of select="'; '"/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_sheet">
            <tr>
                <th colspan="2" class="left">
                    <b>3. Сведения о кадастровом инженере:</b>
                </th>               
            </tr>
            <tr>
                <td  class="left vborder0">
                    <xsl:text>Фамилия, имя, отчество </xsl:text>
                    <i>(при наличии отчества) </i>
                </td>
                <td  class="left vborder0">
                    <ins>
                        <xsl:call-template name="fio">
                            <xsl:with-param name="familyName"
                                select="Contractor/FamilyName"/>
                            <xsl:with-param name="firstName"
                                select="Contractor/FirstName"/>
                            <xsl:with-param name="patronymic"
                                select="Contractor/Patronymic"/>
                        </xsl:call-template>
                    </ins>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>Страховой номер индивидуального лицевого счета </xsl:text>
                </td>
                <td class="left vborder0">
                    <input type="text"/>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>N регистрации в государственном реестре лиц, осуществляющих кадастровую деятельность</xsl:text>
                </td>
                <td class="left vborder0">
                    <input type="text"/>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>Контактный телефон</xsl:text>
                </td>
                <td class="left vborder0">
                    <ins>
                        <xsl:value-of select="Contractor/Telephone"/>
                    </ins>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>Почтовый адрес и адрес электронной почты, по которым осуществляется связь с кадастровым инженером</xsl:text>
                </td>
                <td class="left vborder0">
                    <ins>
                        <xsl:value-of select="Contractor/Address"/>
                        <xsl:value-of select="concat(' ',Contractor/Email)"/>
                    </ins>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>Наименование саморегулируемой организации кадастровых инженеров, членом которой является кадастровый инженер</xsl:text>
                </td>
                <td class="left vborder0">
                    <input type="text"/>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>Сокращенное наименование юридического лица, если кадастровый инженер является работником юридического лица</xsl:text>
                </td>
                <td class="left vborder0">
                    <xsl:choose>
                        <xsl:when test="Contractor/Organization">
                            <ins>
                                <xsl:value-of select="Contractor/Organization/Name"/>
                            </ins>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="procherk"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>N и дата заключения договора на выполнение кадастровых работ</xsl:text>
                </td>
                <td class="left vborder0">
                    <input type="text"/>
                </td>
            </tr>
            <tr>
                <td class="left vborder0">
                    <xsl:text>Дата подготовки технического плана (число, месяц, год)</xsl:text>                    
                </td>
                <td class="left vborder0">
                    <xsl:value-of select="substring(@DateCadastral, 9, 2)"
                    />.<xsl:value-of select="substring(@DateCadastral, 6, 2)"
                    />.<xsl:value-of select="substring(@DateCadastral, 1, 4)"/> 
                </td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="InputData">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Исходные данные'"/>
        </xsl:call-template>
        <table class="tbl_section_sheet_header">
            <tbody>
                <tr>
                    <th colspan="3" class="left">
                        <b>1. Перечень документов, использованных при подготовке технического плана</b>
                    </th>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th class="col105mm">Наименование документа</th>
                        <th>Реквизиты документа</th>
                    </tr>
                </tr>
            </tbody>                        
        </table>
        <table class="tbl_section_sheet_data">
            <thead>                
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col105mm">2</th>
                    <th>3</th>
                </tr>
            </thead>
            <tbody>                
                <xsl:apply-templates select="Documents">
                    <xsl:with-param name="printRow" select="number(6)"/>
                </xsl:apply-templates>
            </tbody>
        </table>

        
    </xsl:template>



    <!-- *******************InputData************************* -->    
    <xsl:template match="Documents">
        <xsl:param name="printRow"/>
        <xsl:for-each select="Document">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td class="left">
                    <xsl:value-of select="Name"/>
                    <xsl:variable name="documents" select="document(concat($urlPrefixDict, 'dAllDocuments_v02.xsd'))"/>
                    <xsl:variable name="code" select="CodeDocument"/>
                    <xsl:value-of select="concat(' (', $documents//xs:enumeration[@value = $code]/xs:annotation/xs:documentation, ')')"/>
                </td>
                <td class="left">
                    <xsl:value-of select="concat('№ ', Number, ' от ', Date)"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
   


    <xsl:template name="newPage">
        <div style="page-break-after:always"> </div>
    </xsl:template>
    <xsl:template name="tIdentify">
        <xsl:param name="identify"/>
        <xsl:value-of select="concat($identify/Name,', ',$identify/OGRN,', ',$identify/INN)"/>
    </xsl:template>
    <xsl:template name="fio">
        <xsl:param name="familyName"/>
        <xsl:param name="firstName"/>
        <xsl:param name="patronymic"/>
        <xsl:choose>
            <xsl:when test="$patronymic">
                <xsl:value-of select="concat($familyName, ' ', $firstName, ' ', $patronymic,' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($familyName, ' ', $firstName,' ')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="procherk">
        <div class="procherk">
            <b>&#x2015;</b>
        </div>
    </xsl:template>   
    <xsl:template name="header1">
        <xsl:param name="text1"/>
        <xsl:param name="text2"/>
        <table class="tbl_section_sheet">
            <tbody>
                <tr>
                    <td>
                        <b style="font-size: 14px;">
                            <xsl:value-of select="$text1"/>
                        </b>
                        <xsl:if test="$text2">
                            <br />
                            <b style="font-size: 14px;">
                                <xsl:value-of select="$text2"/>
                            </b>
                        </xsl:if>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>