`import Ember from 'ember'`

MenuOfficializePublicationRoute = Ember.Route.extend
  model: (params) ->
    @store.find('publication', params.id)


`export default MenuOfficializePublicationRoute`
