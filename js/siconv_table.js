/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function initTable (situacao, jsonEstado){ 
    
    if(typeof(dataLoadTable) != 'undefined'){
        dataLoadTable = {};
    }
    
    var anoInicio = document.getElementById('selectAnosInicio');
    var anoFim = document.getElementById('selectAnosFim');
    var mesInicio = document.getElementById('selectMesInicio');
    var mesFim = document.getElementById('selectMesFim');
                
    url.inicioAno = anoInicio.options[anoInicio.selectedIndex].value;
    url.terminoAno = anoFim.options[anoFim.selectedIndex].value;
    url.inicioMes = mesInicio.options[mesInicio.selectedIndex].value;
    url.terminoMes = mesFim.options[mesFim.selectedIndex].value;
    
    if(url.inicioAno > url.terminoAno){
        alert("O ano inicial não pode ser maior que o final.");
        return;
    } else if (url.inicioAno == url.terminoAno && url.inicioMes > url.terminoMes){
        alert("O mês inicial não pode ser maior que o final.");
        return;
    }
    
    var rows = new Array();    
    
    var linkEstado = "http://api.convenios.gov.br/siconv/v1/consulta/convenios.json?uf=" + 
    //captura o estado selecionado
    d3.select(".estadoClicked")[0][0].attributes['id'].nodeValue;
                
    var idSituacao = 0;
    idSituacao = parseInt(buscaidSituacao(situacao));
         
    var verificaFinalJson = true;
    var linkOffSet = '';
    
    jsonEstado = '';
    
    $('#divImgtableWrapper').css('display','table-cell').show();
    $("#tableWrapper").animate({
        scrollTop: 0
    }, "fast");
    $('#tableWrapper').css('overflow','hidden');

    
    setTimeout(function() {
        
        var num = 0;
        var limiteFinal = 15;
        var limiteInicial = 0;
        var verificaIndex = false;
        
        if(url.tablePage != ''){
            if(parseInt(url.tablePage)){
                limiteFinal = (parseInt(url.tablePage) * 15);
                limiteInicial = ((parseInt(url.tablePage) - 1)*15)
                verificaIndex = true;
                dataLoadTable = {};
                var finalPage = (parseInt(url.tablePage)+1);
 
                dataLoadTable[parseInt(url.tablePage)] = [1]; 
  
            } else {
                erroConexao('erroUrl');
            }
        }
        
        while(num < limiteFinal && verificaFinalJson){

            if(typeof(erroTip) != 'undefined'){
                return;
            }
            
            //monta a tabela para os primeiros 500 valores vindos do json
            $.getJSON(linkOffSet == '' ? linkEstado + "&id_situacao=" + idSituacao : linkOffSet, function(json) {
                jsonEstado = json;
            }).fail(function () {
                erroConexao('erroConexao');
            });
       
       
            if(jsonEstado == ''){
                idSituacao = parseInt(buscaidSituacao(firstChart.series[0].data[0].category));
                situacaoGlob = firstChart.series[0].data[0].category;
                document.getElementById('valueSituacao').innerHTML = firstChart.series[0].data[0].category;
                $.getJSON(linkOffSet == '' ? linkEstado + "&id_situacao=" + idSituacao : linkOffSet, function(json) {
                    jsonEstado = json;
                }).fail(function () {
                    erroConexao('erroConexao');
                });
            }

            if(typeof(erroTip) != 'undefined'){
                return;
            }
    
            if(jsonEstado == ''){
                num = limiteFinal + 10;
                return;
            }   
    
            //verifica se existem novos valores no json (cada json possui no maximo 500)
            if(jsonEstado.metadados.proximos != null){
                linkOffSet = jsonEstado.metadados.proximos;
            } else {
                //usado para carregar novos valores
                verificaFinalJson = false;
            }
            
            num = montaDataSet(jsonEstado, rows, num, limiteFinal, limiteInicial);
        }

        var data = new google.visualization.DataTable();
        data.addColumn('number', 'Convênio');
        data.addColumn('number', 'idOrgão');
        data.addColumn('string', 'Orgão');
        data.addColumn('string', 'Modalidade');
        data.addColumn('string', 'Objeto');
        data.addColumn('number', 'idProponente');
        data.addColumn('string', 'Proponente');
        data.addRows(rows);
        tabelaPrincipal = new google.visualization.Table(document.getElementById('googleTableWrapper'));
    
        var formatterId = new google.visualization.PatternFormat('<a href="http://api.convenios.gov.br/siconv/dados/convenio/{0}" target="_blank">{1}</a>');
        formatterId.format(data, [0,0],0);
                
        var formatter = new google.visualization.PatternFormat('<a href="http://api.convenios.gov.br/siconv/dados/orgao/{0}" target="_blank">{1}</a>');
        formatter.format(data, [1,2],2);
                
        var formatterProp = new google.visualization.PatternFormat('<a href="http://api.convenios.gov.br/siconv/dados/proponente/{0}" target="_blank">{1}</a>');
        formatterProp.format(data, [5,6],6);
                
        var view = new google.visualization.DataView(data);
        view.setColumns([0,2,3,4,6]);
        
        
                
        tabelaPrincipal.draw(view, 
        {
            showRowNumber: true, 
            page: 'enable', 
            sort: 'disable',
            pageSize: 15,
            pagingSymbols: {
                prev: 'Anterior', 
                next: 'Próximo'
            },
            pagingButtonsConfiguration: 'auto',
            allowHtml: true,
            startPage : verificaIndex ? (url.tablePage-1) : 0
        });
    
        //Evento não funciona
        google.visualization.events.addListener(tabelaPrincipal, 'sort', function (event){
            if(typeof(dataLoadTable) != 'undefined'){
                dataLoadTable = {};
                dataLoadTable[0] = [1];
            //dataLoadTable[1] = [1];
            }
            var dataSort = data;
            dataSort.sort([{
                column: event.column, 
                desc: !event.ascending
            }]);
    
            for(var i = 0; i < 15; i++){
                var orgaoText = '';
                var proponenteText = '';
                if(typeof dataSort.getValue(i, 1) == 'undefined'){
                    break;
                }
                $.getJSON('http://api.convenios.gov.br/siconv/dados/orgao/'+dataSort.getValue(i, 1) +'.json', function(orgao) {
                    orgaoText = orgao.orgaos[0].nome.toLowerCase();
                });
                $.getJSON('http://api.convenios.gov.br/siconv/dados/proponente/'+dataSort.getValue(i, 5) +'.json', function(proponente) {
                    proponenteText =  proponente.proponentes[0].nome.toLowerCase();
                    
                });
                
                dataSort.setValue(i, 2, orgaoText == '' ? dataSort.getValue(i, 1) : orgaoText);
                dataSort.setValue(i, 6,  proponenteText == '' ? dataSort.getValue(i, 5) : proponenteText);
                
            }     
            
            //formatterId.format(dataSort, [0,0],0);
            
            //formatter.format(data, [1,2],2);
            
            //formatterProp.format(data, [5,6],6);
            
            var view = new google.visualization.DataView(dataSort);
            view.setColumns([0,2,3,4,6]);
                
            tabelaPrincipal.draw(view, 
            {
                showRowNumber: true, 
                page: 'enable', 
                sort: 'disable',
                pageSize: 15,
                pagingSymbols: {
                    prev: 'Anterior', 
                    next: 'Próximo'
                },
                pagingButtonsConfiguration: 'auto',
                allowHtml: true,
                startPage: 0
            });
    
        });
    
        google.visualization.events.addListener(tabelaPrincipal, 'page', function (){
            
            if(typeof(erroTip) != 'undefined'){
                return;
            }
            
            var pageIndex = arguments[0].page;
            //Passa a pagina da tabela pra a URL:
            url.tablePage = pageIndex+1;
            document.getElementById('inputUrl').value = montaUrl();
            
            var pageLoad = parseInt(data.getNumberOfRows()/15+''); 
        
            //caso tenha chegado ao final do arquivo, para qualquer execução desta função
            if(typeof(dataLoadTable) != 'undefined'){
                if(dataLoadTable[parseInt(data.getNumberOfRows()/15+'')+1] == pageIndex && !verificaFinalJson){
                    return;
                }
            }
        
            $('#divImgtableWrapper').css('display','table-cell').show();
            $("#tableWrapper").animate({
                scrollTop: 0
            }, "fast");
            $('#tableWrapper').css('overflow','hidden');
        
            setTimeout(function() {
                
                //caso chega a uma página anterior, ou na página carrega mais dados se verificaFinalJson = true
                if((pageIndex) == pageLoad || (pageIndex+1) == pageLoad && verificaFinalJson){
                    while((pageLoad == parseInt(data.getNumberOfRows()/15+'') || data.getNumberOfRows()%15 == 0) && verificaFinalJson){    
                        if(verificaFinalJson){
                            $.getJSON(linkOffSet, function(json) {
                                jsonEstado = json;
                            });
                
                            if(jsonEstado.metadados.proximos != null){
                                linkOffSet = jsonEstado.metadados.proximos;
                            } else {
                                verificaFinalJson = false;
                            }
                    
                            var num = 0;               
                
                            for(var i = 0; i < jsonEstado.convenios.length ; i++){
                                if(jsonEstado.convenios[i].data_fim_vigencia < url.terminoAno+"-"+url.terminoMes+"-01" && jsonEstado.convenios[i].data_inicio_vigencia > url.inicioAno+"-"+url.inicioMes+"-01"){
                                    if(typeof(orgaoSelect) == 'undefined'){
                                        if(typeof(url.idOrgao) != 'undefined'){
                                            orgaoSelect = url.idOrgao;
                                        }
                                    }
                                    if(orgaoSelect.length > 0){
                                        for(var j = 0; j < orgaoSelect.length; j++){
                                            if(jsonEstado.convenios[i].orgao_concedente.Orgao.id == orgaoSelect[j]){
                                                var dataRows = new Array();
                                                dataRows.push(jsonEstado.convenios[i].id);
                                                dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id);
                                                dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id+'');
                                                dataRows.push(jsonEstado.convenios[i].modalidade.toLowerCase());
                                                dataRows.push(jsonEstado.convenios[i].objeto_resumido.toLowerCase());
                                                dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id);
                                                dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id+'');
                                                rows.push(dataRows);
                                                num++;
                                            }
                                        }
                                    } else {
                                        var dataRows = new Array();
                                        dataRows.push(jsonEstado.convenios[i].id);
                                        dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id);
                                        dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id+'');
                                        dataRows.push(jsonEstado.convenios[i].modalidade.toLowerCase());
                                        dataRows.push(jsonEstado.convenios[i].objeto_resumido.toLowerCase());
                                        dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id);
                                        dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id+'');
                                        rows.push(dataRows);
                                        num++; 
                                    }
                                }
                            }
                        }  
                        data.removeRows(0, data.getNumberOfRows());
                        data.addRows(rows);
                
                        formatterId.format(data, [0,0],0);
            
                        formatter.format(data, [1,2],2);
            
                        formatterProp.format(data, [5,6],6);
            
                        var view = new google.visualization.DataView(data);
                        view.setColumns([0,2,3,4,6]);
                
                        tabelaPrincipal.draw(view, 
                        {
                            showRowNumber: true, 
                            page: 'enable', 
                            sort: 'disable',
                            pageSize: 15,
                            pagingSymbols: {
                                prev: 'Anterior', 
                                next: 'Próximo'
                            },
                            pagingButtonsConfiguration: 'auto',
                            allowHtml: true,
                            startPage: pageIndex
                        });
            
                    }
                }
        
                if (verifyPage(pageIndex+1)){
                    for(var i = 0; i < 15; i++){
                        var orgaoText = '';
                        var proponenteText = '';
                        if(typeof (rows[((pageIndex*14)+i)+pageIndex]) == 'undefined'){
                            break;
                        }
                        $.getJSON('http://api.convenios.gov.br/siconv/dados/orgao/'+rows[((pageIndex*14)+i)+pageIndex][1] +'.json', function(orgao) {
                            orgaoText = orgao.orgaos[0].nome.toLowerCase();
                        });
                        $.getJSON('http://api.convenios.gov.br/siconv/dados/proponente/'+rows[((pageIndex*14)+i)+pageIndex][5] +'.json', function(proponente) {
                            proponenteText =  proponente.proponentes[0].nome.toLowerCase();
                    
                        });
                
                        rows[((pageIndex*14)+i)+pageIndex][2] = orgaoText == '' ? rows[((pageIndex*14)+i)+pageIndex][2] : orgaoText;
                        rows[((pageIndex*14)+i)+pageIndex][6] = proponenteText == '' ? rows[((pageIndex*14)+i)+pageIndex][6] : proponenteText;
                
                    }
            
                    data.removeRows(0, data.getNumberOfRows());
                    data.addRows(rows);
            
                    formatterId.format(data, [0,0],0);
            
                    formatter.format(data, [1,2],2);
            
                    formatterProp.format(data, [5,6],6);
            
                    var view = new google.visualization.DataView(data);
                    view.setColumns([0,2,3,4,6]);
                
                    tabelaPrincipal.draw(view, 
                    {
                        showRowNumber: true, 
                        page: 'enable', 
                        sort: 'disable',
                        pageSize: 15,
                        pagingSymbols: {
                            prev: 'Anterior', 
                            next: 'Próximo'
                        },
                        pagingButtonsConfiguration: 'auto',
                        allowHtml: true,
                        startPage: pageIndex
                    });
            
            
                }
        
                $('#divImgtableWrapper').hide();
                $('#tableWrapper').css('overflow','auto');
            }, 1000);
        });
    
        google.visualization.events.addListener(tabelaPrincipal, 'select', function (){
            
            if(typeof(erroTip) != 'undefined'){
                return;
            }
            
            var selection = tabelaPrincipal.getSelection();
            var message = '';
            var convenioSelect = new Array();
            for (var i = 0; i < selection.length; i++) {
                var item = selection[i];
                convenioSelect.push(data.getValue(item.row, 0));
            }
            
            //Passa os convenios selecionados para a URL
            url.convSel = convenioSelect;
            document.getElementById('inputUrl').value = montaUrl();
                
            if (selection.length === 0) {
                message = 'nada_selecionado';
            }
            initSecondColumn(message,convenioSelect);
        });
        
        $('#divImgtableWrapper').hide();
        $('#divImgfirstColumnWrapper').hide();
        $('#tableWrapper').css('overflow','auto');
        
    }, 1000);
    
    
}  

