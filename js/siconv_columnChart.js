/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function initFirstColumn(dataSet, categoriaSet, jsonExe){
    //Primeira Gráfico de Coluna Estatico
    firstChart = new Highcharts.Chart({
        chart: {
            renderTo: 'highChartsColumnWrapper',
            zoomType: 'xy'
        },
        title: {
            text: 'Convênio por Situação - ' + d3.select(".estadoClicked")[0][0].attributes['id'].nodeValue,
            x: -30
        },
        exporting: {
            enabled: false
        },
        xAxis: {
            title: {
                enabled: true,
                text: 'Situação'
            },
            startOnTick: true,
            endOnTick: true,
            showLastLabel: true,
            categories: categoriaSet
        },
        yAxis: [
        { // Primary yAxis
            labels: {
                formatter: function() {
                    return this.value +'';
                },
                style: {
                    color: '#4572A7'
                }
            },
            title: {
                text: 'Unidade',
                style: {
                    color: '#4572A7'
                }
            }
        }
        ],
        tooltip: {
            formatter: function() {
                return ''+this.x +': '+ this.y;
            }
        },
        legend: {
            layout: 'horizontal',
            align: 'center',
            backgroundColor: '#FFFFFF',
            borderWidth: 1
        },
        plotOptions: {
            column: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function() {
                            
                            if(typeof(erroTip) != 'undefined'){
                                return;
                            }
                            
                            if(typeof(orgaoSelect) != 'undefined'){
                                orgaoSelect = new Array();
                                $("#valueOrgao").html("");
                            }
                            
                            initTable (this.category, null);
                            situacaoGlob = this.category;
                            document.getElementById('valueSituacao').innerHTML = this.category;

                            //passa situacaoGlob para URL e zera os orgaos selecionados da URL:
                            url.situacaoGlob = buscaidSituacao(situacaoGlob);
                            url.idOrgao = new Array();
                            url.convSel = new Array();
                            document.getElementById('inputUrl').value = montaUrl();
         
                            //Mensagem de nada selecionado
                            if(typeof(secondChart) != 'undefined'){
                                secondChart.destroy();
                                //d3.select(".columnWrapper").append("svg:text").text("LALA");
                                document.getElementById('columnWrapper').innerHTML = '<p>Selecione um convênio para visualização.</p>';

                            }
                            
                              
                        }
                    }
                }
            },
            scatter: {
                marker: {
                    radius: 5,
                    states: {
                        hover: {
                            enabled: true,
                            lineColor: 'rgb(100,100,100)'
                        }
                    }
                },
                states: {
                    hover: {
                        marker: {
                            enabled: false
                        }
                    }
                }
            }
        },
        series: [
        { 
            name: 'Número de Convênios por Situação - ' + d3.select(".estadoClicked")[0][0].attributes['id'].nodeValue,
            color: '#49a47e',
            type: 'column', 
            yAxis: 0, 
            data: dataSet
        }] 
    });
    
    initTable (situacaoGlob, jsonExe, null);
}
            
