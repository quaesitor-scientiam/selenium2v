module remote

struct SwitchTo[D] {
	driver D
}

fn SwitchTo.init[D](driver D) SwitchTo {
	return SwitchTo[D]{
		driver: driver
	}
}
