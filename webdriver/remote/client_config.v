module remote

import webdriver.common { Proxy, ProxyType }
import encoding.base64
import os

enum AuthType {
	basic
	bearer
	x_api_key
}

fn (a AuthType) str() string {
	match a {
		.basic { return 'Basic' }
		.bearer { return 'Bearer' }
		.x_api_key { return 'X-API-Key' }
	}
}

struct ClientConfig {
mut:
	remote_server_addr         ?string
	keep_alive                 bool
	proxy                      ?Proxy = Proxy{
		proxy_type: ProxyType.system
	}
	ignore_certificates        bool
	init_args_for_pool_manager ?map[string]string
	timeout                    ?int // seconds
	ca_certs                   ?string
	username                   ?string
	password                   ?string
	auth_type                  AuthType = .basic
	token                      ?string
	user_agent                 ?string
	extra_headers              ?map[string]string
}

fn ClientConfig.init(remote_server_addr ?string, init_args_for_pool_manager ?map[string]string) ClientConfig {
	mut default_timeout := ?int(none)
	value := os.getenv('GLOBAL_DEFAULT_TIMEOUT')
	if value.len != 0 {
		default_timeout = value.int()
	}
	return ClientConfig{
		remote_server_addr:         remote_server_addr
		keep_alive:                 true
		proxy:                      none
		ignore_certificates:        false
		init_args_for_pool_manager: init_args_for_pool_manager
		timeout:                    default_timeout
		ca_certs:                   none
		username:                   none
		password:                   none
		auth_type:                  .basic
		token:                      none
		user_agent:                 none
		extra_headers:              none
	}
}

// get_auth_header - Returns the authorization to add to the request headers.
fn (c ClientConfig) get_auth_header() ?map[string]string {
	if c.auth_type == .basic && c.username != none && c.password != none {
		credentials := '${c.username}:${c.password}'
		encoded_credentials := base64.encode_str(credentials)
		return {
			'Authorization': '${AuthType.basic} ${encoded_credentials} '
		}
	}
	if c.auth_type == .bearer && c.token != none {
		return {
			'Authorization': '${AuthType.basic}} {c.token}'
		}
	}
	if c.auth_type == .x_api_key && c.token != none {
		return {
			'${AuthType.x_api_key}': '${c.token}'
		}
	}
	return none
}
