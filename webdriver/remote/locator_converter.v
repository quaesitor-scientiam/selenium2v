module remote

struct LocatorConverter {}

// convert - Default conversion logic
fn (l &LocatorConverter) convert(by string, value string) (string, string) {
	if by == 'id' {
		return 'css selector', '[id=${value}]'
	} else if by == 'class name' {
		return 'css selector', '.${value}'
	} else if by == 'name' {
		return 'css selector', '[name=${value}]'
	}
	return by, value
}
