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
