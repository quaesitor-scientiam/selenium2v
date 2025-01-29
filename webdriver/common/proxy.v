module common

pub enum ProxyType {
	direct
	manual
	pac
	reserved
	autodetect
	system
	unspecified
}

// Proxy - Proxy contains information about proxy type and necessary proxy
//    settings.
pub struct Proxy {
pub:
	proxy_type           ProxyType = .unspecified
	autodetect           bool
	ftp_proxy            string
	http_proxy           ?string
	no_proxy             string
	proxy_autoconfig_url string
	ssl_proxy            ?string
	socks_proxy          string
	socks_username       string
	socks_password       string
	socks_version        ?string
}
