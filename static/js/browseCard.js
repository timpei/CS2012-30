
angular.module('browseCardApp', [])
    .config(function($interpolateProvider, $locationProvider){
        $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        });
    })
    .controller('cardController', function($scope, $http, $location) {
        console.log($location.path());
        $scope.setID = $location.path().match('view\/([0-9]+)')[1],
        $scope.index = 0,
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
        $scope.getFlashcards();
    });