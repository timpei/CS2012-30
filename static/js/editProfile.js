

angular.module('editProfileApp', [])
    .config(function($interpolateProvider, $locationProvider){
        $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        });
    })
    .controller('profileController', function($scope, $http, $location) {
        $scope.username = window.location.pathname.match('user\/(.*)\/profile')[1],
        $scope.avatars = ['#F25E5E', '#F2BE6B', '#F2EE6B', '#6BF29F', '#6BB3F2', '#BBA3F4'];

        $scope.getUser = function() {
            $http({
                url: '/getUser/' + $scope.username,
                method: "GET"
            }).success(function(data) {
            	console.log(data);
		        $scope.user = data['user'];
            });
		}

		$scope.setAvatar = function(index) {
		    console.log(index);
            $scope.user.avatar = index;
		}

		$scope.submitEdit = function() {
            console.log($scope.user);
            $http({
                url: '/editProfile/' + $scope.username,
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                data: JSON.stringify($scope.user)
            }).success(function(data) {
                window.location.replace('/user/' + $scope.username + '?banner=profile_edit_success');
            });
        }

		$scope.getUser();
    });