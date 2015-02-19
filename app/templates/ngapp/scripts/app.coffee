'use strict'

angular
  .module '<%= appName %>', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'mainCtrl'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'aboutCtrl'
      .otherwise
        redirectTo: '/'
