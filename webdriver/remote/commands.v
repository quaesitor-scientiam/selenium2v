module remote

/*
*   Licensed to the Software Freedom Conservancy (SFC) under one
*   or more contributor license agreements.  See the NOTICE file
*   distributed with this work for additional information
*   regarding copyright ownership.  The SFC licenses this file
*   to you under the Apache License, Version 2.0 (the
*   "License"); you may not use this file except in compliance
*   with the License.  You may obtain a copy of the License at
*
*   http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing,
*   software distributed under the License is distributed on an
*   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
*   KIND, either express or implied.  See the License for the
*   specific language governing permissions and limitations
*   under the License.
**/

// Command - Defines constants for the standard WebDriver commands.
//
//    While these constants have no meaning in and of themselves, they are
//    used to marshal commands through a service that implements WebDriver's
//    remote wire protocol:
//
//        https://w3c.github.io/webdriver/
pub enum Command {
	new_session
	delete_session
	new_window
	close
	quit
	get
	go_back
	go_forward
	refresh
	add_cookie
	get_cookie
	get_all_cookies
	delete_cookie
	delete_all_cookies
	find_element
	find_elements
	find_child_element
	find_child_elements
	clear_element
	click_element
	send_keys_to_element
	w3c_get_current_window_handle
	w3c_get_window_handles
	set_window_rect
	get_window_rect
	switch_to_window
	switch_to_frame
	switch_to_parent_frame
	w3c_get_active_element
	get_current_url
	get_page_source
	get_title
	w3c_execute_script
	w3c_execute_script_async
	get_element_text
	get_element_tag_name
	is_element_selected
	is_element_enabled
	get_element_rect
	get_element_attribute
	get_element_property
	get_element_value_of_css_property
	get_element_aria_role
	get_element_aria_label
	screenshot
	element_screenshot
	execute_async_script
	set_timeouts
	get_timeouts
	w3c_maximize_window
	get_log
	get_available_log_types
	fullscreen_window
	minimize_window
	print_page
	w3c_dismiss_alert
	w3c_accept_alert
	w3c_set_alert_value
	w3c_get_alert_text
	w3c_actions
	w3c_clear_actions
	set_screen_orientation
	get_screen_orientation
	get_network_connection
	set_network_connection
	current_context_handle
	context_handles
	switch_to_context
	get_shadow_root
	find_element_from_shadow_root
	find_elements_from_shadow_root
	add_virtual_authenticator
	remove_virtual_authenticator
	add_credential
	get_credentials
	remove_credential
	remove_all_credentials
	set_user_verified
	upload_file
	get_downloadable_files
	download_file
	delete_downloadable_files
	get_fedcm_title
	get_fedcm_dialog_type
	get_fedcm_account_list
	select_fedcm_account
	click_fedcm_dialog_button
	cancel_fedcm_dialog
	set_fedcm_delay
	reset_fedcm_cooldown
}

