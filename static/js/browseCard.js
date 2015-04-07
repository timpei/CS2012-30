
angular.module('browseCardApp', [])
    .config(function($interpolateProvider, $locationProvider){
        $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        });
    })
    .controller('cardController', function($scope, $http, $location) {
        $scope.username = $location.path().match('user\/(.*)\/view')[1],
        $scope.setID = $location.path().match('view\/([0-9]+)')[1],
        $scope.index = 0,
        $scope.hasSet = false,
        $scope.addSetText = 'Add',
        $scope.cards = {};

        $scope.previousCard = function() {
            $scope.index = $scope.index - 1;
        }

        $scope.nextCard = function() {
            $scope.index = $scope.index + 1;
        }

        $scope.getFlashcards = function() {
            $http({
                url: '/flashcards/' + $scope.setID,
                method: "GET"
            }).success(function(data) {
            	console.log(data);
		        $scope.cards = data['flashcards'];
            });
		}

		$scope.getHasSet = function() {
            $http({
                url: '/user/' + $scope.username + '/hasSet/' + $scope.setID,
                method: "GET"
            }).success(function(data) {
            	console.log(data);
		        $scope.hasSet = data['hasSet'];
		        $scope.addSetText = $scope.hasSet ? 'Added' : 'Add';
            });
		}

		$scope.addRemoveSet = function() {
		    if (!$scope.hasSet) {
		        $http({
                    url: '/user/' + $scope.username + '/addSet/'+ $scope.setID,
                    method: "POST"
                }).success(function(data) {
                    console.log(data);
                    $scope.addSetText = 'Added';
                    $scope.hasSet = true;
                });
		    } else {
		        $http({
                    url: '/user/' + $scope.username + '/removeSet/'+ $scope.setID,
                    method: "POST"
                }).success(function(data) {
                    console.log(data);
                    $scope.addSetText = 'Add';
                    $scope.hasSet = false;
                });
		    }
		}

        $scope.getFlashcards();
        $scope.getHasSet();
    });