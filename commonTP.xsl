<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="UTF-8"/>

    <!--Путь к справочникам отсчитывается относительно основного шаблона-->
    <xsl:param name="urlPrefixDict" select="'TP_v03/'"/>
    <!--Переменные-->
    <xsl:variable name="maxRows" select="number(50)"/>
    <!--Здание-->
    <xsl:variable name="building" select="TP/Building"/>
    <xsl:variable name="newBuildings" select="TP/Building/Package/NewBuildings"/>
    <xsl:variable name="newApartHouse" select="TP/Building/Package/NewApartHouse"/>
    <xsl:variable name="existBuilding" select="TP/Building/Package/ExistBuilding"/>
    <xsl:variable name="subBuildings" select="TP/Building/Package/SubBuildings"/>
    <!--Сооружение-->
    <xsl:variable name="construction" select="TP/Construction"/>
    <xsl:variable name="newConstructions" select="TP/Construction/Package/NewConstructions"/>
    <xsl:variable name="existConstruction" select="TP/Construction/Package/ExistConstruction"/>
    <xsl:variable name="subConstructions" select="TP/Construction/Package/SubConstructions"/>
    <!--Незавершенное строительство-->
    <xsl:variable name="uncompleted" select="TP/Uncompleted"/>
    <xsl:variable name="newUncompleteds" select="TP/Uncompleted/Package/NewUncompleteds"/>
    <xsl:variable name="existUncompleted" select="TP/Uncompleted/Package/ExistUncompleted"/>
    <xsl:variable name="subUncompleteds" select="TP/Uncompleted/Package/SubUncompleteds"/>
    <!--Помещение-->
    <xsl:variable name="flat" select="TP/Flat"/>
    <xsl:variable name="newFlats" select="TP/Flat/Package/NewFlats"/>
    <xsl:variable name="existFlat" select="TP/Flat/Package/ExistFlat"/>
    <xsl:variable name="subFlats" select="TP/Flat/Package/SubFlats"/>
    <!-- Перечисления -->
    <xsl:key name="geopointElements" match="GeopointsOpred/Element" use="@Number"/>
    <xsl:key name="tochnGeopointElements" match="TochnGeopointsBuilding/Element |
        TochnGeopointsConstruction/Element | TochnGeopointsUncompleted/Element" use="@Number"/>
    <xsl:key name="tochnGeopointsSubElements" match="TochnGeopointsSubBuilding/Element |
        TochnGeopointsSubConstruction/Element | TochnGeopointsSubUncompleted/Element" use="@Number"/>

    <xsl:template match="TP">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="ru">
            <head>
                <title>Технический план</title>
                <meta name="Content-Style-Type" content="text/css"/>
                <script type="text/javascript" src="http://d3js.org/d3.v4.min.js"/>
                <style type="text/css">
                    body{
                    background-color: #fff;
                    color: #000;
                    font-family: times new roman, arial, sans-serif;
                    text-align: center;
                    }
                    th{
                    color: #000;
                    font-family: times new roman, arial, sans-serif;
                    font-size: 10pt;
                    font-weight: 400;
                    text-align: center
                    }
                    td{
                    color: #000;
                    font-family: times new roman, arial, sans-serif;
                    font-size: 10pt;
                    font-weight: 400
                    }
                    table{
                    <!--border-collapse: collapse;-->
                    border-spacing: 0;
                    empty-cells: show;
                    }
                    object{
                        width: 100%; height: 1010px;
                    }
                    embed{
                        width: 100%; height: 1010px;
                    }
                    .understroke{
                    border-bottom: solid;
                    border-bottom-width: 1px
                    }
                    .topstroke{
                    border-top: solid;
                    border-top-width: 1px;
                    text-align: center;
                    vertical-align: top;
                    font: normal xx-small Arial, Verdana, Geneva, Helvetica, sans-serif;
                    width: 90%;
                    margin: 0 auto
                    }
                    .isOverPage{
                        page-break-after: auto; 
                        page-break-inside: avoid;
                    }
                    .tbl_section_title{
                    width: 100%;
                    border-width: 4px 4px 1px 4px;
                    border-style: double double solid double;
                    border-color: #000;
                    margin-top: -4px;
                    text-align: left;
                    page-break-after: auto;
                    page-break-inside: avoid;
                    }
                    .tbl_section_title TD{
                    font: bold small Arial, Verdana, Geneva, Helvetica, sans-serif;
                    margin: 0;
                    padding: 10px 3px;
                    }
                    .tbl_section_title TH{
                    border-width: 1px 1px 0px 0px;
                    border-style: solid;
                    border-color: #000;
                    }
                    .tbl_section_title TH:last-child{
                    border-right: 0px;
                    }
                    .tbl_section_title TR:first-child TH{
                    border-top: 0px;
                    }
                    .tbl_section_content{                        
                    width: 100%;
                    border-width: 0px 4px 4px 4px;
                    border-style: double;
                    border-color: #000;
                    margin-top: -1px;
                    text-align: left;
                    }
                    .tbl_section_content TD{
                    border-width: 1px 1px 0px 0px;
                    border-style: solid;
                    border-color: #000;
                    font: normal 10pt Arial, Verdana, Geneva, Helvetica, sans-serif;
                    vertical-align: middle;
                    margin: 0;
                    padding: 4px 3px;
                    }
                    .tbl_section_content TD:last-child{
                    border-right: 0px;
                    }
                    .tbl_section_content TR:first-child TD{
                    border-top: 0px;
                    }
                    .tbl_section_content TR:last-child TD{
                    border-bottom: 0px;
                    }
                    .tbl_section_content TH{
                    border-width: 1px 1px 1px 0px;
                    border-style: solid;
                    border-color: #000;
                    font-family: times new roman, arial, sans-serif;
                    font-size: 10pt;
                    font-weight: 400;
                    text-align: center;
                    }
                    .tbl_section_content TH:last-child{
                    border-right: 0px;
                    }
                    
                    th.col5mm,td.col5mm{width: 5mm}
                    th.col7mm,td.col7mm{width: 7mm}
                    th.col7-5mm,td.col7-5mm{width: 7.5mm}
                    th.col10mm,td.col10mm{width: 10mm}
                    th.col15mm,td.col15mm{width: 15mm}
                    th.col20mm,td.col20mm{width: 20mm}
                    th.col25mm,td.col25mm{width: 25mm}
                    th.col30mm,td.col30mm{width: 30mm}
                    th.col35mm,td.col35mm{width: 35mm}
                    th.col40mm,td.col40mm{width: 40mm}
                    th.col50mm,td.col50mm{width: 50mm}
                    th.col55mm,td.col55mm{width: 55mm}
                    th.col60mm,td.col60mm{width: 60mm}
                    th.col80mm,td.col80mm{width: 80mm}
                    th.col105mm,td.col105mm{width: 105mm}
                    
                    .small_text{
                    font: normal xx-small Arial, Verdana, Geneva, Helvetica, sans-serif;
                    text-align: center
                    }
                    .windows{
                    height: 300px;
                    overflow-y: auto;
                    overflow-x: hidden;
                    scrollbar-face-color: #ccc;
                    scrollbar-shadow-color: #000;
                    scrollbar-highlight-color: #fff;
                    scrollbar-arrow-color: #000;
                    scrollbar-base-color: Gray;
                    scrollbar-3dlight-color: #eee;
                    scrollbar-darkshadow-color: #333;
                    scrollbar-track-color: #999
                    }
                    div.conclusion{
                    word-break: break-all;
                    }
                    .pole{
                        width: 90%;
                    }
                </style>
                <style type="text/css">
                    svg{
                        background-color: black;
                        margin-top: 2px;
                    }
                    rect{
                        fill: none;
                        pointer-events: all;
                    }
                    .points0{
                        fill: green;
                        stroke: green;
                    }
                    .points1{
                        fill: lightgreen;
                        stroke: lightgreen;
                    }
                    .points2{
                        fill: greenyellow;
                        stroke: greenyellow;
                    }
                    .polylines0{
                        fill: none;
                        stroke: white;
                        stroke-width: 0.5;
                    }
                    .polylines1{
                        fill: none;
                        stroke: white;
                        stroke-width: 0.5;
                        stroke-dasharray: 5, 1, 0.5, 1, 0.5, 1;
                    }
                    .polylines2{
                        fill: none;
                        stroke: white;
                        stroke-width: 0.5;
                        stroke-dasharray: 5, 1, 0.5, 1;
                    }<!--
                    g.polygons{
                        -webkit-filter: invert(100%);
                        filter: invert(100%);
                    }-->
                    .polygons0{
                        fill: gray;
                        stroke: none;
                        stroke-width: 0.1;
                        mix-blend-mode: difference;
                    }
                    .polygons1{
                        fill: lightgray;
                        stroke: none;
                        stroke-width: 0.1;
                        mix-blend-mode: difference;
                    }
                    .polygons2{
                        fill: darkgray;
                        stroke: none;
                        stroke-width: 0.1;
                        mix-blend-mode: difference;
                    }
                    .pointsE{
                        fill: red;
                        stroke: red;
                    }</style>
                <style type="text/css">
                    @media print{
                        .pole{
                                width: 95%;
                                text-decoration: underline;
                                border: 0px solid #C0C0C0;
                                font-family: inherit;
                                font-size: inherit;
                        }
                        .zone {
                            text-decoration: underline;
                            width: 25%;
                        }
                        .date_center {
                            text-align: center;
                            text-decoration: underline;
                        }
                        a.plan {
                            text-decoration: none;
                        }
                        .notPrint{
                            display:none
                        }
                    }
                </style>
            </head>
            <body>
                <div style="margin:0 auto; width: 200mm;">
                    <div class="small_text" style="margin-bottom: 5px;text-align: left;">
                        <xsl:value-of select="//comment()"/>
                    </div>                    
                    <xsl:choose>
                        <xsl:when test="descendant::Building">                            
                            <xsl:call-template name="header1">
                                <xsl:with-param name="text1" select="'ТЕХНИЧЕСКИЙ ПЛАН'"/>
                                <xsl:with-param name="text2" select="'ЗДАНИЯ'"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$building"/>
                        </xsl:when>
                        <xsl:when test="descendant::Construction">
                            <xsl:call-template name="header1">
                                <xsl:with-param name="text1" select="'ТЕХНИЧЕСКИЙ ПЛАН'"/>
                                <xsl:with-param name="text2" select="'СООРУЖЕНИЯ'"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$construction"/>
                        </xsl:when>
                        <xsl:when test="descendant::Uncompleted">
                            <xsl:call-template name="header1">
                                <xsl:with-param name="text1" select="'ТЕХНИЧЕСКИЙ ПЛАН'"/>
                                <xsl:with-param name="text2"
                                    select="'ОБЪЕКТ НЕЗАВЕРШЕННОГО СТРОИТЕЛЬСТВА'"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$uncompleted"/>
                        </xsl:when>
                        <xsl:when test="descendant::Flat">
                            <xsl:call-template name="header1">
                                <xsl:with-param name="text1" select="'ТЕХНИЧЕСКИЙ ПЛАН'"/>
                                <xsl:with-param name="text2" select="'ПОМЕЩЕНИЯ'"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$flat"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td>НЕВЕРНЫЙ ХМЛ ФАЙЛ</td>
                            </tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <xsl:if test="//EntitySpatial">
                    <xsl:call-template name="GenerateMap">
                        <xsl:with-param name="entitySpatial" select="//EntitySpatial"></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Building | Construction | Uncompleted | Flat">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Общие сведения о кадастровых работах'"/>
        </xsl:call-template>
        <xsl:apply-templates select="GeneralCadastralWorks"/>
        <xsl:apply-templates select="InputData"/>
        <xsl:apply-templates select="Survey"/>
        <xsl:choose>
            <xsl:when test="$newBuildings">
                <xsl:for-each select="$newBuildings/NewBuilding">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$newApartHouse">
                <xsl:apply-templates select="$newApartHouse/NewBuilding"/>
                <xsl:for-each select="$newApartHouse/Flats/Flat">
                    <xsl:call-template name="Characteristics">
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$existBuilding">
                <xsl:apply-templates select="$existBuilding"/>                
            </xsl:when>
            <xsl:when test="$subBuildings">
                <xsl:apply-templates select="$subBuildings"/>
            </xsl:when>
            <xsl:when test="$newConstructions">
                <xsl:for-each select="$newConstructions/NewConstruction">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>                
            </xsl:when>
            <xsl:when test="$existConstruction">
                <xsl:apply-templates select="$existConstruction"/>
            </xsl:when>
            <xsl:when test="$subConstructions">
                <xsl:apply-templates select="$subConstructions"/>
            </xsl:when>
            <xsl:when test="$newUncompleteds">
                <xsl:for-each select="$newUncompleteds/NewUncompleted">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>                
            </xsl:when>
            <xsl:when test="$existUncompleted">
                <xsl:apply-templates select="$existUncompleted"/>
            </xsl:when>
            <xsl:when test="$subUncompleteds">
                <xsl:apply-templates select="$subUncompleteds"/>
            </xsl:when>
            <xsl:when test="$newFlats">
                <xsl:for-each select="$newFlats/NewFlat">
                    <xsl:apply-templates select="."></xsl:apply-templates>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$existFlat">
                <xsl:apply-templates select="$existFlat"/>
            </xsl:when>
            <xsl:when test="$subFlats">
                <xsl:apply-templates select="$subFlats"/>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="Conclusion"/>
        <xsl:apply-templates select="SchemeGeodesicPlotting"/>
        <xsl:apply-templates select="SchemeDisposition"/>
        <xsl:apply-templates select="DiagramContour"/>
        <xsl:apply-templates select="Appendix"/>                
    </xsl:template>
    <xsl:template match="GeneralCadastralWorks">
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td>
                        <b>1. Технический план подготовлен в результате выполнения кадастровых работ в связи с:</b>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td >
                        <xsl:value-of select="Reason"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td>
                        <b>2. Сведения о заказчике кадастровых работ</b>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td style="text-align: center; width: 100%; border: none;">
                        <div class="understroke">
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
                        </div>
                        <div class="small_text"> (фамилия, имя, отчество (при наличии отчества)
                            физического лица, страховой номер индивидуального лицевого счета (при
                            наличии), полное наименование юридического лица, органа государственной
                            власти, органа местного самоуправления, иностранного юридического лица с
                            указанием страны его регистрации (инкорпорации)) </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td>
                        <b>3. Сведения о кадастровом инженере:</b>
                    </td>               
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td width="50%" > Фамилия, имя, отчество (при
                        наличии отчества) </td>
                    <td width="50%" >
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
                    <td width="50%" >
                        <xsl:text>Страховой номер индивидуального лицевого счета </xsl:text>
                    </td>
                    <td width="50%" >
                        <xsl:call-template name="inputText"/>
                    </td>
                </tr>
                <tr>
                    <td width="50%" >
                        <xsl:text>Уникальный регистрационный номер члена саморегулируемой организации кадастровых инженеров в реестре членов саморегулируемой организаци кадастровых инженеров и дата внесения сведений о физическом лице в такой реестр</xsl:text>
                    </td>
                    <td width="50%" >
                        <xsl:call-template name="inputText"/>
                    </td>
                </tr>