// str - returns a string value for the 'c' in Command
pub fn (c Command) str() string {
	return match c {
		.new_session { 'newSession' }
		.delete_session { 'deleteSession' }
		.new_window { 'newWindow' }
		.close { 'close' }
		.quit { 'quit' }
		.get { 'get' }
		.go_back { 'goBack' }
		.go_forward { 'goForward' }
		.refresh { 'refresh' }
		.add_cookie { 'addCookie' }
		.get_cookie { 'getCookie' }
		.get_all_cookies { 'getCookies' }
		.delete_cookie { 'deleteCookie' }
		.delete_all_cookies { 'deleteAllCookies' }
		.find_element { 'findElement' }
		.find_elements { 'findElements' }
		.find_child_element { 'findChildElement' }
		.find_child_elements { 'findChildElements' }
		.clear_element { 'clearElement' }
		.click_element { 'clickElement' }
		.send_keys_to_element { 'sendKeysToElement' }
		.w3c_get_current_window_handle { 'w3cGetCurrentWindowHandle' }
		.w3c_get_window_handles { 'w3cGetWindowHandles' }
		.set_window_rect { 'setWindowRect' }
		.get_window_rect { 'getWindowRect' }
		.switch_to_window { 'switchWindow' }
		.switch_to_frame { 'switchFrame' }
		.switch_to_parent_frame { 'switchToParentFrame' }
		.w3c_get_active_element { 'w3cGetActiveElement' }
		.get_current_url { 'getCurrentUrl' }
		.get_page_source { 'getPageSource' }
		.get_title { 'getTitle' }
		.w3c_execute_script { 'w3cExecuteScript' }
		.w3c_execute_script_async { 'w3cExecuteScriptAsync' }
		.get_element_text { 'getElementText' }
		.get_element_tag_name { 'getElementTagName' }
		.is_element_selected { 'isElementSelected' }
		.is_element_enabled { 'isElementEnabled' }
		.get_element_rect { 'getElementRect' }
		.get_element_attribute { 'getElementAttribute' }
		.get_element_property { 'getElementProperty' }
		.get_element_value_of_css_property { 'getElementValueOfCssProperty' }
		.get_element_aria_role { 'getElementAriaRole' }
		.get_element_aria_label { 'getElementAriaLabel' }
		.screenshot { 'screenshot' }
		.element_screenshot { 'elementScreenshot' }
		.execute_async_script { 'executeAsyncScript' }
		.set_timeouts { 'setTimeouts' }
		.get_timeouts { 'getTimeouts' }
		.w3c_maximize_window { 'w3cMaximizeWindow' }
		.get_log { 'getLog' }
		.get_available_log_types { 'getAvailableLogTypes' }
		.fullscreen_window { 'fullscreenWindow' }
		.minimize_window { 'minimizeWindow' }
		.print_page { 'printPage' }
		.w3c_dismiss_alert { 'w3cDismissAlert' }
		.w3c_accept_alert { 'w3cAcceptAlert' }
		.w3c_set_alert_value { 'w3cSetAlertValue' }
		.w3c_get_alert_text { 'w3cGetAlertText' }
		.w3c_actions { 'actions' }
		.w3c_clear_actions { 'clearActionState' }
		.set_screen_orientation { 'setScreenOrientation' }
		.get_screen_orientation { 'getScreenOrientation' }
		.get_network_connection { 'getNetworkConnection' }
		.set_network_connection { 'setNetworkConnection' }
		.current_context_handle { 'getCurrentContextHandle' }
		.context_handles { 'getContextHandles' }
		.switch_to_context { 'switchToContext' }
		.get_shadow_root { 'getShadowRoot' }
		.find_element_from_shadow_root { 'findElementFromShadowRoot' }
		.find_elements_from_shadow_root { 'findElementsFromShadowRoot' }
		.add_virtual_authenticator { 'addVirtualAuthenticator' }
		.remove_virtual_authenticator { 'removeVirtualAuthenticator' }
		.add_credential { 'addCredential' }
		.get_credentials { 'getCredentials' }
		.remove_credential { 'removeCredential' }
		.remove_all_credentials { 'removeAllCredentials' }
		.set_user_verified { 'setUserVerified' }
		.upload_file { 'uploadFile' }
		.get_downloadable_files { 'getDownloadableFiles' }
		.download_file { 'downloadFile' }
		.delete_downloadable_files { 'deleteDownloadableFiles' }
		.get_fedcm_title { 'getFedcmTitle' }
		.get_fedcm_dialog_type { 'getFedcmDialogType' }
		.get_fedcm_account_list { 'getFedcmAccountList' }
		.select_fedcm_account { 'selectFedcmAccount' }
		.click_fedcm_dialog_button { 'clickFedcmDialogButton' }
		.cancel_fedcm_dialog { 'cancelFedcmDialog' }
		.set_fedcm_delay { 'setFedcmDelay' }
		.reset_fedcm_cooldown { 'resetFedcmCooldown' }
	}
}
