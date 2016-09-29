
var SetupPositions = function(strategies) {
	var strategyManager = new StrategyManager(strategies);
	strategyManager.bind();
	strategyManager.UpdatePositions();
	/*angular.module("root",[]).controller("StrategyController", function ($scope, $http) {
		var self = this;
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
		strategyManager.UpdatePositions();
	});*/
	
	return strategyManager;
};


