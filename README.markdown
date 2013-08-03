# GitHub Commits by Day
## Graph
### Challenge


## What is the goal?
I have to use the Github API to get a repository information with their commits. Later the application show you some options to  get the data grouped by days.

## Challenge request: (spanish)
Utilizando la API de Github crear una aplicación que analice la densidad de commits en un día por medio de una gráfica, cualquier repositorio puede ser especificado en la pagina.(Idealmente deberíamos guardar la información de la densidad de commits de los repositorios para no consumir requests futuros hacia github.

##### This is the wireframe:

![alt text](http://christianrojas.s3.amazonaws.com/Git%20graph.png "wireframe")

## Implementation

I decided to use [Ruby on Rails 4](http://rubyonrails.org/ "Ruby on Rails 4") and [AngularJS](http://angularjs.org/ "AngularJS") because i don't have any projects with this rails version and this awesome JS framework and this is my way to learn something new, by the way i love it.


## Demo
This is a short demo video of the current version features.

[![ScreenShot](http://christianrojas.s3.amazonaws.com/video_demo.png)](http://christianrojasgar.wistia.com/medias/thth0bn3ju)

### Setup

Clone this repo

```
$ git clone git@github.com:christianrojas/tangosource_challenge.git
```

Change into the app directory

install or update your gem dependencies
 
```
$ bundle install
```

Prepare the database

```
$ rake db:setup
```

Start the rails server

```
$ rails start
```

Launch your web browser to 

```
$ open http://localhost:3000
```

### ToDo
- Improve Rails Test Driven Development
- Improve JS Test Driven Development
