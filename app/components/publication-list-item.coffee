`import Ember from 'ember'`
`import FileSaverMixin from 'ember-cli-file-saver/mixins/file-saver'`

PublicationListItemComponent = Ember.Component.extend FileSaverMixin,
  ajax: Ember.inject.service()
  tagName: 'tr'
  init: () ->
    this._super()
    @get('diffFrom.id')
    @get('diffTo.id')
    if @get('publication.running')
      @refreshPublication()

  filename: Ember.computed 'publication.id', 'publication.name', ->
    "publication-#{@get('publication.name')}-#{@get('publication.id')}.nt"

  refreshPublication: () ->
    @get('publication').reload().then((result) =>
      if (result.get('running'))
        Ember.run.later((() => @refreshPublication(true)), 60000)
    ).catch(=>
      Ember.run.later((() => @refreshPublication(true)), 60000)
    )
  selectedFrom: Ember.computed 'publication.id', 'diffFrom.id', ->
    console.log("#{@get('publication.id')} == #{@get('diffFrom.id')}")
    @get('publication.id') == @get('diffFrom.id')
  selectedTo: Ember.computed 'publication.id', 'diffTo.id', ->
    @get('publication.id') == @get('diffTo.id')
  actions:
    download: ->
      @get('ajax').request(@get('publication.download'),
        blob:true
        method: 'GET'
        dataType: 'text'
      ).then((content) =>
        @saveTextAs(this.get('filename'), content)
        @set 'loading', false
      ).catch((error) =>
        console.log error
        @set 'loading', false
      )
    delete: ->
      if @get('disabled')
        alert("You can't delete this publication while a diff is being calculated.")
        return false
      if (@get('publication.deletable'))
        go = window.confirm "Are you sure you want to delete this publication?"
        if go then @get('publication').destroyRecord()
      else
        alert("You can't delete this publication.")
    toggleDiff: (fromOrTo) ->
      @attrs.selectPublication(fromOrTo, @get('publication'))
`export default PublicationListItemComponent`
