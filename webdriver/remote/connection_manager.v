module remote

import sync.pool
import net.http

struct ConnectionManager {
	url  string
	args map[string]?Any
}

fn (c &ConnectionManager) request(method string, url string, body ?, fields ?, headers ?, json ?) http.Response {
	return http.Response{}
}

fn (c &ConnectionManager) clear() {
}
