module common

import os { Process, open_append }
import webdriver { SubprocessStdAlias }
import errors { WebDriverException }
import time

pub interface IService {
mut:
	process             ?Process
	port                int
	path                ?string
	env                 map[string]string
	log_output          ?SubprocessStdAlias
	service_url         string
	service_args        ?[]string
	driver_path_env_key string
	start()
	command_line_args() []string
}

// Service - Base struct for all service objects.  Services typically
//    launch a child program in a new process as an interim process to
//    communicate with a browser.
//
// 	  - param executable: install path of the executable
//    - param port: Port for the service to run on, defaults to 0 where the operating system will decide
//    - param log_output: (Optional) int representation of STDOUT/DEVNULL, any IO instance or String path to file
//    - param env: (Optional) Mapping of environment variables for the new process, defaults to `os.environ`
pub struct Service implements IService {
pub mut:
	port                int
	process             ?Process
	path                ?string
	service_args        ?[]string
	log_output          ?SubprocessStdAlias
	env                 map[string]string
	driver_path_env_key string
	service_url         string
}

fn (mut s Service) command_line_args() []string {
	return ['--port=${s.port}']
}

pub fn Service.init(executable_path ?string, port int, env ?map[string]string, log_output ?SubprocessStdAlias,
	driver_path_env_key string) Service {
	mut svc := Service{
		log_output: log_output
	}
	if svc.log_output != none {
		if svc.log_output is string {
			dump(svc.log_output)
			svc.log_output = open_append(svc.log_output) or {
				panic('error while opening log file ${svc.log_output} for appending')
			}
		}
	}
	// mut f := $process.stdout

	svc.port = if port == 0 { free_port() } else { port }
	svc.service_url = 'http://${join_host_port('localhost', svc.port)}'
	svc.env = if env == none { os.environ() } else { env.clone() }
	svc.driver_path_env_key = driver_path_env_key
	if svc.env_path() == none {
		svc.path = executable_path
	} else {
		svc.path = svc.env_path()
	}

	return svc
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

pub fn (mut s Service) env_path() ?string {
	if s.env[s.driver_path_env_key].len > 0 {
		return s.env[s.driver_path_env_key]
	}
	return none
}
