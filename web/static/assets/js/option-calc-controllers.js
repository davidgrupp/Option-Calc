console.log('in option-calc-contollers.js');
var SetupPositions = function(strategies) {
	console.log('in SetupPositions');
	angular.module("root",[]).controller("StrategyController", function ($scope, $http) {
		console.log('in StrategyController');		
		var self = this;

		self.positions = strategies.strategies[0].positions;

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

		/*ReadStrategy($scope, $http, function () {
			self.Action = 'List';

			//read positions if this is a saved strategy
		});*/

		self.addPosition = function (position) {
			alert(JSON.stringify(position));
			$scope.data.push(data);
		};

		//$('#cmpInd').multiselect();
	});
};
