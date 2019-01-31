//
//  ShopifyAPI+Products.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//

import Foundation

public struct Product: Codable {
	public var id: Int?
	public let title: String
}

extension Product: ShopifyResource {
	public static var path: String { return "products" }
}

public struct Products: Codable {
	public let products: [Product]
}

extension Products: ResourceContainer {
	public var contents: [Product] { return products }
}

extension Products: Queryable {
		
	public enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		
		public func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim):
				return URLQueryItem(name: "limit", value: "\(lim)")
				
			case .page(let page):
				return URLQueryItem(name: "page", value: "\(page)")
			}
		}
	}
}
