module main

import common as errors

fn main() {
	println('Hello, World!')
	e := errors.InvalidSwitchToTargetException{
		msg: 'Something is wrong'
	}
	println(e)
}
