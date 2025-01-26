module common

import os
import webdriver { unwind }
import errors { WebDriverException }

// DriverFinder - A Driver finding class responsible for obtaining the correct driver and
//    associated browser.
//
//    :param service: instance of the driver service class.
//    :param options: instance of the browser options class.
pub struct DriverFinder[S, O] {
mut:
	service S
	options O
	paths   map[string]string = {
		'driver_path':  ''
		'browser_path': ''
	}
}

pub fn DriverFinder.init[S, O](service S, options O) DriverFinder[S, O] {
	df := DriverFinder[S, O]{
		service: service
		options: options
		paths:   {
			'driver_path':  ''
			'browser_path': ''
		}
	}
	return df
}

pub fn (mut d DriverFinder[S, O]) get_browser_path() string {
	bp := d.binary_paths() or {
		map[string]string{}
	}
	return bp['browser_path']
}

pub fn (mut d DriverFinder[S, O]) get_driver_path() string {
	bp := d.binary_paths() or {
		map[string]string{}
	}
	return bp['driver_path']
}

fn (mut d DriverFinder[S, O]) binary_paths() !map[string]string {
	if d.paths['driver_path'] != '' {
		return d.paths
	}

	path := unwind(d.service.path)
	if path.len > 0 {
		if os.is_file(path) == false {
			return error('The path ${path} is not a valid file')
		}
		d.paths['driver_path'] = path
	} else {
		mut exception_occurred := false
		mut sm := SeleniumManager{}
		output := sm.binary_paths(d.to_args())
		if os.is_file(output['driver_path']) {
			d.paths['driver_path'] = output['driver_path']
		} else {
			println(WebDriverException{1, 'The driver path is not a valid file: ${output['driver_path']}', ''}.str())
			exception_occurred = true
		}
		if os.is_file(output['browser_path']) {
			d.paths['browser_path'] = output['browser_path']
		} else {
			println(WebDriverException{1, 'The driver path is not a valid file: ${output['browser_path']}', ''}.str())
			exception_occurred = true
		}
		if exception_occurred {
			exit(1)
		}
	}
	return d.paths
}

fn (d &DriverFinder[S, O]) to_args() []string {
	mut args := ['--browser']
	if name := d.options.capabilities['browser_name'] {
		if name is string {
			args << name
		}
	}
	if d.options.browser_version != none {
		args << '--browser-version'
		args << d.options.browser_version
	}
	if d.options.binary_location.len > 0 {
		args << '--browser-path'
		args << d.options.binary_location
	}
	if d.options.proxy != none {
		proxy := d.options.proxy
		http_proxy := unwind(proxy.http_proxy)
		ssl_proxy := unwind(proxy.ssl_proxy)
		mut p := if http_proxy.len > 0 { http_proxy } else { '' }
		p = if p.len == 0 { ssl_proxy } else { p }
		if p.len > 0 {
			args << '--proxy'
			args << p
		}
	}

	return args
}
