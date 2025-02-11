module remote

import webdriver {Dict}
import x.json2 {decode, Any}
import json
import log


fn on_open(mut ws WebSocketConnection) {
	ws.started = true
}

fn on_message(mut WebSocketConnection, message string) {
	ws.process_message(message)
}

struct WebSocketConnection {
	mut:
		response_wait_timeout    int = 30
		response_wait_interval   f32 = 0.1
		max_log_message_size     int = 9999
		callbacks                Dict
		session_id               ?string
		url                      string
		id                       int
		messages                 Dict
		started                  bool
}
fn WebSocketConnection.init(url string) WebSocketConnection {
	wc := WebSocketConnection{url: url}
	wc.start_ws()
	return wc
}


fn (w &WebSocketConnection) start_ws()  {

}

fn (mut w &WebSocketConnection) process_message(message string)  {
	msg := decode[Any](message)!
	log.debug('<- ${msg}[:w.max_log_message_size]')

	if 'id' in msg {
		w.messages[msg['id']] = msg
	}

	if 'method' in msg {
		params := msg['params']
		for callback in w.callbacks[msg['method']] {

		}
	}
}