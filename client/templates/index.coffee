boardNumber = 3

# Index: Event Handlers and Helpers
Template.Index.events
  'click .action-new-board': (event, template) ->
    boardNumber++
    Boards.insert
      name: "Board #{boardNumber}"

Template.Index.helpers
# Example:
#   items: ->
#

# Index: Lifecycle Hooks
Template.Index.created = ->

Template.Index.rendered = ->

Template.Index.destroyed = ->
