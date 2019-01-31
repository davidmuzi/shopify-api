//
//  Customer.swift
//  App
//
//  Created by David Muzi on 2019-01-30.
//

import Foundation

public struct Customer: Decodable {
	public var id: Int?
	public let email: String
	public let acceptsMarketing: Bool
	public let firstName: String
	public let lastName: String?
	
	enum CodingKeys: String, CodingKey {
		case email
		case acceptsMarketing = "accepts_marketing"
		case firstName = "first_name"
		case lastName = "last_name"
		case id
	}
}
