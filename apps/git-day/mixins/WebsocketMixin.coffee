WebSocket = require('ws')

module.exports =
  socket: null

  connectSocket: ->

    isSecure = window.location.protocol == "https:"
    host = [
      if isSecure then "wss://" else "ws://"
      window.location.hostname
    ]
    host = host.concat [":", window.location.port] if window.location.port != ""
    websocketHost = host.join ''

    @socket = new WebSocket(websocketHost)
    @socketWillConnect?(@socket)

    @socket.onopen = =>
      @socketDidConnect?(@socket)
      console.debug 'socket.open'

    @socket.onerror = (e) =>
      @socketDidHaveError?(@socket, e)

    @socket.onclose = =>
      @socketDidClose?(@socket)

    @socket.onmessage = (e) =>
      @socketReceivedMessage?(@socket, e)

  disconnectSocket: ->
    @socketWillClose(@socket)
    @socket.close()
    @socket = null

  socketSendMessage: (raw) ->
    @socket.send raw

