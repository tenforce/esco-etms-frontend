`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'bookmark-list', 'Integration | Component | bookmark list', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{bookmark-list}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#bookmark-list}}
      template block text
    {{/bookmark-list}}
  """

  assert.equal @$().text().trim(), 'template block text'
