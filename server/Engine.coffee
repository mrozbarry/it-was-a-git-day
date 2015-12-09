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
      client.on 'message', (data, flags) ->
      client.on 'close', ->

  registerAdaptor: (adaptor) ->
    adaptor(@app, @)

  publishPing: (payload) ->
    @_broadcast(
      type: 'ping'
      active: payload.active
      events: payload.events
      repository: _.pick payload.repository, ['id', 'name', 'full_name', 'description']
    )

  publishPush: (payload) ->
    @_broadcast(
      type: 'push'
      commits: payload.commits
      pusher: payload.pusher
      repository: _.pick payload.repository, ['id', 'name', 'full_name', 'url']
    )

  _broadcast: (message) ->
    messageString = JSON.stringify(message)
    _.each @server.clients, (client) ->
      client.send(messageString)

