
function SetupPositions(positions) {

	angular.module("root",[]).controller("StrategyController", function ($scope, $http) {
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
}
