module main

import errors
import webdriver.common.keys

fn main() {
	println('Hello, World!')
	e := errors.InvalidSwitchToTargetException{
		msg: 'Something is wrong'
	}
	// print(keys.delete)
	println(e)
}
