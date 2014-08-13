class @IndexController extends RouteController
  waitOn: ->

  data: ->
    board:
      widgets: Widgets.find()

  action: ->
    @render()
