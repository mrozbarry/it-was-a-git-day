WebSocketServer = require("ws").Server
_ = require('lodash')

module.exports = class Engine
  constructor: (@app, httpServer) ->
    @_createWebsocketServer(httpServer)

  _createWebsocketServer: (httpServer) ->
    @server = new WebSocketServer {
      server: httpServer
      clientTracking: true
    }
    @server.on 'connection', (client) ->
      console.log '--- Client connected ---'

      client.on 'message', (data, flags) ->
        console.log 'Client message', data, flags

      client.on 'close', ->
        console.log 'Client disconnected'

    console.log '=== Created websocket server ==='

  registerAdaptor: (adaptor) ->
    adaptor(@app, @)

  publishPush: (payload) ->
    @_broadcast(
      type: 'push'
      commits: payload.commits
      pusher: payload.pusher
      repository: _.pick payload.repository, ['id', 'name', 'full_name', 'url']
    )

  _broadcast: (message) ->
    console.log 'broadcast', message
    messageString = JSON.stringify(message)
    _.each @server.clients, (client) ->
      client.send(messageString)

