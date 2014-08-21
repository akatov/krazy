# BSON Types
# Type	Number
# Double	1
# String	2
# Object	3
# Array	4
# Binary data	5
# Undefined (deprecated)	6
# Object id	7
# Boolean	8
# Date	9
# Null	10
# Regular Expression	11
# JavaScript	13
# Symbol	14
# JavaScript (with scope)	15
# 32-bit integer	16
# Timestamp	17
# 64-bit integer	18
# Min key	255
# Max key	127

Migrations.add
  version: 1
  name: 'Make Votes proper Minimongoid objects embedded in Widgets'
  # comment: 'this is quite horrible, as it updates every single document in ' +
  #   'Widgets. Do not migrate back to this version if the database becomes huge!'
  up: ->
    Widgets = Widget._collection
    Widgets.find({votes:{$exists: true, $type: 3}}).forEach (w) ->
      votes = []
      for voter_id, value of w.votes
        votes.push {user_id: voter_id, value: value}
      Widgets.update({_id: w._id}, {$set: {votes: votes}})
  down: ->
    Widgets = Widget._collection
    Widgets.find({votes:{$exists: true, $type: 4}}).forEach (w) ->
      votes = {}
      for vote of w.votes
        votes[vote.user_id] = vote.value
      Widgets.update({_id: w._id}, {$set: {votes: votes}})

Migrations.migrateTo 'latest'
