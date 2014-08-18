# for positioning of new widgets
# TODO: use a better layout algorithm
position = 0

# Events

Template.BoardsShow.events
  'click .action-new-widget': (event, template) ->
    board_id = template.data.board._id
    Widgets.insert
      owner: Meteor.user()
      contents: ''
      position:
        x: position
        y: position
      voteOptions: []
      votes: {}
      editable: true
      board_id: board_id
    position += 50

Template.BoardsShow.helpers
# Example:
#   items: ->
#

# BoardsShow: Lifecycle Hooks
Template.BoardsShow.created = ->

Template.BoardsShow.rendered = ->

Template.BoardsShow.destroyed = ->
