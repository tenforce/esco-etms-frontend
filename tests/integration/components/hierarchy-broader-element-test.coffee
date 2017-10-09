`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'hierarchy-broader-element', 'Integration | Component | hierarchy broader element', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{hierarchy-broader-element}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#hierarchy-broader-element}}
      template block text
    {{/hierarchy-broader-element}}
  """

  assert.equal @$().text().trim(), 'template block text'
