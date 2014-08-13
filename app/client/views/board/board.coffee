# for positioning of new widgets
# TODO: use a better layout algorithm
position = 0

Template.Board.widgets = ->
  Widgets.find()


# Events

Template.Board.events
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

Template.Board.helpers
# Example:
#   items: ->
#

# Board: Lifecycle Hooks
Template.Board.created = ->

Template.Board.rendered = ->

Template.Board.destroyed = ->
