class @BoardsShowController extends RouteController

  waitOn: ->

  data: ->
    id: @params._id
    # board: Boards.find @params._id
    # widgets: Widgets.find board_id: @params._id
    board:
      widgets: Widgets.find()

  action: ->
    @render()
