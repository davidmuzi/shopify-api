import Foundation

public struct Webhook: Codable {
	public let topic: String
	public let address: String
	public let format = "json"
	public let id: Int?
	
	public init(topic: String, address: String, id: Int? = nil) {
		self.topic = topic
		self.address = address
		self.id = id
	}
}

extension Webhook: ShopifyResource {}

extension Webhook: ShopifyCreatableResource {
	public static var path: String { return "webhooks" }
	public static var identifier: String { return "webhook" }
}

public struct Webhooks: Codable {
	public let webhooks: [Webhook]
}

extension Webhooks: ResourceContainer {
	public var contents: [Webhook] { return webhooks }
}

extension Webhooks: Queryable {
	public enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		case topic(String)
		
		public func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim): return URLQueryItem(name: "limit", value: "\(lim)")
			case .page(let page): return URLQueryItem(name: "page", value: "\(page)")
			case .topic(let topic): return URLQueryItem(name: "topic", value: "\(topic)")
			}
		}
	}
}
