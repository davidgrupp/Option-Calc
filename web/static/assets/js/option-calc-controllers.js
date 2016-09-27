
var SetupPositions = function(strategies) {
	angular.module("root",[]).controller("StrategyController", function ($scope, $http) {
		var self = this;
		var strategyManager = new StrategyManager(strategies);
		//functions
		self.RemovePosition = strategyManager.RemovePosition;
		self.AddPosition = strategyManager.AddPosition;
		self.ValidateGraphData = strategyManager.ValidateGraphData;
		self.UpdatePositions = strategyManager.UpdatePositions;
		self.UpdatePositionEnter = strategyManager.UpdatePositionEnter;
		//properties
		self.positions = strategyManager.positions;
		self.settings = strategyManager.settings;
		self.totals = strategyManager.totals;
	});
};


