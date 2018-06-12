<!DOCTYPE html>
<html>
<head>
  <#include "common/head.ftl">
  <title>聊天室 - 皮卡丘</title>
      <style>
          #message{
              margin-top:40px;
              border:1px solid gray;
              padding:20px;
          }
      </style>
</head>
<body>
<#include "common/header.ftl">
<button onclick="conectWebSocket()">连接WebSocket</button>
<button onclick="closeWebSocket()">断开连接</button>
<hr />
<br />
消息：<input id="text" type="text" />
<button onclick="send()">发送消息</button>
<div id="message"></div>
<script type="text/javascript">
    var websocket = null;

    function conectWebSocket(){

        //判断当前浏览器是否支持WebSocket
        if ('WebSocket'in window) {
            websocket = new WebSocket("ws://localhost:18080/bbs");
        } else {
            alert('Not support websocket')
        }

        //连接发生错误的回调方法
        websocket.onerror = function() {
            setMessageInnerHTML("error");
        };

        //连接成功建立的回调方法
        websocket.onopen = function(event) {
            setMessageInnerHTML("Loc MSG: 成功建立连接");
        };

        //接收到消息的回调方法
        websocket.onmessage = function(event) {
            setMessageInnerHTML(event.data);
        };

        //连接关闭的回调方法
        websocket.onclose = function() {
            setMessageInnerHTML("Loc MSG:关闭连接");
        };

        //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
        window.onbeforeunload = function() {
            websocket.close();
        }
    }
    //将消息显示在网页上
    function setMessageInnerHTML(innerHTML) {
        document.getElementById('message').innerHTML += innerHTML + '<br/>';
    }

    //关闭连接
    function closeWebSocket() {
        websocket.close();
    }

    //发送消息
    function send() {
        var message = document.getElementById('text').value;
        websocket.send(message);
    }
</script>
<#include "common/footer.ftl">

</body>
</html>