`import Ember from 'ember'`
`import {languagesIncludingEnglish} from '../utils/languages'`
`import env from '../config/environment'`

SetLanguageController = Ember.Controller.extend

  languageOptions: languagesIncludingEnglish
  language: {'id':'en', 'title':'English' }

  exportOptions: [{'title':'Occupations'}, {'title':'Skills', disabled:env.etms.disableTaxonomyChange}]
  exportType: {'title':'Occupations'}
  loading: false
  actions:
    setLanguage: (lang) ->
      @set 'language', lang #Ember.get(lang, 'id')
    setExportType: (et) ->
      @set 'exportType', et
    makeExport: ->
      if @get 'loading' then return undefined
      @set 'loading', true
      etype = "concept"
      if @get('exportType.title') == 'Skills'
        etype = "skill"
      # TODO use Ember ajax service 
      $.ajax
        url: '/export?language=' + @get('language.id') + "&type=" + etype,
        type: 'GET',
        success: (data) =>
          Ember.Logger.log(data)
          while(data.length>0)
            if(data.length<1000000)
              Ember.$('a.downloadlocation').attr("href","data:application/octet-stream," + encodeURIComponent("URI,ISCO,PT, NPT's\n#{data}"))[0].click()
              data = ""
            else
              buff = data.substring(0, 1000000)
              data = data.substring(1000000, data.length)
              fn = data.indexOf("\n")
              buff += data.substring(0, fn)
              data = data.substring(fn, data.length)
              Ember.$('a.downloadlocation').attr("href","data:application/octet-stream," + encodeURIComponent("URI,ISCO,PT, NPT's\n#{buff}"))[0].click()
          @set 'loading', false
          # data = JSON.parse(data)
          # data.data.sort (a,b) ->
          #   if(a.score > b.score)
          #     return -1
          #   else
          #    if(b.score > a.score)
          #      return 1
          #    else
          #      return 0
          # eA = Ember.A()
          # data.data.forEach (item, i) ->
          #   nO = Ember.Object.create()
          #   nO.set "id", item.id
          #   nO.set "preflabel", item.label
          #   eA.pushObject nO
          # @set 'searchResults', eA
          # @set 'searchLoading', false
        error: =>
          @set 'loading', false


`export default SetLanguageController`
