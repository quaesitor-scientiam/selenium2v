module chromium

import webdriver.remote { RemoteWebDriver }
import webdriver.common { DriverFinder }

// ChromiumDriver - Create a new WebDriver instance of the ChromiumDriver. Starts the
//        service and then creates new WebDriver instance of ChromiumDriver.
//
//    Args:
//         - browser_name - Browser name used when matching capabilities.
//         - vendor_prefix - Company prefix to apply to vendor-specific WebDriver extension commands.
//         - options - this takes an instance of ChromiumOptions
//         - service - Service object for handling the browser driver if you need to pass extra details
//         - keep_alive - Whether to configure ChromiumRemoteConnection to use HTTP keep-alive.
pub struct ChromiumDriver[O, S] {
	RemoteWebDriver
mut:
	browser_name  ?string
	vendor_prefix ?string
	options       O
	service       S
	keep_alive    bool = true
}

pub fn ChromiumDriver.init[O, S](browser_name string, vendor_prefix string, options O, service S, keep_alive bool) ChromiumDriver[O, S] {
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

	return drv
}
