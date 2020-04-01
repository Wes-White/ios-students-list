//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

enum TrackType: Int {
    case none
    case iOS
    case Web
    case UX
}

enum SortOptions: Int {
    case firstName
    case lastName
}


class StudentController {
    
    
    private var students: [Student] = []
    //created students private var how are we going to use it anywhere?
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    //passing in an optional array of students and an optional array to the closure. Since our closure is returning nothing we use Void or (). We have to have an return for closures. So must includ () or Void.
    func loadFromPersistentStore(completion: @escaping ([Student]?, Error?) -> Void) {
        
        //creating a background queue
        let bgQueue = DispatchQueue(label: "studentQueue", attributes: .concurrent)
        
        
        //putting everything into a backgroud queue
        bgQueue.async {
            let fm = FileManager.default
            //checking to see if our file has data or is nil
            guard let url = self.persistentFileURL,
                fm.fileExists(atPath: url.path) else { return }
            
            //creating/loading the Data object. Data requires us to use a try since it throws an error
            
            do {
                let data = try Data(contentsOf: url)
                //make a decoder
                let decoder = JSONDecoder()
                //decode the array of Students from the data we created above.
                let tempStudents = try decoder.decode([Student].self, from: data)
                //assign the new tempStudents array to our students array.
                self.students = tempStudents
                //everything worked properly. 
                completion(self.students, nil)
                
                //Deal with errors
            } catch {
                print("Error loading student data: \(error)")
                completion(nil, error)
            }
         }
        
    }
    
    func filter(with trackType: TrackType, sortedBy sorter: SortOptions, completion: @escaping ([Student]) -> Void ) {
        
        var updatedStudents: [Student]
        
        switch trackType {
        case .iOS:
            updatedStudents = students.filter { $0.course == "iOS" }
        case .Web:
            updatedStudents = students.filter { $0.course == "Web" }
        case .UX:
            updatedStudents = students.filter { $0.course == "UX" }
        default:
            //filter for none or anthing except cases above.
            updatedStudents = students
        }
        
        // if first element is less than second so A-Z order
        if sorter == .firstName {
            updatedStudents = updatedStudents.sorted {$0.firstName < $1.firstName }
        } else {
            
            updatedStudents = updatedStudents.sorted {$0.lastName < $1.lastName }
        }
        // let the ui know we are done by calling completion.
        completion(updatedStudents)
    }
    
}
