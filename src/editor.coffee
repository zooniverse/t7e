t7e = window.t7e || require './t7e'

mixInStrings = (key, value) ->
  return unless key

  segments = key.split '.'
  single = {}

  for segment in segments[...-1]
    single[segment] ?= {}
    single = single[segment]

  single[segments[-1...]] = value

  t7e.load single

preventDefault = (e) ->
  e.preventDefault()

translatedElements = null

t7e.editor =
  start: ->
    document.documentElement.classList.add 't7e-edit-mode'

    translatedElements = Array::slice.call document.querySelectorAll '[data-t7e-key]'

    for element in translatedElements
      t7e.refresh element, literal: true
      element.contentEditable = true
      element.style.outline = '1px dotted gray'
      element.addEventListener 'click', preventDefault, false

  stop: ->
    document.documentElement.classList.remove 't7e-edit-mode'

    for element in translatedElements
      mixInStrings (element.getAttribute 'data-t7e-key'), element.innerHTML
      element.contentEditable = 'inherit'
      element.style.outline = ''
      element.removeEventListener 'click', preventDefault, false

    t7e.refresh()

  export: ->
    console.log JSON.stringify t7e.strings

  init: ->
    controls = document.createElement 'div'
    controls.innerHTML = '<span class="t7e-editor-label">T7E</span>'
    controls.style.position = 'fixed'
    controls.style.right = 0
    controls.style.top = 0

    for method in ['start', 'stop', 'export']
      button = document.createElement 'button'
      button.innerHTML = method.toUpperCase()
      button.addEventListener 'click', t7e.editor[method], false
      controls.appendChild button

    document.body.appendChild controls

module?.exports = t7e.editor
