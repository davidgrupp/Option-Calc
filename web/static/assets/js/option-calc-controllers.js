
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

		var totalPrice = self.positions
				.map(p => p.quantity > 0 ? p.price : -1 * p.price )
				.reduce((p, a ) => p + a)
				.toFixed(2);

		
		self.total = { price: totalPrice };

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

		/*ReadStrategy($scope, $http, function () {
			self.Action = 'List';

			//read positions if this is a saved strategy
		});*/

		self.addPosition = function () {
			alert("in add position");
			self.positions.push({"strike": 100, "price": 0.0, "type": "", "quantity": 0});
		};

		self.updatePositions = function(){
			var options = self.positions.map(function(p) {
				return { "strike": p.strike, "price": p.price, "type": p.type, "quantity": p.quantity }; 
				});
			console.log("updatePositions settings: " + JSON.stringify(self.chartSettings));
			SetGraph({ "settings": self.chartSettings, "options": options });
		};

		//$('#cmpInd').multiselect();
	});
};
