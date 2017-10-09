`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'search-results', 'Integration | Component | search results', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{search-results}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#search-results}}
      template block text
    {{/search-results}}
  """

  assert.equal @$().text().trim(), 'template block text'
