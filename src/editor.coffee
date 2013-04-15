t7e = window.t7e || require './t7e'

preventDefault = (e) ->
  e.preventDefault()

translatedElements = null

t7e.editor =
  start: ->
    translatedElements = Array::slice.call document.querySelectorAll 'data-t7e-key'

    for element in translatedElements
      # TODO: Replace innerHTML with uninterpolated translation string.
      element.contentEditable = true
      element.style.outline = '1px dotted gray'
      element.addEventListener 'click', preventDefault, false

  stop: ->
    for element in translatedElements
      element.contentEditable = 'inherit'
      element.style.outline = ''
      element.removeEventListener 'click', preventDefault, false

  save: ->
    translations = {}
    for element in translatedElements
      translations[element.getAttribute 'data-t7e-key'] = element.innerHTML

    # TODO: Write this out somewhere.
    console.log JSON.stringify translations

  init: ->
    controls = document.createElement 'div'
    controls.style.position = 'fixed'
    controls.style.right = 0
    controls.style.top = 0

    for method in ['start', 'stop', 'save']
      button = document.createElement 'button'
      button.innerHTML = method.toUpperCase()
      button.addEventListener 'click', t7e.editor[method], false
      controls.appendChild button

    document.appendChild controls

module?.exports = t7e.editor
