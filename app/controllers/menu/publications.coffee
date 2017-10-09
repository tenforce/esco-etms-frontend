`import Ember from 'ember'`
`import FileSaverMixin from 'ember-cli-file-saver/mixins/file-saver'`

PublicationsController = Ember.Controller.extend FileSaverMixin,
  ajax: Ember.inject.service()
  sortProperties: ['modified:asc']
  sortedModel: Ember.computed.sort('model', 'sortProperties')
  diffFrom: null
  diffTo: null
  diffable: Ember.computed 'diffFrom', 'diffTo', ->
    @get('diffFrom') && @get('diffTo') && @get('diffFrom.id') != @get('diffTo.id')
  actions:
    selectPublication: (fromOrTo, publication) ->
      if (@get("diff#{fromOrTo}") != publication)
        @set "diff#{fromOrTo}", publication
      else
        @set "diff#{fromOrTo}", null
    goToDiff: () ->
      @set 'loading', true
      url = "/publications-delta"
      filename = "diff-from-#{@get('diffFrom.name')}-to-#{@get('diffTo.name')}.txt"
      @get('ajax').request(url,
        method: 'GET'
        dataType: 'text'
        data: {pub1: @get('diffFrom.id'), pub2: @get('diffTo.id')}
      ).then((content) =>
          @saveTextAs(filename, content)
          @set 'loading', false
      ).catch((error) =>
        console.log error
        @set 'loading', false
      )

`export default PublicationsController`
