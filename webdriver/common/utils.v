module common

import net { dial_tcp }
import term
import os
import webdriver

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
		return '${host}:${port}'
	} else {
		return '${host}:${port}'
	}
}

// is_connectable - Tries to connect to the server at port to see if it is running.
//
//    Args:
//     - port - The port to connect.
fn is_connectable(port int, hostaddress ?string) bool {
	mut host := ''
	if hostaddress == none {
		host = 'localhost'
	} else {
		host = webdriver.unwind[string](hostaddress)
	}

	mut client := dial_tcp(join_host_port(host, port)) or {
		rlog('net.dial_tcp error ${err}')
		return false
	}
	defer { client.close() or {} }
	return true
}

fn clog(message string) {
	eprintln(term.colorize(term.cyan, message))
}

fn rlog(message string) {
	eprintln(term.colorize(term.red, message))
}
