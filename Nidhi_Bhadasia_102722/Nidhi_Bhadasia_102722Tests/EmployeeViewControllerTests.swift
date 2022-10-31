//
//  EmployeeViewControllerTests.swift
//  Nidhi_Bhadasia_102722Tests
//
//  Created by Guest1 on 10/29/22.
//

import XCTest
@testable import Nidhi_Bhadasia_102722

class EmployeeViewControllerTests: XCTestCase {
    var employeeVC: EmployeeViewController!
    let indexPath = IndexPath(row: 0, section: 0)
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: EmployeeViewController = storyboard.instantiateViewController(withIdentifier: "EmployeeViewController") as! EmployeeViewController
        self.employeeVC = viewController
        self.employeeVC.loadView()
        self.employeeVC.arEmployee = [EmployeeModel(team: "Sales", employees: [.mocked, .mocked1]), EmployeeModel(team: "Retail", employees: [.mocked2])]
    }
    
    func testViewDidLoad() {
        self.employeeVC.viewDidLoad()
    }
    
    func testViewWillAppear() {
        self.employeeVC.viewWillAppear(true)
        self.employeeVC.addRefreshControl()
        XCTAssertTrue(self.employeeVC.responds(to: #selector(self.employeeVC.refreshEmployeeList)))
    }
    
    func testEmployeeAPI() throws {
        // given
        let urlString = Constant.API
        let promise = expectation(description: "Completion handler invoked")
        var response: [Employee]?
        var responseError: String?
        // when
        NetworkManager.shared.fetchEmployeeList(api: urlString) { employees, error in
            response = employees
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        // then
        XCTAssertNotNil(response)
        XCTAssertNil(responseError)
    }
    
    func testEmptyEmployeeAPI() throws {
        // given
        let urlString = Constant.emptyEmployeeAPI
        let promise = expectation(description: "Completion handler invoked")
        var response: [Employee]?
        var responseError: String?
        // when
        NetworkManager.shared.fetchEmployeeList(api: urlString) { employees, error in
            response = employees
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        // then
        XCTAssertNil(response)
        XCTAssertEqual(responseError, Constant.AlertMessage.emptyList)
    }
    
    func testVCHasIBOutlets() {
        XCTAssertNotNil(self.employeeVC.tableView)
        XCTAssertNotNil(self.employeeVC.spinner)
        XCTAssertNotNil(self.employeeVC.refreshCntl)
    }
    
    func testTableViewProtocols() {
        XCTAssertNotNil(self.employeeVC.tableView.dataSource)
        XCTAssertNotNil(self.employeeVC.tableView.delegate)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(self.employeeVC.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(self.employeeVC.responds(to: #selector(self.employeeVC.numberOfSections(in:))))
        XCTAssertTrue(self.employeeVC.responds(to: #selector(self.employeeVC.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(self.employeeVC.responds(to: #selector(self.employeeVC.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewConformsToTableViewDelegatProtocol() {
        XCTAssertTrue(self.employeeVC.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewCellHasReuseIdentifier() {
        let cell = self.employeeVC.tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath)
        let actualReuseIdentifer = cell.reuseIdentifier
        let expectedReuseIdentifier = "EmployeeTableViewCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testTableCellHasCorrectEmployeeInfo() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell: EmployeeTableViewCell = self.employeeVC.tableView(self.employeeVC.tableView, cellForRowAt: indexPath) as! EmployeeTableViewCell
        let employee = self.employeeVC.arEmployee[indexPath.section].employees[indexPath.row]
        XCTAssertEqual(cell.lblName.text, employee.name)
        XCTAssertEqual(cell.lblEmployeeType.text, employee.employeeType.type)
    }
    
    func testTableCellHasCorrectEmployeeInfo1() {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell: EmployeeTableViewCell = self.employeeVC.tableView(self.employeeVC.tableView, cellForRowAt: indexPath) as! EmployeeTableViewCell
        let employee = self.employeeVC.arEmployee[indexPath.section].employees[indexPath.row]
        XCTAssertEqual(cell.lblName.text, employee.name)
        XCTAssertEqual(cell.lblEmployeeType.text, employee.employeeType.type)
    }
    
    func testTableCellHasCorrectEmployeeInfo2() {
        let indexPath = IndexPath(row: 0, section: 1)
        let cell: EmployeeTableViewCell = self.employeeVC.tableView(self.employeeVC.tableView, cellForRowAt: indexPath) as! EmployeeTableViewCell
        let employee = self.employeeVC.arEmployee[indexPath.section].employees[indexPath.row]
        XCTAssertEqual(cell.lblName.text, employee.name)
        XCTAssertEqual(cell.lblEmployeeType?.text, employee.employeeType.type)
        XCTAssertEqual(cell.profileImage.image, UIImage(systemName: "person.fill"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.employeeVC = nil
        super.tearDown()
    }
}
