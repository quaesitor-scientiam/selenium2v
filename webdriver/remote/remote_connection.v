module remote

import os
import webdriver

const remote_commands = {
	'Command.NEW_SESSION': ['POST', '/session']
}

// RemoteConnection - A connection with the Remote WebDriver server.
//
//    Communicates with the server using the WebDriver wire protocol:
//    https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol
pub struct RemoteConnection {
	browser_name ?string
	// Keep backward compatibility for AppiumConnection - https://github.com/SeleniumHQ/selenium/issues/14694
	timeout       ?int
	ca_certs      ?string
	client_config ?ClientConfig
}

pub fn RemoteConnection.init(remote_server_addr ?string, keep_alive ?bool, ignore_proxy ?bool, ignore_certificates ?bool,
	init_args_for_pool_manager ?map[string]string, mut client_config ?&ClientConfig) RemoteConnection {
	if client_config == none {
		client_config = ClientConfig.init(remote_server_addr, init_args_for_pool_manager)
		if keep_alive != none {
			client_config.keep_alive = keep_alive
		}
		if ignore_certificates != none {
			client_config.ignore_certificates = ignore_certificates
		}
	}

	// Keep backward compatibility for AppiumConnection - https://github.com/SeleniumHQ/selenium/issues/14694
	// return RemoteConnection{
	// 	timeout: client_config.timeout
	// 	ca_certs: client_config.ca_certs
	// 	client_config: client_config
	// }
}
