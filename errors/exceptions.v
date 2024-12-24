module errors

const support_msg = 'For documentation on this error, please visit:'
const error_url = 'https://www.selenium.dev/documentation/webdriver/troubleshooting/errors'

// WebDriverException -  is the base error struct
pub struct WebDriverException {
pub:
	error  int
	msg    string
	screen string
}

// InvalidSwitchToTargetException - Thrown when frame or window target to be switched doesn't exist
pub struct InvalidSwitchToTargetException {
	WebDriverException
}

// NoSuchFrameException - Thrown when frame target to be switched doesn't exist.
pub struct NoSuchFrameException {
	InvalidSwitchToTargetException
}

// NoSuchWindowException - Thrown when window target to be switched doesn't exist.
//
//    To find the current set of active window handles, you can get a list
//    of the active window handles in the following way::
//
//        print driver.window_handles
pub struct NoSuchWindowException {
	InvalidSwitchToTargetException
}

// NoSuchElementException - Thrown when element could not be found.
//
//    If you encounter this exception, you may want to check the following:
//        * Check your selector used in your find_by...
//        * Element may not yet be on the screen at the time of the find operation,
//          (webpage is still loading) see selenium.webdriver.support.wait.WebDriverWait()
//          for how to write a wait wrapper to wait for an element to appear.
pub struct NoSuchElementException {
	WebDriverException
}

// NoSuchAttributeException - Thrown when the attribute of element could not be found.
//
//    You may want to check if the attribute exists in the particular
//    browser you are testing against.  Some browsers may have different
//    property names for the same property.  (IE8's .innerText vs. Firefox
//    .textContent)
pub struct NoSuchAttributeException {
	WebDriverException
}

// NoSuchShadowRootException - Thrown when trying to access the shadow root of an element when it does
//    not have a shadow root attached.
pub struct NoSuchShadowRootException {
	WebDriverException
}

// StaleElementReferenceException - Thrown when a reference to an element is now "stale".
//
//    Stale means the element no longer appears on the DOM of the page.
//
//
//    Possible causes of StaleElementReferenceException include, but not limited to:
//        * You are no longer on the same page, or the page may have refreshed since the element
//          was located.
//        * The element may have been removed and re-added to the screen, since it was located.
//          Such as an element being relocated.
//          This can happen typically with a javascript framework when values are updated and the
//          node is rebuilt.
//        * Element may have been inside an iframe or another context which was refreshed.
pub struct StaleElementReferenceException {
	WebDriverException
}

// InvalidElementStateException - Thrown when a command could not be completed because the element is in
//    an invalid state.
//
//    This can be caused by attempting to clear an element that isn't both
//    editable and resettable.
pub struct InvalidElementStateException {
	WebDriverException
}

// UnexpectedAlertPresentException - Thrown when an unexpected alert has appeared.
//
//    Usually raised when  an unexpected modal is blocking the webdriver
//    from executing commands.
pub struct UnexpectedAlertPresentException {
	WebDriverException
pub:
	alert_text string
}

// NoAlertPresentException - Thrown when switching to no presented alert.
//
//    This can be caused by calling an operation on the Alert() class when
//    an alert is not yet on the screen.
pub struct NoAlertPresentException {
	WebDriverException
}

// ElementNotVisibleException - Thrown when an element is present on the DOM, but it is not visible, and
//    so is not able to be interacted with.
//
//    Most commonly encountered when trying to click or read text of an
//    element that is hidden from view.
pub struct ElementNotVisibleException {
	InvalidElementStateException
}

// ElementNotInteractableException - Thrown when an element is present in the DOM but interactions with that
//    element will hit another element due to paint order.
pub struct ElementNotInteractableException {
	InvalidElementStateException
}

// ElementNotSelectableException - Thrown when trying to select an unselectable element.
//
//    For example, selecting a 'script' element.
pub struct ElementNotSelectableException {
	InvalidElementStateException
}

// InvalidCookieDomainException - Thrown when attempting to add a cookie under a different domain than the
//    current URL.
pub struct InvalidCookieDomainException {
	WebDriverException
}

