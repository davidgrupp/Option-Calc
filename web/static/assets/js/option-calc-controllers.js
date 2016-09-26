
var SetupPositions = function(strategies) {
	angular.module("root",[]).controller("StrategyController", function ($scope, $http) {
		console.log('in StrategyController');		
		var self = this;
		console.log("settings: " + JSON.stringify(strategies.settings));
		self.chartSettings = strategies.settings;
		self.positions = strategies.strategies[0].positions;
		for(var i = 0; i < self.positions.length; i++){
			console.log(self.positions[i]);
			//if(self.positions[i] != null)
			self.positions[i].id = i;
		}

		self.calcTotals = function(){
			var totalPrice = self.positions
				.map(p => p.quantity > 0 ? p.price : -1 * p.price )
				.reduce((p, a ) => p + a).toFixed(2);
			var totalCost = self.positions
				.map(p => p.price * p.quantity)
				.reduce((p,a)=> p + a).toFixed(2);;
		
			self.total = { price: totalPrice, cost: totalCost };	
		};
		self.calcTotals();		

		self.Action = 'Loading';

		$('.BtnRemove').click(function (elm) {
			//self.Action = 'List';
			//$scope.$apply();
			console.log('asdf');
			var classes = $(elm).attr('class').split(/\s+/);
			console.log(classes);
		});

		self.RemovePosition = function(position){
			alert('remove' + JSON.stringify(position));
			self.positions.splice(position.id, 1);
		};

		self.addPosition = function () {
			self.positions.push({"strike": null, "price": 0.0, "type": "", "quantity": 0});
		};

		self.ValidateGraphData = function()
		{
			return self.positions.map(function(p) {
				return { "strike": p.strike, "price": p.price, "type": p.type, "quantity": p.quantity }; 
			})
			.filter(function(p){
				return p.strike > 0 
					&& p.price >= 0
					&& (p.type == "Call" || p.type == "Put" || p.type == "Stock")
					&& (p.quantity > 0 || p.quantity < 0);
			});
		};

		self.updatePositions = function(){
			self.calcTotals();
			var positions = self.ValidateGraphData();
			console.log("updatePositions settings: " + JSON.stringify(self.chartSettings));
			SetGraph({ "settings": self.chartSettings, "options": positions });
		};

		self.updatePositionEnter = function(keyEvent){
			if (keyEvent.which === 13)
				self.updatePositions();
		};

		//$('#cmpInd').multiselect();
	});
};
