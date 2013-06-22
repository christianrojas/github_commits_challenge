app = angular.module("tangoSourceChallenge", ["ngResource"])

app.factory "Repo", ["$resource", ($resource) ->
  $resource("/repos/:id", {id: "@id"}, {update: {method: "PUT"}})
]

@tangoSourceChallengeCtrl = ["$scope", "$http", "Repo", ($scope, $http, Repo)->
  $scope.repos = Repo.query()

  $scope.analyzeRepo = ->
    console.log $scope.newRepo.account_repo
    get_github_json_data()

  get_github_json_data = ->
    $http(
      method: "GET"
      url: "https://api.github.com/repos/#{$scope.newRepo.account_repo}/commits"
    ).success((data, status, headers, config) ->
      console.log data
    ).error (data, status, headers, config) ->
      console.log 'No existe el repo'
]