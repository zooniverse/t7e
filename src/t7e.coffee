strings = {}

DOMPurify = window.DOMPurify || require('dompurify')(window)

setData = (el, key, value) ->
  el.setAttribute "data-t7e-#{key.toLowerCase()}", value

getData = (el, key) ->
  el.getAttribute "data-t7e-#{key.toLowerCase()}"

getAllData = (el) ->
  data = {}

  for attr in el.attributes
    continue unless (attr.name.indexOf 'data-t7e-') is 0
    data[attr.name['data-t7e-'.length...]] = attr.value

  data

translate = (tag, key, attrs, transform) ->
  # TODO: This is pretty nasty, eh?
  typesOfArgs = (typeof arg for arg in arguments).join ' '
  [tag, key, attrs, transform] = switch typesOfArgs
    when 'string string object function' then arguments
    when 'string string object' then [arguments..., null]
    when 'string string function' then [arguments[0], arguments[1], {}, arguments[2]]
    when 'string object function' then [null, arguments...]
    when 'string string' then [arguments..., {}, null]
    when 'string object' then [null, arguments..., null]
    when 'string function' then [null, arguments[0], {}, arguments[1]]
    when 'string' then [null, arguments..., {}, null]
    else throw new Error "Couldn't unpack translate arguments (#{typesOfArgs})"

  if tag?
    [tagName, classNames...] = tag.split '.'
    element = document.createElement tagName
    element.className = classNames.join ' '

    setData element, 'key', key

    for attribute, value of attrs
      attribute = if (attribute.charAt 0) is '$'
        "var-#{attribute[1...]}"
      else
        "attr-#{attribute}"

      setData element, attribute, value

    if transform?
      setData element, 'transform', transform.toString()

    refresh element

    element.outerHTML

  else
    segments = key.split '.'

    result = strings
    for segment in segments
      result = result[segment] if result?

    result ?= key

    unless attrs._literal
      for variable, value of attrs when variable.charAt(0) is '$'
        result = result.replace variable, translate(value), 'gi'

    if transform
      result = transform result

    DOMPurify.sanitize result

refresh = (root = document.body, options = {}) ->
  keyedElements = (element for element in root.querySelectorAll '[data-t7e-key]')
  keyedElements.unshift root if getData(root, 'key')?

  for element in keyedElements
    attrs = {}
    attrs[property] = value for property, value of options

    for dataAttr, value of getAllData element
      if dataAttr.indexOf('var-') is 0
        varName = dataAttr['var-'.length...]
        attrs["$#{varName}"] = value

      else if dataAttr.indexOf('attr-') is 0
        attrName = dataAttr['attr-'.length...]
        attrs[attrName] = value

      else if dataAttr.indexOf('opt-') is 0
        optName = dataAttr['opt-'.length...]
        attrs[optName] = value

    key = getData element, 'key'
    transform = eval "(#{getData element, 'transform'})"

    if key
      element.innerHTML = if transform?
        translate key, attrs, transform
      else
        translate key, attrs

    for property, value of attrs when property.charAt(0) isnt '_'
      continue if (property.charAt 0) is '$'
      element.setAttribute property, translate value, attrs

load = (newStringSet, _base = strings) ->
  for own key, value of newStringSet
    if (typeof value is 'string') or (value instanceof Array)
      _base[key] = value
    else
      _base[key] = {} unless key of _base
      load value, _base[key]

translate.strings = strings
translate.refresh = refresh
translate.load = load
translate.getData = getData
translate.setData = setData
translate.getAllData = getAllData

window.t7e = translate
module?.exports = translate
