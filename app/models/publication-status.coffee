`import DS from 'ember-data'`

###
# A Concept does not necessarily have a publication status associated.
# Non-leaf concepts do not have publication statuses, while all leaf concepts do.
# A concept can be editable or non-editable at a concept level. For example, all leaf
# concepts are editable by default.
# An editable concept is going to be a publication status  (draft, published ..) and depending
# on which status it's in, it may be editable or not (such as deprecated = non-editable), but
# it can always go back to an editable state.
#
###
PublicationStatus = DS.Model.extend
  label: DS.attr('string')
  editable: DS.attr('string')
  selectable: DS.attr('string')

  isEditable: Ember.computed 'editable', ->
    @get('editable') is 'true'

  isSelectable: Ember.computed 'selectable', ->
    @get('selectable') is 'true'

`export default PublicationStatus`
