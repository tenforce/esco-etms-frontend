`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'confirmation-popup', 'Integration | Component | confirmation popup', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{confirmation-popup}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#confirmation-popup}}
      template block text
    {{/confirmation-popup}}
  """

  assert.equal @$().text().trim(), 'template block text'
