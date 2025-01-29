module common

import os
import v.pref { get_host_os }
import log
import errors { WebDriverException }
import webdriver
import x.json2

enum PlatformArch {
	darwin
	win32
	win64
	cygwin
	linux
	freebsd
	openbsd
}

fn (a PlatformArch) str() string {
	match a {
		.darwin { return 'any' }
		.win32 { return 'any' }
		.win64 { return 'any' }
		.cygwin { return 'any' }
		.linux { return 'x86_64' }
		.freebsd { return 'x86_64' }
		.openbsd { return 'x86_64' }
	}
}

type Arch = PlatformArch

fn get_se_manager_path_env() ?string {
	res := $env('SE_MANAGER_PATH')
	if res.len == 0 {
		return none
	}
	return res
}

fn location_path(u string) ?string {
	allowed := {
		'darwin':  'macos/selenium-manager'
		'win32':   'windows/selenium-manager.exe'
		'cygwin':  'windows/selenium-manager.exe'
		'windows': 'windows/selenium-manager.exe'
		'linux':   'linux/selenium-manager'
		'freebsd': 'linux/selenium-manager'
		'openbsd': 'linux/selenium-manager'
	}
	p := allowed[u]
	if p.len == 0 {
		return none
	}
	return p
}

struct LogRecord {
mut:
	level     string
	timestamp int
	message   string
}

struct Result {
mut:
	code         int
	message      string
	driver_path  string
	browser_path string
}

fn (r Result) to_map() map[string]string {
	return {
		'code':         r.code.str()
		'message':      r.message
		'driver_path':  r.driver_path
		'browser_path': r.browser_path
	}
}

struct SMOutput {
mut:
	logs   []LogRecord
	result Result
}

// SeleniumManager - Wrapper for getting information from the Selenium Manager binaries.
//
//    This implementation is still in beta, and may change.
struct SeleniumManager {
mut:
	user_os string
	machine string
}

// binary_paths - Determines the locations of the requested assets.
//
//        :Args:
//         - args: the commands to send to the selenium manager binary.
//        :Returns: map of assets and their path
fn (mut s SeleniumManager) binary_paths(args []string) map[string]string {
	mut args1 := [s.get_binary()]
	args1 << args
	if log.get_level() == log.Level.debug {
		args1 << '--debug'
	}
	args1 << '--language-binding'
	args1 << 'vlang'
	args1 << '--output'
	args1 << 'json'

	return s.run(args1)
}

// get_binary - Determines the path of the correct Selenium Manager binary.
//
//        :Returns: The Selenium Manager executable location
//
//        :Raises: WebDriverException if the platform is unsupported
fn (mut s SeleniumManager) get_binary() string {
	parent, name, _ := os.split_path(@FILE)
	mut compiled_path := os.join_path(parent, name)
	exe := if get_host_os() == pref.OS.windows { ?string('.exe') } else { none }
	if exe != none {
		compiled_path += exe
	}
	mut path := ?string(none)
	env_path := get_se_manager_path_env()

	if env_path != none {
		log.info('Selenium Manager set by env SE_MANAGER_PATH to: ${env_path}')
	} else if os.exists(compiled_path) {
		path = compiled_path
	} else {
		un := os.uname()
		s.machine = un.machine
		s.user_os = os.user_os()
		arch := if s.user_os in ['linux', 'freebsd', 'openbsd'] { s.machine } else { 'any' }
		if s.user_os in ['freebsd', 'openbsd'] {
			log.warn('Selenium Manager binary may not be compatible with ${s.user_os}; verify settings')
		}
		location := location_path(s.user_os)
		if location == none {
			log.error(WebDriverException{1, 'Unsupported platform/architecture combination: ${s.user_os}/${s.machine}', ''}.str())
			exit(1)
		}
		path = os.join_path(parent, webdriver.unwind(location))
	}

	if path != none {
		if os.exists(path) {
			log.debug('Selenium Manager binary found at: ${path}')
			return path
		}
	}

	log.error(WebDriverException{1, 'Unable to obtain working Selenium Manager binary; ${path}', ''}.str())
	exit(1)
}

// run - Executes the Selenium Manager Binary.
//
//        :Args:
//         - args: the components of the command being executed.
//        :Returns: The log string containing the driver location.
fn (s &SeleniumManager) run(args []string) map[string]string {
	mut result := map[string]string{}
	command := args[0]
	log.debug('Executing process ${args.join(' ')}')
	mut p := os.new_process(command)
	p.args = args[1..]
	p.set_redirect_stdio()
	if s.machine != 'AMD64' {
		p.create_no_window = true
	}
	p.wait()
	if p.status == .exited && p.code == 0 {
		output := p.stdout_slurp().trim_space()
		smoutput := json2.decode[SMOutput](output) or {
			log.error('Error decoding output from process ${err}')
			exit(1)
		}
		for rec in smoutput.logs {
			if rec.level == 'WARN' {
				log.warn(rec.message)
			}
		}
		p.close()
		result = smoutput.result.to_map()
	}

	return result
}
