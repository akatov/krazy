Router.configure
  layoutTemplate: 'MasterLayout'
  loadingTemplate: 'Loading'
  notFoundTemplate: 'NotFound'
  templateNameConverter: 'upperCamelCase'
  routeControllerNameConverter: 'upperCamelCase'

Router.onBeforeAction ->
  unless Meteor.userId()
    Router.go('index')
, only: ['boards.show']

Router.map ->
  @route 'index', path: '/'
  @route 'boards.show', path: '/boards/:_id'
