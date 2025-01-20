module common

import os

// DriverFinder - A Driver finding class responsible for obtaining the correct driver and
//    associated browser.
//
//    :param service: instance of the driver service class.
//    :param options: instance of the browser options class.
pub struct DriverFinder {
mut:
	service IService
	options IBaseOptions
	paths   map[string]string = {
		'driver_path':  ''
		'browser_path': ''
	}
}

pub fn DriverFinder.init[S, O](service S, options O) DriverFinder {
	df := DriverFinder{
		service: service
		options: options
		paths:   {
			'driver_path':  ''
			'browser_path': ''
		}
	}
	return df
}

pub fn (mut d DriverFinder) get_browser_path() string {
	bp := d.binary_paths() or {
		map[string]string{}
	}
	return bp['driver_path']
}

fn (mut d DriverFinder) binary_paths() !map[string]string {
	if d.paths['driver_path'] != '' {
		return d.paths
	}

	path := d.unwind_path()
	if path.len > 0 {
		if os.is_file(path) == false {
			return error('The path ${path} is not a valid file')
		}
		d.paths['driver_path'] = path
	} else {
		println('SeleniumManager is not implemented')
	}
	return d.paths
}

fn (d &DriverFinder) unwind_path() string {
	if d.service.path != none {
		return d.service.path
	}
	return ''
}
