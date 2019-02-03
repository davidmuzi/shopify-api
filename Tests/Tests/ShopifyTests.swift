//
//  ShopifyTests.swift
//  Async
//
//  Created by David Muzi on 2019-01-30.
//

import XCTest
@testable import Shopify

class ShopifyTests: XCTestCase {

	var api: ShopifyAPI.URLSession!
	
	override func setUp() {
		api = ShopifyAPI.URLSession(token: "token", domain: "myshop.myshopify.com")
	}
	
	func testJSONDecodingToCoreDataObject() {
		
		// Create mock session
		let session = URLSessionMock()
		let json = """
		{
		   "products":[
			  {
				 "title":"Mug"
			  },
			  {
				 "title":"Cup"
			  }
		   ]
		}
		"""
		session.data = json.data(using: .utf8)
		
		let api = ShopifyAPI.URLSession(token: "token", domain: "domain", session: session)

		api.get(resource: Products.self) { result in
			XCTAssertEqual("Mug", result!.products.first!.title)
			XCTAssertEqual("Cup", result!.products.last!.title)
		}
	}
	
	func testQueryItem() {
		let items = QueryBuilder<Products>()
			.addQuery(.limit(5))
			.addQuery(.page(2))
		
		let api = ShopifyAPI.URLSession(token: "token", domain: "myshop.myshopify.com")

		let url = api.makeUrl(query: items)
		XCTAssertEqual(URL(string: "https://myshop.myshopify.com/admin/products.json?limit=5&page=2"), url)
	}
	
	func testOrdersQuery() {
		let items = QueryBuilder<Orders>()
			.addQuery(.limit(3))
			.addQuery(.status(.closed))
		
		let api = ShopifyAPI.URLSession(token: "token", domain: "myshop.myshopify.com")
		
		let url = api.makeUrl(query: items)
		XCTAssertEqual(URL(string: "https://myshop.myshopify.com/admin/orders.json?limit=3&status=closed"), url)
	}
	
	func testDeleteWebHook() {
		
		let session = URLSessionMock()
		session.requestClosure = { request in
			XCTAssertEqual(URL(string: "https://myshop.myshopify.com/admin/webhooks/3.json"), request.url)
			XCTAssertEqual(request.httpMethod, "DELETE")
		}
		
		let api = ShopifyAPI.URLSession(token: "token", domain: "myshop.myshopify.com", session: session)
		let hook = Webhook(topic: "order-create", address: "https://example.com/order", id: 3)
		try! api.delete(resource: hook, callback: { _ in })
	}
	
	func testWebhookQuery() {
		let items = QueryBuilder<Webhooks>()
			.addQuery(.limit(10))
		
		let url = api.makeUrl(query: items)
		XCTAssertEqual(URL(string: "https://myshop.myshopify.com/admin/webhooks.json?limit=10"), url)
	}
	
	@available(OSX 10.12, *)
	func testMarketingEvent() {
		
		let marketingEvent = MarketingEvent(
			id: nil,
			description: "data.description",
			eventType: .ad,
			marketingChannel: .social,
			paid: true,
			startedAt: Date()
		)
		
		let session = URLSessionMock()
		session.requestClosure = { request in
			XCTAssertEqual(URL(string: "https://myshop.myshopify.com/admin/marketing_events.json"), request.url)
			XCTAssertEqual("POST", request.httpMethod)
			
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			
			XCTAssertEqual(try! encoder.encode(["marketing_event": marketingEvent]), request.httpBody)
		}
		
		let api = ShopifyAPI.URLSession(token: "token", domain: "myshop.myshopify.com", session: session)
		try! api.post(resource: marketingEvent, callback: { _ in })
	}
	
	func testCreateWebhook() {
		
		let webhook = Webhook(topic: "customers/update", address: "https://www.ngrok.com/webhook/customer_update")
		
		let session = URLSessionMock()
		session.requestClosure = { request in
			XCTAssertEqual(URL(string: "https://myshop.myshopify.com/admin/webhooks.json"), request.url)
			XCTAssertEqual("POST", request.httpMethod)
			XCTAssertEqual(try! JSONEncoder().encode(["webhook": webhook]), request.httpBody)
		}
		
		let api = ShopifyAPI.URLSession(token: "token", domain: "myshop.myshopify.com", session: session)
		
		try! api.post(resource: webhook, callback: { _ in })
		
	}
}
