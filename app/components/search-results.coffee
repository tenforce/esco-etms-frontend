`import Ember from 'ember'`

SearchResultsComponent = Ember.Component.extend
  actions:
    activateItem: (item) ->
      @sendAction('activateItem', item)

`export default SearchResultsComponent`
