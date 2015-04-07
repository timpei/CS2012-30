

angular.module('createSetApp', [])
    .config(function($interpolateProvider, $locationProvider){
        $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        });
    })
    .controller('formController', function($scope, $http, $location) {

        $scope.removeCard = function(n) {
            $scope.set.flashcards.splice(n, 1);
        }

        $scope.addCard = function() {
            $scope.set.flashcards.push({word: '', translation: ''})
        }

        $scope.submitCreate = function() {
            console.log($scope.set);

            for (var i = 0; i < $scope.set.flashcards.length; i++) {
                if ($scope.set.flashcards[i].word == '' && 
                    $scope.set.flashcards[i].translation == '') {
                    $scope.removeCard(i);
                }
            }
            $http({
                url: '/create_set/' + $scope.set.creator,
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                data: JSON.stringify($scope.set)
            }).success(function(data) {
                window.location.replace('/user/' + $scope.set.creator + '?banner=create_success');
            });
        }

        $scope.submitEdit = function() {
            console.log($scope.set);

            for (var i = 0; i < $scope.set.flashcards.length; i++) {
                if ($scope.set.flashcards[i].word == '' && 
                    $scope.set.flashcards[i].translation == '') {
                    $scope.removeCard(i);
                }
            }
            $http({
                url: '/edit_set/' + $scope.set.creator,
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                data: JSON.stringify($scope.set)
            }).success(function(data) {
                window.location.replace('/user/' + $scope.set.creator + '?banner=edit_success');
            });
        }

        if ($location.path().indexOf('edit') >= 0) {
            var id = $location.path().match('edit\/([0-9])')[1]
            $http({
                url: '/set/' + id,
                method: "GET",
            }).success(function(data) {
                $scope.set = data.result;
            });

            $http({
                url: '/flashcards/' + id,
                method: "GET",
            }).success(function(data) {
                $scope.set.flashcards = data.flashcards;
                console.log($scope.set)
            });

        } else {
            $scope.set = {
                language: 1,
                category: 1,
                description: '',
                creator: $location.path().match('user\/(.*)\/')[1],
            };

            $scope.set.flashcards = [
                {word: '', translation: ''},
                {word: '', translation: ''}
            ];
        }
    });