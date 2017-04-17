# app/assets/javascripts/cable/subscriptions/chat_lobby.coffee
App.chatChannel = App.cable.subscriptions.create { channel: "ChatChannel", room: "Lobby"},
  received: (data) ->
    @appendLine(data)
    #
    $('#chat-feed').stop().animate { scrollTop: $('#chat-feed')[0].scrollHeight }, 800

  appendLine: (data) ->
    html = @createLine(data)
    $("[data-chatroom='Lobby']").append(html)

  createLine: (data) ->
    """
    <article class="chat-line">
      <span class="speaker">#{data["username"]} :</span>
      <span class="body">#{data["message"]}</span>
    </article>
    """

$(document).on 'keypress', 'input.chat-input', (event) ->
  if event.keyCode is 13
    App.chatChannel.send
      message: event.target.value
      room: 'Lobby'
    event.target.value = ''