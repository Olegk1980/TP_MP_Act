<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:act="urn://x-artefacts-rosreestr-ru/incoming/inspection/1.0.1"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="urn://x-artefacts-smev-gov-ru/supplementary/commons/1.0.1"
    xmlns:Doc1="urn://x-artefacts-rosreestr-ru/commons/complex-types/document/1.0.1"
    xmlns:CadEng1="urn://x-artefacts-rosreestr-ru/commons/complex-types/cadastral-engineer/1.0.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:strip-space elements="*"/>
    <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes"
        omit-xml-declaration="yes" encoding="UTF-8"/>

    <!--Путь к справочникам отсчитывается относительно основного шаблона-->
    <xsl:param name="urlPrefixDict" select="'InspectionAct_v01/'"/>

    <xsl:template match="act:InspectionAct">
        <html>
            <head>
                <title>АКТ ОБСЛЕДОВАНИЯ</title>
                <style type="text/css">
                    body{
                        background-color: #fff;
                        color: #000;
                        font-family: times new roman, arial, sans-serif;
                        text-align: center
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
                    .pole{
                        width: 95%;
                    }
                    div.conclusion{
                        word-break: break-all;
                    }                    
                    @media print{
                        .pole{
                            width: 100%;
                            text-decoration: underline;
                            border: 0px solid #C0C0C0;
                            font-family: inherit;
                            font-size: inherit;
                        }
                        .spisok{
                            border: 0px;
                            text-align: center;
                            font-family: inherit;
                            font-size: inherit;
                            -webkit-appearance: none;
                            -moz-appearance: none;
                            appearance: none;                            
                        }
                        .spisok::-ms-expand {
                            display: none;
                        }
                    }</style>
            </head>
            <xsl:element name="body">
                <div style="margin:0 auto; width: 190mm;">
                    <div
                        style="width: 100%; text-align: center; font-size: larger; font-weight: bold; margin: 5px;">
                        <nobr>АКТ ОБСЛЕДОВАНИЯ</nobr>
                    </div>
                    <xsl:apply-templates select="act:Object"/>
                    <xsl:apply-templates select="act:Client"/>
                    <xsl:apply-templates select="act:Contractor"/>
                    <xsl:apply-templates select="act:Documents"/>
                    <xsl:apply-templates select="act:Conclusion"/>
                </div>
            </xsl:element>
        </html>
    </xsl:template>

    <xsl:template match="act:Object">
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td>
                        <b>
                            <xsl:text>1. Акт обследования подготовлен в результате выполнения кадастровых работ в целях представления в орган регистрации прав заявления о снятии с учета </xsl:text>
                        </b>
                        <ins>
                            <xsl:variable name="realty"
                                select="document(concat($urlPrefixDict, 'SchemaCommon/dRealty_v01.xsd'))"/>
                            <xsl:variable name="code" select="act:ObjectType"/>
                            <xsl:value-of
                                select="$realty//xs:enumeration[@value = $code]/xs:annotation/xs:documentation"
                            />
                        </ins>
                        <b>
                            <xsl:text> с кадастровым № </xsl:text>
                        </b>
                        <ins>
                            <xsl:value-of select="act:CadastralNumber"/>
                        </ins>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td style="border: none;">
                        <xsl:text>права на который </xsl:text>
                        <select class="spisok" size="1">
                            <option> зарегистрированы</option>
                            <option>не зарегистрированы</option>
                        </select>
                        <xsl:text> в Едином государственном реестре недвижимости</xsl:text>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="act:Client">
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td>
                        <b>
                            <xsl:text>2. Сведения о заказчике кадастровых работ:</xsl:text>
                        </b>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td style="text-align: center; width: 100%;">
                        <div class="understroke">
                            <xsl:apply-templates
                                select="act:Person | act:Organization | act:Governance | act:ForeignOrganization"
                            />
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
    </xsl:template>

    <xsl:template match="act:Contractor">
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td>
                        <b>
                            <xsl:text>3. Сведения о кадастровом инженере и дате подготовки акта обследования:</xsl:text>
                        </b>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td width="50%"> Фамилия, имя, отчество (последнее - при наличии) </td>
                    <td width="50%">
                        <ins>
                            <xsl:call-template name="FIO">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </ins>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Уникальный регистрационный номер члена саморегулируемой организации кадастровых инженеров в реестре членов саморегулируемой организаци кадастровых инженеров и дата внесения сведений о физическом лице в такой реестр</xsl:text>
                    </td>
                    <td width="50%">
                        <input class="pole" type="text"/>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Страховой номер индивидуального лицевого счета в системе обязательного пенсионного страхования Российской Федерации (СНИЛС)</xsl:text>
                    </td>
                    <td width="50%">
                        <input class="pole" type="text"/>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Контактный телефон</xsl:text>
                    </td>
                    <td width="50%">
                        <ins>
                            <xsl:value-of select="CadEng1:Telephone"/>
                        </ins>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Почтовый  адрес  и  адрес  электронной  почты,  по  которым  осуществляется  связь  с кадастровым инженером</xsl:text>
                    </td>
                    <td width="50%">
                        <ins>
                            <xsl:value-of select="CadEng1:Address"/>
                        </ins>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Наименование саморегулируемой организации кадастровых инженеров, членом которой является кадастровый инженер</xsl:text>
                    </td>
                    <td width="50%">
                        <input class="pole" type="text"/>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Полное или (в случае, если имеется) сокращенное наименование юридического лица, если кадастровый инженер является работником юридического лица, адрес юридического лица</xsl:text>
                    </td>
                    <td width="50%">
                        <ins>
                            <xsl:value-of
                                select="concat(CadEng1:Organization/CadEng1:Name, ', ', CadEng1:Organization/CadEng1:AddressOrganization)"
                            />
                        </ins>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Наименование, номер и дата документа, на основании которого выполняются кадастровые работы</xsl:text>
                    </td>
                    <td width="50%">
                        <input class="pole" type="text"/>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <xsl:text>Дата подготовки Акта обследования (число, месяц, год) </xsl:text>
                    </td>
                    <td width="50%">
                        <ins>
                            <xsl:value-of select="concat(substring(@Date, 9, 2), '.')"/>
                            <xsl:value-of select="concat(substring(@Date, 6, 2), '.')"/>
                            <xsl:value-of select="substring(@Date, 1, 4)"/>
                        </ins>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="act:Documents">
        <table class="tbl_section_title">
            <tbody>
                <tr>
                    <td>
                        <b>
                            <xsl:text>4. Перечень  документов, использованных при подготовке Акта обследования(наименование и реквизиты документа)</xsl:text>
                        </b>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="tbl_section_content">
            <thead>
                <tr>
                    <th style="border-right-width: 1px">1</th>
                    <th>2</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="act:Document">
                    <tr>
                        <xsl:choose>
                            <xsl:when test="not(position() = last())">
                                <td>
                                    <xsl:value-of select="Doc1:Name"/>
                                </td>
                                <td>
                                    <xsl:value-of select="Doc1:Number"/>
                                    <xsl:if test="Doc1:Date">
                                        <xsl:value-of select="concat(' от ', Doc1:Date)"/>
                                    </xsl:if>
                                </td>
                            </xsl:when>
                            <xsl:otherwise>
                                <td>
                                    <xsl:value-of select="Doc1:Name"/>
                                </td>
                                <td style="border: none;">
                                    <xsl:value-of select="Doc1:Number"/>
                                    <xsl:if test="Doc1:Date">
                                        <xsl:value-of select="concat(' от ', Doc1:Date)"/>
                                    </xsl:if>
                                </td>
                            </xsl:otherwise>
                        </xsl:choose>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="act:Conclusion">
        <div class="isOverPage">
            <table class="tbl_section_title">
                <tbody>
                    <tr>
                        <td>
                            <b>
                                <xsl:text>5. Заключение кадастрового инженера</xsl:text>
                            </b>
                        </td>
                    </tr>
                </tbody>
            </table>
            <table class="tbl_section_content">
            <tbody>
                <tr>
                    <td style="border: none;">
                        <div class="conclusion">
                            <xsl:value-of select="."/>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        </div>
    </xsl:template>

    <xsl:template match="act:Person">
        <xsl:call-template name="FIO">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="act:SNILS">
                <xsl:value-of select="concat(' СНИЛС - ', act:SNILS)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="act:Organization">
        <xsl:value-of select="act:Name"/>
    </xsl:template>
    <xsl:template match="act:Governance">
        <xsl:value-of select="act:Name"/>
    </xsl:template>
    <xsl:template match="act:ForeignOrganization">
        <xsl:value-of select="concat(act:Name, ' ', act:Country)"/>
    </xsl:template>

    <xsl:template name="FIO">
        <xsl:param name="node"/>
        <xsl:value-of
            select="concat($node/tns:FamilyName, ' ', $node/tns:FirstName, ' ', $node/tns:Patronymic)"
        />
    </xsl:template>

</xsl:stylesheet>
