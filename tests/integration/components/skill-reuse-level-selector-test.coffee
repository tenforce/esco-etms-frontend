`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'skill-reuse-level-selector', 'Integration | Component | skill reuse level selector', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{skill-reuse-level-selector}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#skill-reuse-level-selector}}
      template block text
    {{/skill-reuse-level-selector}}
  """

  assert.equal @$().text().trim(), 'template block text'
