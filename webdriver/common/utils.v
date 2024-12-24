module common

import net
import net.websocket
import term
import os

@[heap; params]
struct Hosts {
mut:
	data []string
}

fn env_path(key ?string) ?string {
	if key != none {
		return os.getenv_opt(key)
	}
	return none
}

// free_port - Determines a free port using sockets.
fn free_port() int {
	mut listener := net.listen_tcp(.ip, '127.0.0.1:0') or {
		eprintln(err.msg())
		exit(1)
	}
	defer {
		listener.close() or { panic(err) }
	}
	addr := listener.addr() or {
		eprintln(err.msg())
		exit(1)
	}
	port := addr.port() or {
		eprintln(err.msg())
		exit(1)
	}
	return port
}

// join_host_port - Joins a hostname and port together.
//
// This is a minimal implementation intended to cope with IPv6 literals. For
//    example, join_host_port('::1', 80) == '[::1]:80'.
//
//  Args:
//
//      host - A hostname.
//      port - An integer port.
fn join_host_port(host string, port int) string {
	if host.contains(':') && !host.starts_with('[') {
		return '[${host}]:${port}'
	} else {
		return '${host}:${port}'
	}
}

// is_connectable - Tries to connect to the server at port to see if it is running.
//
//    Args:
//     - port - The port to connect.
fn is_connectable(port int, hosts Hosts) bool {
	mut h := hosts
	h.data = ['localhost']

	mut ws := websocket.new_client(join_host_port(h.data[0], port)) or {
		rlog('ws.new_client error ${err}')
		return false
	}
	defer { unsafe { ws.free() } }
	ws.connect() or {
		clog('ws.connect error: ${err}')
		return false
	}
	ws.close(0, '') or { rlog('ws.close error ${err}') }
	return true
}

fn clog(message string) {
	eprintln(term.colorize(term.cyan, message))
}

fn rlog(message string) {
	eprintln(term.colorize(term.red, message))
}
