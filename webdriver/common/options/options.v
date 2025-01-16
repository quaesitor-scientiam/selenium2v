module options

import errors
import webdriver.common.proxy

// BaseOptionsDescriptor -
struct BaseOptionsDescriptor {
	name string
}

// BaseOptions - Gets and Sets the version of the browser.
struct BaseOptions {
	browser_version BaseOptionsDescriptor
}
