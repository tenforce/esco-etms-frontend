`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'show-notes', 'Integration | Component | show notes', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{show-notes}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#show-notes}}
      template block text
    {{/show-notes}}
  """

  assert.equal @$().text().trim(), 'template block text'
