module edge

import webdriver { SubprocessStdAlias }
import webdriver.chromium { ChromiumService }

// EdgeService - A Service class that is responsible for the starting and stopping of
//    `msedgedriver`.
pub struct EdgeService {
	ChromiumService
}

fn EdgeService.init(executable_path ?string, port int, service_args ?[]string, log_output ?SubprocessStdAlias,
	driver_path_env_key ?string, env ?map[string]string) EdgeService {
	mut args := []string{}
	if service_args != none {
		args = service_args.clone()
	}
	mut key := driver_path_env_key
	if driver_path_env_key == none {
		key = 'SE_EDGEDRIVER'
	}
	es := EdgeService{
		ChromiumService: ChromiumService.init(executable_path, port, args, log_output,
			key, env)
	}

	return es
}
