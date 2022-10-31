//
//  EmployeeViewController.swift
//  Nidhi_Bhadasia_102722
//
//  Created by Guest1 on 10/27/22.
//

import UIKit
import SwiftUI

class EmployeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let imageCache = NSCache<NSString, UIImage>()
    
    let refreshCntl = UIRefreshControl()
    var arEmployee = [EmployeeModel]() {
        didSet{
            DispatchQueue.main.async {
                // Reload table when array is set
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup view
        self.title = Constant.AppName
        self.view.backgroundColor = .systemGroupedBackground
        self.fetchEmployeeList(api: Constant.API)
        self.addRefreshControl()
    }
    
    // MARK: - Custom functions
    func addRefreshControl() {
        // Add Refresh Control to Table view
        self.tableView.refreshControl = refreshCntl
        self.refreshCntl.addTarget(self, action: #selector(refreshEmployeeList(_:)), for: .valueChanged)
    }
    
    func showSpinner() {
        // Show spinner
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            // Hide spinner
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            self.refreshCntl.endRefreshing()
        }
    }
    
    func showAlertWithMessage(alertMessage:String)  {
        //Handling error scanario by showing alert message
        let alert = UIAlertController(title: Constant.AppName, message: alertMessage, preferredStyle:.alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshEmployeeList(_ sender: Any) {
        //Get fresh data from API
        self.arEmployee.removeAll()
        self.fetchEmployeeList(api: Constant.API)
    }
    
    @IBSegueAction func showSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        //Load SwiftUI View
        guard let section = tableView.indexPathForSelectedRow?.section else { return nil }
        guard let row = tableView.indexPathForSelectedRow?.row else { return nil }
        let rootView = EmployeeDetailSwiftUIView(employee: arEmployee[section].employees[row])
        return UIHostingController(coder: coder, rootView: rootView)
    }
    
    // MARK: - API call
    func fetchEmployeeList(api: String) {
        // call API to fetch Employee List
        self.showSpinner()
        NetworkManager.shared.fetchEmployeeList(api: api) { [weak self] (arEmployeeList, error) in
            guard let self = self else {
                return
            }
            self.hideSpinner()
            if let arEmployeeList = arEmployeeList {
                let dictEmployee = Dictionary(grouping: arEmployeeList, by: { $0.team })
                for (key, value) in dictEmployee {
                    let value = value.sorted { $0.team < $1.team }
                    self.arEmployee.append(EmployeeModel(team: key, employees: value))
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showAlertWithMessage(alertMessage: error ?? "Something went wrong. Plese try again")
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arEmployee[section].team
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arEmployee.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arEmployee[section].employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        // Configure the cell...
        let employee = arEmployee[indexPath.section].employees[indexPath.row]
        cell.lblName.text = employee.name
        cell.lblEmployeeType.text = employee.employeeType.type
        if let url = employee.photoURLSmall {
            cell.profileImage.fetchEmployeeImage(withUrl: url)
        } else {
            cell.profileImage.image = UIImage(systemName: "person.fill")
        }
        cell.profileImage.layer.borderColor = UIColor.black.cgColor
        cell.profileImage.layer.borderWidth = 1.0
        cell.profileImage.clipsToBounds = true
        cell.profileImage.layer.cornerRadius = 30
        return cell
    }
}
