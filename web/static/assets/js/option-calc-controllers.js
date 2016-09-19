console.log('in option-calc-contollers.js');
var SetupPositions = function(positions) {
	console.log('in SetupPositions');
	angular.module("root",[]).controller("StrategyController", function ($scope, $http) {
		console.log('in StrategyController');		
		var self = this;
		self.positions = positions;

		self.Action = 'Loading';

		$('#BtnRemove').click(function (position) {
			//self.Action = 'List';
			//$scope.$apply();
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
