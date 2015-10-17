var BlogApp = angular.module('BlogApp', ['ngRoute', 'yaru22.angular-timeago']);

BlogApp.config(function($routeProvider, $locationProvider) {
	$routeProvider
    .when('/', {
            templateUrl : 'routes/list.html',
            controller  : 'ListController',
    })
    .when('/page/:page', {
            templateUrl : 'routes/list.html',
            controller  : 'ListController',
    })
	.when('/posts/create', {
		templateUrl : 'routes/create.html',
		controller  : 'CreateController'
	})
	.when('/posts/:poststub', {
		templateUrl : 'routes/post.html',
		controller  : 'PostController'
	})
	.when('/posts/:poststub/edit', {
		templateUrl : 'routes/edit.html',
		controller  : 'EditController'
        });

	$locationProvider.html5Mode(true);
});

BlogApp.controller('MenuController', function($scope, $location) {
});

BlogApp.controller('ListController', function($scope, $http, $routeParams) {
	if (!$routeParams.page) {
		$routeParams.page = 1;
	}
	$http.get('/json/page/'+$routeParams.page)
	.then(function(res){
		$scope.data = res.data;
		if (res.data.pagination.next_page) {
			$scope.next_page = "/page/"+res.data.pagination.next_page;
		} else {
			$scope.next_class = "disabled";
		}

		if (res.data.pagination.prev_page) {
			$scope.prev_page = "/page/"+res.data.pagination.prev_page;
		} else {
			$scope.prev_class = "disabled";
		}
	});
});

BlogApp.controller('PostController', function($scope, $http, $routeParams) {
	$http.get('/json/posts/'+$routeParams.poststub)
	.then(function(res){
		$scope.post = res.data;
	});
});

BlogApp.controller('CreateController', function($scope, $http, $location) {
	$scope.$watch('post', function(val) {
		if ($scope.post.title == "" &&
			$scope.post.postdesc == "" &&
			$scope.post.postmd == "")
		{
			$scope.show = false;
		} else {
			$scope.show = true;
		}
		$scope.post.posthtml = markdown.toHTML(val.postmd);
	}, true);

	$scope.loading = false;

	$scope.show = false;

	$scope.post = {
		title: "",
		postdesc: "",
		postmd: "",
		posthtml: "",
		stub: "",
		public: false
	};

	$scope.submitForm = function(public) {
		if (!$scope.loading) {
			$scope.loading = true;

			formdata = new FormData();

			for ( var key in $scope.post ) {
				formdata.append(key, $scope.post[key]);
			}

			console.log("Here");

			if (public) {
				$scope.post.public = true
			}

			$http.post("/json/posts/create", $scope.post).
			then(function(response) {
				$location.path("/")
			}, function(response) {
				$scope.errors = response.data;
				$scope.loading = false;
			}
			);
		};
	};

});

BlogApp.filter('html', function($sce) { return $sce.trustAsHtml; });
