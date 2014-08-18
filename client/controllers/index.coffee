class @IndexController extends RouteController
  waitOn: ->

  data: ->
    boards: Boards.find()

  action: ->
    @render()
