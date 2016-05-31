exec = require 'easy-exec'

PORT = process.env.PORT ? 7373

task 'serve', (options) ->
  console.log ">>> http://localhost:#{PORT}/demo/"
  exec "static . --port #{PORT}"
  exec 'coffee --watch --output ./demo --compile ./demo'
  exec 'coffee --watch --output . --compile ./src'
  exec 'stylus --import ./node_modules/nib --watch ./src --out .'
