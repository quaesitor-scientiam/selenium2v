module chromium

import webdriver.remote { ClientConfig, RemoteConnection }

struct ChromiumRemoteConnection {
	RemoteConnection
mut:
	browser_name ?string
}

fn ChromiumRemoteConnection.init(remote_server_addr ?string, browser_name ?string, vendor_prefix ?string, keep_alive bool, ignore_proxy bool,
	client_config ?ClientConfig) ChromiumRemoteConnection {
	mut cc := ClientConfig{}
	if client_config == none {
		cc = ClientConfig{
			remote_server_addr: remote_server_addr
			keep_alive:         keep_alive
			timeout:            120
		}
	} else {
		cc = client_config
	}

	return ChromiumRemoteConnection{
		RemoteConnection: RemoteConnection.init(ignore_proxy, cc)
	}
}

fn remote_commands(vendor_prefix string) map[string][]string {
	return {
		'launchApp':               ['POST', r'/session/$sessionId/chromium/launch_app']
		'setPermissions':          ['POST', r'/session/$sessionId/permissions']
		'setNetworkConditions':    ['POST', r'/session/$sessionId/chromium/network_conditions']
		'getNetworkConditions':    ['GET', r'/session/$sessionId/chromium/network_conditions']
		'deleteNetworkConditions': ['DELETE', r'/session/$sessionId/chromium/network_conditions']
		'executeCdpCommand':       ['POST', r'/session/$sessionId/' + '${vendor_prefix}/cdp/execute']
		'getSinks':                ['GET', r'/session/$sessionId/' +
			'${vendor_prefix}/cast/get_sinks']
		'getIssueMessage':         ['GET',
			r'/session/$sessionId/' + '${vendor_prefix}cast/get_issue_message']
		'setSinkToUse':            ['POST',
			r'/session/$sessionId/' + '${vendor_prefix}cast/set_sink_to_use']
		'startDesktopMirroring':   ['POST',
			r'/session/$sessionId/' + '${vendor_prefix}cast/start_desktop_mirroring']
		'startTabMirroring':       ['POST',
			r'/session/$sessionId/' + '${vendor_prefix}cast/start_tab_mirroring']
		'stopCasting':             ['POST',
			r'/session/$sessionId/' + '${vendor_prefix}cast/stop_casting']
	}
}
