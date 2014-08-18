(exports ? @).VotingTemplates = new Meteor.Collection 'voting_templates'

# Add query methods like this:
#  VotingTemplates.findPublic ->
#    VotingTemplates.find is_public: true
