exec = require 'easy-exec'

task 'serve', (options) ->
  exec 'coffee --watch --output . --compile src/t7e.coffee'
  exec "silver server --port #{process.env.PORT || 7373}"
