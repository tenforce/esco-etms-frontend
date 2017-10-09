`import Ember from 'ember'`

MenuCreatePublicationController = Ember.Controller.extend
  errorMessage: null
  storePublication: ->
    go = window.confirm "Taxonomy Publication Service Warning:\n\nYou requested to start a publication action.\nIt is recommended to run all validations before going ahead with the publication.\n\nClick OK if you want to continue."
    if go is true
      record = @store.createRecord('publication',
        name: @get('publicationName'),
        issued: @get('publicationDate')
      )
      record.save().then( () =>
        @transitionToRoute 'menu.publications'
      ).catch( (error) =>
        @set 'errorMessage', error.errors[0].title
        record.deleteRecord()
      )

  actions:
    createPublication: ->
      @set('errorMessage', null)
      name = @get('publicationName')
      if name
        @storePublication()
      else
        @set 'errorMessage', 'Name is a required field'

`export default MenuCreatePublicationController`
