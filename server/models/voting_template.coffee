VotingTemplate._collection.allow
  insert: (userId, doc) ->
    true

  update: (userId, doc, fieldNames, modifier) ->
    true

  remove: (userId, doc) ->
    true

VotingTemplate._collection.deny
  insert: (userId, doc) ->
    false

  update: (userId, doc, fieldNames, modifier) ->
    false

  remove: (userId, doc) ->
    false

Meteor.startup ->
  if VotingTemplate.count() == 0
    _.forEach [
      name: "OK"
      opts: ["OK"]
      clss: ["positive"]
    ,
      name: "Yes/No"
      opts: ["Yes", "No"]
      clss: ["positive","negative"]
    ,
      name: "+/-/0"
      opts: ["Like", "Dislike", "Whatev"],
      clss: ["positive", "negative", "neutral"]
    ], (t) ->
      VotingTemplate.create t
