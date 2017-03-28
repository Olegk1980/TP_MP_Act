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
                <script type="text/javascript" src="https://d3js.org/d3.v4.min.js"/>
                <style type="text/css">
                        body{color:#000;font-family:times new roman, arial, sans-serif;text-align:center}
                        table{border:0; width:180mm; margin-left:auto; margin-right:auto; border-collapse:collapse;empty-cells:show}
                        table.tbl_container{width:100%;border-collapse:collapse;border:0;padding:1px}
                        
                       
                        th{color:#000;font-family:times new roman, arial, sans-serif;font-size:10pt;font-weight:400;text-align:center;}
                        td{color:#000;font-family:times new roman, arial, sans-serif;font-size:10pt;font-weight:400;text-align:center;}                        
                        span.center{text-align:center}
                        div.title1{text-align:right;padding-right:10px;font-size:100%}
                        div.title2{margin-left:auto;margin-right:auto;font-size:100%;text-align:center;}
                        div.left{text-align:left;font-size:100%}
                        div.center{text-align:center;font-size:100%}
                        div.procherk{vertical-align:top;width:100%}
                        span.undestroke{padding-left:4px;padding-right:4px;border-bottom:1px solid #000}
                        object{width: 100%; height: 920px;}
                        embed{width: 100%; height: 920px;}
                        .tbl_section_sheet{
                            border:3px double #000;
                            padding:1px;
                            margin-bottom:-3px;
                        }
                        .tbl_section_sheet_data{
                            border-left-width: 3px;
                            border-left-style: double;
                            border-right-width: 3px;
                            border-right-style: double;
                            padding:1px;                    
                            margin-bottom:-1px;
                        }
                        .tbl_border_bottom{
                            border-bottom-width: 3px;
                            border-bottom-style: double;
                            padding:1px;
                            margin-bottom:-3px;
                        }
                        .tbl_section_sheet th,.tbl_section_sheet td,
                        .tbl_section_sheet_data th, .tbl_section_sheet_data td{
                            text-align:center; 
                            border:1px solid #000;
                            vertical-align:middle;
                            margin:0;
                            padding:3px 3px;
                        }
                        .tbl_section_sheet th.left,.tbl_section_sheet td.left{text-align:left}
                        .tbl_section_sheet_data th.left,.tbl_section_sheet_data td.left{text-align:left}                        
                        
                        .tbl_section_sheet th.vtop,.tbl_section_sheet td.vtop{vertical-align:top}
                        
                        .tbl_section_sheet th.vborder0,.tbl_section_sheet td.vborder0{border-left: 0px;border-right: 0px;}
                        
                        .tbl_section_sheet th.gborder0,.tbl_section_sheet td.gborder0{border-bottom: 0px;border-top: 0px;}
                        .tbl_section_sheet_data th.gborder0,.tbl_section_sheet_data td.gborder0{border-bottom: 0px;border-top: 0px;}
                        
                        .tbl_section_sheet_data th.col5mm,.tbl_section_sheet_data td.col5mm{width: 5mm}
                        .tbl_section_sheet_data th.col7-5mm,.tbl_section_sheet_data td.col7-5mm{width: 7.5mm}
                        .tbl_section_sheet_data th.col10mm,.tbl_section_sheet_data td.col10mm{width: 10mm}
                        .tbl_section_sheet_data th.col15mm,.tbl_section_sheet_data td.col15mm{width: 15mm}
                        .tbl_section_sheet_data th.col20mm,.tbl_section_sheet_data td.col20mm{width: 20mm}
                        .tbl_section_sheet_data th.col25mm,.tbl_section_sheet_data td.col25mm{width: 25mm}
                        .tbl_section_sheet_data th.col30mm,.tbl_section_sheet_data td.col30mm{width: 30mm}
                        .tbl_section_sheet_data th.col35mm,.tbl_section_sheet_data td.col35mm{width: 35mm}
                        .tbl_section_sheet_data th.col40mm,.tbl_section_sheet_data td.col40mm{width: 40mm}
                        .tbl_section_sheet_data th.col50mm,.tbl_section_sheet_data td.col50mm{width: 50mm}
                        .tbl_section_sheet_data th.col55mm,.tbl_section_sheet_data td.col55mm{width: 55mm}
                        .tbl_section_sheet_data th.col60mm,.tbl_section_sheet_data td.col60mm{width: 60mm}
                        .tbl_section_sheet_data th.col80mm,.tbl_section_sheet_data td.col80mm{width: 80mm}
                        .tbl_section_sheet_data th.col105mm,.tbl_section_sheet_data td.col105mm{width: 105mm}
                        
                        DIV.conclusion{overflow: scroll;word-break: break-all;}
                        @media print{
                            .notprint{display:none}
                        }
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
                                                                <xsl:with-param name="text2" select="'ОБЪЕКТ НЕЗАВЕРШЕННОГО СТРОИТЕЛЬСТВА'"/>
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
            <xsl:when test="$newFlats">
                <xsl:for-each select="$newFlats/NewFlat">
                    <xsl:apply-templates select="."></xsl:apply-templates>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$existFlat">
                <xsl:apply-templates select="$existFlat"/>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="Conclusion"/>
        <xsl:apply-templates select="SchemeGeodesicPlotting"/>
        <xsl:apply-templates select="SchemeDisposition"/>
        <xsl:apply-templates select="DiagramContour"/>
        <xsl:apply-templates select="Appendix"/>
        <xsl:if test="//EntitySpatial">
            <xsl:call-template name="GenerateMap">
                <xsl:with-param name="entitySpatial" select="//EntitySpatial"></xsl:with-param>
            </xsl:call-template>
        </xsl:if>        
    </xsl:template>
    <xsl:template match="GeneralCadastralWorks">
        <table class="tbl_section_sheet">
            <tbody>
                <tr>
                    <th class="left gborder0">
                        <b>1. Технический план подготовлен в результате выполнения кадастровых работ в связи с:</b>
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
                        <b>2. Сведения о заказчике кадастровых работ</b>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="3" class="left">
                            <b>1. Перечень документов, использованных при подготовке технического плана</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th class="col105mm">Наименование документа</th>
                        <th>Реквизиты документа</th>
                    </tr>
                </table>
            </caption>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="8" class="left">
                            <b>2. Сведения о геодезической основе, использованной при подготовке технического плана
                                <div>
                                    <xsl:text>Система координат </xsl:text>
                                    <ins>
                                        <xsl:for-each select="preceding-sibling::CoordSystems/CoordSystem">
                                            <xsl:value-of select="@Name"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </ins>
                                </div>
                            </b>
                        </th>
                    </tr>
                    <tr>
                        <th rowspan="2" class="col5mm">№<br/>п/п</th>
                        <th rowspan="2">Название пункта и тип знака геодезической сети</th>
                        <th rowspan="2" class="col25mm">Класс геодезической сети</th>
                        <th colspan="2" class="col40mm">Координаты, м</th>
                        <th colspan="3" class="col60mm">Сведения о состоянии на <input type="text" id="date_center"/></th>
                    </tr>
                    <tr>
                        <th class="col20mm">X</th>
                        <th class="col20mm">Y</th>
                        <th class="col20mm">наружного знака пункта</th>
                        <th class="col20mm">центра пункта</th>
                        <th class="col20mm">марки</th>
                    </tr>
                </table>
            </caption>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="4" class="left">
                            <b>3. Сведения о средствах измерений</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th class="col55mm">Наименование прибора (инструмента, аппаратуры)</th>
                        <th class="col55mm">Сведения об утверждении типа средств измерений</th>
                        <th>Реквизиты свидетельства о поверке прибора (инструмента, аппаратуры)</th>
                    </tr>
                </table>
            </caption>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="2" class="left">
                            <b>4. Сведения об объекте (объектах) недвижимости, из которого (которых) был образован объект недвижимости</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th>Кадастровый номер</th>
                    </tr>
                </table>
            </caption>
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
        <table class="tbl_section_sheet_data">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="2" class="left">
                            <b>5. Сведения о помещениях, машино-местах, расположенных в здании, сооружении</b>
                        </th>
                    </tr>
                    <tr>
                        <th colspan="2" class="left">
                            <b>5.1. Сведения о помещениях, расположенных в здании, сооружении</b>    
                        </th>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th>Кадастровый номер помещения</th>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <td class="col5mm">1</td>
                    <td>2</td>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="2" class="left">
                            <b>5.2. Сведения о машино-местах, расположенных в здании, сооружении</b>    
                        </th>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th>Кадастровый номер машино-места</th>
                    </tr>
                </table>
            </caption>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="3" class="left">
                            <b>1. Метод определения координат характерных точек контура объекта недвижимости, части (частей) объекта недвижимости</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col15mm">Номер контура</th>
                        <th class="col35mm">Номера характерных точек контура</th>
                        <th>Метод определения координат</th>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col15mm">1</th>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="3" class="left">
                            <b>2. Точность определения координат характерных точек контура объекта недвижимости</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col15mm">Номер контура</th>
                        <th class="col35mm">Номера характерных точек контура</th>
                        <th>Формулы, примененные для расчетасредней квадратической погрешности определения координат характерных точек контура(Mt),м</th>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col15mm">1</th>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="4" class="left">
                            <b>3. Точность определения координат характерных точек контура части (частей) объекта недвижимости</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col15mm">Номер контура</th>
                        <th class="col35mm">Номера характерных точек контура</th>
                        <th class="col35mm">Учетный номер или обозначение части</th>
                        <th>Формулы, примененные для расчетасредней квадратической погрешности определения координат характерных точек контура(Mt),м</th>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col15mm">1</th>
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
                        <td><xsl:call-template name="procherk"/></td>
                        <td><xsl:call-template name="procherk"/></td>
                        <td><xsl:call-template name="procherk"/></td>
                        <td><xsl:call-template name="procherk"/></td>
                    </xsl:otherwise>                
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="NewBuilding | ExistBuilding | NewConstruction | ExistConstruction | SubBuilding | SubConstruction">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Описание местоположения объекта недвижимости'"/>
        </xsl:call-template>        
        <table class="tbl_section_sheet_data">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="9" class="left">
                            <b>1. Описание местоположения здания, сооружения, объекта незавершенного строительства на земельном участке</b>
                        </th>
                    </tr>
                    <tr>
                        <th colspan="9" class="left gborder0">
                            <b>1.1. Сведения о характерных точках контура объекта недвижимости</b>    
                        </th>
                    </tr>
                    <tr>
                        <td colspan="9" class="left gborder0">
                            Зона N
                            <input type="text" style="text-decoration: underline;width: 25%;"/>
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="2" class="col15mm">Номер контура</th>
                        <th rowspan="2" class="col20mm">Номера характерных точек контура</th>
                        <th colspan="2" class="col40mm">Координаты, м</th>
                        <th rowspan="2" class="col10mm">R,м</th>
                        <th rowspan="2">Средняя квадратическая погрешность определения координат характерных точек контура (Mt),м</th>
                        <th rowspan="2" class="col20mm">Тип контура</th>
                        <th colspan="2" class="col15mm">Глубина, высота, м</th>
                    </tr>
                    <tr>
                        <th class="col20mm">X</th>
                        <th class="col20mm">Y</th>
                        <th class="col7-5mm">H1</th>
                        <th class="col7-5mm">H2</th>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <td class="col15mm">1</td>
                    <td class="col20mm">2</td>
                    <td class="col20mm">3</td>
                    <td class="col20mm">4</td>
                    <td class="col10mm">5</td>
                    <td>6</td>
                    <td class="col20mm">7</td>
                    <td class="col7-5mm">8</td>
                    <td class="col7-5mm">9</td>
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
        <table class="tbl_section_sheet_data">
            <tbody>
                <tr>
                    <th colspan="2" class="left">
                        <b>1.2. Сведения о предельных глубине и высоте конструктивных элементов объекта недвижимости</b>
                    </th>
                </tr>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="9" class="left gborder0">
                            <b>1.3. Сведения о характерных точках пересечения контура объекта недвижимости с контуром (контурами) иных зданий, сооружений, объектов незавершенного строительства</b>    
                        </th>
                    </tr>
                    <tr>
                        <td colspan="9" class="left gborder0">
                            Зона N
                            <input type="text" style="text-decoration: underline;width: 25%;"/>                      
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
                        <th class="col7-5mm">H2</th>
                    </tr>
                </table>
            </caption>
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
    </xsl:template>
    <xsl:template match="NewFlat | ExistFlat">
        <xsl:call-template name="Characteristics">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="Characteristics">        
        <xsl:param name="node"/>
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Характеристики объекта недвижимости'"/>
        </xsl:call-template> 
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th class="col5mm">N п/п</th>
                        <th class="col80mm">Наименование характеристики</th>
                        <th>Значение характеристики</th>
                    </tr>
                </table>
            </caption>
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
                            <xsl:when test="$node/Address">
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
                        <xsl:call-template name="procherk"/>
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
                    <td class="left"><xsl:value-of select="$node/Name"/></td>
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
    <xsl:template match="Conclusion">
        <xsl:call-template name="header1">
            <xsl:with-param name="text1" select="'Заключение кадастрового инженера'"/>
        </xsl:call-template>
        <table class="tbl_section_sheet">
            <tbody>
                <tr>
                    <td class="left">
                        <div class="conclusion">
                            <xsl:value-of select="."/>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="SchemeGeodesicPlotting">
        <xsl:call-template name="newPage"/>
        <table class="tbl_container notprint">
            <tbody>
                <tr>
                    <td>
                        <xsl:call-template name="header1">
                            <xsl:with-param name="text1" select="'Схема геодезических построений'"/>
                        </xsl:call-template>
                        <table class="tbl_section_sheet">
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
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="SchemeDisposition">
        <xsl:call-template name="newPage"/>
        <table class="tbl_container notprint">
            <tbody>
                <tr>
                    <td>
                        <xsl:call-template name="header1">
                            <xsl:with-param name="text1" select="'Схема расположения'"/>
                        </xsl:call-template>
                        <table class="tbl_section_sheet">
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
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="DiagramContour">
        <table class="tbl_container notprint">
            <tbody>
                <tr>
                    <td>
                        <xsl:choose>
                            <xsl:when test="AppliedFile">
                                <xsl:for-each select="AppliedFile">
                                    <xsl:call-template name="newPage"/>
                                    <xsl:call-template name="header1">
                                        <xsl:with-param name="text1" select="'Чертеж объекта'"/>
                                    </xsl:call-template>
                                    <table class="tbl_section_sheet">
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
                                <table class="tbl_section_sheet">
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
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="Appendix">
        <xsl:call-template name="newPage"/>
        <table class="tbl_container notprint">
            <tbody>
                <tr>
                    <td>
                        <xsl:call-template name="header1">
                            <xsl:with-param name="text1" select="'Приложения'"/>
                        </xsl:call-template>
                        <table class="tbl_section_sheet_data tbl_border_bottom">
                            <caption>
                                <table class="tbl_section_sheet_data">
                                    <tr>
                                        <th class="col25mm">Номер приложения</th>
                                        <th class="col80mm">Наименование приложения</th>
                                        <th>Приложенный файл</th>
                                    </tr>
                                </table>
                            </caption>
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
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="GenerateMap">
        <xsl:param name="entitySpatial"/>
        <xsl:call-template name="newPage"/>
        <div class="notprint">
            <xsl:call-template name="header1">
                <xsl:with-param name="text1" select="'Сгенерированная карта'"/>
            </xsl:call-template>
            <svg width="1024" height="800"/>
            <xsl:variable name="yMin">
                <xsl:for-each select="//NewBuilding/EntitySpatial/*//Ordinate/@Y | //NewConstruction/EntitySpatial/*//Ordinate/@Y | //ExistBuilding/EntitySpatial/*//Ordinate/@Y | //ExistConstruction/EntitySpatial/*//Ordinate/@Y">
                    <xsl:sort select="." data-type="number" order="ascending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="xMin">
                <xsl:for-each select="//NewBuilding/EntitySpatial/*//Ordinate/@X | //NewConstruction/EntitySpatial/*//Ordinate/@X | //ExistBuilding/EntitySpatial/*//Ordinate/@X | //ExistConstruction/EntitySpatial/*//Ordinate/@X">
                    <xsl:sort select="." data-type="number" order="ascending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="yMax">
                <xsl:for-each select="//NewBuilding/EntitySpatial/*//Ordinate/@Y | //NewConstruction/EntitySpatial/*//Ordinate/@Y | //ExistBuilding/EntitySpatial/*//Ordinate/@Y | //ExistConstruction/EntitySpatial/*//Ordinate/@Y">
                    <xsl:sort select="." data-type="number" order="descending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="xMax">
                <xsl:for-each select="//NewBuilding/EntitySpatial/*//Ordinate/@X | //NewConstruction/EntitySpatial/*//Ordinate/@X | //ExistBuilding/EntitySpatial/*//Ordinate/@X | //ExistConstruction/EntitySpatial/*//Ordinate/@X">
                    <xsl:sort select="." data-type="number" order="descending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <script>
                var json = {"type":"FeatureCollection","features":[
                <xsl:for-each select="//NewBuilding/EntitySpatial/SpatialElement | //NewConstruction/EntitySpatial/SpatialElement | //ExistBuilding/EntitySpatial/SpatialElement | //ExistConstruction/EntitySpatial/SpatialElement">
                    <xsl:choose>
                        <!-- Точка -->
                        <xsl:when test="SpelementUnit/@TypeUnit = 'Окружность'">
                            <xsl:for-each select="SpelementUnit">
                                <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                                <xsl:value-of select="'&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;points&quot;},'"/>
                                <xsl:value-of select="'&quot;geometry&quot;:{&quot;type&quot;:&quot;Point&quot;,&quot;coordinates&quot;:'"/>
                                <xsl:value-of select="concat('[',Ordinate/@Y,',',Ordinate/@X,']')"/>
                                <xsl:value-of select="',&quot;radius&quot;:'"/> 
                                <xsl:value-of select="R"/>
                                <xsl:value-of select="'}}'"/>
                                <xsl:if test="not(position() = last())">
                                    <xsl:value-of select="','"/>
                                </xsl:if>
                            </xsl:for-each>                                        
                        </xsl:when>
                        <!-- Полилиния -->
                        <xsl:when test="not(SpelementUnit[1]/Ordinate/@X | SpelementUnit[1]/Ordinate/@Y | SpelementUnit[1]/Ordinate/@NumGeopoint = SpelementUnit[last()]/Ordinate/@X | SpelementUnit[last()]/Ordinate/@Y | SpelementUnit[last()]/Ordinate/@NumGeopoint)">
                            <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                            <xsl:value-of select="'&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;polylines&quot;},'"/>
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
                        <xsl:otherwise>
                            <xsl:value-of select="'{&quot;type&quot;:&quot;Feature&quot;,'"/>
                            <xsl:value-of select="'&quot;properties&quot;:{&quot;ObjectType&quot;:&quot;polygons&quot;},'"/>
                            <xsl:value-of select="'&quot;geometry&quot;:{&quot;type&quot;:&quot;Polygon&quot;,&quot;coordinates&quot;:[['"/>
                            <xsl:for-each select="SpelementUnit">                                            
                                <xsl:value-of select="concat('[',Ordinate/@Y,',',Ordinate/@X,']')"/>
                                <xsl:if test="not(position() = last())">
                                    <xsl:value-of select="','"/>
                                </xsl:if>
                            </xsl:for-each>                                            
                            <xsl:value-of select="']]}}'"/> 
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="not(position() = last())">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>]};</xsl:text>                            
                
                <xsl:value-of select="concat('var yAvg = ', $yMin + (($yMax - $yMin) div 2),';')"/>
                <xsl:value-of select="concat('var xAvg = ', $xMax + (($xMin - $xMax) div 2),';')"/>
                <xsl:choose>
                    <xsl:when test="($yMax - $yMin) &gt; 1024">
                        <xsl:value-of select="concat('var scaleMx = ', 1,';')"/>
                        <xsl:value-of select="concat('var scaleEx = ', ($xMax - $xMin) div 800,';')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('var scaleEx = ', 2,';')"/>
                        <xsl:value-of select="concat('var scaleMx = ', floor(1024 div ($yMax - $yMin)),';')"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                var svg = d3.select("svg");
                var width = +svg.attr("width");
                var height = +svg.attr("height");
                
                var path = d3.geoPath()
                .projection(matrix(scaleMx, 0, 0, -scaleMx, (width/2)-(yAvg*scaleMx), (height/2)+(xAvg*scaleMx)));
                function matrix(a, b, c, d, tx, ty) {
                return d3.geoTransform({
                point: function(x, y) {
                this.stream.point(a * x + b * y + tx, c * x + d * y + ty);
                }
                });
                }    
                
                var g = svg.append("g");                            
                svg.append("rect")
                .attr("width", width)
                .attr("height", height)
                .call(d3.zoom()
                .scaleExtent([1 / scaleEx, 5])
                .on("zoom", function () {
                g.attr("transform", d3.event.transform);
                }));
                
                var polygon = json.features.filter(function(d) { return d.properties.ObjectType === "polygons";});
                g.selectAll(".polygons")
                .data(polygon)
                .enter().append("path")
                .attr("class", "polygons")
                .attr("d", path);
                var point = json.features.filter(function(d) { return d.properties.ObjectType === "points";});
                g.selectAll(".points")
                .data(point)
                .enter().append("path")
                .attr("class", "points")
                .attr("d", path);           
                var polyline = json.features.filter(function(d) { return d.properties.ObjectType === "polylines";});
                g.selectAll(".polylines")
                .data(polyline)
                .enter().append("path")
                .attr("class", "polylines")
                .attr("d", path);                                
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
                    <xsl:value-of select="'сохраненно'"/>
                </td>
                <td>
                    <xsl:value-of select="'сохраненно'"/>
                </td>
                <td>
                    <xsl:value-of select="'сохраненно'"/>
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
        <xsl:variable name="allContour" select="count(Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])])"/>
        <xsl:for-each select="Element[generate-id(.) = generate-id(key('geopointElements', @Number)[1])]">
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
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="TochnGeopointsBuilding | TochnGeopointsConstruction | TochnGeopointsUncompleted">
        <xsl:variable name="allContour" select="count(Element[generate-id(.) = generate-id(key('tochnGeopointElements', @Number)[1])])"/>
        <xsl:for-each select="Element[generate-id(.) = generate-id(key('tochnGeopointElements', @Number)[1])]">
            <xsl:variable name="firstNumGeopoint" select="@NumGeopoint"/>
            <xsl:variable name="lastNumGeopoint" select="key('tochnGeopointElements', @Number)[last()]/@NumGeopoint"/>
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
                            <xsl:value-of select="./Formula"/>
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
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>        
    </xsl:template>
    <xsl:template match="TochnGeopointsSubBuilding | TochnGeopointsSubConstruction | TochnGeopointsSubUncompleted">
        <xsl:variable name="allContour" select="count(Element[generate-id(.) = generate-id(key('tochnGeopointsSubElements', @Number)[1])])"/>
        <xsl:for-each select="Element[generate-id(.) = generate-id(key('tochnGeopointsSubElements', @Number)[1])]">
            <xsl:variable name="firstNumGeopoint" select="@NumGeopoint"/>
            <xsl:variable name="lastNumGeopoint" select="key('tochnGeopointsSubElements', @Number)[last()]/@NumGeopoint"/>
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
            <xsl:for-each select="SpelementUnit">
                <tr>
                    <td>
                        <xsl:value-of select="$num"/>
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