function montaDataSet (jsonEstado, rows, num, limiteFinal ,limiteInicial) {
  
    for(var i = 0; i < jsonEstado.convenios.length ; i++){
        if(jsonEstado.convenios[i].data_fim_vigencia < url.terminoAno+"-"+url.terminoMes+"-01" && 
            jsonEstado.convenios[i].data_inicio_vigencia > url.inicioAno+"-"+url.inicioMes+"-01"){
            
            if(typeof(orgaoSelect) == 'undefined'){
                if(typeof(url.idOrgao) != 'undefined'){
                    orgaoSelect = url.idOrgao;
                }
            }
            if(orgaoSelect.length > 0){
                for(var j = 0; j < orgaoSelect.length; j++){
                    if(jsonEstado.convenios[i].orgao_concedente.Orgao.id == orgaoSelect[j]){
                        var dataRows = new Array();
                        dataRows.push(jsonEstado.convenios[i].id);
                        dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id);
                        if(num >= limiteInicial && num < limiteFinal){
                            var orgaoText = '';
                            $.getJSON('http://api.convenios.gov.br/siconv/dados/orgao/'+jsonEstado.convenios[i].orgao_concedente.Orgao.id +'.json', function(orgao) {
                                orgaoText = orgao.orgaos[0].nome.toLowerCase();
                            });
                            dataRows.push(orgaoText == ''?jsonEstado.convenios[i].orgao_concedente.Orgao.id+'' : orgaoText);
                        } else {
                            dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id+'');
                        }
                        dataRows.push(jsonEstado.convenios[i].modalidade.toLowerCase());
                        dataRows.push(jsonEstado.convenios[i].objeto_resumido.toLowerCase());
                        dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id);
                        if(num >= limiteInicial && num < limiteFinal){
                            var proponenteText = '';
                            $.getJSON('http://api.convenios.gov.br/siconv/dados/proponente/'+jsonEstado.convenios[i].proponente.Proponente.id +'.json', function(proponente) {
                                proponenteText = proponente.proponentes[0].nome.toLowerCase();
                            });
                            dataRows.push(proponenteText == '' ? jsonEstado.convenios[i].proponente.Proponente.id+'' : proponenteText);
                        } else {
                            dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id+'');
                        }
                        rows.push(dataRows);
                        num++;
                    }
                }
            } else {
                var dataRows = new Array();
                dataRows.push(jsonEstado.convenios[i].id);
                dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id);
                if(num >= limiteInicial && num < limiteFinal){
                    var orgaoText = '';
                    $.getJSON('http://api.convenios.gov.br/siconv/dados/orgao/'+jsonEstado.convenios[i].orgao_concedente.Orgao.id +'.json', function(orgao) {
                        orgaoText = orgao.orgaos[0].nome.toLowerCase();
                    });
                    dataRows.push(orgaoText == ''?jsonEstado.convenios[i].orgao_concedente.Orgao.id+'' : orgaoText);
                } else {
                    dataRows.push(jsonEstado.convenios[i].orgao_concedente.Orgao.id+'');
                }
                dataRows.push(jsonEstado.convenios[i].modalidade.toLowerCase());
                dataRows.push(jsonEstado.convenios[i].objeto_resumido.toLowerCase());
                dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id);
                if(num >= limiteInicial && num < limiteFinal){
                    var proponenteText = '';
                    $.getJSON('http://api.convenios.gov.br/siconv/dados/proponente/'+jsonEstado.convenios[i].proponente.Proponente.id +'.json', function(proponente) {
                        proponenteText = proponente.proponentes[0].nome.toLowerCase();
                    });
                    dataRows.push(proponenteText == '' ? jsonEstado.convenios[i].proponente.Proponente.id+'' : proponenteText);
                } else {
                    dataRows.push(jsonEstado.convenios[i].proponente.Proponente.id+'');
                }
                rows.push(dataRows);
                num++;
            }
           
            
            
        }
        
    }  
        
    return num;
}

