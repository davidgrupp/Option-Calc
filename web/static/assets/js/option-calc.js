

function SetGraph(chartConfig){
    console.log("setgraph: \r\n"+JSON.stringify(chartConfig));
     $.post({
        url: '/api/chart/points',
        data: JSON.stringify(chartConfig),
        contentType: 'application/json',
        success: function(data){
            console.log(data);
            var xdata = [];
            var ydata = [];
            for(var i = 0; i < data.chart.length; i++){
                xdata.push(data.chart[i].x);
                ydata.push([data.chart[i].x, data.chart[i].y]);
            }

            //console.log(xdata);
            //console.log(ydata);
            $('#chart').highcharts({
                chart: {
                    type: 'area',
                    
                },
                title: {
                    text: 'Strategy'
                },
                xAxis: {
                    title: {
                        enabled: false,
                        text: "Price"
                    },
                    minPadding: 0,
                    maxPadding: 0,
                    startOnTick: true,
                    endOnTick: true,
                    showLastLabel: false
                },
                yAxis: {
                    title: {
                        text: "Gain / Loss"
                    },
                    minorGridLineWidth: "0px",
                    plotLines: [{
                        color: "rgb(90, 90, 90)",
                        width: 2,
                        value: 0,
                        zIndex: 1
                    }]
                },
                credits: {
                    enabled: false
                },
                series: [{
                    name: 'Strategy 1',
                    data: ydata
                }],
                plotOptions: {
                    area: {
                        animation: true,
                        lineWidth: 3,
                        allowPointSelect: false,
                        color: "rgb(90, 180, 90)",
                        negativeColor: "rgb(180, 90, 90)",
                        marker: {
                            radius: 0,
                            states: {
                                hover: { enabled: true, lineColor: "rgb(100,0,100)" }
                            }
                        },
                        states: {
                            hover: {
                                marker: { enabled: true }
                            }
                        },
                        tooltip: {
                            headerFormat: "<b>{series.name}<\/b><br>",
                            pointFormat: "Price = {point.x}<br />Gain / Loss = {point.y}"
                        }
                    }
                }
            });

        }});
}