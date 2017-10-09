`import DS from 'ember-data'`

Notification = DS.Model.extend
  notificationType: DS.attr('string')
  purpose: DS.attr('string')
  message: DS.attr('string')
  listButton: DS.attr('string')
  expirationDate: DS.attr('string')
  list: DS.attr('string-set')
`export default Notification`
