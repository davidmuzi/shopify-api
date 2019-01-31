//
//  ShopifyTests.swift
//  Async
//
//  Created by David Muzi on 2019-01-30.
//

import XCTest
import Vapor
import Shopify_Vapor
import Shopify

class ShopifyTests: XCTestCase {

	var app: Application!
	let token = ProcessInfo.processInfo.environment["token"]!
	let domain = ProcessInfo.processInfo.environment["domain"]!
	
	var shopify: ShopifyAPI.Vapor!
	
	var dummyRequest: Request!
	
    override func setUp() {
		let config = Config.default()
		let services = Services.default()
		let env = Environment.testing
		app = try! Application(config: config, environment: env, services: services)
		
		let session = Session(id: "test", data: SessionData())
		session["shop_domain"] = domain
		session["access_token"] = token
		
		shopify = try! ShopifyAPI.Vapor(session: session)
		
		let request = HTTPRequest(method: .GET, url: URL(string: "/")!)
		dummyRequest = Request(http: request, using: app)
	}

    func testGetProducts() {
		let expected = expectation(description: "")
		
		_ = try! shopify.get(resource: Products.self, request: dummyRequest)
			.then({ (products) -> EventLoopFuture<HTTPResponse> in
				
				XCTAssertGreaterThan(products.products.count, 0)
				expected.fulfill()

				return self.dummyRequest.future(HTTPResponse(status: .ok))
			})
		
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
		
		_ = try! shopify.post(resource: marketingEvent, request: dummyRequest).then({ (event) -> EventLoopFuture<HTTPResponse> in
			XCTAssertGreaterThan(event.id!, 0)
			expected.fulfill()
			
			return self.dummyRequest.future(HTTPResponse(status: .ok))
		})
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
}
