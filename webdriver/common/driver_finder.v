module common

import os

// DriverFinder - A Driver finding class responsible for obtaining the correct driver and
//    associated browser.
//
//    :param service: instance of the driver service class.
//    :param options: instance of the browser options class.
struct DriverFinder {
mut:
	service Service
	options BaseOptions
	paths   map[string]string = {
		'driver_path':  ''
		'browser_path': ''
	}
}

fn (mut d DriverFinder) binary_paths() !map[string]string {
	if d.paths['driver_path'] != '' {
		return d.paths
	}

	// browser := d.options.capabilities{}['browserName']
	path := d.service.path
	if path != none {
		if os.is_file(path) == false {
			return error('The path ${path} is not a valid file')
		}
		d.paths['driver_path'] = path
	} else {
		// TODO: implement SeleniumManager handling
	}

	return d.paths
}
