import Foundation

// https://www.swiftbysundell.com/posts/mocking-in-swift

class URLSessionMock: URLSession {
	typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
	
	// Properties that enable us to set exactly what data or error
	// we want our mocked URLSession to return for any request.
	var data: Data?
	var error: Error?
	
	var requestClosure: ((URLRequest) -> Void)?
	
	
	override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
		let data = self.data
		let error = self.error
		
		return URLSessionDataTaskMock { completionHandler(data, nil, error) }
	}
	
	override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		let data = self.data
		let error = self.error
		requestClosure?(request)
		return URLSessionDataTaskMock { completionHandler(data, nil, error) }
	}
}

// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {
	private let closure: () -> Void
	
	init(closure: @escaping () -> Void) { self.closure = closure }
	
	// We override the 'resume' method and simply call our closure
	// instead of actually resuming any task.
	override func resume() { closure() }
}
