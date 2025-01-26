module edge

import webdriver.chromium { ChromiumDriver }
import webdriver.common { Edge }

pub struct EdgeDriver[O, S] {
	ChromiumDriver[O, S]
}

pub fn EdgeDriver.init[O, S](options ?O, service ?S) ?EdgeDriver[O, S] {
	mut svc := service
	mut opts := options
	if opts == none {
		opts = EdgeOptions.init()
	}
	if svc == none {
		svc = EdgeService.init(none, 0, none, none, none, none)
	}
	if opts != none {
		if svc != none {
			bname := Edge{}.browser_name
			drv := ChromiumDriver.init(bname, 'ms', opts, svc, true)
			return EdgeDriver[O, S]{
				ChromiumDriver: drv
			}
		}
	}

	return none
}
