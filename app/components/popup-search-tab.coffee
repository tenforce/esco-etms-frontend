`import Ember from 'ember'`
`import Ensure from 'ember-data-ensure'`

PopupSearchTabComponent = Ember.Component.extend
  store: Ember.inject.service('store')
  ajax: Ember.inject.service()
  textQuery: ''
  searchLoading: false
  searchDone: false
  searchResults: []
  clickedResults: []

  # Defaults go in popup-component.coffee
  mergeAllowDeprecatedSearch: Ember.computed 'mergeFunctionalityFlag', ->
    mergeFunctionalityFlag = @get('mergeFunctionalityFlag')
    if not mergeFunctionalityFlag then false else mergeFunctionalityFlag

  # The concepts which are already related to the concept, including the concept itself.
  # TODO make server side again if server accepts POST body. This is too big for a GET.
  relatedConcepts: Ember.computed ->
    Ensure.ensureCollect @get('concept'), {
        'id',
        'narrower': {'id'},
        'broader': {'id'},
        'nace': {'id'},
        'replaces': {'id'},
        'replacements': {'id'},
        'relations': {'to': {'id'}},
        'inverseRelations': {'from': {'id'}}
      }

  hasSelectedResults: Ember.computed 'clickedResults', 'clickedResults.length', ->
    results = @get 'clickedResults'
    not Ember.isEmpty(results)

  numberOfResults: Ember.computed 'searchResults', ->
    if @get('searchResults')
      return @get('searchResults').length
    else
      return 0

  willDestroyElement: ->
    @_super()
    @get('clickedResults').clear()

  performSearch: ->
    store = @get('store')
    @set 'searchLoading', true
    @set 'searchDone', false
    @getSearchResults(@get('textQuery')).then (searchResults) =>
      @get('relatedConcepts').then (relatedConcepts) =>
        ids = searchResults.map (c) ->
          c.id

        # filter out results that can't be added to the concept anymore
        # TODO remove if we go back to server-side filtering
        ids = ids.reject (id) =>
          relatedConcepts.includes(id)

        @get('store').query('concept',
          filter: {id: ids.join(',')}
          include: ["pref-labels"]
        ).then (concepts) =>

          # retain the order (by relevance) from the search
          idMap = {}
          concepts.map (item) ->
            idMap[item.get('id')] = item
          orderedConcepts = []
          ids.map (id) ->
            if idMap[id]
              orderedConcepts.push idMap[id]

          unless @get('isDestroyed')
            @set 'searchResults', orderedConcepts
            @set 'searchLoading', false
            @set 'searchDone', true
            # we only scroll when the search has been done
            Ember.run.later =>
              $('html,body').stop().animate({scrollTop: $('.results').offset().top + 15}, 2000);


        error: ->
          unless @get('isDestroyed')
            @set 'searchResults', Ember.A()
            @set 'searchLoading', false
            @set 'searchDone', true


  getSearchResults: (textQuery) ->
    data = {
      'conceptScheme': @get('conceptScheme'),
      'locale': "en",
      'text': textQuery,
      'numberOfResults': "100",
    }

    if @get('searchFilter.include')
      data['include'] = @get('searchFilter.include').join(',') || undefined

    if @get('searchFilter.exclude')
      data['exclude'] = @get('searchFilter.exclude').join(',') || undefined

    @get('ajax').request('/indexer/search/textSearch',
      data: data
    ).then((searchResults) =>
      return searchResults.data
    ).catch (reason) =>
      console.log "Search failed: " + reason
      []



  actions:
    saveElements: ->
      clickedResults = @get('clickedResults').slice()
      @get('clickedResults').clear()
      @sendAction('saveAllElements', clickedResults)

    listItemClick: (item) ->
      clickedResults = @get('clickedResults')
      itemId = item.get('id')
      # click element when nothing is selected
      # or when we click on a non-selected element
      # we also add it to the 'selection'
      unless clickedResults.findBy('id', itemId)
        clickedResults.pushObject item
      @send('saveElements')

    textContentModified: (event) ->
      @set 'textQuery', event.target.value
      if(event.keyCode == 13 && not event.shiftKey)
        if @get 'textQuery'
          @performSearch()


`export default PopupSearchTabComponent`