// UnableToSetCookieException - Thrown when a driver fails to set a cookie.
pub struct UnableToSetCookieException {
	WebDriverException
}

// TimeoutException - Thrown when a command does not complete in enough time.
pub struct TimeoutException {
	WebDriverException
}

// MoveTargetOutOfBoundsException - Thrown when the target provided to the `ActionsChains` move() method is
//    invalid, i.e. out of document.
pub struct MoveTargetOutOfBoundsException {
	WebDriverException
}

// UnexpectedTagNameException - Thrown when a support class did not get an expected web element.
pub struct UnexpectedTagNameException {
	WebDriverException
}

// InvalidSelectorException - Thrown when the selector which is used to find an element does not
//    return a WebElement.
//
//    Currently this only happens when the selector is an xpath expression
//    and it is either syntactically invalid (i.e. it is not a xpath
//    expression) or the expression does not select WebElements
//    ( e.g. count(//input) ).
pub struct InvalidSelectorException {
	WebDriverException
}

// ImeNotAvailableException - Thrown when IME support is not available.
//
//    This exception is thrown for every IME-related method call if IME
//    support is not available on the machine.
pub struct ImeNotAvailableException {
	WebDriverException
}

// ImeActivationFailedException - Thrown when activating an IME engine has failed.
pub struct ImeActivationFailedException {
	WebDriverException
}

// InvalidArgumentException - The arguments passed to a command are either invalid or malformed.
pub struct InvalidArgumentException {
	WebDriverException
}

// JavascriptException - An error occurred while executing JavaScript supplied by the user.
pub struct JavascriptException {
	WebDriverException
}

// NoSuchCookieException - No cookie matching the given path name was found amongst the associated
//    cookies of the current browsing context's active document.
pub struct NoSuchCookieException {
	WebDriverException
}

// ScreenshotException - A screen capture was made impossible.
pub struct ScreenshotException {
	WebDriverException
}

// ElementClickInterceptedException - The Element Click command could not be completed because the element
//    receiving the events is obscuring the element that was requested to be
//    clicked.
pub struct ElementClickInterceptedException {
	WebDriverException
}

// InsecureCertificateException - Navigation caused the user agent to hit a certificate warning, which is
//    usually the result of an expired or invalid TLS certificate.
pub struct InsecureCertificateException {
	WebDriverException
}

// InvalidCoordinatesException - The coordinates provided to an interaction's operation are invalid.
pub struct InvalidCoordinatesException {
	WebDriverException
}

// InvalidSessionIdException - Occurs if the given session id is not in the list of active sessions,
//    meaning the session either does not exist or that it's not active.
pub struct InvalidSessionIdException {
	WebDriverException
}

// SessionNotCreatedException - A new session could not be created.
pub struct SessionNotCreatedException {
	WebDriverException
}

// UnknownMethodException - The requested command matched a known URL but did not match any methods
//    for that URL.
pub struct UnknownMethodException {
	WebDriverException
}

// NoSuchDriverException - Raised when driver is not specified and cannot be located.
pub struct NoSuchDriverException {
	WebDriverException
}

// DetachedShadowRootException - Raised when referenced shadow root is no longer attached to the DOM.
pub struct DetachedShadowRootException {
	WebDriverException
}

type WebDriverExceptions = WebDriverException
	| InvalidSwitchToTargetException
	| NoSuchFrameException
	| NoSuchWindowException
	| NoSuchElementException
	| NoSuchAttributeException
	| NoSuchShadowRootException
	| StaleElementReferenceException
	| InvalidElementStateException
	| UnexpectedAlertPresentException
	| NoAlertPresentException
	| ElementNotVisibleException
	| ElementNotInteractableException
	| ElementNotSelectableException
	| InvalidCookieDomainException
	| UnableToSetCookieException
	| TimeoutException
	| MoveTargetOutOfBoundsException
	| UnexpectedTagNameException
	| InvalidSelectorException
	| ImeNotAvailableException
	| ImeActivationFailedException
	| InvalidArgumentException
	| JavascriptException
	| NoSuchCookieException
	| ScreenshotException
	| ElementClickInterceptedException
	| InsecureCertificateException
	| InvalidCoordinatesException
	| InvalidSessionIdException
	| SessionNotCreatedException
	| UnknownMethodException
	| NoSuchDriverException
	| DetachedShadowRootException

