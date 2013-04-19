exec = require 'easy-exec'

task 'serve', (options) ->
  exec 'coffee --watch --output . --compile ./src'
  exec 'stylus --watch ./src --out .'
  exec "silver server --port #{process.env.PORT || 7373}"
