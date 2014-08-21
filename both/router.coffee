Router.configure
  layoutTemplate: 'MasterLayout'
  loadingTemplate: 'Loading'
  notFoundTemplate: 'NotFound'
  templateNameConverter: 'upperCamelCase'
  routeControllerNameConverter: 'upperCamelCase'

Router.onBeforeAction ->
  Router.go 'index' unless User.currentId()
, only: ['boards.show']

Router.map ->
  @route 'index', path: '/'
  @route 'boards.show', path: '/boards/:_id'
