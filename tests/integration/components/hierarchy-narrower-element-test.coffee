`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'hierarchy-narrower-element', 'Integration | Component | hierarchy narrower element', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{hierarchy-narrower-element}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#hierarchy-narrower-element}}
      template block text
    {{/hierarchy-narrower-element}}
  """

  assert.equal @$().text().trim(), 'template block text'
