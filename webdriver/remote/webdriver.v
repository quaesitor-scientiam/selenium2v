module remote

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
	web_element WebElement
	shadowroot  ShadowRoot
}
