`import Ember from 'ember';`
`import ResizeTextareaMixin from 'ember-concept-display/mixins/resize-textarea';`

NotificationComponentComponent = Ember.Component.extend ResizeTextareaMixin,
  notification: null
  relatedItems: Ember.computed.alias 'notification.list'
  message: Ember.computed.alias 'notification.message'
  listButton: Ember.computed.alias 'notification.listButton'
  minDate: null

  titleLabel: Ember.computed 'type', ->
    if @get('type') is 'create' then return "Create notification"
    else if @get('type') is 'update' then return "Update notification"
  saveButtonLabel: "Save"
  messageLabel: "Message"
  expirationLabel: "Expiration date"
  listButtonLabel: "Clickable text"
  relatedButtonLabel: "Add to the items"

  defaultType: "message"
  notificationTypes:[
    "message",
    "list"
  ]

  defaultPurpose: "success"
  purposeTypes:[
    "success",
    "alert",
    "warning"
  ]

  tmpRelatedItems: {}
  toggleHashChange: true

  store: Ember.inject.service('store')

  didReceiveAttrs: ->
    if @get 'notification'
      @set 'type', 'update'
    else
      @set 'type', 'create'
      @reset()

  reset: ->
    @set 'minDate', new Date(Date.now())

    @set 'notification', null
    @set 'notification', @get('store').createRecord('notification', list:[])
    @set('notification.expirationDate', "")
    @set('notification.message', "")
    @set('notification.notificationType', @get('defaultType'))
    @set('notification.purpose', @get('defaultPurpose'))


  shouldDisableSave: Ember.computed 'notification.notificationType', 'emptyInfos', 'emptyList', ->
    if @get('emptyInfos') then return true
    if @get('notification.notificationType') is 'list'
      return @get('emptyList')
  emptyInfos: Ember.computed 'notification.message', 'notification.expirationDate', 'notification.notificationType', 'notification.purpose', ->
    unless @get('notification.message') and @get('notification.expirationDate') and @get('notification.notificationType') and @get('notification.purpose')
      return true
    return false
  emptyList: Ember.computed 'notification.notificationType', 'notification.list', 'notification.list.length', ->
    unless @get('notification.notificationType') and @get('notification.list') then return true
    if @get('notification.list.length') is 0 then return true
    false

  newRelatedItem: ""
  addRelatedItem: () ->
    unless @get('notification.list') then @set 'notification.list', []
    @get('notification.list').pushObject(@get('newRelatedItem').trim())
    @set 'newRelatedItem', ''
    Ember.run.next =>
      @$('.relatedItem').last().focus()
  actions:
    save: ->
      @set 'error', false
      @set 'success', false
      type = @get 'type'
      prom = @get('notification').save()
      prom.then =>
        if type is "update"
          @sendAction 'transitionToList'
        else if type is "create"
          @reset()
        @set 'success', true
      prom.catch =>
        @set 'error', true

    selectDate: (value) ->
      @set('notification.expirationDate', value)

    selectType: (type) ->
      @set('notification.notificationType', type)

    selectPurpose: (purpose) ->
      @set('notification.purpose', purpose)

    increaseRelatedItemField: ->
      @addRelatedItem()

    textContentModified: (index, event) ->
      if(event.keyCode == 13 && not event.shiftKey)
        @get('notification.list')[index] = event.target.value.trim()
        Ember.run.next =>
          @$('.relatedItem').get(index+1).focus()
      else
        @get('notification.list')[index] = event.target.value

    newTextContentModified: (index, event) ->
      if(event.keyCode == 13 && not event.shiftKey)
        @addRelatedItem()
      else
        @set 'newRelatedItem', event.target.value

    removeRelatedItem: (index) ->
      @set('notification.list', @get('notification.list').without(@get('notification.list')[index]))
      #@get('notification.list').removeObject(@get('notification.list').objectAt(index))
      Ember.run.next =>
        @$('.relatedItem').get(index).focus()
    removeNewRelatedItem: (index) ->
      false


`export default NotificationComponentComponent`
