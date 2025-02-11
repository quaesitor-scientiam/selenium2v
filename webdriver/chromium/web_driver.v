module chromium

import webdriver.remote { RemoteWebDriver }
import webdriver.common { DriverFinder }

// ChromiumDriver - Controls the WebDriver instance of ChromiumDriver and allows you to
//    drive the browser.
pub struct ChromiumDriver[O, S] {
	RemoteWebDriver
mut:
	browser_name  ?string
	vendor_prefix string
	options       O
	service       S
	keep_alive    bool = true
}

pub fn ChromiumDriver.init[O, S](browser_name ?string, vendor_prefix string, options O, service S, keep_alive ?bool) ChromiumDriver[O, S] {
	mut kalive := true
	if keep_alive != none {
		kalive = keep_alive
	}

	mut finder := DriverFinder.init(service, options)
	mut drv := ChromiumDriver[O, S]{
		service: service
		options: options
	}
	drv.options.binary_location = finder.get_browser_path()
	drv.options.browser_version = none
	if drv.service.env_path() == none {
		drv.service.path = finder.get_driver_path()
	} else {
		drv.service.path = drv.service.env_path()
	}
	drv.service.start()

	executor := ChromiumRemoteConnection.init(drv.service.service_url, browser_name, vendor_prefix,
		kalive, drv.options.ignore_local_proxy, none)
	RemoteWebDriver.init(command_executor: executor, options: options)

	return drv
}
