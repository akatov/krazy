ServiceConfiguration.configurations.remove {}

_.forEach Meteor.settings.services, (service) ->
  ServiceConfiguration.configurations.insert service
