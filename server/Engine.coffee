WebSocketServer = require("ws").Server

module.exports = class Engine
  constructor: (app) ->
    @server = new WebSocketServer {
      server: app
      clientTracking: true
    }

  newPush: (commits) ->

  newBranch: (branchName, description) ->

  _broadcast: (message) ->
    _.each @server.clients, (client) ->
      client.send(message)



