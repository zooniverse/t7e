translate = window.t7e

languages =
  'en-us':
    hello: 'Hello'
    helloFriend: 'Hello, $friend!'
    goodbye: 'Goodbye'
    goodbyeTitle: 'See you soon'
    flag: 'http://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/125px-Flag_of_the_United_States.svg.png'
    flagTitle: 'The Flag of the USA'
    outLink: 'http://www.google.com/'

  'es-mx':
    hello: 'Hola'
    helloFriend: '¡Hola, $friend!'
    flag: 'http://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Flag_of_Mexico.svg/125px-Flag_of_Mexico.svg.png'
    flagTitle: 'La bandera de México'
    goodbye: 'Adios'
    goodbyeTitle: 'Hasta la vista'
    outLink: 'http://www.google.com.mx/'

# Set up the menu.

select = document.createElement 'select'
for language of languages
  option = document.createElement 'option'
  option.value = language
  option.innerHTML = language.toUpperCase()
  select.appendChild option

onLanguageChange = ->
  translate.load languages[select.value]
  translate.refresh()

select.addEventListener 'change', onLanguageChange

document.body.appendChild select

onLanguageChange()


# Add some translated content.

container = document.createElement 'div'

container.innerHTML += translate 'div.foo', 'hello'

container.innerHTML += translate 'div.foo.bar', 'helloFriend', $friend: 'Aaron'

container.innerHTML += translate 'div', 'goodbye', title: 'goodbyeTitle'

container.innerHTML += translate 'img', null, src: 'flag', title: 'flagTitle'
container.innerHTML += '<br />'

container.innerHTML += translate 'a', 'goodbye', href: 'outLink', title: 'Title not translated'

document.body.appendChild container

t7e.editor.init()
