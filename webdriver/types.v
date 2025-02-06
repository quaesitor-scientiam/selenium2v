module webdriver

import os { File }

pub type SubprocessStdAlias = string | int | f32 | File

pub fn unwind[T](value ?T) T {
	if value != none {
		return value
	}
	return T{}
}
