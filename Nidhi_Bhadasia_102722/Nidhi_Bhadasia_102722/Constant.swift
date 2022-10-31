//
//  Constant.swift
//  Nidhi_Bhadasia_102722
//
//  Created by Guest1 on 10/27/22.
//

import Foundation

struct Constant {
    
    static let AppName = "Employee Directory"
    static let API = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    static let malformedAPI = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    static let emptyEmployeeAPI = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"

    struct AlertMessage {
        static let emptyList = "The employee list is empty."
        static let urlNotFound = "The requested URL cannot be found."
    }
}
