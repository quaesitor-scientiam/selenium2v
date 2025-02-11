module chromium

import webdriver.common { ArgOptions, Capability_types, DesiredCapabilities, has_val }
import maps

type OptionTypes = string | int | bool | map[string]string | []string

pub struct ChromiumOptions {
	ArgOptions
pub mut:
	key                  string
	binary_location      string
	extension_files      []string
	extensions           Capability_types
	experimental_options map[string]Capability_types
	debugger_address     ?Capability_types
}

pub fn ChromiumOptions.init(key string, dc DesiredCapabilities) ChromiumOptions {
	mut value := key
	if key == '' {
		value = 'goog:chromeOptions'
	}

	return ChromiumOptions{
		ArgOptions: ArgOptions.init(dc)
		key:        value
	}
}

pub fn (mut c ChromiumOptions) add_experimental_option(name string, value Capability_types) {
	c.experimental_options[name] = value
}

pub fn (c ChromiumOptions) to_capabilities() map[string]Capability_types {
	mut caps := c.capabilities.clone()
	mut chrome_options := c.experimental_options.clone()
	if c.mobile_options != none {
		if c.mobile_options.len > 0 {
			maps.merge_in_place(mut chrome_options, c.mobile_options)
		}
	}
	chrome_options['extensions'] = c.extensions
	if has_val(c.binary_location) {
		chrome_options['binary'] = c.binary_location
	}
	chrome_options['args'] = c.arguments
	if c.debugger_address != none {
		if has_val(c.debugger_address) {
			chrome_options['debuggerAddress'] = c.debugger_address
		}
	}
	caps[c.key] = chrome_options
	return caps
}
