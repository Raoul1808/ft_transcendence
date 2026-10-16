const ws = new WebSocket("ws://127.0.0.1:8080/ws");

ws.onmessage = function(e) {
    console.log(e.data);
}

ws.onclose = function() {
    console.log("disconnected");
}

const enc = new TextEncoder();

document.querySelector('#connecter').addEventListener('submit', function(e) {
    e.preventDefault();
    let username = document.querySelector('#username').value;
    let channel = document.querySelector('#channel').value;
    let conn = { username: username, channel: channel };
    ws.send(JSON.stringify(conn));
    ws.binaryType = "arraybuffer"
});

document.querySelector('#messager').addEventListener('submit', function(e) {
    e.preventDefault();
    let message = document.querySelector('#message').value;
    ws.send(enc.encode(message));
    document.querySelector('#message').value = "";
});
