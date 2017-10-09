`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'skill-type-selector', 'Integration | Component | skill type selector', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{skill-type-selector}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#skill-type-selector}}
      template block text
    {{/skill-type-selector}}
  """

  assert.equal @$().text().trim(), 'template block text'
