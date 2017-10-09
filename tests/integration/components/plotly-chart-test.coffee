`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'plotly-chart', 'Integration | Component | plotly chart', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{plotly-chart}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#plotly-chart}}
      template block text
    {{/plotly-chart}}
  """

  assert.equal @$().text().trim(), 'template block text'
