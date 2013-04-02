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
            layout: 'vertical',
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
                            
                            initTable (this.category, null, null);
                            situacaoGlob = this.category;
                            document.getElementById('valueSituacao').innerHTML = this.category;
                            
                            if(typeof(orgaoSelect) != 'undefined'){
                                orgaoSelect = new Array();
                                $("#valueOrgao").html("");
                            }
                                      
                            
                                       
                            //Mensagem de nada selecionado
                            if(typeof(secondChart) != 'undefined'){
                                secondChart.destroy();
                                //d3.select(".columnWrapper").append("svg:text").text("LALA");
                                document.getElementById('columnWrapper').innerHTML = '<p>Selecione um ou mais convênios na tabela acima para visualizar os valores do(s) convênio(s).</p>'+
                            '<p>Para selecionar mais de um convênio segure o botão Ctrl e clique nos convênios desejados.</p>'

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
            color: '#afd655', 
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
        secondChart.destroy();
        document.getElementById('columnWrapper').innerHTML = '<p>Selecione um ou mais convênios na tabela acima para visualizar os valores do(s) convênio(s).</p>'+
    '<p>Para selecionar mais de um convênio segure o botão Ctrl e clique nos convênios desejados.</p>'
                    
    }else{
        var serie = new Array();
        var colors = Highcharts.getOptions().colors;
        for(var i = 0; i < convenioSelect.length; i++){
            //faz a consulta dos convenios pela api do siconv
            var numConvenio = convenioSelect[i];
            var linkConvenio = "http://api.convenios.gov.br/siconv/dados/convenio/"+numConvenio+".json";
            var erro = true;
            $.getJSON(linkConvenio, function(json) {
                erro = false;
                //Segundo Gráfico de Coluna Estatico
                serie.push({ 
                    name: 'Convênio '+json.convenios[0].id + '',
                    color: colors[i], 
                    type: 'column', 
                    yAxis: 0, 
                    data: [
                    parseFloat(json.convenios[0].valor_global) ,
                    parseFloat(json.convenios[0].valor_repasse),
                    parseFloat(json.convenios[0].valor_contra_partida)
                    ] 
                });

            }).fail(function () {
                erroConexao('erroConexao')
            });
            if(erro){
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
                layout: 'vertical',
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
    }
}

function addDataFirstColumn (form){
    $('#divImgfirstColumnWrapper').css('display','table-cell').show();
    
    setTimeout(function() {
        var dataSet = new Array();
        var categorySet = new Array();
        for(var i = 0; i < firstChart.series[0].data.length; i++){
            dataSet.push(firstChart.series[0].data[i].y);
            categorySet.push(firstChart.series[0].data[i].category);
        }
    
        var formSitucao = document.getElementById('combo1');
    
        var id_situcao =  formSitucao.options[formSitucao.selectedIndex].value;
        var nome_situcao =  formSitucao.options[formSitucao.selectedIndex].text;
        formSitucao.options[formSitucao.selectedIndex].style.display='none';
    
        var linkEstado = "http://api.convenios.gov.br/siconv/v1/consulta/convenios.json?uf=" + 
        //captura o estado selecionado
        d3.select(".estadoClicked")[0][0].attributes['id'].nodeValue;
    
        $( "#dialog-form-situacao" ).dialog( "close" );
    
        $.getJSON(linkEstado + "&id_situacao=" +  id_situcao, function(json) {
        
            var totalRegistros = 0;
        
            if(typeof(json.metadados.total_registros) == 'undefined'){
                totalRegistros = null;
            } else {
                totalRegistros = json.metadados.total_registros;
            }
        
            dataSet.push(totalRegistros);
            categorySet.push(nome_situcao);
        }).fail(function () {
            erroConexao('erroConexao')
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