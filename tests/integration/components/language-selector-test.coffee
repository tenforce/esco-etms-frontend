`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'language-selector', 'Integration | Component | language selector', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{language-selector}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#language-selector}}
      template block text
    {{/language-selector}}
  """

  assert.equal @$().text().trim(), 'template block text'
