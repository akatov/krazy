#
# * Add query methods like this:
# *  Boards.findPublic = function () {
# *    return Boards.find({is_public: true});
# *  }
# 
Boards.allow
  insert: (userId, doc) ->
    true

  update: (userId, doc, fieldNames, modifier) ->
    true

  remove: (userId, doc) ->
    true

Boards.deny
  insert: (userId, doc) ->
    false

  update: (userId, doc, fieldNames, modifier) ->
    false

  remove: (userId, doc) ->
    false

Meteor.startup ->
  Boards.remove _id: $exists: true
  [
    _id: '1'
    name: 'Board 1'
  ,
    _id: '2'
    name: 'Board 2'
  ,
    _id: '3'
    name: 'Board 3'
  ].forEach (b) ->
    Boards.insert b
