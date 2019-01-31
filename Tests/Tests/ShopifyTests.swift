//
//  ShopifyTests.swift
//  Async
//
//  Created by David Muzi on 2019-01-30.
//

import XCTest
import Shopify

class ShopifyTests: XCTestCase {

	let token = ProcessInfo.processInfo.environment["token"]!
	let domain = ProcessInfo.processInfo.environment["domain"]!

	var session: ShopifyAPI.URLSession!
	
	override func setUp() {
		session = ShopifyAPI.URLSession(token: token, domain: domain)
	}
	
	func testGetProducts() {

		let expected = expectation(description: "")
		
		session.get(resource: Products.self) { result in
			XCTAssertGreaterThan(result!.products.count, 0)
			result!.products.forEach { XCTAssertGreaterThan($0.id!, 0) }
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testQueryItem() {
		let items = QueryBuilder<Products>()
			.addQuery(.limit(5))
			.addQuery(.page(2))
		
		let expected = expectation(description: "")
		
		session.get(query: items) { (result) in
			XCTAssertEqual(5, result?.contents.count)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testOrderQueryItem() {
		let items = QueryBuilder<Orders>()
			.addQuery(.limit(5))
			.addQuery(.page(2))
		
		let expected = expectation(description: "")
		
		session.get(query: items) { (result) in
			XCTAssertEqual(5, result?.contents.count)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testMarketingEvent() {
		let expected = expectation(description: "")
		
		let marketingEvent = MarketingEvent(
			id: nil,
			description: "data.description",
			eventType: .ad,
			marketingChannel: .social,
			paid: true,
			startedAt: Date()
		)
		
		try! session.post(resource: marketingEvent) { (resource) in
			XCTAssertNotEqual(resource?.id, 0)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
	}
	
	func testCreateWebhook() {
		let expected = expectation(description: "")
		
		let webhook = Webhook(topic: "customers/update", address: "https://www.ngrok.com/webhook/customer_update")
		
		try! session.post(resource: webhook, callback: { (resource) in
			XCTAssertNotEqual(resource!.id, 0)
			expected.fulfill()
		})
		
		waitForExpectations(timeout: 15, handler: nil)
		
	}
	
	func testGetWebhooks() {
		let items = QueryBuilder<Webhooks>()
			.addQuery(.limit(10))
		
		let expected = expectation(description: "")
		
		session.get(query: items) { (result) in
			XCTAssertEqual(1, result?.contents.count)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testDeleteWebHook() {
		let items = QueryBuilder<Webhooks>()
			.addQuery(.limit(11))
		
		let expected = expectation(description: "")
		
		session.get(query: items) { (result) in
			
			let hook: Webhook = result!.contents.first!
			
			try! self.session.delete(resource: hook, callback: { error in
				
				XCTAssertNil(error)
				expected.fulfill()
				
			})
			
		}
		
		waitForExpectations(timeout: 15, handler: nil)
	}

}
