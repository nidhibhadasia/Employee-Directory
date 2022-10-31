//
//  Empolyee.swift
//  Nidhi_Bhadasia_102722
//
//  Created by Guest1 on 10/27/22.
//

import Foundation

struct Employee: Codable, Equatable, Hashable, Identifiable {
    let id: String
    let name: String
    let phoneNumber: String?
    let email: String?
    let bio: String?
    let photoURLSmall: String?
    let photoURLLarge: String?
    let team: String
    let employeeType: EmployeeType
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name = "full_name"
        case phoneNumber = "phone_number"
        case email = "email_address"
        case bio = "biography"
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case team
        case employeeType = "employee_type"
    }
}

extension Employee {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
        self.email = try? container.decode(String.self, forKey: .email)
        self.bio = try? container.decode(String.self, forKey: .bio)
        self.photoURLSmall = try? container.decode(String.self, forKey: .photoURLSmall)
        self.photoURLLarge = try? container.decode(String.self, forKey: .photoURLLarge)
        self.team = try container.decode(String.self, forKey: .team)
        self.employeeType = try container.decode(EmployeeType.self, forKey: .employeeType)
    }
}

enum EmployeeType: String, Codable, Equatable, Hashable {
    case FULLTIME = "FULL_TIME"
    case PARTTIME = "PART_TIME"
    case CONTRACTOR = "CONTRACTOR"
    
    var type: String {
        switch self {
        case .FULLTIME:
            return "Full Time"
        case .PARTTIME:
            return "Part Time"
        case .CONTRACTOR:
            return "Contractor"
        }
    }
}

struct EmployeeModel {
    var team: String
    var employees: [Employee]
}

extension Employee {
    static var mocked: Employee {
        return Employee(
            id: "0d8fcc12-4d0c-425c-8355-390b312b909c",
            name: "Eric Rogers",
            phoneNumber: "5553280123",
            email: "jmason.demo@squareup.com",
            bio: "Engineer on the Point of Sale team.",
            photoURLSmall: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
            photoURLLarge: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",
            team: "Sales",
            employeeType: .FULLTIME
        )
    }
    
    static var mocked1: Employee {
        return Employee(
            id: "0d8fcc12-4d0c-425c-8355-390b312b909c",
            name: "Richard Stein",
            phoneNumber: "5553280123",
            email: "richard.stein@squareup.com",
            bio: "Product manager for the Point of sale app",
            photoURLSmall: "https://s3.amazonaws.com/sq-mobile-interview/photos/43ed39b3-fbc0-4eb8-8ed3-6a8de479a52a/small.jpg",
            photoURLLarge: "https://s3.amazonaws.com/sq-mobile-interview/photos/43ed39b3-fbc0-4eb8-8ed3-6a8de479a52a/large.jpg",
            team: "Sales",
            employeeType: .PARTTIME
        )
    }
    
    static var mocked2: Employee {
        return Employee(
            id: "61b21d34-5499-401a-98b3-16f26e645d54",
            name: "Alaina Daly",
            phoneNumber: "5553280123",
            email: "alaina.daly@squareup.com",
            bio: "Product marketing manager for the Retail Point of Sale app in New York",
            photoURLSmall: nil,
            photoURLLarge: nil,
            team: "Retail",
            employeeType: .CONTRACTOR
        )
    }
}
