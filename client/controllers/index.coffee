class @IndexController extends RouteController
  waitOn: ->

  data: ->
    boards: Board.find()

  action: ->
    @render()
