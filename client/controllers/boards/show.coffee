class @BoardsShowController extends RouteController

  waitOn: ->

  data: ->
    id: @params._id
    board: Board.first @params._id
    widgets: Widgets.find board_id: @params._id

  action: ->
    @render()
