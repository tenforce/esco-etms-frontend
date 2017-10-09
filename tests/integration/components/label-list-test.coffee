`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'label-list', 'Integration | Component | label list', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{label-list}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#label-list}}
      template block text
    {{/label-list}}
  """

  assert.equal @$().text().trim(), 'template block text'
