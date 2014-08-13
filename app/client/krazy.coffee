# for positioning of new widgets
# TODO: use a better layout algorithm
position = 0

Template.board.widgets = ->
  Widgets.find()

Template.board.events
  'click #newWidget': ->
    Widgets.insert
      owner: Meteor.user()
      contents: ''
      position:
        x: position
        y: position
      voteOptions: []
      votes: {}
      editable: true
    position += 50

UI.registerHelper 'arraify', (o) ->
  _.map o, (v, k) -> {key: k, value: v}
