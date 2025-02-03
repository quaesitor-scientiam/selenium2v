module remote

pub const remote_commands = {
	'Command.NEW_SESSION': ['POST', '/session']
	'Command.QUIT':        ['DELETE', r'/session/$sessionId']
}
