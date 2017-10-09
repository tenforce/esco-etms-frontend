`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'tab-shortcuts', 'Integration | Component | tab shortcuts', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{tab-shortcuts}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#tab-shortcuts}}
      template block text
    {{/tab-shortcuts}}
  """

  assert.equal @$().text().trim(), 'template block text'
