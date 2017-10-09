`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'popup-search-tab', 'Integration | Component | popup search tab', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{popup-search-tab}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#popup-search-tab}}
      template block text
    {{/popup-search-tab}}
  """

  assert.equal @$().text().trim(), 'template block text'
