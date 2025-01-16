module common

// PageLoadStrategy - "Enum of possible page load strategies.
//
//    Selenium support following strategies:
//        * normal (default) - waits for all resources to download
//        * eager - DOM access is ready, but other resources like images may still be loading
//        * none - does not block `WebDriver` at all
//
//    Docs: https://www.selenium.dev/documentation/webdriver/drivers/options/#pageloadstrategy.
enum PageLoadStrategy {
	normal
	eager
	none
}

type Capability_types = string | PageLoadStrategy

// BaseOptionsDescriptor -
struct BaseOptionsDescriptor {
	name string
}

// PageLoadStrategyDescriptor - Determines the point at which a navigation command is returned:
//    https://w3c.github.io/webdriver/#dfn-table-of-page-load-strategies
struct PageLoadStrategyDescriptor {
	name string
}

// UnHandledPromptBehaviorDescriptor - How the driver should respond when an alert is present and the:
//    command sent is not handling the alert:
//    https://w3c.github.io/webdriver/#dfn-table-of-page-load-strategies
struct UnHandledPromptBehaviorDescriptor {
	name string
}

// TimeoutsDescriptor - How long the driver should wait for actions to complete before:
//    returning an error https://w3c.github.io/webdriver/#timeouts
struct TimeoutsDescriptor {
	name string
}

// ProxyDescriptor - Returns: Proxy if set, otherwise None.
struct ProxyDescriptor {
	name string
}

// BaseOptions - Gets and Sets the version of the browser.
pub struct BaseOptions {
mut:
	browser_version             ?string
	platform_name               ?string
	accept_insecure_certs       bool
	strict_file_interactability bool
	set_window_rect             bool
	enable_bidi                 bool
	web_socket_url              ?string
	page_load_strategy          PageLoadStrategy
	unhandled_prompt_behavior   ?string
	timeouts                    ?string
	proxy                       ?string
	enable_downloads            bool
	capabilities                map[string]Capability_types
	mobile_options              bool
	ignore_local_proxy          bool
}

fn BaseOptions.init() BaseOptions {
	mut b := BaseOptions{
		browser_version:             none
		platform_name:               none
		accept_insecure_certs:       false
		strict_file_interactability: false
		set_window_rect:             false
		enable_bidi:                 false
		web_socket_url:              none
		page_load_strategy:          .normal
		unhandled_prompt_behavior:   none
		timeouts:                    none
		proxy:                       none
		enable_downloads:            false
		mobile_options:              false
		ignore_local_proxy:          false
	}
	b.set_capability('pageLoadStrategy', PageLoadStrategy.normal)
	return b
}

pub fn (mut b BaseOptions) set_capability(name string, value Capability_types) {
	b.capabilities[name] = value
}

pub struct ArgOptions {
	BaseOptions
	arguments             []string
	binary_location_error string
	fedcm_capability      string
}

pub fn ArgOptions.init[T](dc T) ArgOptions {
	mut b := BaseOptions.init()

	$for v in T.variants {
		if dc is v {
			sv := struct_values(dc)
			for key, value in sv {
				b.set_capability(key, value)
			}
		}
	}
	return ArgOptions{
		BaseOptions:           b
		arguments:             []
		binary_location_error: 'Binary Location Must be a String'
		fedcm_capability:      'fedcm:accounts'
	}
}

fn struct_values[T](s T) map[string]string {
	mut res := map[string]string{}
	$if T is $struct {
		$for field in T.fields {
			res[field.name] = s.$(field.name).str()
		}
	}
	return res
}
