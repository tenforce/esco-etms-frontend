`import Ember from 'ember'`

clearHierarchyCache = ->
  Ember.$.ajax
    url: "/hierarchy/cache/clear",
    type: "POST",
    data: {},
    success: (ret) ->
      console.log 'hierarchy refreshed'
    error: (ret) ->
      console.log 'hierarchy refresh failed'

`export default clearHierarchyCache`