function verifyPage (pageIndex){
    if(typeof(dataLoadTable) == 'undefined'){
        dataLoadTable = {};
        dataLoadTable[0] = [1];
        dataLoadTable[1] = [1];
        dataLoadTable[2] = [1];
    } else {
        if (dataLoadTable[pageIndex+''] == null || typeof(dataLoadTable[pageIndex+'']) == 'undefined'
            || !dataLoadTable[pageIndex+''] == 1){
            dataLoadTable[1] = [1];
            dataLoadTable[pageIndex+''] = [1];
            return true;
        } else {
            return false;
        }
    }
    
    return true;
}

function createModalTable(){

    document.getElementById('tableOrgaoWrapper').innerHTML = '';
    
    var linkOrgao = 'http://api.convenios.gov.br/siconv/v1/consulta/orgaos.json?nome='+
    $('#nomeOrgao').select().val();
    
    var jsonOrgao = '';
    var rows = new Array();
    
    $('#divImgtableModalWrapper').css('display','table-cell').show();
    
    setTimeout(function() {
        $.getJSON(linkOrgao, function(json) {
            jsonOrgao = json;
        }).fail(function () {
            document.getElementById('erroConsultaOrgao').innerHTML = 'Erro na consulta do orgão. Tente novamente...';
            $('#divImgtableModalWrapper').hide();
            return;
        });
    
        if(jsonOrgao == ''){
            document.getElementById('erroConsultaOrgao').innerHTML = 'Erro na consulta do orgão. Tente novamente...';
            $('#divImgtableModalWrapper').hide();
            return;
        }

        if(typeof(erroTip) != 'undefined'){
            return;
        }

        document.getElementById('erroConsultaOrgao').innerHTML = '';
    
        for(var i = 0; i < jsonOrgao.orgaos.length ; i++){
            var dataRows = new Array();
            dataRows.push(jsonOrgao.orgaos[i].nome);
            dataRows.push(jsonOrgao.orgaos[i].id);
            rows.push(dataRows);
        }
    
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Nome');
        data.addColumn('number', 'id');
        data.addRows(rows);
        var tabela = new google.visualization.Table(document.getElementById('tableOrgaoWrapper'));
                
                
        tabela.draw(data,
        {
            showRowNumber: true,
            page: 'enable',
            pageSize: 4,
            pagingSymbols: {
                prev: 'Anterior',
                next: 'Próximo'
            },
            pagingButtonsConfiguration: 'auto',
            allowHtml: true
        });
    
        google.visualization.events.addListener(tabela, 'select', function (){
        
            var selection = tabela.getSelection();
            $( "#dialog-form-orgao" ).dialog( "option", "buttons", [ {
                text: "Filtrar",
                click: function() {
                    orgaoSelect = new Array();
                    $("#valueOrgao").html("");
                    for (var i = 0; i < selection.length; i++) {
                        var item = selection[i];
                        $("#valueOrgao").append(data.getValue(item.row, 1)+" ");
                        orgaoSelect.push(data.getValue(item.row, 1));
                    }
                    
                    //Passa os orgaos selecionados para a URL:
                    url.idOrgao = orgaoSelect;
                    document.getElementById('inputUrl').value = montaUrl();
                
                    $( "#dialog-form-orgao" ).dialog( "option", "buttons", [ ] );
                    $( "#dialog-form-orgao" ).dialog( "close" );
                
                    tabela.clearChart();
                
                    initTable (situacaoGlob, null);
                
                    $('#nomeOrgao').select().val('');
                
                }
            } ] );
        });
        $('#divImgtableModalWrapper').hide();
    }, 10);
}
