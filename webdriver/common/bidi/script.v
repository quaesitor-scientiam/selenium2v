module bidi


struct Script {
	conn
	log_entry_subscribed  bool
}
fn Script.init(conn) Script {
	return Script{conn: conn}
}