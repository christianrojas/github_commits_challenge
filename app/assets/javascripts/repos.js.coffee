App = angular.module("tangoSourceChallenge", ["ngResource"])

App.config ["$httpProvider", ($httpProvider) ->
  # Inject the CSRF token
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = document.getElementsByName("csrf-token")[0].content
  $httpProvider.defaults.headers.common['Accept'] = "application/json"
]

App.factory "Repo", ["$resource", ($resource) ->
  $resource("/repos/:id", {id: "@id"}, {update: {method: "PUT"}})
]

@tangoSourceChallengeCtrl = ["$scope", "$http", "Repo", ($scope, $http, Repo)->
  $scope.repos = Repo.query()


]
