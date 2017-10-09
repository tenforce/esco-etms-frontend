`import Ember from 'ember'`
`import env from '../config/environment'`

ConceptStatusComponent = Ember.Component.extend
  classNames:["status"]
  classNameBindings: ["statusForCss"]
  attributeBindings: ["title"]

  status: Ember.computed 'model.hasPublicationStatus', ->
    @get('model.hasPublicationStatus.label')

  statusForCss: Ember.computed 'status', ->
    status = @get('status')
    if status
      status.replace(`/ /g,'-'`)
    else
      ''
  title: Ember.computed 'status', ->
    statusName = @get('status')
    title = "Sorry, this status is unknown"
    env.statuses.map (status) ->
        if status.id == statusName
            title = status.explained
    title

`export default ConceptStatusComponent`
