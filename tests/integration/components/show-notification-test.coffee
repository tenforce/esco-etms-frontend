`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'show-notification', 'Integration | Component | show notification', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{show-notification}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#show-notification}}
      template block text
    {{/show-notification}}
  """

  assert.equal @$().text().trim(), 'template block text'
