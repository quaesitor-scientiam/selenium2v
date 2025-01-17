module edge

import webdriver.chromium { ChromiumDriver }
import webdriver.common { Edge }

pub struct EdgeDriver {
	ChromiumDriver
}

pub fn EdgeDriver.init(options ?EdgeOptions, service ?EdgeService) ?EdgeDriver {
	mut svc := service
	mut opts := options
	if svc == none {
		svc = EdgeService.init(none, 0, none, none, none, none)
	}
	if opts == none {
		opts = EdgeOptions.init()
	}
	if opts != none {
		if svc != none {
			bname := Edge{}.browser_name
			drv := ChromiumDriver.init(bname, 'ms', opts, svc, true)
			return EdgeDriver{
				ChromiumDriver: drv
			}
		}
	}

	return none
}