pub fn (err WebDriverExceptions) str() string {
	mut exception_msg := '${err.msg}'
	if err.screen != '' {
		exception_msg += '; Screenshot: available via screen\n'
	}
	match err {
		WebDriverException {
			return 'WebDriverException: ${exception_msg}'
		}
		InvalidSwitchToTargetException {
			return 'InvalidSwitchToTargetException: ${exception_msg}'
		}
		NoSuchFrameException {
			return 'NoSuchFrameException: ${exception_msg}'
		}
		NoSuchWindowException {
			return 'NoSuchWindowException: ${exception_msg}'
		}
		NoSuchAttributeException {
			return 'NoSuchAttributeException: ${exception_msg}'
		}
		NoSuchShadowRootException {
			return 'NoSuchShadowRootException: ${exception_msg}'
		}
		InvalidElementStateException {
			return 'InvalidElementStateException: ${exception_msg}'
		}
		NoAlertPresentException {
			return 'NoAlertPresentException: ${exception_msg}'
		}
		ElementNotVisibleException {
			return 'ElementNotVisibleException: ${exception_msg}'
		}
		ElementNotInteractableException {
			return 'ElementNotInteractableException: ${exception_msg}'
		}
		ElementNotSelectableException {
			return 'ElementNotSelectableException: ${exception_msg}'
		}
		InvalidCookieDomainException {
			return 'InvalidCookieDomainException: ${exception_msg}'
		}
		UnableToSetCookieException {
			return 'UnableToSetCookieException: ${exception_msg}'
		}
		TimeoutException {
			return 'TimeoutException: ${exception_msg}'
		}
		MoveTargetOutOfBoundsException {
			return 'MoveTargetOutOfBoundsException: ${exception_msg}'
		}
		UnexpectedTagNameException {
			return 'UnexpectedTagNameException: ${exception_msg}'
		}
		ImeNotAvailableException {
			return 'ImeNotAvailableException: ${exception_msg}'
		}
		ImeActivationFailedException {
			return 'ImeActivationFailedException: ${exception_msg}'
		}
		InvalidArgumentException {
			return 'InvalidArgumentException: ${exception_msg}'
		}
		JavascriptException {
			return 'JavascriptException: ${exception_msg}'
		}
		NoSuchCookieException {
			return 'NoSuchCookieException: ${exception_msg}'
		}
		ScreenshotException {
			return 'ScreenshotException: ${exception_msg}'
		}
		ElementClickInterceptedException {
			return 'ElementClickInterceptedException: ${exception_msg}'
		}
		InsecureCertificateException {
			return 'InsecureCertificateException: ${exception_msg}'
		}
		InvalidCoordinatesException {
			return 'InvalidCoordinatesException: ${exception_msg}'
		}
		InvalidSessionIdException {
			return 'InvalidSessionIdException: ${exception_msg}'
		}
		SessionNotCreatedException {
			return 'SessionNotCreatedException: ${exception_msg}'
		}
		UnknownMethodException {
			return 'UnknownMethodException: ${exception_msg}'
		}
		DetachedShadowRootException {
			return 'NoSuchDriverException: ${exception_msg}'
		}
		StaleElementReferenceException {
			exception_msg += '; ${support_msg} ${error_url}'
			return 'StaleElementReferenceException: ${exception_msg}'
		}
		NoSuchElementException {
			exception_msg += '; ${support_msg} ${error_url}'
			return 'NoSuchElementException: ${exception_msg}'
		}
		UnexpectedAlertPresentException {
			exception_msg = 'Alert Text ${err.alert_text}'
			return 'UnexpectedAlertPresentException: ${exception_msg}'
		}
		InvalidSelectorException {
			exception_msg += '; ${support_msg} ${error_url}'
			return 'InvalidSelectorException: ${exception_msg}'
		}
		NoSuchDriverException {
			exception_msg += '; ${support_msg} ${error_url}/driver_location'
			return 'NoSuchDriverException: ${exception_msg}'
		}
	}
}
