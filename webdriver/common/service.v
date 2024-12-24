module common

import os { Process, open_append }
import webdriver { SubprocessStdAlias }
import errors { WebDriverException }
import time

// Service - Base struct for all service objects.  Services typically
//    launch a child program in a new process as an interim process to
//    communicate with a browser.
//
// 	  - param executable: install path of the executable
//    - param port: Port for the service to run on, defaults to 0 where the operating system will decide
//    - param log_output: (Optional) int representation of STDOUT/DEVNULL, any IO instance or String path to file
//    - param env: (Optional) Mapping of environment variables for the new process, defaults to `os.environ`
pub struct Service {
mut:
	process             ?Process
	path                ?string
	port                int
	service_args        ?[]string
	log_output          ?SubprocessStdAlias
	env                 ?map[string]string
	driver_path_env_key ?string
}

pub fn Service.init(executable_path ?string, port int, env ?map[string]string, log_output ?SubprocessStdAlias,
	driver_path_env_key ?string) Service {
	mut s := Service{
		log_output: log_output
	}
	if s.log_output != none {
		workaround := s.log_output
		if workaround is string {
			s.log_output = open_append(workaround) or {
				panic('error while opening log file ${workaround} for appending')
			}
		}
	}
	// mut f := $process.stdout

	mut freeport := port
	if port == 0 {
		freeport = free_port()
	}

	mut osenv := if env == none { os.environ() } else { env.clone() }

	mut exepath := env_path(driver_path_env_key)
	if exepath == none {
		exepath = executable_path
	}

	svc := Service{
		log_output:          log_output
		port:                freeport
		env:                 osenv
		driver_path_env_key: driver_path_env_key
		path:                exepath
	}

	return svc
}

// service_url - Gets the url of the Service.
fn (s &Service) service_url() string {
	return 'http://${join_host_port('localhost', s.port)}'
}

fn (s &Service) command_line_args() []string {
	return ['--port=${s.port}']
}

// start_process - Creates a subprocess by executing the command provided.
//
//     param path: full command to execute
fn (mut s Service) start_process(path string) {
	mut cmd := [path]
	cmd << s.command_line_args()
	s.process = os.new_process(cmd[0])
}

// start - Starts the Service.
//
//	Exceptions:
//     - WebDriverException: Raised either when it can't start the service
//           or when it can't connect to the service
fn (mut s Service) start() {
	if s.path != none {
		s.start_process(s.path)
	} else {
		eprintln(WebDriverException{ msg: 'Service path cannot be NONE' })
	}

	mut cnt := 0
	for true {
		if s.process != none {
			if s.process.is_alive() == false {
				if is_connectable(s.port) {
					break
				}
				time.sleep(510 * time.microsecond)
				cnt += 1
				if cnt == 70 {
					eprintln(WebDriverException{ msg: 'Cannot connect to the Service ${s.path}' })
					break
				}
			}
		} else {
			eprintln(WebDriverException{ msg: 'Service ${s.path} unexpectedly exited.' })
			break
		}
	}
}
