// keys - Set of specific key codes
module common

pub enum Key {
	null
	cancel
	help
	backspace
	back_space
	tab
	clear
	return_key
	enter
	shift
	left_shift
	control
	left_control
	alt
	left_alt
	pause
	escape
	space
	page_up
	page_down
	end
	home
	left
	arrow_left
	up
	arrow_up
	right
	arrow_right
	down
	arrow_down
	insert
	delete
	semicolon
	equals
	numpad0
	numpad1
	numpad2
	numpad3
	numpad4
	numpad5
	numpad6
	numpad7
	numpad8
	numpad9
	multiply
	add
	separator
	subtract
	decimal
	divide
	f1
	f2
	f3
	f4
	f5
	f6
	f7
	f8
	f9
	f10
	f11
	f12
	meta
	command
	zenkaku_hankaku
}

// keycode - returns a rune value for the 'k' in Key
pub fn (k Key) keycode() rune {
	return match k {
		.null { `\ue000` }
		.cancel { `\ue001` }
		.help { `\ue002` }
		.backspace { `\ue003` }
		.back_space { Key.backspace.keycode() }
		.tab { `\ue004` }
		.clear { `\ue005` }
		.return_key { `\ue006` }
		.enter { `\ue007` }
		.shift { `\ue008` }
		.left_shift { Key.shift.keycode() }
		.control { `\ue009` }
		.left_control { Key.control.keycode() }
		.alt { `\ue00a` }
		.left_alt { Key.alt.keycode() }
		.pause { `\ue00b` }
		.escape { `\ue00c` }
		.space { `\ue00d` }
		.page_up { `\ue00e` }
		.page_down { `\ue00f` }
		.end { `\ue010` }
		.home { `\ue011` }
		.left { `\ue012` }
		.arrow_left { Key.left.keycode() }
		.up { `\ue013` }
		.arrow_up { Key.up.keycode() }
		.right { `\ue014` }
		.arrow_right { Key.right.keycode() }
		.down { `\ue015` }
		.arrow_down { Key.down.keycode() }
		.insert { `\ue016` }
		.delete { `\ue017` }
		.semicolon { `\ue018` }
		.equals { `\ue019` }
		.numpad0 { `\ue01a` }
		.numpad1 { `\ue01b` }
		.numpad2 { `\ue01c` }
		.numpad3 { `\ue01d` }
		.numpad4 { `\ue01e` }
		.numpad5 { `\ue01f` }
		.numpad6 { `\ue020` }
		.numpad7 { `\ue021` }
		.numpad8 { `\ue022` }
		.numpad9 { `\ue023` }
		.multiply { `\ue024` }
		.add { `\ue025` }
		.separator { `\ue026` }
		.subtract { `\ue027` }
		.decimal { `\ue028` }
		.divide { `\ue029` }
		.f1 { `\ue031` }
		.f2 { `\ue032` }
		.f3 { `\ue033` }
		.f4 { `\ue034` }
		.f5 { `\ue035` }
		.f6 { `\ue036` }
		.f7 { `\ue037` }
		.f8 { `\ue038` }
		.f9 { `\ue039` }
		.f10 { `\ue03a` }
		.f11 { `\ue03b` }
		.f12 { `\ue03c` }
		.meta { `\ue03d` }
		.command { `\ue03d` }
		.zenkaku_hankaku { `\ue040` }
	}
}
