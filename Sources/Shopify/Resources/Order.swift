//
//  ShopifyAPI+Orders.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//
import Foundation

public struct Order: Codable {
	
	let email: String
	let totalPrice: String
	public let id: Int?
	
	enum CodingKeys: String, CodingKey {
		case totalPrice = "total_price"
		case email
		case id
	}
}

extension Order: ShopifyResource {
	public static var path: String { return "orders" }
}

public struct Orders: Codable {
	public let orders: [Order]
}

extension Orders: ResourceContainer {
	public var contents: [Order] { return orders }
}

extension Orders: Queryable {
	
	public enum Status: String {
		case open
		case closed
		case cancelled
	}
	
	public enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		case status(Status)
		
		public func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim):
				return URLQueryItem(name: "limit", value: "\(lim)")
			case .page(let page):
				return URLQueryItem(name: "page", value: "\(page)")
			case .status(let status):
				return URLQueryItem(name: "status", value: status.rawValue)

			}
		}
	}
}
