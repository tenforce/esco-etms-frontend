`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'show-nace', 'Integration | Component | show nace', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{show-nace}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#show-nace}}
      template block text
    {{/show-nace}}
  """

  assert.equal @$().text().trim(), 'template block text'
