module remote

// FileDetector - Used for identifying whether a sequence of chars represents the path to
//    a file.
interface IFileDetector {
	is_local_file(string) ?string
}

// LocalFileDetector - Detects files on the local disk.
struct LocalFileDetector {}

fn (l &LocalFileDetector) is_local_file(path string) ?string {
	return none
}