function initSecondColumn (message, convenioSelect) {
    if (message == "nada_selecionado"){
        //Mensagem de nada selecionado
        if(typeof(secondChart) != 'undefined'){
            secondChart.destroy();
        }
        document.getElementById('columnWrapper').innerHTML = '<p>Selecione um convênio para visualização.</p>';
                    
    }else{
        /*if(typeof(secondChart) != 'undefined'){
            secondChart.destroy();
        }*/
        
        document.getElementById('columnWrapper').innerHTML = '';
        
        $('#divImgcolumnLoaderWrapper').css('display','table-cell').show();
            
        setTimeout(function() {
            var serie = new Array();
            var colors = Highcharts.getOptions().colors;
            for(var i = 0; i < convenioSelect.length; i++){
                //faz a consulta dos convenios pela api do siconv
                var numConvenio = convenioSelect[i];
                var linkConvenio = "http://api.convenios.gov.br/siconv/dados/convenio/"+numConvenio+".json";
                var erro = '';
                $.getJSON(linkConvenio, function(json) {
                    erro = json;
                    //Segundo Gráfico de Coluna Estatico
                    if(typeof(json.convenios[0].id) != 'undefined'){
                        serie.push({ 
                            name: 'Convênio '+json.convenios[0].id + '',
                            color: colors[i], 
                            type: 'column', 
                            yAxis: 0, 
                            data: [
                            parseFloat(typeof(json.convenios[0].valor_global) != 'undefined' ? json.convenios[0].valor_global : 0) ,
                            parseFloat(typeof(json.convenios[0].valor_repasse) != 'undefined' ? json.convenios[0].valor_repasse : 0),
                            parseFloat(typeof(json.convenios[0].valor_contra_partida) != 'undefined' ? json.convenios[0].valor_contra_partida : 0)
                            ] 
                        });
                    }
                }).fail(function () {
                    erroConexao('erroConexao');
                });
                if(erro == ''){
                    secondChart.destroy();
                    document.getElementById('columnWrapper').innerHTML = 'Erro de conexão';
                    return;
                }
            }  

                
            secondChart = new Highcharts.Chart({
                chart: {
                    renderTo: 'columnWrapper',
                    zoomType: 'xy'
                },
                exporting: {
                    enabled: false
                },
                title: {
                    text: 'Convênio'
                },
                exporting: {
                    enabled: false
                },
                xAxis: {
                    title: {
                        enabled: true,
                        text: 'Valores'
                    },
                    startOnTick: true,
                    endOnTick: true,
                    showLastLabel: true,
                    categories: ['Valor Global', 'Valor Repasse','Valor ContraPartida']
                },
                yAxis: [
                { // Primary yAxis
                    labels: {
                        formatter: function() {
                            return 'R$ ' + this.value;
                        },
                        style: {
                            color: '#4572A7'
                        }
                    },
                    title: {
                        text: 'Cash',
                        style: {
                            color: '#4572A7'
                        }
                    }
                }
                ],
                tooltip: {
                    formatter: function() {
                        return ''+this.x +': R$ '+ this.y;
                    }
                },
                legend: {
                    layout: 'horizontal',
                    align: 'center',
                    backgroundColor: '#FFFFFF',
                    borderWidth: 1
                },
                plotOptions: {
                    scatter: {
                        marker: {
                            radius: 5,
                            states: {
                                hover: {
                                    enabled: true,
                                    lineColor: 'rgb(100,100,100)'
                                }
                            }
                        },
                        states: {
                            hover: {
                                marker: {
                                    enabled: false
                                }
                            }
                        }
                    }
                },
                series: serie
            });
    
            $('#divImgcolumnLoaderWrapper').hide();
        }, 10);
    }
}

function addDataFirstColumn (form){
      
    if(document.getElementById('combo1').selectedIndex == 0){
        $( "#dialog-form-situacao" ).dialog( "close" );
        return;
    }
    
    $('#divImgfirstColumnWrapper').css('display','table-cell').show();
    
    setTimeout(function() {
        var dataSet = new Array();
        var categorySet = new Array();
        for(var i = 0; i < firstChart.series[0].data.length; i++){
            dataSet.push(firstChart.series[0].data[i].y);
            categorySet.push(firstChart.series[0].data[i].category);
        }
    
        var formSitucao = document.getElementById('combo1');
    
        var id_situacao =  formSitucao.options[formSitucao.selectedIndex].value;
        
        var nome_situacao =  formSitucao.options[formSitucao.selectedIndex].text;
        formSitucao.options[formSitucao.selectedIndex].style.display='none';
        if(typeof(formSitucao.options[0].value) != null){
            formSitucao.options[0].selected='selected';
        }
        
        //Salvando situação na url:
        url.idSituacao.push(id_situacao);
        document.getElementById('inputUrl').value = montaUrl();
         
        var linkEstado = "http://api.convenios.gov.br/siconv/v1/consulta/convenios.json?uf=" + 
        //captura o estado selecionado
        d3.select(".estadoClicked")[0][0].attributes['id'].nodeValue;
    
        $( "#dialog-form-situacao" ).dialog( "close" );
    
        $.getJSON(linkEstado + "&id_situacao=" +  id_situacao, function(json) {
        
            var totalRegistros = 0;
        
            if(typeof(json.metadados.total_registros) == 'undefined'){
                totalRegistros = null;
            } else {
                totalRegistros = json.metadados.total_registros;
            }
        
            dataSet.push(totalRegistros);
            categorySet.push(nome_situacao);
        }).fail(function () {
            erroConexao('erroConexao');
        });
    
        if(typeof(erroTip) != 'undefined'){
            return;
        }
    
        firstChart.series[0].setData(dataSet);
        firstChart.xAxis[0].setCategories(categorySet);
    
        firstChart.redraw();
    
        $('#divImgfirstColumnWrapper').hide();
    }, 10);
}