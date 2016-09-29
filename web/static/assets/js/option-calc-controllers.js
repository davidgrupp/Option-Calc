
var SetupPositions = function(strategies) {
	

	angular.module("root",[]).controller("StrategyController", function ($scope, $http) {
		var self = this;
		self.sm = new StrategyManager(strategies, $http);
		//functions
		self.RemovePosition = self.sm.RemovePosition;
		self.AddPosition = self.sm.AddPosition;
		self.ValidateGraphData = self.sm.ValidateGraphData;
		self.UpdatePositions = self.sm.UpdatePositions;
		self.UpdatePositionEnter = self.sm.UpdatePositionEnter;
		//properties
		self.positions = self.sm.positions;
		self.settings = self.sm.settings;
		self.totals = self.sm.totals;
		self.sm.UpdatePositions();
	});
	
	//return strategyManager;
};


