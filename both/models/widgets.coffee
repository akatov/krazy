(exports ? @).Widgets = new Meteor.Collection 'widgets'

# Add query methods like this:
#  Widgets.findPublic = ->
#    Widgets.find is_public: true
