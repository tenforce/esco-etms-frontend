`import Ember from 'ember'`

###
# Returns an array with the available status transitions from a given status transitions
# graph description in the form of a javascript object.
#
# @param description: a javascript object describing the graph with nodes, edges and
# predicates to be fulfilled for a transition to appear. An example graph would be:
#
#
# Promises are nested in such way because of the async nature of the predicates.
# Predicates can be functions that are resolved asynchronously and hence a mechanism
# to wait for each predicate of each edge is necessary.
#
# description = {
#   nodes: ['Draft', 'Ready for publication'],
#   edges: [
#     {
#       from: 'Draft',
#       to: 'Ready for publication',
#       predicates: [() => { return condition } ],
#       predicateCriteria: 'any/all'
#     },
#     {
#       from: 'Ready for publication',
#       to: 'Draft',
#       predicates: [],
#       predicateCriteria: 'any'
#     }
#   ]
# }
###
statusTransitions = (description, currentNode) =>
  new Ember.RSVP.Promise (res, rej) =>
    edges = description.edges.filter((edge) =>
      edge.from == currentNode)
    promises = edges.map (edge) =>
      new Ember.RSVP.Promise (resolve, reject) =>
        Ember.RSVP.Promise.all(edge.predicates.map (f) => f()).then (predicates) =>
          if edge.predicateCriteria is undefined or edge.predicateCriteria == 'all'
            if (predicates.every (pred) => pred is true) then resolve edge.to else resolve false
          else
            if (predicates.some (pred) => pred is true) then resolve edge.to else resolve false
    Ember.RSVP.Promise.all(promises).then (transitions) =>
      res transitions.filter (el) =>
        el isnt false


`export default statusTransitions`
