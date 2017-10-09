`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'wrapper-concept-status-selector', 'Integration | Component | wrapper concept status selector', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{wrapper-concept-status-selector}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#wrapper-concept-status-selector}}
      template block text
    {{/wrapper-concept-status-selector}}
  """

  assert.equal @$().text().trim(), 'template block text'
