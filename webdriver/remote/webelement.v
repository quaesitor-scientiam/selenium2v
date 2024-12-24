module remote

@[heap; params]
struct Params {
mut:
	data map[string]string
}

// WebElement - Represents a DOM element.
//
//    Generally, all interesting operations that interact with a document will be
//    performed through this interface.
//
//    All method calls will do a freshness check to ensure that the element
//    reference is still valid.  This essentially determines whether the
//    element is still attached to the DOM.  If this test fails, then an
//    ``StaleElementReferenceException`` is thrown, and all future calls to this
//    instance will fail.
struct WebElement {
	parent ?&WebElement
	id     string
}

// tag_name - This element's ``tagName`` property.
fn (w &WebElement) tag_name() string {
	res := w.execute(Command.get_element_tag_name.str())
	return res.data['value'] or { 'Value does not exist' }
}

// execute - "Executes a command against the underlying HTML element.
//
//        Args:
//          command: The name of the command to _execute as a string.
//          params: A dictionary of named parameters to send with the command.
//
//        Returns:
//          The command's JSON response loaded into a dictionary object.
fn (w &WebElement) execute(command string, params Params) Params {
	mut p := params

	p.data['id'] = w.id
	if w.parent != none {
		p = w.parent.execute(command, p)
	}

	return p
}
