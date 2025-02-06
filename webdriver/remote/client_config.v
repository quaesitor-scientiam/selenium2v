module remote

import webdriver.common { Proxy, ProxyType, parse_url }
import encoding.base64
import os
import net.urllib { URL }
import log
import errors

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

pub struct ClientConfig {
pub mut:
	remote_server_addr         ?string
	keep_alive                 bool
	proxy                      ?Proxy = Proxy{
		proxy_type: ProxyType.system
	}
	ignore_certificates        bool
	init_args_for_pool_manager ?map[string]Any
	timeout                    ?int // seconds
	ca_certs                   ?string
	username                   ?string
	password                   ?string
	auth_type                  AuthType = .basic
	token                      ?string
	user_agent                 ?string
	extra_headers              ?map[string]string
}

fn ClientConfig.init(remote_server_addr ?string, init_args_for_pool_manager ?map[string]Any) ClientConfig {
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

// get_proxy_url - Returns the proxy URL to use for the connection.
fn (c ClientConfig) get_proxy_url() ?string {
	mut proxy_type := ProxyType.unspecified
	if c.proxy != none {
		proxy_type = c.proxy.proxy_type
	}
	mut remote_add := URL{}
	if c.remote_server_addr != none {
		remote_add = parse_url(c.remote_server_addr)
	}

	if proxy_type == .direct {
		return none
	}
	if proxy_type == .system {
		no_proxy := os.getenv_opt('NO_PROXY') or { os.getenv('no_proxy') }.split(',').map(it.trim_space())
		if no_proxy.len > 0 {
			for value in no_proxy {
				if value == '*' {
					return none
				}
				n_url := parse_url(value)
				if n_url.host.len > 0 && remote_add.host == n_url.host {
					return none
				}
				if remote_add.host.contains(n_url.path) {
					return none
				}
			}
		}
		mut env_value := ''
		if c.remote_server_addr != none {
			if c.remote_server_addr.starts_with('https://') {
				env_value = os.getenv_opt('https_proxy') or { os.getenv('HTTPS_PROXY') }
			} else {
				env_value = os.getenv_opt('http_proxy') or { os.getenv('HTTP_PROXY') }
			}
			return env_value
		}
	}
	if proxy_type == .manual {
		if c.remote_server_addr != none {
			if c.proxy != none {
				if c.remote_server_addr.starts_with('https://') {
					return c.proxy.ssl_proxy
				} else {
					return c.proxy.http_proxy
				}
			}
		}
	}
	return none
}
