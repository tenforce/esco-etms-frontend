`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`

AdminIndexRoute = Ember.Route.extend AuthenticatedRouteMixin,

# DEPRECATED
  model: ->
    Ember.RSVP.hash
      todo: @store.query('task', {"filter[status]": "todo"})
      translated: @store.query('task', {"filter[status]": "translated"})
      reviewed: @store.query('task', {"filter[status]": "reviewed"})
      reviewedWithChanges: @store.query('task', {"filter[status]": "reviewedWithChanges"})
      confirmed: @store.query('task', {"filter[status]": "confirmed"})

`export default AdminIndexRoute`
