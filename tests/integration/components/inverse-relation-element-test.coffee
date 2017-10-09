`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'inverse-relation-element', 'Integration | Component | inverse relation element', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{inverse-relation-element}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#inverse-relation-element}}
      template block text
    {{/inverse-relation-element}}
  """

  assert.equal @$().text().trim(), 'template block text'
