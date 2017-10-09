`import Ember from 'ember'`

DashboardRoute = Ember.Route.extend
  model: (params) ->
    @set('params', params)
  setupController: (controller, model) ->
    controller.set('display', @get('params.display'))
    @_super(controller, model)

`export default DashboardRoute`