<!--                <tr>
                    <td width="50%" >
                        <xsl:text>N регистрации в государственном реестре лиц, осуществляющих кадастровую деятельность</xsl:text>
                    </td>
                    <td width="50%" >
                        <xsl:call-template name="inputText"/>
                    </td>
                </tr>-->
                <tr>
                    <td width="50%" >
                        <xsl:text>Контактный телефон</xsl:text>
                    </td>
                    <td width="50%" >
                        <ins>
                            <xsl:value-of select="Contractor/Telephone"/>
                        </ins>
                    </td>
                </tr>
                <tr>
                    <td width="50%" >
                        <xsl:text>Почтовый адрес и адрес электронной почты, по которым осуществляется связь с кадастровым инженером</xsl:text>
                    </td>
                    <td width="50%" >
                        <ins>
                            <xsl:value-of select="Contractor/Address"/>
                            <xsl:value-of select="concat(' ',Contractor/Email)"/>
                        </ins>
                    </td>
                </tr>
                <tr>
                    <td width="50%" >
                        <xsl:text>Наименование саморегулируемой организации кадастровых инженеров, членом которой является кадастровый инженер</xsl:text>
                    </td>
                    <td width="50%" >
                        <xsl:call-template name="inputText"/>
                    </td>
                </tr>
                <tr>
                    <td width="50%" >
                        <xsl:text>Полное или (в случае, если имеется) сокращенное наименование юридического лица, если кадастровый инженер является работником юридического лица, адрес юридического лица</xsl:text>
                    </td>
                    <td width="50%" >
                        <xsl:choose>
                            <xsl:when test="Contractor/Organization">
                                <ins>
                                    <xsl:value-of select="Contractor/Organization/Name"/>
                                    <br />
                                    <xsl:value-of select="Contractor/Organization/AddressOrganization"/>
                                </ins>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="procherk"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td width="50%" >
                        <xsl:text>Наименование, номер и дата документа, на основании которого выполняются кадастровые работы</xsl:text>
                    </td>
                    <td width="50%" >
                        <xsl:call-template name="inputText">
                            <xsl:with-param name="textarea" select="'true'"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td width="50%" >
                        <xsl:text>Дата подготовки технического плана (число, месяц, год)</xsl:text>                    
                    </td>
                    <td width="50%" >
                        <ins>
                            <xsl:value-of select="concat(substring(@DateCadastral, 9, 2), '.')"/>
                            <xsl:value-of select="concat(substring(@DateCadastral, 6, 2), '.')"/>
                            <xsl:value-of select="substring(@DateCadastral, 1, 4)"/>
                        </ins>
                    </td>
                </tr>                
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="InputData">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Исходные данные'"/>
        </xsl:call-template>
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td colspan="3">
                        <b>1. Перечень документов, использованных при подготовке технического плана</b>
                    </td>
                </tr>
                <tr>
                    <th class="col5mm">№<br/>п/п</th>
                    <th class="col105mm">Наименование документа</th>
                    <th>Реквизиты документа</th>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col105mm">2</th>
                    <th>3</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="Documents">
                        <xsl:apply-templates select="Documents"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="8" class="left">
                            <b>2. Сведения о геодезической основе, использованной при подготовке технического плана
                                <br />
                                <xsl:text>Система координат </xsl:text>
                                <ins>
                                    <xsl:for-each select="preceding-sibling::CoordSystems/CoordSystem">
                                        <xsl:value-of select="@Name"/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </ins>                                
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="2" class="col5mm">№<br/>п/п</th>
                        <th rowspan="2">Название пункта и тип знака геодезической сети</th>
                        <th rowspan="2" class="col25mm">Класс геодезической сети</th>
                        <th colspan="2" class="col40mm">Координаты, м</th>
                        <th colspan="3" class="col60mm">Сведения о состоянии на 
                            <xsl:call-template name="inputText">
                                <xsl:with-param name="date_center" select="'true'"/>
                            </xsl:call-template>
                        </th>
                    </tr>            
                    <tr>
                        <th class="col20mm">X</th>
                        <th class="col20mm">Y</th>
                        <th class="col20mm">наружного знака пункта</th>
                        <th class="col20mm">центра пункта</th>
                        <th class="col20mm">марки</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th>2</th>
                    <th class="col25mm">3</th>
                    <th class="col20mm">4</th>
                    <th class="col20mm">5</th>
                    <th class="col20mm">6</th>
                    <th class="col20mm">7</th>
                    <th class="col20mm">8</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="GeodesicBases">
                        <xsl:apply-templates select="GeodesicBases"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="4" class="left">
                            <b>3. Сведения о средствах измерений</b>
                        </td>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th class="col55mm">Наименование прибора (инструмента, аппаратуры)</th>
                        <th class="col55mm">Сведения об утверждении типа средств измерений</th>
                        <th>Реквизиты свидетельства о поверке прибора (инструмента, аппаратуры)</th>
                    </tr>
            </tbody>
                </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col55mm">2</th>
                    <th class="col55mm">3</th>
                    <th>4</th>
                </tr>
            </thead>
             <tbody>
                 <xsl:choose>
                     <xsl:when test="MeansSurvey">
                         <xsl:apply-templates select="MeansSurvey"/>
                     </xsl:when>
                     <xsl:otherwise>
                         <tr>
                             <td><xsl:call-template name="procherk"/></td>
                             <td><xsl:call-template name="procherk"/></td>
                             <td><xsl:call-template name="procherk"/></td>
                             <td><xsl:call-template name="procherk"/></td>
                         </tr>
                     </xsl:otherwise>
                 </xsl:choose>                 
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="2" class="left">
                            <b>4. Сведения об объекте (объектах) недвижимости, из которого (которых) был образован объект недвижимости</b>
                        </td>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th>Кадастровый номер</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th>2</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>            
                    <xsl:when test="preceding-sibling::Package//PrevCadastralNumbers">
                        <xsl:for-each select="preceding-sibling::Package//PrevCadastralNumbers/CadastralNumber">
                            <tr>
                                <td><xsl:value-of select="position()"/></td>
                                <td><xsl:value-of select="."/></td>
                            </tr>                            
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="2" class="left">
                            <b>5. Сведения о помещениях, машино-местах, расположенных в здании, сооружении</b>
                        </td>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="2" class="left">
                            <b>5.1. Сведения о помещениях, расположенных в здании, сооружении</b>    
                        </td>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th>Кадастровый номер помещения</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th>2</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="1 = 1">
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr> 
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>                         
                    </xsl:otherwise>
                </xsl:choose>                
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="2" class="left">
                            <b>5.2. Сведения о машино-местах, расположенных в здании, сооружении</b>    
                        </td>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th>Кадастровый номер машино-места</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th  class="col5mm">1</th>
                    <th>2</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="1 = 1">
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>                         
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="Survey">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Сведения о выполненных измерениях и расчетах'"/>
        </xsl:call-template>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="3" class="left">
                            <b>1. Метод определения координат характерных точек контура объекта недвижимости, части (частей) объекта недвижимости</b>
                        </td>
                    </tr>
                    <tr>
                        <th class="col40mm">Номер контура</th>
                        <th class="col35mm">Номера характерных точек контура</th>
                        <th>Метод определения координат</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col40mm">1</th>
                    <th class="col35mm">2</th>
                    <th>3</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="GeopointsOpred">
                        <xsl:apply-templates select="GeopointsOpred"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>    
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="3" class="left">
                            <b>2. Точность определения координат характерных точек контура объекта недвижимости</b>
                        </td>
                    </tr>
                    <tr>
                        <th class="col40mm">Номер контура</th>
                        <th class="col35mm">Номера характерных точек контура</th>
                        <th>Формулы, примененные для расчетасредней квадратической погрешности определения координат характерных точек контура(Mt),м</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col40mm">1</th>
                    <th class="col35mm">2</th>
                    <th>3</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="TochnGeopointsBuilding | TochnGeopointsConstruction | TochnGeopointsUncompleted">
                        <xsl:apply-templates select="TochnGeopointsBuilding | TochnGeopointsConstruction | TochnGeopointsUncompleted"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="4" class="left">
                            <b>3. Точность определения координат характерных точек контура части (частей) объекта недвижимости</b>
                        </td>
                    </tr>
                    <tr>
                        <th class="col40mm">Номер контура</th>
                        <th class="col35mm">Номера характерных точек контура</th>
                        <th class="col35mm">Учетный номер или обозначение части</th>
                        <th>Формулы, примененные для расчетасредней квадратической погрешности определения координат характерных точек контура(Mt),м</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col40mm">1</th>
                    <th class="col35mm">2</th>
                    <th class="col35mm">3</th>
                    <th>4</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="TochnGeopointsSubBuilding | TochnGeopointsSubConstruction | TochnGeopointsSubUncompleted">
                        <xsl:apply-templates select="TochnGeopointsSubBuilding | TochnGeopointsSubConstruction | TochnGeopointsSubUncompleted"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:otherwise>                
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="NewBuilding | ExistBuilding | NewConstruction | ExistConstruction | NewUncompleted | ExistUncompleted">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Описание местоположения объекта недвижимости'"/>
        </xsl:call-template>        
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="9" class="left">
                            <b>1. Описание местоположения здания, сооружения, объекта незавершенного строительства на земельном участке</b>
                        </td>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="9" class="left gborder0">
                            <b>1.1. Сведения о характерных точках контура объекта недвижимости</b>    
                        </td>
                    </tr>
                    <tr>
                        <td colspan="9" class="left gborder0">
                            Зона N
                            <xsl:call-template name="inputText">
                                <xsl:with-param name="zone" select="'true'"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="2" class="col40mm fontsize8">Номер контура</th>
                        <th rowspan="2" class="col20mm fontsize8">Номера характерных точек контура</th>
                        <th colspan="2" class="col40mm fontsize8">Координаты, м</th>
                        <th rowspan="2" class="col7mm fontsize8">R,м</th>
                        <th rowspan="2" class="fontsize8">Средняя квадратическая погрешность определения координат характерных точек контура (Mt),м</th>
                        <th rowspan="2" class="col20mm fontsize8">Тип контура</th>
                        <th colspan="2" class="col15mm fontsize8">Глубина, высота, м</th>
                    </tr>
                    <tr>
                        <th class="col20mm fontsize8">X</th>
                        <th class="col20mm fontsize8">Y</th>
                        <th class="col7-5mm fontsize8">H1</th>
                        <th class="col7-5mm fontsize8">H2</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col40mm">1</th>
                    <th class="col20mm">2</th>
                    <th class="col20mm">3</th>
                    <th class="col20mm">4</th>
                    <th class="col7mm">5</th>
                    <th>6</th>
                    <th class="col20mm">7</th>
                    <th class="col7-5mm">8</th>
                    <th class="col7-5mm">9</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="EntitySpatial">
                        <xsl:apply-templates select="EntitySpatial"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                            <td><xsl:call-template name="procherk"/></td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td colspan="2" class="left">
                        <b>1.2. Сведения о предельных глубине и высоте конструктивных элементов объекта недвижимости</b>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td class="col105mm left">
                        <xsl:text>Предельная глубина конструктивных элементов объекта недвижимости, м</xsl:text>
                    </td>
                    <td><xsl:call-template name="procherk"/></td>                            
                </tr>
                <tr>
                    <td class="col105mm left">
                        <xsl:text>Предельная высота конструктивных элементов объекта недвижимости, м</xsl:text>
                    </td>
                    <td><xsl:call-template name="procherk"/></td>                            
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="9" class="left gborder0">
                            <b>1.3. Сведения о характерных точках пересечения контура объекта недвижимости с контуром (контурами) иных зданий, сооружений, объектов незавершенного строительства</b>    
                        </td>
                    </tr>
                    <tr>
                        <td colspan="9" class="left gborder0">
                            Зона N
                            <xsl:call-template name="inputText">
                                <xsl:with-param name="zone" select="'true'"/>
                            </xsl:call-template>                      
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="2" class="col15mm">Номер контура</th>
                        <th rowspan="2" class="col20mm">Номера характерных точек контура</th>
                        <th colspan="2" class="col40mm">Координаты, м</th>
                        <th rowspan="2">Средняя квадратическая погрешность определения координат характерных точек контура (Mt),м</th>
                        <th rowspan="2" class="col20mm">Тип контура</th>
                        <th colspan="2" class="col15mm">Глубина, высота, м</th>
                        <th rowspan="2" class="col25mm">Кадастровый номер</th>                        
                    </tr>
                    <tr>
                        <th class="col20mm">X</th>
                        <th class="col20mm">Y</th>
                        <th class="col7-5mm">H1</th>
                        <th class="col7-5mm" style="border-right: 1px solid;">H2</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col15mm">1</th>
                    <th class="col20mm">2</th>
                    <th class="col20mm">3</th>
                    <th class="col20mm">4</th>
                    <th>5</th>
                    <th class="col20mm">6</th>
                    <th class="col7-5mm">7</th>
                    <th class="col7-5mm">8</th>
                    <th class="col25mm">9</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                    <td><xsl:call-template name="procherk"/></td>
                </tr>
            </tbody>
        </table>
        <xsl:call-template name="Characteristics">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:if test="./SubBuildings | ./SubConstructions | ./SubUncompleted">
            <xsl:apply-templates select="./SubBuildings | ./SubConstructions | ./SubUncompleted"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="NewFlat | ExistFlat">
        <xsl:call-template name="Characteristics">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:if test="./SubFlats">
            <xsl:apply-templates select="./SubFlats"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Characteristics">
        <xsl:param name="node"/>
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Характеристики объекта недвижимости'"/>
        </xsl:call-template> 
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <th class="col5mm">N п/п</th>
                        <th class="col80mm">Наименование характеристики</th>
                        <th>Значение характеристики</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col80mm">2</th>
                    <th>3</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td class="left">Вид объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ancestor::Building">
                                <xsl:choose>
                                    <xsl:when test="$node/ancestor::Flats">
                                        <xsl:text>Помещение</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:text>Здание</xsl:text></xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="$node/ancestor::Construction">
                                <xsl:text>Сооружение</xsl:text>
                            </xsl:when>
                            <xsl:when test="$node/ancestor::Uncompleted">
                                <xsl:text>Объект незавершенного строительства</xsl:text>
                            </xsl:when>
                            <xsl:when test="$node/ancestor::Flat">
                                <xsl:text>Помещение</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td>2</td>
                    <td class="left">Кадастровый номер объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/@CadastralNumber">
                                <xsl:value-of select="$node/@CadastralNumber"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>     
                    </td>
                </tr>
                <tr>
                    <td rowspan="2">3</td>
                    <td class="left">Ранее присвоенный государственный учетный номер объекта недвижимости (кадастровый, инвентарный или условный номер)</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/OldNumbers">
                                <xsl:apply-templates select="$node/OldNumbers"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose> 
                    </td>
                </tr>
                <tr>
                    <td class="left">Кадастровый номер исходного объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ParentCadastralNumber">
                                <xsl:apply-templates select="$node/ParentCadastralNumber"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td>4</td>
                    <td class="left">Кадастровый номер земельного участка (земельных участков), в пределах которого (которых) расположен объект недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ParentCadastralNumbers">
                                <xsl:apply-templates select="$node/ParentCadastralNumbers"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>                
                </tr>
                <tr>
                    <td>5</td>
                    <td class="left">Номер кадастрового квартала (кадастровых кварталов), в пределах которого (которых) расположен объект недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/CadastralBlocks">
                                <xsl:apply-templates select="$node/CadastralBlocks"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>                
                </tr>
                <tr>
                    <td rowspan="2">6</td>
                    <td class="left">Кадастровый номер иного объекта недвижимости, в пределах (в составе) которого расположен объект недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/OtherCadastralNumbers">
                                <xsl:text>NaN</xsl:text>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>            
                </tr>
                <tr>
                    <td class="left">Номер, тип этажа (этажей), на котором (которых) расположено помещение</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/PositionInObject/Levels">
                                <xsl:for-each select="$node/PositionInObject/Levels/Level">
                                    <xsl:element name="a">
                                        <xsl:attribute name="class">
                                            <xsl:value-of select="'plan'"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="Position/Plans/Plan/@Name"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">
                                            <xsl:value-of select="'_blank'"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="concat(@Number,' - ')"/>
                                        <xsl:variable name="typeStorey" select="document(concat($urlPrefixDict, 'dTypeStorey_v01.xsd'))"/>
                                        <xsl:variable name="code" select="@Type"/>
                                        <xsl:value-of select="$typeStorey//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                                    </xsl:element>
                                    <xsl:if test="position() != last()">
                                        <xsl:value-of select="', '"/>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="$node/PositionInObject/Position">
                                <xsl:value-of select="$node/PositionInObject/Position/@NumberOnPlan"/>
                                <xsl:for-each select="$node/PositionInObject/Position/Plans/Plan">
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="@Name"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">
                                            <xsl:value-of select="'_blank'"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="concat('План ', @Scale)"/>                                        
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="procherk"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td rowspan="4">7</td>
                    <td class="left">Адрес объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="not($node/Address/Note)">
                                <xsl:apply-templates select="$node/Address"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>            
                </tr>
                <tr>
                    <td class="left">Дата последнего обновления записи в государственном адресном реестре</td>
                    <td class="left">
                        <xsl:call-template name="procherk"/>
                    </td>
                </tr>
                <tr>
                    <td class="left">Местоположение объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/Address/Note">
                                <xsl:apply-templates select="$node/Address"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td class="left">Дополнение местоположения объекта недвижимости</td>
                    <td class="left">
                        <xsl:call-template name="procherk"/>
                    </td>
                </tr>
                <tr>
                    <td rowspan="2">8</td>
                    <td class="left">Назначение объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/AssignationBuilding">
                                <xsl:variable name="assBuilding" select="document(concat($urlPrefixDict, 'dAssBuilding_v01.xsd'))"/>
                                <xsl:variable name="code" select="$node/AssignationBuilding"/>
                                <xsl:value-of select="$assBuilding//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                            </xsl:when>
                            <xsl:when test="$node/ancestor::Construction">
                                <xsl:value-of select="$node/AssignationName"/>
                            </xsl:when>
                            <xsl:when test="$node/ancestor::Uncompleted">
                                <xsl:call-template name="procherk"/>
                            </xsl:when>
                            <xsl:when test="$node/Assignation">
                                <xsl:variable name="assFlat" select="document(concat($urlPrefixDict, 'dAssFlat_v01.xsd'))"/>
                                <xsl:variable name="code" select="$node/Assignation/AssignationCode"/>
                                <xsl:value-of select="$assFlat//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                                <xsl:choose>
                                    <xsl:when test="$node/Assignation/AssignationCode = '206002000000'">
                                        <xsl:value-of select="' - '"/>                                        
                                        <xsl:variable name="assFlatType" select="document(concat($urlPrefixDict, 'dAssFlatType_v01.xsd'))"/>
                                        <xsl:variable name="codeType" select="$node/Assignation/AssignationType"/>
                                        <xsl:value-of select="$assFlatType//xs:enumeration[@value = $codeType]/xs:annotation/xs:documentation"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$node/Assignation/TotalAssets">
                                            <xsl:value-of select="' - '"/>
                                            <xsl:if test="$node/Assignation/TotalAssets = 'false'">
                                                <xsl:value-of select="'не '"/>
                                            </xsl:if>
                                            <xsl:value-of select="'является общим имуществом в многоквартирном доме'"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="procherk"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>                
                </tr>
                <tr>
                    <td class="left">Проектируемое назначение объекта незавершенного строительства</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ancestor::Uncompleted">
                                <xsl:value-of select="$node/AssignationName"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td>9</td>
                    <td class="left">Наименование объекта недвижимости</td>					
					<xsl:choose>
                        <xsl:when test="$node/Name != ''">
                            <td class="left"><xsl:value-of select="$node/Name"/></td>
                        </xsl:when>
                        <xsl:otherwise><td class="left"><xsl:call-template name="inputText"/></td></xsl:otherwise>
                    </xsl:choose>
                </tr>
                <tr>
                    <td rowspan="2">10</td>
                    <td class="left">Количество этажей объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/Floors/@Floors">
                                <xsl:value-of select="$node/Floors/@Floors"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td class="left">в том числе подземных</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/Floors/@UndergroundFloors">
                                <xsl:value-of select="$node/Floors/@UndergroundFloors"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td>11</td>
                    <td class="left">Материал наружных стен здания</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ancestor::Building">
                                <xsl:for-each select="$node/ElementsConstruct/Material">
                                    <xsl:variable name="wall" select="document(concat($urlPrefixDict, 'dWall_v01.xsd'))"/>
                                    <xsl:variable name="code" select="@Wall"/>
                                    <xsl:value-of select="$wall//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="procherk"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td rowspan="2">12</td>
                    <td class="left">Год ввода объекта недвижимости в эксплуатацию по завершении его строительства</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ExploitationChar/@YearUsed">
                                <xsl:value-of select="$node/ExploitationChar/@YearUsed"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td class="left">Год завершения строительства объекта недвижимости</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ExploitationChar/@YearBuilt">
                                <xsl:value-of select="$node/ExploitationChar/@YearBuilt"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td>13</td>
                    <td class="left">Площадь объекта недвижимости (Р), m&#178;</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/Area">
                                <xsl:value-of select="$node/Area"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td>14</td>
                    <td class="left">Вид (виды) разрешенного использования объекта недвижимости</td>
                    <td class="left">
                        <xsl:call-template name="procherk"/>
                    </td>
                </tr>
                <tr>
                    <td rowspan="2">15</td>
                    <td class="left">Основная характеристика сооружения и ее значение</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ancestor::Construction">
                                <xsl:for-each select="$node/KeyParameters/KeyParameter">
                                    <xsl:variable name="typeParameter" select="document(concat($urlPrefixDict, 'dTypeParameter_v01.xsd'))"/>
                                    <xsl:variable name="code" select="@Type"/>
                                    <xsl:value-of select="$typeParameter//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                                    <xsl:value-of select="concat(' ', @Value)"/>
                                    <xsl:if test="position() != last()">
                                        <br />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td class="left">Основная характеристика объекта незавершенного строительства и ее проектируемое значение</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/ancestor::Uncompleted">
                                <xsl:for-each select="$node/KeyParameters/KeyParameter">
                                    <xsl:variable name="typeParameter" select="document(concat($urlPrefixDict, 'dTypeParameter_v01.xsd'))"/>
                                    <xsl:variable name="code" select="@ype"/>
                                    <xsl:value-of select="$typeParameter//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                                    <xsl:value-of select="concat(' ', @Value)"/>
                                    <xsl:if test="position() != last()">
                                        <br />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="procherk"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td>16</td>
                    <td class="left">Степень готовности объекта незавершенного строительства, %</td>
                    <td class="left">
                        <xsl:choose>
                            <xsl:when test="$node/DegreeReadiness">
                                <xsl:value-of select="concat($node/DegreeReadiness, '%')"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="SubBuildings | SubConstructions | SubUncompleteds | SubUncompleted | SubFlats">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Сведения о части (частях) объекта недвижимости'"/>
        </xsl:call-template>
        <xsl:for-each select="NewSubBuilding | ExistSubBuilding | NewSubConstruction | ExistSubConstruction | NewSubUncompleted | ExistSubUncompleted | NewSubFlat | ExistSubFlat">
            <table class="tbl_section_title">
                <tbody>
                        <tr>
                            <td colspan="6" class="left">
                                <xsl:value-of select="concat('Учетный номер или обозначение части: ', @Definition,preceding-sibling::CadastralNumber/text())"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="left">
                                <b>1. Сведения о местоположении части объекта недвижимости</b>    
                            </td>
                        </tr>
                </tbody>
            </table>
            <table class="tbl_section_title">
                <tbody>
                        <tr>
                            <td colspan="6" class="left gborder0">
                                <b>1.1. Описание местоположения части объекта недвижимости в виде контура</b>    
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="left gborder0">
                                Зона N
                                <xsl:call-template name="inputText">
                                    <xsl:with-param name="zone" select="'true'"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="2" class="col20mm">Номера характерных точек контура</th>
                            <th colspan="2" class="col40mm">Координаты, м</th>
                            <th rowspan="2">Средняя квадратическая погрешность определения координат характерных точек контура (Mt),м</th>
                            <th rowspan="2" class="col30mm">Тип контура</th>
                            <th rowspan="2" class="col40mm">Примечание</th>
                        </tr>
                        <tr>
                            <th class="col20mm">X</th>
                            <th class="col20mm">Y</th>
                        </tr>
                </tbody>
            </table>
            <table class="tbl_section_content">
                <thead>
                    <tr>
                        <th class="col20mm">1</th>
                        <th class="col20mm">2</th>
                        <th class="col20mm">3</th>
                        <th>4</th>
                        <th class="col30mm">5</th>
                        <th class="col40mm">6</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:choose>
                        <xsl:when test="EntitySpatial">
                            <xsl:call-template name="SubEntitySpatial">
                                <xsl:with-param name="entitySpatial" select="EntitySpatial"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td><xsl:call-template name="procherk"/></td>
                                <td><xsl:call-template name="procherk"/></td>
                                <td><xsl:call-template name="procherk"/></td>
                                <td><xsl:call-template name="procherk"/></td>
                                <td><xsl:call-template name="procherk"/></td>
                                <td><xsl:call-template name="procherk"/></td>
                            </tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </tbody>
            </table>
            <table class="tbl_section_title">
                <tbody>
                    <tr>
                        <td class="left gborder0">
                            <b>1.2. Иное описание местоположения части объекта недвижимости</b>    
                        </td>
                    </tr>
                </tbody>
            </table>
            <table class="tbl_section_content">
                <tbody>
                    <tr>
                        <td class="left gborder0">
                            <xsl:value-of select="Description"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </xsl:for-each>
        <table class="tbl_section_title">
            <tbody>
                    <tr>
                        <td colspan="4" class="left">
                            <b>2. Общие сведения о части объекта недвижимости</b>    
                        </td>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th class="col40mm">Учетный номер и обозначение части</th>
                        <th class="col40mm">Площадь (Р), / протяженность</th>
                        <th>Характеристика части</th>
                    </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col40mm">2</th>
                    <th class="col40mm">3</th>
                    <th>4</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="NewSubBuilding | ExistSubBuilding | NewSubConstruction | ExistSubConstruction | NewSubUncompleted | ExistSubUncompleted | NewSubFlat | ExistSubFlat">
                    <tr>
                        <td>
                            <xsl:value-of select="position()"/>
                        </td>
                        <td>
                            <xsl:value-of select="concat(@Definition,preceding-sibling::CadastralNumber/text())"/>
                        </td>
                        <td>
                            <xsl:value-of select="Area"/>
                        </td>
                        <td class="left">
                            <xsl:value-of select="Encumbrance"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="Conclusion">
        <div class="isOverPage">
            <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Заключение кадастрового инженера'"/>
        </xsl:call-template>
            <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td class="left">
                        <div class="conclusion">
                            <xsl:call-template name="StringReplace">
                                <xsl:with-param name="input" select="." />
                                <xsl:with-param name="oldValue" select="'. '" />
                                <xsl:with-param name="newValue" select="'.&lt;br&gt;'" />
                            </xsl:call-template>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        </div>
    </xsl:template>
    <xsl:template match="SchemeGeodesicPlotting">
        <xsl:call-template name="newPage"/>
        <xsl:call-template name="header1">
                            <xsl:with-param name="text1" select="'Схема геодезических построений'"/>
                        </xsl:call-template>
        <table class="tbl_section_content">
                            <tbody>
                                <tr>
                                    <td class="left">                        
                                        <xsl:call-template name="tAppliedFilePDF">
                                            <xsl:with-param name="name" select="@Name"/>
                                        </xsl:call-template>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
    </xsl:template>
    <xsl:template match="SchemeDisposition">
        <xsl:call-template name="newPage"/>
        <xsl:call-template name="header1">
                            <xsl:with-param name="text1" select="'Схема расположения'"/>
                        </xsl:call-template>
        <table class="tbl_section_content">
                            <tbody>
                                <tr>
                                    <td class="left">                        
                                        <xsl:call-template name="tAppliedFilePDF">
                                            <xsl:with-param name="name" select="@Name"/>
                                        </xsl:call-template>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
    </xsl:template>
    <xsl:template match="DiagramContour">
        <xsl:choose>
                            <xsl:when test="AppliedFile">
                                <xsl:for-each select="AppliedFile">
                                    <xsl:call-template name="newPage"/>
                                    <xsl:call-template name="header1">
                                        <xsl:with-param name="text1" select="'Чертеж объекта'"/>
                                    </xsl:call-template>
                                    <table class="tbl_section_content">
                                        <tbody>
                                            <tr>
                                                <td class="left">
                                                    <xsl:call-template name="tAppliedFilesJPEG">
                                                        <xsl:with-param name="name" select="@Name"/>
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>                    
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="newPage"/>
                                <xsl:call-template name="header1">
                                    <xsl:with-param name="text1" select="'Чертеж объекта'"/>
                                </xsl:call-template>
                                <table class="tbl_section_content">
                                    <tbody>
                                        <tr>
                                            <td style="text-align: left;">
                                                <xsl:call-template name="tAppliedFilePDF">
                                                    <xsl:with-param name="name" select="@Name"/>
                                                </xsl:call-template>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </xsl:otherwise>
                        </xsl:choose>        
    </xsl:template>
    <xsl:template match="Appendix">
        <xsl:call-template name="newPage"/>
        <xsl:call-template name="header1">
                            <xsl:with-param name="text1" select="'Приложения'"/>
                        </xsl:call-template>
                        <table class="tbl_section_title">
                            <tbody>
                                    <tr>
                                        <th class="col25mm">Номер приложения</th>
                                        <th class="col80mm">Наименование приложения</th>
                                        <th>Приложенный файл</th>
                                    </tr>
                            </tbody>
                        </table>
        <table class="tbl_section_content">
                            <thead>
                                <tr>
                                    <th class="col25mm">1</th>
                                    <th class="col80mm">2</th>
                                    <th>3</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="AppliedFiles">
                                    <tr>
                                        <td>
                                            <xsl:value-of select="NumberAppendix"/>
                                        </td>
                                        <td class="left">
                                            <xsl:value-of select="NameAppendix"/>
                                        </td>
                                        <td>
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="AppliedFile/@Name"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                    <xsl:value-of select="'_blank'"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="AppliedFile/@Name"/>
                                            </xsl:element>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>                        
    </xsl:template>
    <xsl:template name="GenerateMap">
        <xsl:param name="entitySpatial"/>
        <xsl:call-template name="newPage"/>
        <div class="notPrint">
            <b>Сгенерированная карта</b>
            <svg/>
            <xsl:variable name="yMin">
                <xsl:for-each select="//EntitySpatial/*//Ordinate/@Y">
                    <xsl:sort select="." data-type="number" order="ascending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="xMin">
                <xsl:for-each select="//EntitySpatial/*//Ordinate/@X">
                    <xsl:sort select="." data-type="number" order="ascending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="yMax">
                <xsl:for-each select="//EntitySpatial/*//Ordinate/@Y">
                    <xsl:sort select="." data-type="number" order="descending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="xMax">
                <xsl:for-each select="//EntitySpatial/*//Ordinate/@X">
                    <xsl:sort select="." data-type="number" order="descending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <script>
                var json = {"type":"FeatureCollection","features":[
                <xsl:for-each select="//EntitySpatial/SpatialElement | //EntitySpatial/SpatialElement | //EntitySpatial/SpatialElement | //EntitySpatial/SpatialElement">
                    <xsl:choose>
                        <xsl:when test="count(SpelementUnit) = 1">
                            <xsl:choose>
                                <!-- Точка -->
                                <xsl:when test="SpelementUnit/@TypeUnit = 'Окружность'">
                                    <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                                    <xsl:value-of select="concat('&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;points&quot;,&quot;Underground&quot;:',@Underground,',&quot;NumbCont&quot;:&quot;',@Number,'&quot;},')"/>
                                    <xsl:value-of select="'&quot;geometry&quot;:{&quot;type&quot;:&quot;Point&quot;,&quot;coordinates&quot;:'"/>
                                    <xsl:value-of select="concat('[',SpelementUnit/Ordinate/@Y,',',SpelementUnit/Ordinate/@X,']')"/>
                                    <xsl:value-of select="',&quot;radius&quot;:'"/> 
                                    <xsl:value-of select="SpelementUnit/R"/>
                                    <xsl:value-of select="'}}'"/>           
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                                    <xsl:value-of select="concat('&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;points&quot;,&quot;Underground&quot;:&quot;E&quot;,&quot;NumbCont&quot;:&quot;',@Number,'&quot;},')"/>
                                    <xsl:value-of select="'&quot;geometry&quot;:{&quot;type&quot;:&quot;Point&quot;,&quot;coordinates&quot;:'"/>
                                    <xsl:value-of select="concat('[',SpelementUnit/Ordinate/@Y,',',SpelementUnit/Ordinate/@X,']')"/>
                                    <xsl:value-of select="',&quot;radius&quot;:&quot;0.5&quot;'"/>
                                    <xsl:value-of select="'}}'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- Полилиния -->
                                <!--<xsl:when test="not(SpelementUnit[1]/Ordinate/@X | SpelementUnit[1]/Ordinate/@Y | SpelementUnit[1]/Ordinate/@NumGeopoint = SpelementUnit[last()]/Ordinate/@X | SpelementUnit[last()]/Ordinate/@Y | SpelementUnit[last()]/Ordinate/@NumGeopoint)">-->
                                <xsl:when test="(not(SpelementUnit[1]/Ordinate/@X | SpelementUnit[1]/Ordinate/@Y = SpelementUnit[last()]/Ordinate/@X | SpelementUnit[last()]/Ordinate/@Y)) and (SpelementUnit[1]/@TypeUnit = 'Точка')">
                                    <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                                    <xsl:value-of select="concat('&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;polylines&quot;,&quot;Underground&quot;:',@Underground,',&quot;NumbCont&quot;:&quot;',@Number,'&quot;},')"/>
                                    <xsl:value-of select="'&quot;geometry&quot;:{&quot;type&quot;:&quot;LineString&quot;,&quot;coordinates&quot;:['"/>
                                    <xsl:for-each select="SpelementUnit">                                            
                                        <xsl:value-of select="concat('[',Ordinate/@Y,',',Ordinate/@X,']')"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:value-of select="','"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="']}}'"/>                                        
                                </xsl:when>
                                <!-- Полигон -->
                                <xsl:when test="(SpelementUnit[1]/Ordinate/@X | SpelementUnit[1]/Ordinate/@Y = SpelementUnit[last()]/Ordinate/@X | SpelementUnit[last()]/Ordinate/@Y) and (SpelementUnit[1]/@TypeUnit = 'Точка')">
                                    <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                                    <xsl:value-of select="concat('&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;polygons&quot;,&quot;Underground&quot;:',@Underground,',&quot;NumbCont&quot;:&quot;',@Number,'&quot;},')"/>
                                    <xsl:value-of select="'&quot;geometry&quot;:{&quot;type&quot;:&quot;Polygon&quot;,&quot;coordinates&quot;:[['"/>
                                    <xsl:for-each select="SpelementUnit">                                            
                                        <xsl:value-of select="concat('[',Ordinate/@Y,',',Ordinate/@X,']')"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:value-of select="','"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:value-of select="']]}}'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="SpelementUnit">
                                        <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                                        <xsl:value-of select="concat('&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;points&quot;,&quot;Underground&quot;:&quot;E&quot;,&quot;NumbCont&quot;:&quot;',@Number,'&quot;},')"/>
                                        <xsl:value-of select="'&quot;geometry&quot;:{&quot;type&quot;:&quot;Point&quot;,&quot;coordinates&quot;:'"/>
                                        <xsl:value-of select="concat('[',Ordinate/@Y,',',Ordinate/@X,']')"/>
                                        <xsl:value-of select="',&quot;radius&quot;:&quot;0.5&quot;'"/>
                                        <xsl:value-of select="'}}'"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="not(position() = last())">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>]};</xsl:text>                            
                
                <xsl:text></xsl:text>                
                var width = document.documentElement.clientWidth - 100;
                var height = 800;                
                <xsl:value-of select="concat('var yMin = ', $yMin,';')"/>
                <xsl:value-of select="concat('var yMax = ', $yMax,';')"/>
                <xsl:value-of select="concat('var xMin = ', $xMin,';')"/>
                <xsl:value-of select="concat('var xMax = ', $xMax,';')"/>
                var yAvg = (((yMax - yMin) / 2)+yMin),
                xAvg = (((xMax - xMin) / 2)+xMin);
                var scale = (width/(yAvg-yMin))/2 > (height/(xAvg-xMin))/2 ? (height/(xAvg-xMin))/2 : (width/(yAvg-yMin))/2;
                var scaleMx = Math.floor(width/(yMax-yMin));
                scaleMx = scaleMx > 1 ? scaleMx : 1;
                
                var svg = d3.select("svg")
                .attr("width",width)
                .attr("height",height);
                <!--var width = +svg.attr("width");
                var height = +svg.attr("height");-->
                
                var path = d3.geoPath()
                .projection(matrix(scaleMx, 0, 0, -scaleMx, (width/2)-(yAvg*scaleMx), (height/2)+(xAvg*scaleMx)));
                function matrix(a, b, c, d, tx, ty) {
                return d3.geoTransform({
                point: function(x, y) {
                this.stream.point(a * x + b * y + tx, c * x + d * y + ty);
                }
                });
                }  
                
                var zoom = d3.zoom()
                .scaleExtent([1 / 10, 20])
                .on("zoom", function () {
                g.attr("transform", 
                "translate(" + d3.event.transform.x + 
                "," + d3.event.transform.y + 
                ")scale(" + d3.event.transform.k + ")"
                );
                }
                );
                
                var g = svg.append("g");
                
                svg.append("rect")
                .attr("width", width)
                .attr("height", height)
                .call(zoom)
                .call(zoom.scaleTo, scale/scaleMx);
                
                <!--   Площадные объекты       -->
                var polygon = json.features.filter(function(d) { return d.properties.ObjectType === "polygons";});
                var gPolygon = g.append("g").attr("class", "polygons");                
                gPolygon.selectAll(".polygons")
                .data(polygon)
                .enter().append("path")
                .attr("class", function(d) {return d.properties.ObjectType + d.properties.Underground;})
                .attr("numObj", function(d) {return d.properties.NumbCont;})
                .attr("d", path);
                <!--   Точечные объекты       -->                
                var point = json.features.filter(function(d) { return d.properties.ObjectType === "points";});
                var gPoint = g.append("g").attr("class", "points");                
                gPoint.selectAll(".points")
                .data(point)
                .enter().append("path")
                .attr("class", function(d) {return d.properties.ObjectType + d.properties.Underground;})
                .attr("numObj", function(d) {return d.properties.NumbCont;})
                .attr("d", path);           
                <!--   Линейные объекты       -->
                var polyline = json.features.filter(function(d) {return d.properties.ObjectType === "polylines"});
                var gPline = g.append("g").attr("class", "polylines");                
                gPline.selectAll(".polylines")
                .data(polyline)
                .enter().append("path")
                .attr("class", function(d) {return d.properties.ObjectType + d.properties.Underground;})
                .attr("numObj", function(d) {return d.properties.NumbCont;})
                .attr("d", path);
                
                <!--g.selectAll("path")
                .data(json.features)
                .enter().append("path")
                .attr("class", function(d) {return d.properties.ObjectType + d.properties.Underground;})
                .attr("numObj", function(d) {return d.properties.NumbCont;})
                .attr("d", path);-->
                
            </script>
        </div>
    </xsl:template>
    
    
    <!-- *******************InputData************************* -->    
    <xsl:template match="Documents">
        <xsl:for-each select="Document">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="Name"/>
                    <xsl:variable name="documents" select="document(concat($urlPrefixDict, 'dAllDocuments_v02.xsd'))"/>
                    <xsl:variable name="code" select="CodeDocument"/>
                    <xsl:value-of select="concat(' (', $documents//xs:enumeration[@value = $code]/xs:annotation/xs:documentation, ')')"/>
                </td>
                <td >
                    <xsl:value-of select="concat('№ ', Number, ' от ', Date)"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="GeodesicBases">
        <xsl:for-each select="GeodesicBase">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="concat(PName, ', ', PKind)"/>
                </td>
                <td>
                    <xsl:value-of select="PKlass"/>
                </td>
                <td>
                    <xsl:value-of select="OrdX"/>
                </td>
                <td>
                    <xsl:value-of select="OrdY"/>
                </td>
                <td>
                    <xsl:value-of select="'сохранено'"/>
                </td>
                <td>
                    <xsl:value-of select="'сохранено'"/>
                </td>
                <td>
                    <xsl:value-of select="'сохранено'"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="MeansSurvey">
        <xsl:for-each select="MeanSurvey">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="Name"/>
                </td>
                <td>
                    <xsl:value-of select="concat(Registration/Number, ', ', Registration/Duration)"/>
                </td>
                <td>
                    <xsl:value-of select="CertificateVerification"/>
                </td>
            </tr>
        </xsl:for-each>       
    </xsl:template>
    <!-- *********************Survey************************** -->    
    <xsl:template match="GeopointsOpred">
        <!--<xsl:variable name="allContour" select="count(Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])])"/>-->
        <!--<xsl:for-each select="Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])]">
            <xsl:variable name="firstNumGeopoint" select="@NumGeopoint"/>
            <xsl:variable name="lastNumGeopoint" select="key('geopointElements', @Number)[last()]/@NumGeopoint"/>
            <xsl:choose>
                <xsl:when test="$allContour != 1">
                    <tr>
                        <td>
                            <xsl:value-of select="concat(@Number,'/',$allContour)"/>
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="$firstNumGeopoint = $lastNumGeopoint">
                                    <xsl:value-of select="$firstNumGeopoint"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <xsl:variable name="geopointOpred" select="document(concat($urlPrefixDict, 'dGeopointOpred_v01.xsd'))"/>
                            <xsl:variable name="code" select="./GeopointOpred"/>
                            <xsl:value-of select="concat(' (', $geopointOpred//xs:enumeration[@value = $code]/xs:annotation/xs:documentation,')')"/>
                        </td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <tr>
                        <td>
                            <xsl:call-template name="procherk"/>
                        </td>
                        <td>
                            <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                        </td>
                        <td>
                            <xsl:variable name="geopointOpred" select="document(concat($urlPrefixDict, 'dGeopointOpred_v01.xsd'))"/>
                            <xsl:variable name="code" select="./GeopointOpred"/>
                            <xsl:value-of select="concat(' (', $geopointOpred//xs:enumeration[@value = $code]/xs:annotation/xs:documentation,')')"/>
                        </td>
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>-->
        <xsl:for-each select="Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])]">
            <xsl:variable name="firstNumGeopoint" select="@NumGeopoint"/>
            <xsl:variable name="lastNumGeopoint" select="key('geopointElements', @Number)[last()]/@NumGeopoint"/>
            <xsl:choose>
                <xsl:when test="count(Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])]) != 1">
                    <tr>
                        <td>
                            <xsl:choose>
                                <xsl:when test="contains(@Number,'.')">
                                    <!--<xsl:value-of select="concat(substring-before(@Number,'.'),'/',substring-after(@Number,'/'))"/>-->
                                    <xsl:choose>
                                        <xsl:when test="substring-before(@Number,'.') = 0">
                                            <xsl:call-template name="procherk"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-before(@Number,'.')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="@Number = 0">
                                            <xsl:call-template name="procherk"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@Number"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="$firstNumGeopoint = $lastNumGeopoint">
                                    <xsl:value-of select="$firstNumGeopoint"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <xsl:variable name="geopointOpred" select="document(concat($urlPrefixDict, 'dGeopointOpred_v01.xsd'))"/>
                            <xsl:variable name="code" select="./GeopointOpred"/>
                            <xsl:value-of select="concat(' (', $geopointOpred//xs:enumeration[@value = $code]/xs:annotation/xs:documentation,')')"/>
                        </td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <tr>
                        <td>
                            <xsl:call-template name="procherk"/>
                        </td>
                        <td>
                            <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                        </td>
                        <td>
                            <xsl:variable name="geopointOpred" select="document(concat($urlPrefixDict, 'dGeopointOpred_v01.xsd'))"/>
                            <xsl:variable name="code" select="./GeopointOpred"/>
                            <xsl:value-of select="concat(' (', $geopointOpred//xs:enumeration[@value = $code]/xs:annotation/xs:documentation,')')"/>
                        </td>
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>    
    </xsl:template>
    <xsl:template match="TochnGeopointsBuilding | TochnGeopointsConstruction | TochnGeopointsUncompleted">
        <!--<xsl:variable name="allContour" select="count(Element[generate-id(.) = generate-id(key('tochnGeopointElements', @Number)[1])])"/>-->
        <xsl:for-each select="Element[generate-id(.) = generate-id(key('tochnGeopointElements', @Number)[1])]">
            <xsl:variable name="firstNumGeopoint" select="@NumGeopoint"/>
            <xsl:variable name="lastNumGeopoint" select="key('tochnGeopointElements', @Number)[last()]/@NumGeopoint"/>
            <xsl:choose>
                <xsl:when test="count(Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])]) != 1">
                    <tr>
                        <td>
                            <xsl:choose>
                                <xsl:when test="contains(@Number,'.')">                                    
                                    <!--<xsl:value-of select="concat(substring-before(@Number,'.'),'/',substring-after(@Number,'/'))"/>-->
                                    <xsl:choose>
                                        <xsl:when test="substring-before(@Number,'.') = 0">
                                            <xsl:call-template name="procherk"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-before(@Number,'.')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="@Number = 0">
                                            <xsl:call-template name="procherk"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@Number"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="$firstNumGeopoint = $lastNumGeopoint">
                                    <xsl:value-of select="$firstNumGeopoint"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <!-- <xsl:value-of select="./Formula"/> -->
                            <xsl:choose>
                                <xsl:when test="contains(./Formula,'Формула0.10')">
                                    <xsl:value-of select="'Mt = √m²0 + m²0, Mt = √0.10² + 0.03² = 0.10 м'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="./Formula"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <tr>
                        <td>
                            <xsl:call-template name="procherk"/>
                        </td>
                        <td>
                            <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                        </td>
                        <td>
                            <!-- <xsl:value-of select="./Formula"/> -->
                            <xsl:choose>
                                <xsl:when test="contains(./Formula,'Формула0.10')">
                                    <xsl:value-of select="'Mt = √m²0 + m²0, Mt = √0.10² + 0.03² = 0.10 м'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="./Formula"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>        
    </xsl:template>
    <xsl:template match="TochnGeopointsSubBuilding | TochnGeopointsSubConstruction | TochnGeopointsSubUncompleted">
        <!--<xsl:variable name="allContour" select="count(Element[generate-id(.) = generate-id(key('tochnGeopointsSubElements', @Number)[1])])"/>-->
        <xsl:for-each select="Element[generate-id(.) = generate-id(key('tochnGeopointsSubElements', @Number)[1])]">
            <xsl:variable name="firstNumGeopoint" select="@NumGeopoint"/>
            <xsl:variable name="lastNumGeopoint" select="key('tochnGeopointsSubElements', @Number)[last()]/@NumGeopoint"/>
            <xsl:choose>
                <xsl:when test="count(Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])]) != 1">
                    <tr>
                        <td>
                            <xsl:choose>
                                <xsl:when test="contains(@Number,'.')">
                                    <!--<xsl:value-of select="concat(substring-before(@Number,'.'),'/',substring-after(@Number,'/'))"/>-->
                                    <xsl:choose>
                                        <xsl:when test="substring-before(@Number,'.') = 0">
                                            <xsl:call-template name="procherk"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-before(@Number,'.')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="@Number">
                                            <xsl:call-template name="procherk"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@Number"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="$firstNumGeopoint = $lastNumGeopoint">
                                    <xsl:value-of select="$firstNumGeopoint"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td>
                            <xsl:value-of select="./Formula"/>
                        </td>
                        <td>
                            <xsl:value-of select="@NumberRecordDefinition"/>
                        </td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <tr>
                        <td>
                            <xsl:call-template name="procherk"/>
                        </td>
                        <td>
                            <xsl:value-of select="concat($firstNumGeopoint,' - ',$lastNumGeopoint)"/>
                        </td>
                        <td>
                            <xsl:value-of select="./Formula"/>
                        </td>
                        <td>
                            <xsl:value-of select="@NumberRecordDefinition"/>
                        </td>
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>        
    </xsl:template>
    <!-- **********************OBJECTS************************ -->
    <xsl:template match="EntitySpatial">
        <xsl:for-each select="SpatialElement">
            <xsl:variable name="num" select="@Number"/>
            <xsl:variable name="typeKontour">
                <xsl:choose>
                    <xsl:when test="@Underground = 0">
                        <xsl:value-of select="'Наземный контур'"/>
                    </xsl:when>
                    <xsl:when test="@Underground = 1">
                        <xsl:value-of select="'Подземный контур'"/>
                    </xsl:when>
                    <xsl:when test="@Underground = 2">
                        <xsl:value-of select="'Надземный контур'"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <tr>
                <td class="left" colspan="9">
                    <xsl:choose>
                        <xsl:when test="contains(@Number,'.')">
                            <xsl:value-of select="'Внутренний контур'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Внешний контур'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
            <xsl:for-each select="SpelementUnit">                
                <xsl:choose>
                    <xsl:when test="(count(parent::SpatialElement/SpelementUnit) = 1 and @TypeUnit = 'Точка')">
                        <xsl:text disable-output-escaping="yes">&lt;tr style="background-color: red;"&gt;</xsl:text>
                    </xsl:when>
                    <xsl:when test="string-length(ceiling(Ordinate/@X)) != 6">
                        <xsl:text disable-output-escaping="yes">&lt;tr style="background-color: rebeccapurple;"&gt;</xsl:text>
                    </xsl:when>
                    <xsl:when test="string-length(ceiling(Ordinate/@Y)) != 7">
                        <xsl:text disable-output-escaping="yes">&lt;tr style="background-color: rebeccapurple;"&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                    <td>
                        <xsl:choose>
                            <xsl:when test="contains($num,'.')">
                               <!--<xsl:value-of select="concat(substring-before($num,'.'),'/',substring-after($num,'/'))"/>-->
                                <xsl:choose>
                                    <xsl:when test="substring-before($num,'.') = 0">
                                        <xsl:call-template name="procherk"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-before($num,'.')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$num = 0">
                                        <xsl:call-template name="procherk"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$num"/>
                                    </xsl:otherwise>
                                </xsl:choose>                                
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td>
                        <xsl:value-of select="Ordinate/@NumGeopoint"/>
                    </td>
                    <td>
                        <xsl:value-of select="Ordinate/@X"/>
                    </td>
                    <td>
                        <xsl:value-of select="Ordinate/@Y"/>
                    </td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="R">
                                <xsl:value-of select="R"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="procherk"/></xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td>
                        <xsl:value-of select="Ordinate/@DeltaGeopoint"/>
                    </td>
                    <td>
                        <xsl:value-of select="$typeKontour"/>
                    </td>
                    <td>
                        <xsl:call-template name="procherk"/>
                    </td>
                    <td>
                        <xsl:call-template name="procherk"/>
                    </td>
                <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="SubEntitySpatial">
        <xsl:param name="entitySpatial"/>
        <xsl:for-each select="$entitySpatial/SpatialElement">
            <xsl:variable name="num" select="@Number"/>
            <xsl:variable name="typeKontour">
                <xsl:choose>
                    <xsl:when test="@Underground = 0">
                        <xsl:value-of select="'Наземный контур'"/>
                    </xsl:when>
                    <xsl:when test="@Underground = 1">
                        <xsl:value-of select="'Подземный контур'"/>
                    </xsl:when>
                    <xsl:when test="@Underground = 2">
                        <xsl:value-of select="'Надземный контур'"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <tr>
                <td class="left" colspan="6">
                    <xsl:choose>
                        <xsl:when test="contains(@Number,'.')">
                            <xsl:value-of select="'Внутренний контур'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Внешний контур'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
            <xsl:for-each select="SpelementUnit">
                <tr>
                    <td>
                        <xsl:value-of select="Ordinate/@NumGeopoint"/>
                    </td>
                    <td>
                        <xsl:value-of select="Ordinate/@X"/>
                    </td>
                    <td>
                        <xsl:value-of select="Ordinate/@Y"/>
                    </td>
                    <td>
                        <xsl:value-of select="Ordinate/@DeltaGeopoint"/>
                    </td>
                    <td>
                        <xsl:value-of select="$typeKontour"/>
                    </td>
                    <td>
                        <xsl:value-of select="@Note"/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="OldNumbers| OldNumbersOKS">
        <xsl:for-each select="OldNumber">
            <xsl:value-of select="@Number"/>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="ParentCadastralNumbers">
        <xsl:for-each select="CadastralNumber">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="ParentCadastralNumber">
        <xsl:choose>
            <xsl:when test="CadastralNumberOKS">
                <xsl:value-of select="CadastralNumberOKS"/>
            </xsl:when>
            <xsl:when test="OldNumbersOKS">
                <xsl:apply-templates select="OldNumbersOKS"/>
            </xsl:when>
            <xsl:when test="Address">
                <xsl:apply-templates select="Address"/>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="CadastralNumberFlat">
            <xsl:value-of select="concat(', ',CadastralNumberFlat)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="CadastralBlocks">
        <xsl:for-each select="CadastralBlock">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="Address">
        <xsl:call-template name="tAddressInpFull">
            <xsl:with-param name="address" select="."></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="tAddressInpFull">
        <xsl:param name="address"/>        
        <xsl:choose>
            <xsl:when test="not($address/Note)">
                <xsl:variable name="regionsRF" select="document(concat($urlPrefixDict, 'dRegionsRF_v01.xsd'))"/>
                <xsl:variable name="code" select="$address/Region"/>
                <xsl:value-of select="$regionsRF//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                <xsl:if test="$address/District">
                    <xsl:value-of select="concat(', ', $address/District/@Type, '.', $address/District/@Name)"/>
                </xsl:if>
                <xsl:if test="$address/City">
                    <xsl:value-of select="concat(', ', $address/City/@Type, '.', $address/City/@Name)"/>
                </xsl:if>
                <xsl:if test="$address/Locality">
                    <xsl:value-of select="concat(', ', $address/Locality/@Type, '.', $address/Locality/@Name)"/>
                </xsl:if>
                <xsl:call-template name="tAddressInp">
                    <xsl:with-param name="addressInp" select="$address"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$address/Other | $address/Note">
                    <!-- <xsl:value-of select="$addressInp/Other"/> -->
                    <xsl:value-of select="$address/Note"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>       
    </xsl:template>
    <xsl:template name="tAddressInp">
        <xsl:param name="addressInp"/>
        <xsl:if test="$addressInp/Street">
            <xsl:value-of select="concat(', ', $addressInp/Street/@Type, '.', $addressInp/Street/@Name)"/>
        </xsl:if>
        <xsl:if test="$addressInp/Level1">
            <xsl:value-of select="concat(', ', $addressInp/Level1/@Type, '.', $addressInp/Level1/@Value)"/>
        </xsl:if>
        <xsl:if test="$addressInp/Level2">
            <xsl:value-of select="concat(', ', $addressInp/Level2/@Type, '.', $addressInp/Level2/@Value)"/>
        </xsl:if>
        <xsl:if test="$addressInp/Level3">
            <xsl:value-of select="concat(', ', $addressInp/Level3/@Type, '.', $addressInp/Level3/@Value)"/>
        </xsl:if>
        <xsl:if test="$addressInp/Apartment">
            <xsl:value-of select="concat(', ', $addressInp/Apartment/@Type, '.', $addressInp/Apartment/@Value)"/>
        </xsl:if>        
    </xsl:template>
    <xsl:template name="tAppliedFilePDF">
        <xsl:param name="name"/>
        <xsl:element name="object">
            <xsl:attribute name="data">
                <xsl:value-of select="$name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="'application/pdf'"/>
            </xsl:attribute>
            <xsl:value-of disable-output-escaping='yes' select="concat('&lt;embed src=',$name,' type=&quot;application/pdf&quot; /&gt;')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="tAppliedFilesJPEG">
        <xsl:param name="name"/>
        <xsl:element name="object">
            <xsl:attribute name="data">
                <xsl:value-of select="$name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="'image/jpeg'"/>
            </xsl:attribute>
            <xsl:value-of disable-output-escaping='yes' select="concat('&lt;embed src=',$name,' type=&quot;image/jpeg&quot; /&gt;')"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="header1">
        <xsl:param name="text1"/>
        <xsl:param name="text2"/>
        <table class="tbl_section_title" style="text-align: center;">
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
    <xsl:template name="inputText">        
        <xsl:param name="date_center"/>
        <xsl:param name="zone"/>
        <xsl:param name="textarea"/>
        <xsl:choose>
            <xsl:when test="$date_center = 'true'">
                <input class="pole date_center" type="text"/>
            </xsl:when>
            <xsl:when test="$zone = 'true'">
                <input class="pole zone" type="text"/>
            </xsl:when>
            <xsl:when test="$textarea">
                <textarea class="pole"/>
            </xsl:when>
            <xsl:otherwise>
                <input class="pole" type="text"/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    <xsl:template name="procherk">
        <div class="procherk">
            <b>&#x2015;</b>
        </div>
    </xsl:template>
    <xsl:template name="newPage">
        <div style="page-break-after:always"> </div>
    </xsl:template>
    <xsl:template name="min">
        <xsl:param name="items"/>
        <xsl:for-each select="$items">
            <xsl:sort select="." data-type="number" order="ascending"/>
            <xsl:if test="position() = 1">
                <xsl:value-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="max">
        <xsl:param name="items"/>
        <xsl:for-each select="$items">
            <xsl:sort select="." data-type="number" order="descending"/>
            <xsl:if test="position() = 1">
                <xsl:value-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="StringReplace">
        <xsl:param name="input" />
        <xsl:param name="oldValue" />
        <xsl:param name="newValue" />
        <xsl:choose>
            <xsl:when test="contains($input, $oldValue)">
                <xsl:value-of select="substring-before($input,$oldValue)" />
                <xsl:value-of select="$newValue" disable-output-escaping="yes"/>
                <xsl:call-template name="StringReplace">
                    <xsl:with-param name="input"
                        select="substring-after($input,$oldValue)" />
                    <xsl:with-param name="oldValue" select="$oldValue" />
                    <xsl:with-param name="newValue" select="$newValue" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="svgPolygon">
        <xsl:param name="color"/>
        <xsl:param name="stroke_width"/>
        <xsl:element name="polygon">
            <xsl:attribute name="points">
                <xsl:for-each select="SpelementUnit">
                    <!--<xsl:sort select="@SuNmb"/>-->
                    <xsl:if test="not(position() = last())">
                        <xsl:value-of select="Ordinate/@Y"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="Ordinate/@X"/>
                        <xsl:if test="following-sibling::SpelementUnit[2]">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:value-of select="concat('fill:none;stroke:', $color, ';stroke-width:', $stroke_width, ';')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="svgPolyline">
        <xsl:param name="color"/>
        <xsl:param name="stroke_width"/>
        <xsl:param name="ordinate"/>
        <xsl:element name="polyline">
            <xsl:attribute name="points">
                <xsl:for-each select="$ordinate">
                    <xsl:value-of select="@Y"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="@X"/>
                    <xsl:if test="not(position() = last())">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:value-of select="concat('fill:none;stroke:', $color, ';stroke-width:', $stroke_width, ';')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="svgPoint">
        <xsl:param name="color"/>
        <xsl:param name="stroke_width"/>
        <xsl:param name="fill_color"/>
        <xsl:element name="circle">
            <xsl:attribute name="cx">
                <xsl:value-of select="Ordinate/@Y"/>
            </xsl:attribute>
            <xsl:attribute name="cy">
                <xsl:value-of select="Ordinate/@X"/>
            </xsl:attribute>
            <xsl:attribute name="r">
                <xsl:value-of select="R + $stroke_width"/>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:value-of select="concat('fill:', $fill_color, ';stroke:', $color, ';stroke-width:', $stroke_width, ';')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
