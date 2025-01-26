module chromium

import webdriver.common { ArgOptions, DesiredCapabilities }

type OptionTypes = string | int | bool | map[string]string | []string

pub struct ChromiumOptions {
	ArgOptions
pub mut:
	key                  string
	binary_location      string
	extension_files      []string
	extensions           []string
	experimental_options map[string]OptionTypes
	debugger_address     ?[]string
}

pub fn ChromiumOptions.init(key string, dc DesiredCapabilities) ChromiumOptions {
	mut value := key
	if key == '' {
		value = 'goog:chromeOptions'
	}

	return ChromiumOptions{
		ArgOptions:           ArgOptions.init(dc)
		key:                  value
		binary_location:      ''
		extensions:           []
		extension_files:      []
		experimental_options: {}
		debugger_address:     none
	}
}

pub fn (mut c ChromiumOptions) add_experimental_option(name string, value OptionTypes) {
	c.experimental_options[name] = value
}
