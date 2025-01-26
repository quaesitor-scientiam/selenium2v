module main

import webdriver.edge { EdgeDriver, EdgeOptions }

fn open_browser(download_path string) ?EdgeDriver[O, S] {
	mut options := EdgeOptions.init()
	options.add_experimental_option('excludeSwitches', ['enable-logging'])
	options.add_experimental_option('detach', true)
	options.add_experimental_option('prefs', {
		'download.default_directory': download_path
	})

	driver := EdgeDriver.init(options, none)

	return driver
}

fn main() {
	driver := open_browser('S:/Business Projects/PartsUnlimited/downloads')
	if driver == none {
		println('No Driver was created')
	} else {
		println('Successful driver creation')
	}
}
