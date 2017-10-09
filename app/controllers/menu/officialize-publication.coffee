`import Ember from 'ember'`

OfficializePublicationController = Ember.Controller.extend
  ajax: Ember.inject.service()
  running: false
  actions:
    officialize: () ->
      @set 'running', true
      url = "/publications/#{@get('model.id')}/make-official"
      @get('ajax').post(url).then( (result) =>
        @set 'running', false
        @transitionToRoute 'menu.publications'
      ).catch( (error) =>
        @set 'errorMessage', error.errors?[0].title
        @set 'running', false
      )




`export default OfficializePublicationController`
