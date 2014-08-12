# Add query methods like this:
#  VotingTemplates.findPublic ->
#    VotingTemplates.find is_public: true

VotingTemplates.allow
  insert: (userId, doc) ->
    true

  update: (userId, doc, fieldNames, modifier) ->
    true

  remove: (userId, doc) ->
    true

VotingTemplates.deny
  insert: (userId, doc) ->
    false

  update: (userId, doc, fieldNames, modifier) ->
    false

  remove: (userId, doc) ->
    false

Meteor.startup ->
  if VotingTemplates.find().count() == 0
    _.forEach([
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
      VotingTemplates.insert t
    )
