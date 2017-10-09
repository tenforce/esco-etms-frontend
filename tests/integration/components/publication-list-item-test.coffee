`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'publication-list-item', 'Integration | Component | publication list item', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{publication-list-item}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#publication-list-item}}
      template block text
    {{/publication-list-item}}
  """

  assert.equal @$().text().trim(), 'template block text'
