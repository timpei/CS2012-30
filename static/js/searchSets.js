angular.module('searchSetApp', [])
    .config(function($interpolateProvider, $locationProvider){
        $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        });
    })
    .controller('mainController', function($scope, $http, $location) {
        $scope.username = $location.path().match('user\/(.*)\/')[1],
		$scope.tab = 'quick';

		$scope.quick = { query: '' };
		$scope.query = {
			language: 0,
			category: 0
		}

		$scope.quickTab = function() {
			$scope.tab = 'quick';
		}

		$scope.advancedTab = function() {
			$scope.tab = 'advanced';
		}

		$scope.advancedSearch = function() {
            $http({
                url: '/advancedSearch/' + $scope.username,
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                data: JSON.stringify($scope.query)
            }).success(function(data) {
            	console.log(data);
            });
		}

		$scope.searchAll = function() {
            $http({
                url: '/quickSearch/' + $scope.username,
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                data: JSON.stringify($scope.quick)
            }).success(function(data) {
            	console.log(data);
            });
		}
	});