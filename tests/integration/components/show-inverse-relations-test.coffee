`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'show-inverse-relations', 'Integration | Component | show inverse relations', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{show-inverse-relations}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#show-inverse-relations}}
      template block text
    {{/show-inverse-relations}}
  """

  assert.equal @$().text().trim(), 'template block text'
