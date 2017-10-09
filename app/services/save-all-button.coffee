`import Ember from 'ember'`

# Ember objects can subscribe to this service to receive a saveAllClick()
# it's their responsibility to decide whether they should ignore it (for example if they're not dirty) or not
SaveAllButtonService = Ember.Service.extend

  subscriptions: []

  # Any of the subscribers have a thruty 'dirty' property
  dirty: Ember.computed "subscriptions.@each.dirty", ->
    @get('subscriptions').isAny('dirty')

  subscribe: (subscriber) ->
    @get('subscriptions').pushObject(subscriber)

  unsubscribe: (subscriber) ->
    @get('subscriptions').removeObject(subscriber)

  clearSubscribers: () ->
    @set('subscriptions', [])

  resetAll: () ->
    @get('subscriptions').forEach (subscriber) ->
      if subscriber.get('dirty')
        subscriber.resetAllClick()

  saveAll: ->
    @get('subscriptions').forEach (subscriber) ->
      if subscriber.get('dirty')
        subscriber.saveAllClick()



`export default SaveAllButtonService`
