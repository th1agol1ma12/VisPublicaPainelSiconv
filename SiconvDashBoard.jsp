<html>
    <head>
        <title>Siconv Dashboard</title>
        <script src="lib/jquery-1.7.2.min.js" type="text/javascript"></script>
        <script type="text/javascript" src="lib/highcharts.js"></script>
        <script src="http://code.highcharts.com/modules/exporting.js"></script>
        <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
        <link href="css/siconv_dashboard.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" charset="utf-8" src="js/siconv_columnChart.js"></script>
        <script type="text/javascript" charset="utf-8" src="js/siconv_table.js"></script>
        <script type="text/javascript" src="lib/d3.v3.min.js"></script>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script src="lib/jq-ui.min.js"></script>
        <link href="css/jq-ui.css" rel="stylesheet" type="text/css" />    
        <link href="css/style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <div class="container" id="container" style="min-height: 1900px;">
            <div class="imageHeader" onclick="">
                <img alt="Logo VisPublica"  src="images/vp.png" width="70" class="imgHeader" style="float:left;" />
            </div>
            <br class="clear" />
            <a href="#1" onclick="javascript: openModalInfo();">
                <span style="color: rgb(51,51,51);">Sobre o projeto</span>
                <img src="images/icon_info.png">
            </a>
            <br class="clear" /><br class="clear" />

            <div class="containerDashboardVisPublica" id="containerDashboardVisPublica" style="display:  none;">
                <p></p>
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
                        <p></p>
                    </div>
                </div>
                <div class="optionsWrapper" id="optionsWrapper">
                    <table style="width: 100%;">
                        <tr>
                        <td colspan="2"><span class="tituloForm" id="tituloForm">Vigência:</span></td>
                        </tr>
                        <tr>
                        <td>
                        <span class="titulo">Início </span>
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
                        <span class="titulo"> Término </span>
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
                        <button type="button" id="bttAtualizarAnos" onclick="javascript:actionBttAtualizar();">Atualizar</button>
                        </td>
                        </tr>
                        <tr>
                        <td>
                        <span class="tituloSitucao" id="tituloSitucao" >Situação: </span>
                        <span class="parameterValue" id="valueSituacao">EM EXECUÇÃO</span>
                        </td>
                        <td>
                        <span class="tituloSitucao">Orgão: </span> <span class="parameterValue" id="valueOrgao"></span>
                        <button id="pesquisaOrgao" class="buttonPesquisarOrgao" >Pesquisar</button>
                        </td>
                        </tr>
                    </table>
                </div>
                <div class="tableWrapper" id="tableWrapper">
                    <div class="googleTableWrapper" id="googleTableWrapper">
                    </div>
                    <p></p>
                </div>
                <div class="columnWrapper" id="columnWrapper">
                    <p>Selecione um ou mais convênios na tabela acima para visualizar os valores do(s) convênio(s).</p>
                    <p>Para selecionar mais de um convênio segure o botão Ctrl e clique nos convênios desejados.</p>
                </div>
            </div>

            <script type='text/javascript'>
                $.ajaxSetup({
                    async: false
                });  
                
                var situacaoGlob = "EM EXECUÇÃO";

                actionClickMap(SP);

                function carregaConvenioEstado(nomeEstado, idSituacao){
                    if(typeof(erroTip) != 'undefined'){return;}
                    
                    document.getElementById('valueSituacao').innerHTML = "EM EXECUÇÃO";
                    situacaoGlob = "EM EXECUÇÃO";
                    
                    if(typeof(dataLoadTable) != 'undefined'){
                        dataLoadTable = {};
                    }
                    if(typeof(orgaoSelect) != 'undefined'){
                        orgaoSelect = new Array();
                    }
                    
                    var verificaJson = '';
                    
                    $.getJSON("http://api.convenios.gov.br/siconv/v1/consulta/situacoes_convenios.json", function(json) {
                        verificaJson = json;
                        $("#combo1 option").remove();
                        for(var i=0;i<json.situacoes_convenios.length;i++){
                            if(json.situacoes_convenios[i].id != 28 && json.situacoes_convenios[i].id != 569){
                                $("#combo1").append("<option value=\""+json.situacoes_convenios[i].id+"\">"+json.situacoes_convenios[i].nome+"</option>");
                            }
                        } 
                    });
                    
                    if(idSituacao == null){
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
                    
                    $('#divImgfirstColumnWrapper').css('display','table-cell').show();
                    
                    $('#divImgtableWrapper').css('display','table-cell').show();

                    setTimeout(function() {
  
                        //Para cada situação passada se faz uma barra no primeiro gráfico
                        for(var i = 0; i < idSituacao.length ; i++){
                            //Busca por convênios em execução (num. 28) 
                            $.getJSON(linkEstado + "&id_situacao=" + idSituacao[i], function(json) {
                                verificaConexao = json;
                                if(idSituacao[i] == 28){
                                    jsonExe = json;
                                }
                        
                                dataFirstColumn.push(json.metadados.total_registros);
                                categoriaFirstColumn.push(buscaNomeSituacao(idSituacao[i]));
                            });
                        }
                    
                        if(typeof(dataFirstColumn[0]) == 'undefined' || verificaConexao == ''){
                            erroConexao('erroConexao');
                        } else {
                            //initFirstColumn([1], ['cat1'], '');
                            initFirstColumn(dataFirstColumn, categoriaFirstColumn, jsonExe);
                        }
                        
                    }, 10);
                }
                
                function erroConexao (erro){
                    if ( erro == 'erroConexao'){
                        
                        if(typeof(erroTip) != 'undefined'){return false;}
                        
                        if(typeof(firstChart) != 'undefined'){
                            firstChart.destroy();
                        }
                        if (typeof(tabelaPrincipal) != 'undefined'){
                            tabelaPrincipal.clearChart();
                        }  
 
                        erroTip = 'Erro';
                        
                        /*$( "#dialog-form-erro" ).dialog({
                            autoOpen: false,
                            height: 150,
                            width: 500,
                            resizable: false,
                            modal: true
                        });
                        $( "#dialog-form-erro" ).dialog( "option", "buttons", [ {
                                text: "Sair", 
                                click: function() { 
                                    $( "#dialog-form-erro" ).dialog( "close" );
                                }
                            }]);
                    
                        $( "#dialog-form-erro" ).dialog( "open" );*/
                        
                        document.getElementById('containerDashboardVisPublica').style.opacity = '0.4';
                        document.getElementById('pesquisaOrgao').disabled = true;   
                        document.getElementById('addSituacao').disabled = true; 
                        document.getElementById('bttAtualizarAnos').disabled = true; 
                        document.getElementById('tableWrapper').innerHTML = '';
                        document.getElementById('tableWrapper').style.height = '100px';

                        document.getElementById('container').style.minHeight = '1078px';
                        document.getElementById('containerDashboardVisPublica').style.height = '900px';
                        document.getElementById('containerDashboardVisPublica').style.display = '';
                        
                        initFirstColumn([1],['EM EXECUÇÂO'],'');
                        
                        return false;
                    }
                }
            
                function buscaNomeSituacao (idSituacao){
                    return situacaoNome[idSituacao+''];
                }    
            
                function buscaidSituacao (nomeSituacao){     
                    return situacaoId[nomeSituacao+''];
                }   
            
                function actionBttAtualizar(){
                    if(typeof(orgaoSelect) == 'undefined' && !orgaoSelect.length > 0){
                        $("#valueOrgao").html("");
                    }
                    initTable(situacaoGlob, null);
                }        
            
                function actionClickMap(e){
                    $("#valueOrgao").html("");
                    d3.select(".estadoClicked").classed("estadoClicked",false); 
                    d3.select("path#"+e.id).classed("estadoClicked",true); 
                }
                
                function loaderAjax (wrapper, position, gif){
                    var divLoader = document.createElement('div');
                    divLoader.setAttribute('id', 'divImg'+wrapper);
                    divLoader.setAttribute('style', 
                    'text-align: center; background: none repeat scroll 0 0 #DDDDDD; opacity: 0.45;'+
                        'width:'+$('#'+wrapper).width()+'px; height:'+$('#'+wrapper).height()+'px;'+
                        'display: none; vertical-align: middle; position:'+position+';');
                    
                    document.getElementById(wrapper).appendChild(divLoader);
                    
                    var inputImg = document.createElement('img');
                    inputImg.setAttribute('alt', 'activity');
                    inputImg.setAttribute('src', 'gifs/'+gif);
                    inputImg.setAttribute('id', 'ajaxLoader'+wrapper);
                    //inputImg.setAttribute('style', 'display: none;');
                    
                    var p = document.createElement("p");
                    var txt = document.createTextNode("Carregando...");
                    
                    p.appendChild(txt);
        
                    document.getElementById('divImg'+wrapper).appendChild(inputImg);
                    document.getElementById('divImg'+wrapper).appendChild(p);
                }
                
                function initModal (){
                    //Modal para a pesquisa de orgao
                    $( "#dialog-form-orgao" ).dialog({
                        autoOpen: false,
                        height: 400,
                        width: 500,
                        resizable: false,
                        modal: true
                    });
                    //evento do botão pesquisar orgão
                    $( "#pesquisaOrgao")
                    .button()
                    .click(function() {
                        $( "#dialog-form-orgao" ).dialog( "open" );
                    });
            
                    //Modal para adicionar situacao
                    $( "#dialog-form-situacao" ).dialog({
                        autoOpen: false,
                        height: 140,
                        width: 800,
                        resizable: false,
                        modal: true
                    });
                    //evento do botão Adicionar
                    $( "#addSituacao" )
                    .button()
                    .click(function() {
                        $( "#dialog-form-situacao" ).dialog( "open" );
                    });
                }
                
                function openModalInfo(){
                    $("#dialog-form-sobre").dialog("open");
                }
 
                if(typeof(google) != 'undefined'){
                    google.load('visualization', '1', {packages:['table']});
                }
                $(function () {
                    $(document).ready(function() {
                        
                        initModal ();   
                        
                        //Modal Sobre
                        $( "#dialog-form-sobre" ).dialog({
                            width: 620,
                            resizable: false,
                            autoOpen: false,
                            modal:true
                        });
                        
                                                
                        var verificarConexao = '';
                        
                        $.getJSON("http://api.convenios.gov.br/siconv/v1/consulta/situacoes_convenios.json", function(json) {
                            //Inserir nome e id de todas as situações de convênios para posterior pesquisa
                            situacaoNome = {};
                            situacaoId = {};
                            
                            for(var i=0;i<json.situacoes_convenios.length;i++){                 
                                situacaoNome[json.situacoes_convenios[i].id+''] = [json.situacoes_convenios[i].nome];
                            }
                            
                            for(var i=0;i<json.situacoes_convenios.length;i++){                 
                                situacaoId[json.situacoes_convenios[i].nome] = [json.situacoes_convenios[i].id+''];
                            }
                            
                            verificarConexao = json;
                  
                        }).fail(function () {erroConexao('erroConexao')});
                        
                        if (typeof(verificarConexao.situacoes_convenios) == 'undefined' || verificarConexao == ''){
                            erroConexao('erroConexao'); 
                        } else {
                            loaderAjax('tableWrapper', 'relative', 'ajax-loader.gif');
                            loaderAjax('firstColumnWrapper', 'relative', 'ajax-loader.gif');
                          
                            carregaConvenioEstado("SP", null);

                            document.getElementById('containerDashboardVisPublica').style.display = '';
                        }
  
                    });
                });         
                
            </script>  
            <div class="creativeCommons" id="creativeCommons">
                <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR" target="_blank"><img alt="Licença Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-nc/3.0/br/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/InteractiveResource" property="dct:title" rel="dct:type">Este trabalho</span> está licenciado sob uma <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR" target="_blank">licença Creative Commons Atribuição-NãoComercial 3.0 Brasil</a>.
            </div>
        </div>

    </body>
    <div id="dialog-form-orgao" title="Pesquisa por orgão" style="font-size: 14px;">
        <label for="name">Orgão</label>
        <input type="text" name="nomeOrgao" id="nomeOrgao" class="text ui-widget-content ui-corner-all" />
        <button type="button" onclick="javascript:createModalTable();" >Atualizar</button>
        <div class="tableModalWrapper" id="tableModalWrapper"></div>
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
    <div id="dialog-form-sobre" class="dialog-form-sobre" title="Informação do Painel Siconv">
        <p>O Painel Siconv foi desenvolvido pela COPPE/UFRJ em parceria com a UNIFEI (Universidade Federal de Itajubá) e o Ministério do Planejamento, Orçamento e Gestão.</p>

        <p>Este painel faz parte do projeto VisPublica (Visualização de Dados Públicos) que foi elaborado com a finalidade de investigar as técnicas de Visualização de Informação e sua aplicação no contexto governamental.</p>

        <p>Para o desenvolvimento do painel foram utilizadas as seguinte técnicas e tecnologias:</p>
        <ul>
            <li>O Mapa foi construído com a tecnologia SVG (Scalable Vector Graphics - Gráficos Vetoriais Escaláveis)</li>

            <li>Para a elaboração do Gráfico de Barras foi utilizado a tecnologia Highcharts</li>

            <li>A Tabela foi gerada com a tecnologia Google Visualization API</li>
        </ul>

        <p>Os dados apresentados estão disponíveis no Portal de Convênios através do link abaixo.</p>

        <p>Convênios Firmados Pelo Poder Executivo da Administração Pública Federal:<br><a href="http://api.convenios.gov.br/siconv/doc/" target="_blank">http://api.convenios.gov.br/siconv/doc/</a></p>

        <p>O Código Fonte Desta Aplicação esta disponível em: <br><a href="LINK" target="_blank">LINK</a></p>

        <p>Para saber mais sobre o projeto VisPublica e as técnicas e tecnologias utilizadas no painel, acesse portal <a href="http://vispublica.gov.br/" target="_blank">VisPublica</a></p>
    </div>

</div>
</html>
