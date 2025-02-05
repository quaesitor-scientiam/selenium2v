module remote

import os
import net.urllib { URL }
import log
import encoding.base64
import maps { merge, merge_in_place }
import sync.pool

type Any = ?int | ?string

// RemoteConnection - A connection with the Remote WebDriver server.
//
//    Communicates with the server using the WebDriver wire protocol:
//    https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol
pub struct RemoteConnection {
	commands map[string][]string = remote_commands
mut:
	browser_name   ?string
	client_config  ?ClientConfig
	system         string
	extra_commands ?map[string][]string
	proxy_url      ?string
	conn           ConnectionManager
}

pub fn RemoteConnection.init(ignore_proxy bool, client_config ?ClientConfig) RemoteConnection {
	mut rc := RemoteConnection{
		client_config: client_config
		system:        os.user_os()
	}
	rc.proxy_url = none
	if ignore_proxy == false {
		if client_config != none {
			rc.proxy_url = client_config.get_proxy_url()
		}
	}

	rc.conn = rc.get_connection_manager()

	return rc
}

// execute - Send a command to the remote server.
//
//        Any path substitutions required for the URL mapped to the command should be
//        included in the command parameters.
//
//        :Args:
//         - command - A string specifying the command to execute.
//         - params - A dictionary of named parameters to send with the command as
//           its JSON payload.
pub fn (r &RemoteConnection) execute(command string, params map[string]string) {
	mut command_info := []string{}
	if command !in r.commands {
		if r.extra_commands != none {
			if command !in r.extra_commands {
				assert false, 'Unrecognised command ${command}'
			} else {
				command_info = r.extra_commands[command]
			}
		}
	} else {
		command_info = r.commands[command]
	}

	path_string := command_info[1]
}

// get_remote_connection_headers - Get headers for remote request.
//
//        :Args:
//         - parsed_url - The parsed url
//         - keep_alive (Boolean) - Is this a keep-alive connection (default: False)
fn (r &RemoteConnection) get_remote_connection_headers(parsed_url URL, keep_alive bool) map[string]string {
	mut user_agent := ''
	if r.client_config != none {
		if r.client_config.user_agent != none {
			user_agent = r.client_config.user_agent
		}
	}

	mut headers := {
		'Accept':       'application/json'
		'Content-Type': 'application/json;charset=UTF-8'
		'User-Agent':   user_agent
	}

	if parsed_url.user.username.len > 0 {
		log.warn('Embedding username and password in URL could be insecure, use ClientConfig instead')
		base64string := base64.encode_str('${parsed_url.user.username}:${parsed_url.user.password}')
		headers['Authorization'] = 'Basic ${base64string}'
	}

	if keep_alive {
		headers['Connection'] = 'keep-alive'
	}

	if r.client_config != none {
		if r.client_config.extra_headers != none {
			headers = merge[string, string](headers, r.client_config.extra_headers)
		}
	}

	return headers
}

fn (r &RemoteConnection) get_connection_manager() ConnectionManager {
	mut pool_manager_args := map[string]?Any{}
	if r.client_config != none {
		pool_manager_args['timeout'] = r.client_config.timeout
		if r.client_config.init_args_for_pool_manager != none {
			merge_in_place(mut &pool_manager_args, r.client_config.init_args_for_pool_manager)
		}
		if r.client_config.ignore_certificates {
			pool_manager_args['cert_reqs'] = wrap_opt_any('CERT_NONE')
		} else if r.client_config.ca_certs != none {
			pool_manager_args['cert_reqs'] = wrap_opt_any('CERT_REQUIRED')
			pool_manager_args['ca_certs'] = wrap_opt_any(r.client_config.ca_certs)
		}
	}
	if r.proxy_url != none {
		if r.proxy_url.to_lower().starts_with('sock') {
			return ConnectionManager{r.proxy_url, pool_manager_args}
		}
	}
	return ConnectionManager{
		args: pool_manager_args
	}
}

fn wrap_opt_any(s ?string) ?Any {
	return ?Any(?string(s))
}
