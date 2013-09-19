<%@ page isELIgnored="false" contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="vTemplate" tagdir="/WEB-INF/tags/template" %>

<vTemplate:basic>
    <jsp:attribute name="head">
        <title>Painel SICONV</title>
        <script type="text/javascript" src="/vispublica/js/highcharts/highcharts.js"></script>
        <script src="http://code.highcharts.com/modules/exporting.js"></script>
        <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
        <script type="text/javascript" charset="utf-8" src="siconv_columnChart.js"></script>
        <script type="text/javascript" charset="utf-8" src="siconv_table.js"></script>
        <script type="text/javascript" src="/vispublica/js/d3.v3.min.js"></script>
        <script type="text/javascript" src="/vispublica/js/google/jsapi.js"></script>
        <script src="/vispublica/js/jq-ui.min.js"></script>
        <link href="/vispublica/css/jq-ui.css" rel="stylesheet" type="text/css" />
        <link href="/vispublica/css/dashboard.css" rel="stylesheet" type="text/css" />
        <link href="siconv_dashboard.css" rel="stylesheet" type="text/css" />
    </jsp:attribute>
    <jsp:attribute name="content">
        <div class="siconvDashboard containerDashboardVisPublica" id="containerDashboardVisPublica" style="display:  none;">
            <div class="headerDashboard">
                <span class="titleDashboard">Convênios firmados pelo Poder Executivo Federal</span>
                <a href="/vispublica/publico/integracao/siconv/sobre.jsp" style="cursor: pointer;" target="_blank">
                    <span>Sobre o projeto</span>
                    <img src="/vispublica/images/icon_info.png">
                </a>
            </div>
            <div id="url" class="url">
                <div class="urlText">Para compartilhar o painel, copie a url abaixo:</div>
                <input type="text" name="inputUrl" id="inputUrl" class="text ui-widget-content ui-corner-all inputUrlLabel">
            </div>
            <div class="filtersWrapper">
                <div class="mapWrapper">
                    <div class="mapTitle">Selecione o Estado:</div>
                    <%@include file="mapa.jsp" %>
                </div>
                <div class="rightColumn">
                    <div class="containerButtonAddSituacao">
                        <button id="addSituacao">Adicionar Situação</button>
                    </div>
                    <div class="firstColumnWrapper" id="firstColumnWrapper">
                        <div class="highChartsColumnWrapper" id="highChartsColumnWrapper">
                        </div>
                    </div>
                </div>
            </div>
            <div class="vigenciaWrapper">
                <div class="headerSection">
                    Vigência
                </div>
                <div class="optionsWrapper" id="optionsWrapper">
                    <table class="tableOptions">
                        <tr>
                            <td>
                                <span>Início: </span>
                                <select id="selectMesInicio" name="selectMesInicio">
                                    <option  selected value="01">Jan</option>
                                    <option  value="02">Fev</option>
                                    <option  value="03">Mar</option>
                                    <option  value="04">Abr</option>
                                    <option  value="05">Mai</option>
                                    <option  value="06">Jun</option>
                                    <option  value="07">Jul</option>
                                    <option  value="08">Ago</option>
                                    <option  value="09">Set</option>
                                    <option  value="10">Out</option>
                                    <option  value="11">Nov</option>
                                    <option  value="12">Dez</option>
                                </select>
                                /
                                <select id="selectAnosInicio" name="selectAnosInicio">
                                    <option  value="2015">2015</option>
                                    <option  value="2014">2014</option>
                                    <option  value="2013">2013</option>
                                    <option  value="2012">2012</option>
                                    <option  value="2011">2011</option>
                                    <option  selected value="2010">2010</option>
                                    <option  value="2009">2009</option>
                                    <option  value="2008">2008</option>
                                    <option  value="2007">2007</option>
                                </select>
                            </td>
                            <td>
                                <span> Término: </span>
                                <select id="selectMesFim" name="selectMesFim">
                                    <option  value="01">Jan</option>
                                    <option  value="02">Fev</option>
                                    <option  value="03">Mar</option>
                                    <option  value="04">Abr</option>
                                    <option  value="05">Mai</option>
                                    <option  value="06">Jun</option>
                                    <option  value="07">Jul</option>
                                    <option  value="08">Ago</option>
                                    <option  value="09">Set</option>
                                    <option  value="10">Out</option>
                                    <option  value="11">Nov</option>
                                    <option selected value="12">Dez</option>
                                </select>
                                /
                                <select id="selectAnosFim" name="selectAnosFim">
                                    <option  value="2015">2015</option>
                                    <option  value="2014">2014</option>
                                    <option selected value="2013">2013</option>
                                    <option  value="2012">2012</option>
                                    <option  value="2011">2011</option>
                                    <option  value="2010">2010</option>
                                </select>
                                <input type="hidden" id="inputTitulo" />
                            </td>
                            <td style="width: 50%;">
                                <span id="tituloSitucao" >Situação: </span>
                                <span id="valueSituacao" class="parameterValue">EM EXECUÇÃO</span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <span>Orgão: </span> <span class="parameterValue" id="valueOrgao"></span>
                                <button id="pesquisaOrgao" class="buttonPesquisarOrgao" >Adicionar</button>
                            </td>
                            <td>
                                <button type="button" id="bttAtualizarAnos">Pesquisar</button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="info" id="info">
                    <p>Selecione um ou mais convênios na tabela abaixo para visualizar os valores do(s) convênio(s).</p>
                    <p>Para selecionar mais de um convênio segure o botão Ctrl e clique nos convênios desejados.</p>
                </div>
                <div class="tableWrapper" id="tableWrapper">
                    <div class="googleTableWrapper" id="googleTableWrapper">
                    </div>
                </div>
                <div class="columnLoaderWrapper" id="columnLoaderWrapper">
                    <div class="columnWrapper" id="columnWrapper">
                        <p>Selecione um convênio para visualização.</p>
                    </div>
                </div>
            </div>
        </div>

        <script type='text/javascript'>
            $.ajaxSetup({
                async: false
            });

            document.getElementById('containerBarVisPublicaPage').style.display = 'none';

            situacaoGlob = '';

            url = {
                uf: '',
                situacaoGlob: '',
                inicioMes: '',
                inicioAno: '',
                terminoMes: '',
                terminoAno: '',
                tablePage: '',
                idOrgao: [],
                convSel: [],
                idSituacao: []
            };

            function urlToJs() {
                if (getParameterUrl('uf') != null) {
                    url.uf = getParameterUrl('uf');
                    if (getParameterUrl('idSituacoes') != null) {
                        var itens = getParameterUrl('idSituacoes').split(",");
                        for (var i = 0; i < itens.length; i++) {
                            url.idSituacao[i] = itens[i];
                        }
                    } else {
                        url.idSituacao[0] = '28';
                        url.idSituacao[1] = '569';
                    }

                    if (getParameterUrl('situacaoSel') != null) {
                        url.situacaoGlob = getParameterUrl('situacaoSel');

                        if (getParameterUrl('convSel') != null) {
                            var itens = getParameterUrl('convSel').split(",");
                            for (var i = 0; i < itens.length; i++) {
                                url.convSel[i] = itens[i];
                            }
                        }

                    } else {
                        url.situacaoGlob = '28';
                    }

                    if (getParameterUrl('iAno') != null) {
                        url.inicioAno = getParameterUrl('iAno');
                    } else {
                        url.inicioAno = '2010';
                    }

                    if (getParameterUrl('tAno') != null) {
                        url.terminoAno = getParameterUrl('tAno');
                    } else {
                        url.terminoAno = '2013';
                    }

                    if (getParameterUrl('iMes') != null) {
                        url.inicioMes = getParameterUrl('iMes');
                    } else {
                        url.inicioMes = '01';
                    }

                    if (getParameterUrl('tMes') != null) {
                        url.terminoMes = getParameterUrl('tMes');
                    } else {
                        url.terminoMes = '12';
                    }

                    if ((url.inicioAno > url.terminoAno) || (url.inicioAno == url.terminoAno
                        && url.inicioMes > url.terminoMes)) {
                        erroConexao('erroUrl');
                        return false;
                    }

                    if (getParameterUrl('orgaos') != null) {
                        var itens = getParameterUrl('orgaos').split(",");
                        for (var i = 0; i < itens.length; i++) {
                            url.idOrgao[i] = itens[i];
                        }
                    }

                    if (getParameterUrl('tablePage') != null) {
                        url.tablePage = getParameterUrl('tablePage');
                    }

                    return true;
                } else {
                    //estado
                    url.uf = 'SP';
                    //situações do gráfico de colunas
                    url.idSituacao[0] = '28';
                    url.idSituacao[1] = '569';
                    //situacao global
                    url.situacaoGlob = '28';
                    //datas
                    url.inicioAno = '2010';
                    url.terminoAno = '2013';
                    url.inicioMes = '01';
                    url.terminoMes = '12';
                    return false;
                }
            }

            function montaUrl() {
                var textUrl = window.location.href.split("?")[0];

                if (url.uf != '') {
                    textUrl += '?uf=' + url.uf;
                    if (url.idSituacao.length > 0) {
                        textUrl += '&idSituacoes=';
                        for (var i = 0; i < url.idSituacao.length; i++) {
                            textUrl += url.idSituacao[i] + ',';
                        }
                        //retira a ultima virgula:
                        textUrl = textUrl.substring(0, textUrl.length - 1);

                    }
                    if (url.situacaoGlob != '') {
                        textUrl += '&situacaoSel=' + url.situacaoGlob;
                        if (url.inicioMes != '') {
                            textUrl += '&iMes=' + url.inicioMes;
                        } else {
                            textUrl += '&iMes=01';
                        }
                        if (url.inicioAno != '') {
                            textUrl += '&iAno=' + url.inicioAno;
                        } else {
                            textUrl += '&iAno=2010';
                        }
                        if (url.terminoMes != '') {
                            textUrl += '&tMes=' + url.terminoMes;
                        } else {
                            textUrl += '&tMes=12';
                        }
                        if (url.terminoAno != '') {
                            textUrl += '&tAno=' + url.terminoAno;
                        } else {
                            textUrl += '&tAno=2013';
                        }


                        if (url.idOrgao.length > 0) {
                            textUrl += '&orgaos=';
                            for (var i = 0; i < url.idOrgao.length; i++) {
                                textUrl += url.idOrgao[i] + ',';
                            }
                            //retira a ultima virgula:
                            textUrl = textUrl.substring(0, textUrl.length - 1);

                        }

                        if (url.tablePage != '') {
                            textUrl += '&tablePage=' + url.tablePage;
                        }

                        if (url.convSel.length > 0) {
                            textUrl += '&convSel=';
                            for (var i = 0; i < url.convSel.length; i++) {
                                textUrl += url.convSel[i] + ',';
                            }
                            //retira a ultima virgula:
                            textUrl = textUrl.substring(0, textUrl.length - 1);

                        }

                    } else {
                        textUrl += '&situacaoSel=28';
                    }
                }

                return textUrl;
            }

            function carregaConvenioEstado(nomeEstado, idSituacao) {
                if (typeof(erroTip) != 'undefined') {
                    return;
                }

                document.getElementById('valueSituacao').innerHTML = "EM EXECUÇÃO";
                situacaoGlob = "EM EXECUÇÃO";

                if (typeof(dataLoadTable) != 'undefined') {
                    dataLoadTable = {};
                }
                if (typeof(orgaoSelect) != 'undefined') {
                    orgaoSelect = new Array();
                }
                if (typeof(secondChart) != 'undefined') {
                    secondChart.destroy();
                    document.getElementById('columnWrapper').innerHTML = '<p>Selecione um convênio para visualização.</p>';
                }

                //Se o usuario clicar no mapa, zera a url:
                url.uf = nomeEstado;
                url.idSituacao = new Array();
                url.idSituacao.push('28');
                url.idSituacao.push('569');
                url.situacaoGlob = '28';
                url.inicioAno = '2010';
                url.terminoAno = '2013';
                url.inicioMes = '01';
                url.terminoMes = '12';
                url.tablePage = '1';
                url.idOrgao = new Array();
                url.convSel = new Array();
                document.getElementById('inputUrl').value = montaUrl();

                var verificaJson = '';

                $.getJSON("http://api.convenios.gov.br/siconv/v1/consulta/situacoes_convenios.json", function(json) {
                    verificaJson = json;
                    $("#combo1 option").remove();
                    $("#combo1").append("<option value=\"" + '0' + "\">" + '' + "</option>");
                    for (var i = 0; i < json.situacoes_convenios.length; i++) {
                        if (json.situacoes_convenios[i].id != 28 && json.situacoes_convenios[i].id != 569) {
                            $("#combo1").append("<option value=\"" + json.situacoes_convenios[i].id + "\">" + json.situacoes_convenios[i].nome + "</option>");
                        }
                    }
                }).fail(function() {
                    erroConexao('erroConexao')
                });

                if (idSituacao == null) {
                    var idSituacao = new Array();
                    idSituacao.push(28);
                    idSituacao.push(569);
                }

                var dataFirstColumn = new Array();
                var categoriaFirstColumn = new Array();

                //Primeiro jSon em execução, usado para a inizialização da tabela
                var jsonExe;
                var verificaConexao = '';
                var linkEstado = "http://api.convenios.gov.br/siconv/v1/consulta/convenios.json?uf=" + nomeEstado;

                $('#divImgfirstColumnWrapper').css('display', 'table-cell').show();

                $('#divImgtableWrapper').show();

                setTimeout(function() {

                    //Para cada situação passada se faz uma barra no primeiro gráfico
                    for (var i = 0; i < idSituacao.length; i++) {
                        //Busca por convênios em execução (num. 28)
                        $.getJSON(linkEstado + "&id_situacao=" + idSituacao[i], function(json) {
                            verificaConexao = json;
                            if (idSituacao[i] == 28) {
                                jsonExe = json;
                            }

                            dataFirstColumn.push(json.metadados.total_registros);
                            categoriaFirstColumn.push(buscaNomeSituacao(idSituacao[i]));
                        }).fail(function() {
                            erroConexao('erroConexao')
                        });
                    }

                    if (typeof(dataFirstColumn[0]) == 'undefined' || verificaConexao == '') {
                        erroConexao('erroConexao');
                    } else {
                        initFirstColumn(dataFirstColumn, categoriaFirstColumn, jsonExe);
                    }

                }, 10);
            }

            function montaPainelUrl() {
                if (typeof(erroTip) != 'undefined') {
                    return;
                }

                actionClickMap(document.getElementById(url.uf));

                if (buscaNomeSituacao(url.situacaoGlob) == 'erro') {
                    erroConexao('erroUrl');
                    return;
                }

                document.getElementById('valueSituacao').innerHTML = buscaNomeSituacao(url.situacaoGlob);
                situacaoGlob = buscaNomeSituacao(url.situacaoGlob);

                if (typeof(dataLoadTable) != 'undefined') {
                    dataLoadTable = {};
                }

                if (typeof(url.idOrgao) != 'undefined') {
                    orgaoSelect = url.idOrgao;

                    var textorgao = '';
                    for (var n in url.idOrgao) {
                        textorgao += url.idOrgao[n] + ' ';
                    }
                    $("#valueOrgao").html(textorgao);

                }


                var verificaJson = '';

                $.getJSON("http://api.convenios.gov.br/siconv/v1/consulta/situacoes_convenios.json", function(json) {
                    verificaJson = json;
                    $("#combo1 option").remove();
                    $("#combo1").append("<option value=\"" + '0' + "\">" + '' + "</option>");
                    var orgaoSel = true;
                    for (var i = 0; i < json.situacoes_convenios.length; i++) {
                        for (var j = 0; j < url.idSituacao.length; j++) {
                            if (json.situacoes_convenios[i].id == url.idSituacao[j]) {
                                orgaoSel = false;
                            }
                        }
                        if (orgaoSel) {
                            $("#combo1").append("<option value=\"" + json.situacoes_convenios[i].id + "\">" + json.situacoes_convenios[i].nome + "</option>");
                        }
                        orgaoSel = true;
                    }
                }).fail(function() {
                    erroConexao('erroConexao')
                });

                var idSituacao = new Array();
                for (var i = 0; i < url.idSituacao.length; i++) {

                    if (buscaNomeSituacao(url.idSituacao[i]) == 'erro') {
                        erroConexao('erroUrl');
                        return;
                    }

                    idSituacao.push(url.idSituacao[i]);
                }

                var dataFirstColumn = new Array();
                var categoriaFirstColumn = new Array();

                //Primeiro jSon em execução, usado para a inizialização da tabela
                var jsonExe;
                var verificaConexao = '';
                var linkEstado = "http://api.convenios.gov.br/siconv/v1/consulta/convenios.json?uf=" + url.uf;

                $('#divImgfirstColumnWrapper').css('display', 'table-cell').show();

                $('#divImgtableWrapper').css('display', 'table-cell').show();

                document.getElementById('selectAnosInicio').options[2015 - parseInt(url.inicioAno)].selected = 'selected';
                ;
                document.getElementById('selectAnosFim').options[2015 - parseInt(url.terminoAno)].selected = 'selected';
                ;

                document.getElementById('selectMesInicio').options[parseInt(url.inicioMes) - 1].selected = 'selected';
                ;
                document.getElementById('selectMesFim').options[parseInt(url.terminoMes) - 1].selected = 'selected';
                ;

                setTimeout(function() {

                    //Para cada situação passada se faz uma barra no primeiro gráfico
                    for (var i = 0; i < idSituacao.length; i++) {
                        //Busca por convênios em execução (num. 28)
                        $.getJSON(linkEstado + "&id_situacao=" + idSituacao[i], function(json) {
                            verificaConexao = json;
                            if (idSituacao[i] == url.situacaoGlob) {
                                jsonExe = json;
                            }
                            dataFirstColumn.push(json.convenios.length > 0 ? json.metadados.total_registros : 0);
                            categoriaFirstColumn.push(buscaNomeSituacao(idSituacao[i]));
                        }).fail(function() {
                            erroConexao('erroConexao')
                        });
                    }

                    if (typeof(dataFirstColumn[0]) == 'undefined' || verificaConexao == '') {
                        erroConexao('erroConexao');
                    } else {
                        initFirstColumn(dataFirstColumn, categoriaFirstColumn, jsonExe);
                    }

                }, 10);

                var convSelecionados = new Array();
                for (var i = 0; i < url.convSel.length; i++) {
                    convSelecionados.push(url.convSel[i]);
                }

                if (convSelecionados.length > 0) {
                    initSecondColumn('', convSelecionados);
                }
            }

            function erroConexao(erro) {

                if (typeof(erroTip) != 'undefined') {
                    return false;
                }

                var erroTxt = '';

                if (erro == 'erroConexao') {
                    erroTxt = 'Desculpe, tivemos um erro de conexão.';
                } else if (erro == 'erroUrl') {
                    erroTxt = 'Desculpe, tivemos um erro com os parâmetros da URL.';
                }

                document.getElementById('nameError').innerHTML = erroTxt;

                if (typeof(firstChart) != 'undefined') {
                    firstChart.destroy();
                }
                if (typeof(tabelaPrincipal) != 'undefined') {
                    tabelaPrincipal.clearChart();
                }

                erroTip = 'Erro';

                $("#dialog-form-erro").dialog({
                    autoOpen: false,
                    height: 150,
                    width: 500,
                    resizable: false,
                    modal: true
                });
                $("#dialog-form-erro").dialog("option", "buttons", [{
                        text: "Sair",
                        click: function() {
                            $("#dialog-form-erro").dialog("close");
                        }
                    }]);

                $("#dialog-form-erro").dialog("open");

                $('#divImgtableWrapper').hide();
                $('#divImgfirstColumnWrapper').hide();
                $('#divImgtableModalWrapper').hide();
                $('#divImgcolumnLoaderWrapper').hide();
                
                $('<div />').appendTo($('#containerDashboardVisPublica')).css({
                    position: 'absolute',
                    top: 0,
                    left: 0,
                    width: '100%',
                    height: '100%',
                    zIndex: 9999
                });
                
                document.getElementById('containerDashboardVisPublica').style.opacity = '0.4';
                document.getElementById('pesquisaOrgao').disabled = true;
                document.getElementById('addSituacao').disabled = true;
                document.getElementById('bttAtualizarAnos').disabled = true;
                document.getElementById('tableWrapper').innerHTML = '';
                document.getElementById('tableWrapper').style.height = '100px';

                document.getElementById('containerDashboardVisPublica').style.height = '1060px';
                document.getElementById('containerDashboardVisPublica').style.display = '';

                initFirstColumn([1], ['EM EXECUÇÂO'], '');

                return false;

            }

            function buscaNomeSituacao(idSituacao) {
                return typeof(situacaoNome[idSituacao + '']) != 'undefined' ? situacaoNome[idSituacao + ''] :
                    'erro';
            }

            function buscaidSituacao(nomeSituacao) {
                return typeof(situacaoId[nomeSituacao + '']) != 'undefined' ? situacaoId[nomeSituacao + ''] :
                    'erro';
            }

            function actionBttAtualizar() {
                if (typeof(orgaoSelect) != 'undefined') {
                    if (!orgaoSelect.length > 0) {
                        $("#valueOrgao").html("");
                    }
                }
                initTable(situacaoGlob, null);
                document.getElementById('inputUrl').value = montaUrl();
            }

            function actionClickMap(e) {
                //Acrescenta o Estado selecionado a url
                if (e == null) {
                    d3.select(".estadoClicked").classed("estadoClicked", false);
                    d3.select("path#SP").classed("estadoClicked", true);
                    erroConexao('erroUrl');
                    return;
                }

                $("#valueOrgao").html("");
                d3.select(".estadoClicked").classed("estadoClicked", false);
                d3.select("path#" + e.id).classed("estadoClicked", true);
            }

            function loaderAjax(wrapper, position, gif) {
                var divLoader = document.createElement('div');
                divLoader.setAttribute('id', 'divImg' + wrapper);
                divLoader.setAttribute('class', 'divLoader');

                if (position == 'absolute') {
                    divLoader.setAttribute('style',
                    'width:' + $('#' + wrapper).width() + 'px; height:' + $('#' + wrapper).height() + 'px;' +
                        'position:' + position + '; top: 0;');
                } else {
                    divLoader.setAttribute('style',
                    'width:' + $('#' + wrapper).width() + 'px; height:' + $('#' + wrapper).height() + 'px;' +
                        'position:' + position + ';');
                }

                document.getElementById(wrapper).appendChild(divLoader);

                var inputImg = document.createElement('img');
                inputImg.setAttribute('alt', 'activity');
                inputImg.setAttribute('src', 'gifs/' + gif);
                inputImg.setAttribute('id', 'ajaxLoader' + wrapper);

                if (position == 'absolute') {
                    inputImg.setAttribute('style', 'margin-top: 100px;');
                }
                //inputImg.setAttribute('style', 'display: none;');

                var p = document.createElement("p");
                var txt = document.createTextNode("Carregando...");

                p.appendChild(txt);

                document.getElementById('divImg' + wrapper).appendChild(inputImg);
                document.getElementById('divImg' + wrapper).appendChild(p);
            }

            function initModal() {
                //Modal para a pesquisa de orgao
                $("#dialog-form-orgao").dialog({
                    autoOpen: false,
                    height: 303,
                    width: 500,
                    resizable: false,
                    modal: true
                });
                //evento do botão pesquisar orgão
                $("#pesquisaOrgao")
                .button()
                .click(function() {
                    $("#dialog-form-orgao").dialog("open");
                });

                $("#bttAtualizarAnos").button().click(function() {
                    actionBttAtualizar();
                });


                //Modal para adicionar situacao
                $("#dialog-form-situacao").dialog({
                    autoOpen: false,
                    height: 140,
                    width: 800,
                    resizable: false,
                    modal: true
                });
                //evento do botão Adicionar
                $("#addSituacao")
                .button()
                .click(function() {
                    $("#dialog-form-situacao").dialog("open");
                });

                //Modal Sobre
                $("#dialog-form-sobre").dialog({
                    width: 620,
                    resizable: false,
                    autoOpen: false,
                    modal: true
                });
            }

            $(function(){
                $('#modalInfoLink').click(function(e){
                    e.preventDefault();

                    var left  = ($(window).width()-500)/2,
                    top   = ($(window).height()-400)/2,
                    popup = window.open("sobre.jsp", "popup", "width=500, height=400, top="+top+", left="+left);

                    return false;
                });
            })

            function getParameterUrl(name)
            {
                var url = window.location.search.replace("?", "");
                var itens = url.split("&");

                for (var n in itens)
                {
                    if (itens[n].match(name))
                    {
                        return decodeURIComponent(itens[n].replace(name + "=", ""));
                    }
                }
                return null;
            }

            erroGoogle = 'false';

            if (typeof(google) != 'undefined') {
                google.load('visualization', '1', {packages: ['table']});
            } else {
                erroGoogle = 'true';
            }

            $(function() {
                $(document).ready(function() {

                    initModal();

                    var verificarConexao = '';
                        
                    if (erroGoogle == 'true') {
                        erroConexao('erroConexao');
                    }

                    $.getJSON("http://api.convenios.gov.br/siconv/v1/consulta/situacoes_convenios.json", function(json) {
                        //Inserir nome e id de todas as situações de convênios para posterior pesquisa
                        situacaoNome = {};
                        situacaoId = {};

                        for (var i = 0; i < json.situacoes_convenios.length; i++) {

                            situacaoNome[json.situacoes_convenios[i].id + ''] = [json.situacoes_convenios[i].nome];
                        }

                        for (var i = 0; i < json.situacoes_convenios.length; i++) {
                            situacaoId[json.situacoes_convenios[i].nome] = [json.situacoes_convenios[i].id + ''];
                        }

                        verificarConexao = json;

                    }).fail(function() {
                        erroConexao('erroConexao')
                    });

                    if (typeof(verificarConexao.situacoes_convenios) == 'undefined' || verificarConexao == '') {
                        erroConexao('erroConexao');
                    } else {
                        loaderAjax('tableWrapper', 'absolute', 'ajax-loader.gif');
                        loaderAjax('firstColumnWrapper', 'relative', 'ajax-loader.gif');
                        loaderAjax('tableModalWrapper', 'relative', 'ajax-loader.gif');
                        loaderAjax('columnLoaderWrapper', 'absolute', 'ajax-loader.gif');

                        //Captura as parametros da Url e mapeia para uma estrutura js
                        urlToJs();
                        //inicia o painel com os parametros
                        montaPainelUrl();

                        document.getElementById('inputUrl').value = montaUrl();

                        document.getElementById('containerDashboardVisPublica').style.display = '';
                    }

                });
            });

        </script>
        <div class="creativeCommons" id="creativeCommons">
            <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR" target="_blank"><img alt="Licença Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-nc/3.0/br/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/InteractiveResource" property="dct:title" rel="dct:type">Este trabalho</span> está licenciado sob uma <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR" target="_blank">licença Creative Commons Atribuição-NãoComercial 3.0 Brasil</a>.
        </div>        
    </jsp:attribute>
    <jsp:attribute name="footer">
        <div id="dialog-form-orgao" title="Pesquisa por orgão" style="font-size: 14px;">
            <label for="name">Orgão</label>
            <input type="text" name="nomeOrgao" id="nomeOrgao" class="text ui-widget-content ui-corner-all" />
            <button type="button" id="bttAtualizarAnos" onclick="javascript:createModalTable();" >Atualizar</button>
            <div class="MessageErroModal" id="erroConsultaOrgao"></div>
            <div class="tableModalWrapper" id="tableModalWrapper" style="position: relative;">
                <div class="tableOrgaoWrapper" id="tableOrgaoWrapper"></div>
            </div>
        </div>
        <div id="dialog-form-situacao" title="Adicionar Situação" style="font-size: 14px;">
            <label for="nomeCombo1">Selecione uma situação:</label>
            <select id="combo1" name="combo1">
            </select>
            <button type="button" onclick="javascript:addDataFirstColumn();" >Adicionar</button>
        </div>
        <div id="dialog-form-erro" title="Erro" style="font-size: 14px; display: none;">
            <label for="name" id="nameError">Desculpe, tivemos um erro de conexão.</label>
        </div>
    </jsp:attribute>
</vTemplate:basic>

