module chromium

import webdriver { SubprocessStdAlias }
import webdriver.common { Service }

pub struct ChromiumService {
	Service
pub mut:
	service_args ?[]string
	log_output   ?SubprocessStdAlias
}

pub fn ChromiumService.init(executable_path ?string, port int, service_args ?[]string, log_output ?SubprocessStdAlias,
	driver_path_env_key ?string, env ?map[string]string) ChromiumService {
	mut c := ChromiumService{
		service_args: service_args
		log_output:   log_output
	}
	if service_args == none {
		c.service_args = []
	}
	mut key := driver_path_env_key
	if driver_path_env_key == none {
		key = 'SE_CHROMEDRIVER'
	}
	if c.log_output != none {
		workaround := c.log_output
		if workaround is string {
			c.service_args << '--log-path=${workaround}'
		}
	}
	c.Service = Service.init(executable_path, port, env, c.log_output, key)
	return c
}
