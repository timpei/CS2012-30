angular.module('searchSetApp', [])
    .config(function($interpolateProvider, $locationProvider){
        $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
    })
    .controller('mainController', function($scope, $http, $location) {
        $scope.username = window.location.pathname.match('user\/(.*)\/')[1],
		$scope.tab = 'quick';
		$scope.intro = true;

		$scope.quick = { query: '' };
		$scope.query = {
			language: 0,
			category: 0
		}

		$scope.searchResults = [];
		$scope.searchResultsQuery = ''

		$scope.quickTab = function() {
			$scope.quick = { query: '' };
			$scope.tab = 'quick';
		}

		$scope.advancedTab = function() {
			$scope.query = {
				title: '',
				description: '',
				creator: '',
				language: 0,
				category: 0,
			}
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
            	$scope.searchResults = data.results;
            	$scope.intro = false;
            	$scope.advanced = true;
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
            	$scope.searchResults = data.results;
            	$scope.searchResultsQuery = $scope.quick.query;
            	$scope.intro = false;
            	$scope.advanced = false;
            });
		}
	});