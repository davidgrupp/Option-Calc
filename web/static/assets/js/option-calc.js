var StrategyManager = function(strategies){
	var self = this;

	//self.Optionsx100 = false;
	self.settings = strategies.settings;
	self.positions = strategies.strategies[0].positions;
	for(var i = 0; i < self.positions.length; i++){
		self.positions[i].id = i;
	}
    self.totals = { price: 0, cost: 0 };

	self.RemovePosition = function(position){
		self.positions.splice(position.id, 1);
		self.updatePositions();
	};

	self.AddPosition = function () {
		self.positions.push({"strike": null, "price": 0.0, "type": "", "quantity": 0});
	};

	self.ValidateGraphData = function()
	{
		return self.positions.map(function(p) {
			return { "strike": p.strike, "price": p.price, "type": p.type, 
				"quantity": (self.Optionsx100 && (p.type == "Call" || p.type == "Put")
				? p.quantity * 100 : p.quantity) }; 
		})
		.filter(function(p){
			return (p.strike > 0 && (p.type == "Call" || p.type == "Put"))
				&& p.price >= 0
				&& (p.type == "Call" || p.type == "Put" || p.type == "Stock")
				&& (p.quantity > 0 || p.quantity < 0);
		});
	};

	self.UpdatePositions = function(){
		self.calcTotals();
		var positions = self.ValidateGraphData();
		SetGraph({ "settings": self.chartSettings, "options": positions });
	};

	self.UpdatePositionEnter = function(keyEvent){
		if (keyEvent.which === 13)
			self.updatePositions();
	};
};

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
                        animation: false,
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