<%@ page isELIgnored="false" contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="vTemplate" tagdir="/WEB-INF/tags/template" %>

<vTemplate:basic>
    <jsp:attribute name="head">
        <link href="/vispublica/css/style.css" rel="stylesheet" type="text/css" />
        <title>Sobre o Painel SICONV</title>
    </jsp:attribute>
    <jsp:attribute name="content">
        <div class="sobre">
            <div class="headerSobre">
                <span class="titleSobre">Informações do Painel SICONV</span>
            </div>
            <div class="contentSobre">
                <p>O objetivo do painel é apresentar de forma gráfica e interativa os convênios firmados pelo Poder Executivo Federal da Administração Pública entre os anos de 2007 a 2015.</p><br>

                <p>O Painel Siconv foi desenvolvido pela COPPE/UFRJ em parceria com a UNIFEI (Universidade Federal de Itajubá) e o Ministério do Planejamento, Orçamento e Gestão.</p><br>

                <p>Este painel faz parte do projeto VisPublica (Visualização de Dados Públicos) que foi elaborado com a finalidade de investigar as técnicas de Visualização de Informação e sua aplicação no contexto governamental.</p><br>

                <p>Para o desenvolvimento do painel foram utilizadas as seguinte técnicas e tecnologias:</p><br>
                <ul>
                    <li>O Mapa foi construído com a tecnologia SVG (Scalable Vector Graphics - Gráficos Vetoriais Escaláveis)</li>

                    <li>Para a elaboração do Gráfico de Barras foi utilizado a tecnologia Highcharts</li>

                    <li>A Tabela foi gerada com a tecnologia Google Visualization API</li>
                </ul>

                <p>Os dados apresentados estão disponíveis no Portal de Convênios através do link abaixo.</p><br>

                <p>Convênios Firmados Pelo Poder Executivo da Administração Pública Federal:<br><a href="http://api.convenios.gov.br/siconv/doc/" target="_blank">http://api.convenios.gov.br/siconv/doc/</a></p><br>

                <p>O Código Fonte Desta Aplicação esta disponível em: <br><a href="https://github.com/vispublica/VisPublicaPainelSiconv" target="_blank">https://github.com/vispublica/VisPublicaPainelSiconv</a></p><br>

                <p>Para saber mais sobre o projeto VisPublica e as técnicas e tecnologias utilizadas no painel, acesse portal <a href="http://vispublica.gov.br/" target="_blank">VisPublica</a></p><br>
            </div>
             </div>
        </jsp:attribute>
    </vTemplate:basic>
