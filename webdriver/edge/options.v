module edge

import webdriver.chromium { ChromiumOptions }
import webdriver.common { DesiredCapabilities, Edge }

pub struct EdgeOptions {
	ChromiumOptions
	default_capabilities DesiredCapabilities
	use_webview          bool
}

pub fn EdgeOptions.init() EdgeOptions {
	opts := ChromiumOptions.init('ms.edgeOptions', Edge{})
	return EdgeOptions{
		ChromiumOptions:      opts
		use_webview:          false
		default_capabilities: Edge{}
	}
}
