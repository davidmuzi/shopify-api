import Foundation

struct MarketingEvents: Codable {
	enum CodingKeys: String, CodingKey {
		case marketingEvents = "marketing_events"
	}
	
	let marketingEvents: [MarketingEvent]
}

public struct MarketingEvent: Codable {
	public enum EventType: String, Codable {
		case ad
		case post
		case message
		case retargeting
		case affiliate
		case loyalty
		case newsletter
		case abandonedCart = "abandoned_cart"
	}
	
	public enum MarketingChannel: String, Codable {
		case search
		case display
		case social
		case email
		case referral
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case description = "description"
		case eventType = "event_type"
		case marketingChannel = "marketing_channel"
		case paid = "paid"
		case startedAt = "started_at"
	}
	
	public let id: Int?
	let description: String
	let eventType: EventType
	let marketingChannel: MarketingChannel
	let paid: Bool
	let startedAt: Date
	
	public init(id: Int? = nil, description: String, eventType: EventType, marketingChannel: MarketingChannel, paid: Bool, startedAt: Date) {
		self.id = id
		self.description = description
		self.eventType = eventType
		self.marketingChannel = marketingChannel
		self.paid = paid
		self.startedAt = startedAt
	}
}

extension MarketingEvents: ResourceContainer {
	var contents: [MarketingEvent] { return marketingEvents }
}

extension MarketingEvent: ShopifyCreatableResource {
	public static var path: String { return "marketing_events" }
	public static var identifier = "marketing_event"
}

extension MarketingEvent: ShopifyResource {}
