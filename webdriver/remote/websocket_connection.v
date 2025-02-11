module remote

import webdriver { Dict }
import x.json2 { Any, decode }
import log
import net.websocket { Client, ClientOpt, new_client }

type FN_on_open = fn (mut ws WebSocketConnection)

type FN_on_message = fn (mut ws WebSocketConnection, message string)

type FN_on_error = fn (mut ws WebSocketConnection, error string)

type FN_run_socket = fn (mut ws WebSocketConnection)

fn on_open(mut ws WebSocketConnection) {
	ws.started = true
}

fn on_message(mut ws WebSocketConnection, message string) {
	ws.process_message(message)
}

fn on_error(mut ws WebSocketConnection, error string) {
	log.debug('Error: ${error}')
}

fn run_socket(mut ws WebSocketConnection) {
	if ws.url.starts_with('wss://') {
		ws.run_forever(
			ssl_opt:         {
				'cert_reqs': CERT_NONE
			}
			suppress_origin: true
		)
	} else {
		ws.run_forever(suppress_origin: true)
	}
}

pub struct WebSocketConnection {
mut:
	response_wait_timeout  int = 30
	response_wait_interval f32 = 0.1
	max_log_message_size   int = 9999
	callbacks              Dict
	session_id             ?string
	url                    string
	id                     int
	messages               Dict
	started                bool
	app                    WebSocketApp
}

fn WebSocketConnection.init(url string) WebSocketConnection {
	wc := WebSocketConnection{
		url: url
	}
	wc.start_ws()
	return wc
}

fn (mut ws WebSocketConnection) start_ws() {
	ws.app = WebSocketApp.init(ws.url, on_open: on_open, on_message: on_message, on_error: on_error)
}

fn (mut ws WebSocketConnection) process_message(message string) {
	msg := decode[Any](message)!
	log.debug('<- ${msg}[:w.max_log_message_size]')

	if 'id' in msg {
		ws.messages[msg['id']] = msg
	}

	if 'method' in msg {
		params := msg['params']
		for callback in ws.callbacks[msg['method']] {
		}
	}
}

struct WebSocketApp {
	client Client
}

fn WebSocketApp.init(url string, on_open FN_on_open, on_message FN_on_message, on_error FN_on_error) WebSocketApp {
	mut nc := new_client(url, ClientOpt{}) or {
		log.error(err)
		exit(1)
	}
	nc.on_open(on_open)
	nc.on_message(on_message)
	nc.on_error(on_error)
	return WebSocketApp{
		client: nc
	}
}
