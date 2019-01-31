//
//  ProductsAPI.swift
//
//  Created by David Muzi on 2019-01-01.
//

import Foundation

public enum ShopifyAPI {}

public protocol ShopifyResource {
	var id: Int? { get }
	static var path: String { get }
}

public protocol ResourceContainer {
	associatedtype Resource: ShopifyResource
	var contents: [Resource] { get }
}

public protocol ShopifyCreatableResource {
	static var path: String { get }
	static var identifier: String { get }
}

// MARK: - Query Support

public protocol Queryable {
	associatedtype Query: QueryItemConvertable
}

public protocol QueryItemConvertable {
	func queryItem() -> URLQueryItem
}

public class QueryBuilder<Q: Queryable> {
	
	public typealias Resource = Q
	
	public init() {}
	
	private var _queryItems = [Q.Query]()
	
	public func addQuery(_ item: Q.Query) -> QueryBuilder {
		_queryItems.append(item)
		return self
	}
	
	func queryItems() -> [URLQueryItem] {
		return _queryItems.map{ $0.queryItem() }
	}
}
