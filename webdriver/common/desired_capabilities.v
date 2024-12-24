module common

// DesiredCapabilities - Set of default supported desired capabilities.
//
//    Use this as a starting point for creating a desired capabilities object for
//    requesting remote webdrivers for connecting to selenium server or selenium grid.
//
//    Usage Example::
//
//        from selenium import webdriver
//
//        selenium_grid_url = "http://198.0.0.1:4444/wd/hub"
//
//        # Create a desired capabilities object as a starting point.
//        capabilities = DesiredCapabilities.FIREFOX.copy()
//        capabilities['platform'] = "WINDOWS"
//        capabilities['version'] = "10"
//
//        # Instantiate an instance of Remote WebDriver with the desired capabilities.
//        driver = webdriver.Remote(desired_capabilities=capabilities,
//                                  command_executor=selenium_grid_url)
//
//    Note: Always use '.copy()' on the DesiredCapabilities object to avoid the side
//    effects of altering the Global class instance.
pub type DesiredCapabilities = FireFox
	| InternetExplorer
	| Edge
	| Chrome
	| Safari
	| HtmlUnit
	| HtmlUnitWithJS
	| IPhone
	| IPad
	| WpeWebKIT
	| WebKitGTK

pub struct FireFox {
	browser_name          string = 'firefox'
	accept_insecure_certs bool   = true
	moz_debugger_address  bool   = true
}

pub struct InternetExplorer {
	browser_name  string = 'internet explorer'
	platform_name string = 'windows'
}

pub struct Edge {
pub:
	browser_name string = 'MicrosoftEdge'
}

pub struct Chrome {
	browser_name string = 'chrome'
}

pub struct Safari {
	browser_name  string = 'safari'
	platform_name string = 'mac'
}

pub struct HtmlUnit {
	browser_name string = 'htmlunit'
	version      string
	platform     string = 'ANY'
}

pub struct HtmlUnitWithJS {
	browser_name       string = 'htmlunit'
	version            string = 'firefox'
	platform           string = 'ANY'
	javascript_enabled bool   = true
}

pub struct IPhone {
	browser_name string = 'iPhone'
	version      string
	platform     string = 'mac'
}

pub struct IPad {
	browser_name string = 'iPad'
	version      string
	platform     string = 'mac'
}

pub struct WebKitGTK {
	browser_name string = 'MiniBrowser'
}

pub struct WpeWebKIT {
	browser_name string = 'MiniBrowser'
}
