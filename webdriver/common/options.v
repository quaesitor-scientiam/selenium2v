module common

import webdriver { CapabilityTypeDict, Capability_types, Dict, PageLoadStrategy }

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
pub mut:
	capabilities                CapabilityTypeDict
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
	proxy                       ?Proxy
	enable_downloads            bool
	mobile_options              ?CapabilityTypeDict
	ignore_local_proxy          bool
}

pub fn (mut b BaseOptions) set_capability(name string, value Capability_types) {
	b.capabilities[name] = value
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
		ignore_local_proxy:          false
	}
	b.set_capability('pageLoadStrategy', PageLoadStrategy.normal)
	return b
}

pub struct ArgOptions {
	BaseOptions
	arguments             Capability_types
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
		binary_location_error: 'Binary Location Must be a String'
		fedcm_capability:      'fedcm:accounts'
	}
}

fn struct_values[T](s T) Dict {
	mut res := Dict{}
	$if T is $struct {
		$for field in T.fields {
			res[field.name] = s.$(field.name).str()
		}
	}
	return res
}
