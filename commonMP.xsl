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
                    thead{display: table-header-group;}
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
                    .tbl_section_sheet th, .tbl_section_sheet td, 
                    .tbl_section_sheet_data th, .tbl_section_sheet_data td{
                    border:1px solid #000;
                    vertical-align:middle;
                    margin:0;
                    padding:3px 3px;
                    }
                    .tbl_section_sheet_data th.col5mm,.tbl_section_sheet_data td.col5mm{width: 5mm}
                    .tbl_section_sheet_data th.col20mm,.tbl_section_sheet_data td.col20mm{width: 20mm}
                    .tbl_section_sheet_data th.col25mm,.tbl_section_sheet_data td.col25mm{width: 25mm}
                    .tbl_section_sheet_data th.col30mm,.tbl_section_sheet_data td.col30mm{width: 30mm}
                    .tbl_section_sheet_data th.col40mm,.tbl_section_sheet_data td.col40mm{width: 40mm}
                    .tbl_section_sheet_data th.col50mm,.tbl_section_sheet_data td.col50mm{width: 50mm}
                    .tbl_section_sheet_data th.col55mm,.tbl_section_sheet_data td.col55mm{width: 55mm}
                    .tbl_section_sheet_data th.col60mm,.tbl_section_sheet_data td.col60mm{width: 60mm}
                    .tbl_section_sheet_data th.col105mm,.tbl_section_sheet_data td.col105mm{width: 105mm}

                    .tbl_section_sheet_data th.left,.tbl_section_sheet_data td.left{text-align:left}
                                        
                    .tbl_section_sheet th.left,.tbl_section_sheet td.left{text-align:left}
                    .tbl_section_sheet th.vtop,.tbl_section_sheet td.vtop{vertical-align:top}
                    .tbl_section_sheet th.vborder0,.tbl_section_sheet td.vborder0{border-left: 0px;border-right: 0px;}
                    .tbl_section_sheet th.gborder0,.tbl_section_sheet td.gborder0{border-bottom: 0px;border-top: 0px;}

                    DIV.conclusion{width: 176mm; overflow: scroll;}
                    
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
                                                    <xsl:apply-templates select="Survey"/>
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
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
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
                <xsl:apply-templates select="Documents"/>                
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
                <xsl:apply-templates select="GeodesicBases"/>
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
                <xsl:apply-templates select="MeansSurvey"/>
            </tbody>
        </table>
        <table class="tbl_section_sheet_data tbl_border_bottom">
            <caption>
                <table class="tbl_section_sheet_data">
                    <tr>
                        <th colspan="3" class="left">
                            <b>4. Сведения о наличии объектов недвижимости на исходных земельных участках</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th class="col55mm">Кадастровый номер земельного участка</th>
                        <th>Кадастровые или иные номера объектов недвижимости, расположенных на земельном участке</th>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <td class="col5mm">1</td>
                    <td class="col55mm">2</td>
                    <td>3</td>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="ObjectsRealty">
                        <xsl:apply-templates select="ObjectsRealty"/>
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
                            <b>5. Сведения о частях исходных или уточняемых земельных участках</b>
                        </th>
                    </tr>
                    <tr>
                        <th class="col5mm">№<br/>п/п</th>
                        <th class="col55mm">Кадастровый номер земельного участка</th>
                        <th>Учетные номера частей земельного участка</th>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <td class="col5mm">1</td>
                    <td class="col55mm">2</td>
                    <td>3</td>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="SubParcels">
                        <xsl:apply-templates select="SubParcels"/>
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
                            <b>1. Метод определения координат характерных точек границ земельных участков и их
                                частей</b>
                        </th>
                        <tr>
                            <th class="col5mm">№<br/>п/п</th>
                            <th class="col55mm">Кадастровый номер или обозначение земельного участка, частей земельного
                                участка</th>
                            <th>Метод определения координат</th>
                        </tr>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col55mm">2</th>
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
                            <b>2. Точность положения характерных точек границ земельных участков</b>
                        </th>
                        <tr>
                            <th class="col5mm">№<br/>п/п</th>
                            <th class="col55mm">Кадастровый номер или обозначение земельного участка, частей земельного
                                участка</th>
                            <th>Формулы, примененные для расчета средней квадратической погрешности
                                положения характерных точек границ (Mt),м</th>
                        </tr>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col55mm">2</th>
                    <th>3</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="TochnGeopointsParcels">
                        <xsl:apply-templates select="TochnGeopointsParcels"/>
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
                            <b>3. Точность положения характерных точек границ частей земельных участков</b>
                        </th>
                        <tr>
                            <th class="col5mm">№<br/>п/п</th>
                            <th class="col55mm">Кадастровый номер или обозначение земельного участка</th>
                            <th class="col30mm">Учетный номер или обозначение части</th>
                            <th>Формулы, примененные для расчета средней квадратической погрешности
                                положения характерных точек границ (Mt),м</th>
                        </tr>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col55mm">2</th>
                    <th class="col30mm">3</th>
                    <th>4</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="TochnGeopointsSubParcels">
                        <xsl:apply-templates select="TochnGeopointsSubParcels"/>
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
                        <th colspan="4" class="left">
                            <b>4. Точность определения площади земельных участков</b>
                        </th>
                        <tr>
                            <th class="col5mm">№<br/>п/п</th>
                            <th class="col55mm">Кадастровый номер или обозначение земельного участка</th>
                            <th class="col25mm">Площадь(Р), м²</th>
                            <th>Формулы, примененные для расчета предельной допустимой погрешности
                                определения площади земельного участка(∆Р), м²</th>
                        </tr>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col55mm">2</th>
                    <th class="col25mm">3</th>
                    <th>4</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="TochnAreaParcels">
                        <xsl:apply-templates select="TochnAreaParcels"/>
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
                        <th colspan="5" class="left">
                            <b>5. Точность определения площади частей земельных участков</b>
                        </th>
                        <tr>
                            <th class="col5mm">№<br/>п/п</th>
                            <th class="col55mm">Кадастровый номер или обозначение земельного участка</th>
                            <th class="col30mm">Учетный номер или обозначение части</th>
                            <th class="col25mm">Площадь(Р), м²</th>
                            <th>Формулы, примененные для расчета предельной допустимой погрешности
                                определения площади земельного участка(∆Р), м²</th>
                        </tr>
                    </tr>
                </table>
            </caption>
            <thead>
                <tr>
                    <th class="col5mm">1</th>
                    <th class="col55mm">2</th>
                    <th class="col30mm">3</th>
                    <th class="col25mm">4</th>
                    <th>5</th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="TochnAreaSubParcels">
                        <xsl:apply-templates select="TochnAreaSubParcels"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
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
                <td class="left">
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
    <xsl:template match="ObjectsRealty">
        <xsl:for-each select="ObjectRealty">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="CadastralNumberParcel"/>
                </td>
                <td>
                    <xsl:for-each select="InnerCadastralNumbers/CadastralNumber">
                        <xsl:value-of select="."/>
                        <xsl:choose>
                            <xsl:when test="position() != last()">
                                <xsl:value-of select="', '"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="OldNumbers">
                                    <xsl:value-of select="', '"/>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="OldNumbers/OldNumber">
                        <xsl:if test="position() != last()">
                            <xsl:value-of select="', '"/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="SubParcels">
        <xsl:for-each select="SubParcel">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="CadastralNumberParcel"/>
                </td>
                <td>
                    <xsl:value-of select="NumberRecord"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <!-- *********************Survey************************** -->
    <xsl:template match="GeopointsOpred">
        <xsl:for-each select="GeopointOpred">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="CadastralNumberDefinition"/>
                </td>
                <td>
                    <xsl:for-each select="Methods">
                        <xsl:variable name="gpOpred" select="document(concat($urlPrefixDict, 'dGeopointOpred_v01.xsd'))"/>
                        <xsl:variable name="code" select="GeopointOpred"/>
                        <xsl:value-of select="$gpOpred//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"/>
                        <xsl:if test="GeopointOpredDescription">
                            <xsl:value-of select="concat(' (',GeopointOpredDescription,')')"/>
                        </xsl:if>
                        <xsl:if test="position() != last()">
                            <xsl:value-of select="', '"/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="TochnGeopointsParcels">
        <xsl:for-each select="TochnGeopointsParcel">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="CadastralNumberDefinition"/>
                </td>
                <td>
                    <xsl:value-of select="Formula"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="TochnGeopointsSubParcels">
        <xsl:for-each select="TochnGeopointsSubParcel">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="CadastralNumberDefinition"/>
                </td>
                <td>
                    <xsl:value-of select="NumberRecordDefinition"/>
                </td>
                <td>
                    <xsl:value-of select="Formula"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="TochnAreaParcels">
        <xsl:for-each select="TochnAreaParcel">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td>
                    <xsl:value-of select="CadastralNumberDefinition"/>
                </td>
                <td>
                    <xsl:value-of select="Area/Area"/>
                </td>
                <td>
                    <xsl:value-of select="Formula"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="TochnAreaSubParcels">
        <xsl:for-each select="TochnAreaSubParcel">
            <tr>
                <td>
                    <xsl:value-of select="position()"/>
                </td>
                <td class="left">
                    <xsl:value-of select="CadastralNumberDefinition"/>
                </td>
                <td>
                    <xsl:value-of select="NumberRecordDefinition"/>
                </td>
                <td>
                    <xsl:value-of select="Area/Area"/>
                </td>
                <td class="left">
                    <xsl:value-of select="Formula"/>
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