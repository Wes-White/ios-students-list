//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let studentController = StudentController()
    private var filteredAndSortedStudents: [Student] = [] {
        //property observere. So everytime this code changes run this code inside the didSet
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        studentController.loadFromPersistentStore { (students, error) in
            if let error = error {
                NSLog("Error Loading Students: \(error)")
                return
            }
            // take the array of students and assign them to our filteredAndSortedStudents array. Using DispatchQueue main because we have to bring this back to the main queue in order to show it via the uI.
            DispatchQueue.main.async {
                if let students = students {
                    self.filteredAndSortedStudents = students
                }
            }
         }
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        
    }
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = filteredAndSortedStudents[indexPath.row]
        // Configure cell
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.course
        
        return cell
    }
}
