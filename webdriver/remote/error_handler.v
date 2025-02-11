module remote

// ErrorHandler - Handles errors returned by the WebDriver server.
struct ErrorHandler {}

// check_response - Checks that a JSON response from the WebDriver does not have an error.
//
//        :Args:
//         - response - The JSON response from the WebDriver server as a dictionary
//           object.
fn (e &ErrorHandler) check_response(response map[string]string) {
}
