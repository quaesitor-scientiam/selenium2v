module chromium

import webdriver.remote { RemoteWebDriver }
import webdriver.common { ArgOptions, DriverFinder, IService }

// ChromiumDriver - Create a new WebDriver instance of the ChromiumDriver. Starts the
//        service and then creates new WebDriver instance of ChromiumDriver.
//
//    Args:
//         - browser_name - Browser name used when matching capabilities.
//         - vendor_prefix - Company prefix to apply to vendor-specific WebDriver extension commands.
//         - options - this takes an instance of ChromiumOptions
//         - service - Service object for handling the browser driver if you need to pass extra details
//         - keep_alive - Whether to configure ChromiumRemoteConnection to use HTTP keep-alive.
pub struct ChromiumDriver {
	RemoteWebDriver
	browser_name  ?string
	vendor_prefix ?string
	options       ArgOptions
	service       ?IService
	keep_alive    bool = true
}

pub fn ChromiumDriver.init[T, S](browser_name string, vendor_prefix string, options T, service S, keep_alive bool) ChromiumDriver {
	mut finder := DriverFinder.init(service, options)
	finder.get_browser_path()
	return ChromiumDriver{
		service: service
	}
}
