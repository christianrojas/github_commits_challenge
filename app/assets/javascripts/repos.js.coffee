# GLOBAL VARIABLES
# -------------------------------------------------- 
root = exports ? this
root.query     = -> 0
root.sha       = -> ""
root.json_objs = -> ""

# Module App
App = angular.module("tangoSourceChallenge", ["ngResource"])

# App Config
App.config ["$httpProvider", ($httpProvider) ->
  # Inject the CSRF token
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = document.getElementsByName("csrf-token")[0].content
  $httpProvider.defaults.headers.common['Accept'] = "application/json"
]

# Factory to get repos
App.factory "Repo", ["$resource", ($resource) ->
  $resource("/repos/:id", {id: "@id"}, {update: {method: "PUT"}})
]

# Main controller
@tangoSourceChallengeCtrl = ["$scope", "$http", "Repo", ($scope, $http, Repo)->

  # SCOPE ACTIONS & METHODS
  # -------------------------------------------------- 
  $scope.repos = Repo.query() # Get all repos in the model

  $scope.process_request = ->
    root.query = $scope.newQuery.query # Sets the global variable 
    check_repos_list()

  $scope.validate_input_query = ->
    # Regular Expresion to validate 'account/repo'
    # Only one / and - inside words
    regExp = /^\b[a-zA-Z0-9\-]+\b\/\b[a-zA-Z0-9\-]+\b$/
    if regExp.test($scope.newQuery.query)
      $scope.inputError = false
    else
      $scope.inputError = true
      console.log regExp.test($scope.newQuery.query)

  # LOCAL METHODS
  # -------------------------------------------------- 
  check_repos_list = -> # Find if the new repo request already exist
    $http.get("/repos"
    ).then ((response) ->
      flag = false
      id   = 0
      for repo in response.data
        if root.query is "#{repo.account}/#{repo.repo}"
          flag = true
          id   = repo.id
      if flag then get_repo_data(repo.id) else check_remote_repo()
    ), (error) ->

  get_repo_data = (id) -> # Get registred repo data
    $http.get("/repos/#{id}"
    ).then ((response) ->
      get_unique_repo_days(response.data)
    ), (error) ->

  get_unique_repo_days = (data) ->
    root.json_objs   = jQuery.parseJSON(data.chain_obj_notation)
    crude_days_array = []
    uniqueDays       = []
    
    # Fix date string for all commits
    for commit in root.json_objs
      crude_days_array.push(moment(commit.commit.author.date))

    # Get the unique days
    $.each crude_days_array, (i, value) -> 
      value = value.format('YYYY-MM-DD')
      uniqueDays.push value if $.inArray(value, uniqueDays) is -1

    $scope.days = []
    for day in uniqueDays
      formated = moment(day).format("dddd, MMMM D YYYY")
      $scope.days.push({day: formated, value: day })

    $scope.dayPicker = $scope.days[0] # Initial value for the select

  get_day_commits = (day) ->
    day_commits = []
    for commit in root.json_objs
      if moment(commit.commit.author.date).format('YYYY-MM-DD') is day.value
        day_commits.push(commit)
    return day_commits

  $scope.make_day_graph = () ->
    hours   = []
    count   = []
    counter = 0 
    size    = get_day_commits($scope.dayPicker).length
    $.each get_day_commits($scope.dayPicker).reverse(), (i, value) -> # Get the unique hours
      value = moment(value.commit.author.date).format('ha')
      
      if $.inArray(value, hours) is -1
        hours.push value
        count.push counter if counter isnt 0
        counter = 0
        counter++
        count.push counter if i is size - 1
      else
        counter++
        count.push counter if i is size - 1

    $("#container").highcharts
      title:
        text: "Daily commits per hour"
        x: -20 #center
      subtitle:
        text: "Source: Github Repository [ christianrojas/firewool ]"
        x: -20
      xAxis:
        categories: hours # Unique hours array
      yAxis:
        title:
          text: "Commits (Hour)"
        plotLines: [
          value: 0
          width: 1
        ]
      tooltip:
        enabled: true
      legend: false
      series: [
        name: "Commits"
        data: count # Count by hours array
        color: "#2eaced"
      ]

  register_repo = -> # Create a new record in the database
    input = root.query.split('/')
    Repo.save repo: input[1], account: input[0], chain_obj_notation: root.json_objs, ((resource) ->
      $scope.repos.push resource
      $scope.newRepo = {}
    ), (response) ->
      console.log "Error: " + response.status

  # REMOTE METHODS
  # --------------------------------------------------
  check_remote_repo = ->
    $.ajax "https://api.github.com/repos/#{root.query}",
      type: 'GET'
      dataType: 'json'
      success: () ->
         get_remote_repo_commits()
      error: () ->
        # TODO Mostrar mensaje No se encontro este deposito.
        console.log "Deposito no existe"

  get_remote_repo_commits = -> # Get all commits from a github repo
    flag      = true # Loop control
    root.sha  = ""
    root.json_objs = ""

    loop      
      $.ajax "https://api.github.com/repos/#{root.query}/commits?#{root.sha}per_page=100",
        type: 'GET'
        dataType: 'json'
        async: false
        success: (data, textStatus, jqXHR) ->
          response = JSON.stringify(data)
          if root.sha is "" # Once
            root.json_objs += response.substring(0, response.length - 1)
          else # Multi
            front_fix = response.substring(0, response.length - 1)
            back_fix  = front_fix.substring(1,front_fix.length)
            root.json_objs += ',' + back_fix
        complete: (XMLHttpRequest) ->
          try
            link_header  = XMLHttpRequest.getResponseHeader('Link').split(';')[0]
            index_in_url = link_header.indexOf("last_sha")
            root.sha     = "last_sha=" + link_header.substring(index_in_url + 9).replace('>','').substr(0,40) + "&"
          catch error
            flag = false
        error: (request, status, error) ->

      break if flag is false # Brake if it's the last request

    root.json_objs += ']' # close json Object
    
    register_repo() # We are ready to register the new repo request in to DB

  get_repo_data(53) # <---- DELETE THIS LINE / JUST TESTING
]
