var StrategyManager = function(strategies, $http){
	var self = this;
    self.$http = $http;

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
			return (p.strike > 0 || (p.type != "Call" && p.type != "Put"))
				&& p.price >= 0
				&& (p.type == "Call" || p.type == "Put" || p.type == "Stock")
				&& (p.quantity > 0 || p.quantity < 0);
		});
	};

	self.UpdatePositions = function(){
		var positions = self.ValidateGraphData();
        self.SetGraph(self.settings, positions, self.UpdateData);
	};

	self.UpdatePositionEnter = function(keyEvent){
		if (keyEvent.which === 13)
			self.UpdatePositions();
	};

    self.UpdateData = function(data){
        self.totals = data.totals;
    };

    self.SetGraph = function (settings, positions, updateDataCallback){
        var chartConfig = { "settings": settings, "positions": positions };
        self.$http({
            url: '/api/chart/points',
            method: "POST",
            data: chartConfig
        })
        .then(function(response) {
                var ydata = [];
                for(var i = 0; i < response.data.chart.length; i++){
                    ydata.push([response.data.chart[i].x, response.data.chart[i].y]);
                }
                updateDataCallback(response.data);
                var chart = new StrategyChart(ydata);
        }, 
        function(response) {
                console.log('api call failed');
                console.log(response);
        });
    }

};

var QuoteManager = function(quote, $http){
	var self = this;
    self.$http = $http;

    self.symbol = quote != null ? quote.symbol : null;
    self.expiration = quote != null ? quote.expiration : [];
    self.expirations = quote != null ? quote.expirations : [];
    self.strikePrices = quote != null ? quote.strikePrices : [];

    self.GetQuoteKeyPress = function(){

    };

    self.GetQuote = function(){

    };

    self.GetStrikes = function(){

    };
};


var StrategyChart = function(ydata){
    self = this;
    self.chart = $('#chart').highcharts({
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
};