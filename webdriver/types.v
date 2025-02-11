module webdriver

import os { File }

pub type SubprocessStdAlias = string | int | f32 | File
pub type Dict = map[string]string

pub type CapabilityTypeDict = map[string]Capability_types

// PageLoadStrategy - "Enum of possible page load strategies.
//
//    Selenium support following strategies:
//        * normal (default) - waits for all resources to download
//        * eager - DOM access is ready, but other resources like images may still be loading
//        * none - does not block `WebDriver` at all
//
//    Docs: https://www.selenium.dev/documentation/webdriver/drivers/options/#pageloadstrategy.
pub enum PageLoadStrategy {
	normal
	eager
	none
}

pub type Capability_types = bool
	| string
	| []string
	| Dict
	| PageLoadStrategy
	| CapabilityTypeDict

pub fn unwind[T](value ?T) T {
	if value != none {
		return value
	}
	return T{}
}
