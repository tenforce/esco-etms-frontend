`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'help-box-wrapper', 'Integration | Component | help box wrapper', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{help-box-wrapper}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#help-box-wrapper}}
      template block text
    {{/help-box-wrapper}}
  """

  assert.equal @$().text().trim(), 'template block text'
