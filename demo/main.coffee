translate = window.t7e

LANGUAGES =
  'en-us':
    hello: 'Hello'
    helloFriend: 'Hello, $friend!'
    goodbye: 'Goodbye'
    goodbyeTitle: 'See you soon'
    flag: 'http://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/125px-Flag_of_the_United_States.svg.png'

  'es-mx':
    hello: 'Hola'
    helloFriend: '¡Hola, $friend!'
    goodbye: 'Adios'
    goodbyeTitle: 'Hasta la vista'
    flag: 'http://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Flag_of_Mexico.svg/125px-Flag_of_Mexico.svg.png'


# Set up the menu.

select = document.createElement 'select'
for language of LANGUAGES
  option = document.createElement 'option'
  option.value = language
  option.innerHTML = language.toUpperCase()
  select.appendChild option

onLanguageChange = ->
  translate.load LANGUAGES[select.value]
  translate.refresh()

select.addEventListener 'change', onLanguageChange

document.body.appendChild select

onLanguageChange()


# Add some translated content.

container = document.createElement 'div'

container.innerHTML += translate div: 'hello'

container.innerHTML += translate div: 'helloFriend', $friend: 'Aaron'

container.innerHTML += translate div: 'goodbye', title: 'goodbyeTitle'

container.innerHTML += translate img: '', src: 'flag'

document.body.appendChild container
