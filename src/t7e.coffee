strings = {}

dataSet = (el, key, value) ->
  el.setAttribute "data-t7e-#{key.toLowerCase()}", value

dataGet = (el, key) ->
  el.getAttribute "data-t7e-#{key.toLowerCase()}"

dataAll = (el) ->
  data = {}

  for attr in el.attributes
    continue unless (attr.name.indexOf 'data-t7e-') is 0
    data[attr.name['data-t7e-'.length...]] = attr.value

  data

defaultOptions =
  raw: false # Return an actual element, not its markup
  literal: false # Don't interpolate $-variables
  fallback: null # Or a string

translate = ([tag]..., key, options = {}) ->
  [tag, key, options] = [arguments..., {}] if typeof options is 'string'

  if tag?
    [tag, classNames...] = tag.split '.'

    element = document.createElement tag
    element.classList.add className for className in classNames

    dataSet element, 'key', key || ''

    for property, value of options
      dataAttribute = if (property.charAt 0) is '$'
        "var-#{property[1...]}"
      else if property not of defaultOptions
        "attr-#{property}"
      else
        "opt-#{property}"

      dataSet element, dataAttribute, value

    translate.refresh element

    raw = if options.raw? then options.raw else defaultOptions.raw

    if raw
      element
    else
      outer = document.createElement 'div'
      outer.appendChild element
      outer.innerHTML

  else
    segments = key.split '.'

    object = strings
    for segment in segments
      object = object[segment] if object?

    object = object.join '\n' if object instanceof Array
    result = object || options.fallback || key

    literal = if options.literal? then options.literal else defaultOptions.literal
    unless literal
      for variable, value of options when (variable.charAt 0) is '$'
        result = result.replace variable, value, 'gi'

    result

translate.refresh = (root = document.body, givenOptions = {}) ->
  keyedElements = Array::slice.call root.querySelectorAll '[data-t7e-key]'
  keyedElements.unshift root if (dataGet root, 'key')?

  options = {}
  options[property] = value for property, value of givenOptions

  for element in keyedElements
    key = dataGet element, 'key'

    for dataAttr, value of dataAll element
      if (dataAttr.indexOf 'var-') is 0
        varName = dataAttr['var-'.length...]
        options["$#{varName}"] = value

      else if (dataAttr.indexOf 'attr-') is 0
        attrName = dataAttr['attr-'.length...]
        options[attrName] = value

      else if (dataAttr.indexOf 'opt-') is 0
        optName = dataAttr['opt-'.length...]
        options[optName] = value

    element.innerHTML = translate key, options

    for property, value of options
      continue if (property.charAt 0) is '$'
      continue if property of defaultOptions
      element.setAttribute property, translate value, options

  null

translate.load = (newStringSet, _base = strings) ->
  for own key, value of newStringSet
    if (typeof value is 'string') or (value instanceof Array)
      _base[key] = value
    else
      _base[key] = {} unless key of _base
      translate.load _base[key], value

window?.t7e = translate
module?.exports = translate
