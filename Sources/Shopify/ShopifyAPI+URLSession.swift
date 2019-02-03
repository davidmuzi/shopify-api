//
//  ShopifyAPI+URLSession.swift
//  App
//
//  Created by David Muzi on 2019-01-10.
//

import Foundation

extension ShopifyAPI {

	public class URLSession {
		
		private let session: Foundation.URLSession
		private let host: URL
		
		public init(token: String, domain: String, session: Foundation.URLSession? = nil) {
			
			if let session = session {
				self.session = session
			} else {
				let config = URLSessionConfiguration.default
				config.httpAdditionalHeaders = ["X-Shopify-Access-Token": token,
												"Content-Type": "application/json; charset=utf-8"]
				self.session = Foundation.URLSession(configuration: config)
			}
			self.host = URL(string: "https://\(domain)/admin/")!
		}

		public func get<Q: QueryBuilder<R>, R: ResourceContainer>(query: Q, callback: @escaping (Q.Resource?) -> Void) where R: Decodable {
			let url = makeUrl(query: query)
			decodeResource(url: url, callback: callback)
		}
		
		func makeUrl<Q: QueryBuilder<R>, R: ResourceContainer>(query: Q) -> URL {
			let url = host.appendingPathComponent(Q.Resource.Resource.path).appendingPathExtension("json")
			var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
			components.queryItems = query.queryItems()
			return components.url!
		}
		
		public func get<R: ResourceContainer>(resource: R.Type, callback: @escaping (R?) -> Void) where R: Decodable {
			let url = host.appendingPathComponent(R.Resource.path).appendingPathExtension("json")
			decodeResource(url: url, callback: callback)
		}
		
		public func post<R: Codable & ShopifyCreatableResource>(resource: R, callback: @escaping (R?) -> Void) throws {
			let url = host.appendingPathComponent(R.path).appendingPathExtension("json")

			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			
			let encoder = JSONEncoder()
			if #available(OSX 10.12, *) {
				encoder.dateEncodingStrategy = .iso8601
			}
			
			request.httpBody = try encoder.encode([R.identifier: resource])
			
			session.dataTask(with: request) { (data, response, error) in
				guard let data = data, data.count > 0, error == nil else { return callback(nil) }
				typealias Container = [String: R]
				
				let decoder = JSONDecoder()
				if #available(OSX 10.12, *) {
					decoder.dateDecodingStrategy = .iso8601
				}
				
				if let contained = try? decoder.decode(Container.self, from: data), let contents = contained[R.identifier] {
					callback(contents)
				} else { callback(nil) }
			}.resume()
		}
		
		public func delete<R: ShopifyResource>(resource: R, callback: @escaping (Error?) -> Void) throws {
			guard let id = resource.id else { return }
			let url = host.appendingPathComponent(R.path)
				.appendingPathComponent("\(id)")
				.appendingPathExtension("json")
			
			var request = URLRequest(url: url)
			request.httpMethod = "DELETE"
			
			session.dataTask(with: request) { (data, response, error) in
				if let error = error { return callback(error) }
				guard let r = response as? HTTPURLResponse, r.statusCode == 200 else { return callback(BadResponse()) }
				callback(nil)
				}.resume()
		}
		
		private func decodeResource<R: Decodable>(url: URL, callback: @escaping (R?) -> Void) {
			session.dataTask(with: url) { (data, response, error) in
				guard let data = data, error == nil else { return callback(nil) }
				callback(try! JSONDecoder().decode(R.self, from: data))
			}.resume()
		}
	}
}

private struct BadResponse: Error { }
