WebSocket = require('ws')

module.exports =
  socket: null
  _socketClosedLocally: false

  connectSocket: ->
    isSecure = window.location.protocol == "https:"
    host = [
      if isSecure then "wss://" else "ws://"
      window.location.hostname
    ]
    host = host.concat [":", window.location.port] if window.location.port != ""
    websocketHost = host.join ''

    @socket = new WebSocket(websocketHost)
    @_socketClosedLocally = false
    @socketWillConnect?(@socket)

    @socket.onopen = =>
      @socketDidConnect?(@socket)
      console.debug 'socket.open'

    @socket.onerror = (e) =>
      @socketDidHaveError?(@socket, e)
      console.log 'socket error', arguments

    @socket.onclose = =>
      @socketDidClose?(@socket, closeByPeer: !@_socketClosedLocally)

    @socket.onmessage = (e) =>
      @socketReceivedMessage?(@socket, e)

  disconnectSocket: ->
    @_socketClosedLocally = true
    @socketWillClose(@socket)
    @socket.close()
    @socket = null

  socketSendMessage: (raw) ->
    @socket.send raw

