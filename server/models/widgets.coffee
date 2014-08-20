# Add query methods like this:
#  Widgets.findPublic = ->
#    Widgets.find is_public: true

Widgets.allow
  insert: (userId, doc) ->
    true

  update: (userId, doc, fieldNames, modifier) ->
    true

  remove: (userId, doc) ->
    true

Widgets.deny
  insert: (userId, doc) ->
    false

  update: (userId, doc, fieldNames, modifier) ->
    false

  remove: (userId, doc) ->
    false

Meteor.startup ->
  # always clean Widgets collection at startup for now
  Widgets.remove _id: $exists: true
