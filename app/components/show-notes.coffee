`import Ember from 'ember'`

ShowNotesComponent = Ember.Component.extend
  displayNotes: false
  note : Ember.computed.alias 'concept.escoNote'
  store: Ember.inject.service()

  actions:
    textContentModified: (event) ->
         if(event.keyCode == 13 && not event.shiftKey)
             @get('concept').save()
             @toggleProperty 'displayNotes'
         else
             @set 'note', event.target.value

    toggleNotes: ->
      if @get "displayNotes"
        @get('concept').save()
      @toggleProperty 'displayNotes'

`export default ShowNotesComponent`
