class @IndexController extends RouteController
  waitOn: ->

  data: ->
    boards: [
      _id: 1
      name: 'Board 1'
    ,
      _id: 2
      name: 'Board 2'
    ,
      _id: 3
      name: 'Board 3'
    ]

  action: ->
    @render()
