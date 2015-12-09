# Adapted from rvagg/github-webhook-handler
# https://github.com/rvagg/github-webhook-handler/blob/master/github-webhook-handler.js

crypto = require('crypto')

signBlob = (key, blob) ->
  digest = crypto.createHmac('sha1', key).update(blob).digest('hex')
  "sha1=#{digest}"

respondWithError = (response, jsonResponse) ->
  response.writeHead(400, 'content-type': 'application/json')
  response.end(JSON.stringify(jsonResponse))
  false

validateRequest = (request, response, data) ->
  return true if process.env.NODE_ENV != 'production'

  signature = request.headers['x-hub-signature']
  id = request.headers['x-github-delivery']

  unless signature?
    return respondWithError response, error: 'No x-hub-signature header'

  unless id?
    return respondWithError response, error: 'No x-github-delivery header'

  unless data
    return respondWithError response, error: 'No body from request'

  unless signature == signBlob(process.env.GITHUB_SECRET, data)
    return respondWithError response, error: 'Payload not from github'

  true

module.exports = (app, engine) ->
  app.post '/github_callback', (request, response) ->

    githubBody = ''
    request.on 'data', (chunk) -> githubBody += chunk
    request.on 'end', ->
      return unless validateRequest(request, response, githubBody)

      responseObject = JSON.parse(githubBody)

      switch request.headers['x-github-event']
        when 'ping'
          engine.publishPing responseObject
        when 'push'
          engine.publishPush responseObject

      response.writeHead 200, 'content-type': 'application/json'
      response.end JSON.stringify(success: true)
