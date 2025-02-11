module remote

import arrays
import webdriver {Dict, CapabilityTypeDict}
import webdriver.common {has_val}
import webdriver.common.bidi {Script}

//create_caps - Makes a W3C alwaysMatch capabilities object.
//
//    Filters out capability names that are not in the W3C spec. Spec-compliant
//    drivers will reject requests containing unknown capability names.
//
//    Moves the Firefox profile, if present, from the old location to the new Firefox
//    options object.
//
//    :args:
//    ----------
//    caps : dict
//        - A dictionary of capabilities requested by the caller.
fn create_caps(capabilities CapabilityTypeDict) CapabilityTypeDict {
	caps := capabilities.clone()
	always_match := Dict{}
	return {'capabilities': {'firstMatch': [Dict{}], 'alwaysMatch': caps}}
}

fn create_matches[O](options []O) {
	capabilities := {'capabilities': map[string]striing{}}
	opts := []string{}
	for opt in options {
		arrays.append(opts, [opt.to_capabilities()])
	}
	for i in 0..opts.len {
		mut min_index := i
		if i + 1 < opts.len {
			first_keys := opts[min_index]
		}
	}
}


type Auth_ID_type = int | string

// RemoteWebDriver - Controls a browser by sending commands to a remote server. This server
//    is expected to be running the WebDriver wire protocol as defined at
//    https://www.selenium.dev/documentation/legacy/json_wire_protocol/.
//
//    :Attributes:
//     - session_id - String ID of the browser session started and controlled by this WebDriver.
//     - capabilities - Dictionary of effective capabilities of this browser session as returned
//         by the remote server. See https://www.selenium.dev/documentation/legacy/desired_capabilities/
//     - command_executor - remote_connection.RemoteConnection object used to execute commands.
//     - error_handler - errorhandler.ErrorHandler object used to handle errors.
pub struct RemoteWebDriver {
	web_element           WebElement
	shadowroot            ShadowRoot
	// command_executor      E
	is_remote             bool
	session_id            ?string
	caps 		          CapabilityTypeDict
	pinned_scripts        Dict
	error_handler         ErrorHandler
	switch_to             SwitchTo[D]
	mobile                Mobile
	file_detector         IFileDetector
	locator_converter     LocatorConverter
	web_element_cls       WebElement
	authenticator_id      map[string]?Auth_ID_type
	// start_client
	fedcm                 FedCM
	websocket_connection  ?WebSocketConnection
	script                ?Script
}
pub fn RemoteWebDriver.init[E, O](command_executor E, options O ) RemoteWebDriver {
	mut ignore_local_proxy := false
	mut capabilities := CapabilityTypeDict
	if options is array {
		capabilities = create_matches(options)
		ignore_local_proxy = false
	} else {
		capabilities = options.to_capabilities()
		ignore_local_proxy = options.ignore_local_proxy
	}
	web_driver := RemoteWebDriver{command_executor: command_executor}
	web_driver.start_session(capabilities)
	web_driver.fedcm(web_driver)

	return web_driver
}

// start_client - Called before starting a new session.
//        This method may be overridden to define custom startup behavior.
fn (r &RemoteWebDriver) start_client() {}

// start_session - Creates a new session with the desired capabilities.
//
//        :args:
//        ----------
//        capabilities : dict
//            - A capabilities dict to start the session with.
fn (r &RemoteWebDriver) start_session(capabilities map[string]map[string]map[string]string)  {
	caps := create_caps(capabilities)
	response := r.execute(Command.new_session, caps)['value']
}

// execute - Sends a command to be executed by a command.CommandExecutor.
//
//        Parameters:
//        ----------
//        driver_command : str
//            - The name of the command to execute as a string.
//
//        params : dict
//            - A dictionary of named Parameters to send with the command.
//
//        Returns:
//        --------
//          dict - The command's JSON response loaded into a dictionary object.
fn (r &RemoteWebDriver) execute(driver_command Command, params CapabilityTypeDict) Dict {
	mut params := r.wrap_value(params)
	if has_val(r.session_id) {
		if !has_val(params) {
			params = {'session_id': r.session_id}
		}else if !'session_id' in params {
			params['session_id'] = r.session_id
		}
	}

	response := r.command_executor.execute(driver_command, params)
}

fn (r &RemoteWebDriver) wrap_value(value CapabilityTypeDict ) CapabilityTypeDict {
	if value is Dict {
		mut converted := Dict{}
		for k, v in value {
			converted[key] = r.wrap_value(v)
		}
		return converted
	}
	if value is array {
		return  [r.wrap_value(item ) for item in value]
	}
}

