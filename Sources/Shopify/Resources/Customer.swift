//
//  Customer.swift
//  App
//
//  Created by David Muzi on 2019-01-30.
//

import Foundation

struct Customer: Decodable {
	var id: Int?
	let email: String
	let acceptsMarketing: Bool
	let firstName: String
	let lastName: String?
	
	enum CodingKeys: String, CodingKey {
		case email
		case acceptsMarketing = "accepts_marketing"
		case firstName = "first_name"
		case lastName = "last_name"
		case id
	}
}
