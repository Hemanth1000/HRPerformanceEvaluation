//
//  EmployeeSprintPerformanceViewController.swift
//  Parsing
//
//  Created by Apple on 22/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import QuartzCore

class Table: TableViewCell {
    
    
    @IBOutlet weak var columnName: UILabel!
    @IBOutlet weak var rating: UILabel!
    
}

class EmployeeSprintPerformanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var empName:String = ""
    var empId:Int = 0
    var empPosition:String = ""
    var sprint:Int = 0
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var position: UILabel!
    
    @IBOutlet weak var staticNameField: UILabel!
    @IBOutlet weak var staticIdField: UILabel!
    @IBOutlet weak var staticPositionField: UILabel!
    
    var columns = [[String:AnyObject]]()
    var performanceFieldsArray = [String]()
    var dict = [String:AnyObject]()
    var keyArray = [String]()
    var valArray = Array(repeating: 0, count: 100)
    var n:Int = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("in display", empName, empId, sprint)
        
        self.name.text = "\(empName)"
        self.id.text = "\(empId)"
        self.position.text = "\(empPosition)"
        self.staticNameField.layer.cornerRadius = 15
        self.staticIdField.layer.cornerRadius = 15
        self.staticPositionField.layer.cornerRadius = 15
        
        self.name.layer.cornerRadius = 15
        self.id.layer.cornerRadius = 15
        self.staticNameField.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        
        AF.request(IP+"/getPerformanceFields").responseJSON{
            response in
//            print(response)
            let swiftJson = JSON(response.data as Any)
            //                    print(swiftJson["performance_columns"])
            self.keyArray = swiftJson["performance_columns"].arrayValue.map {$0.stringValue}
            print("inside key alamofire")
            print(self.keyArray)
            print("================================================")
        
        
    AF.request(IP+"/displayEmployeePerformance?employeeId=\(self.empId)&sprint=\(self.sprint)").responseJSON{
            response in
            let swiftJson = JSON(response.data as Any)
            if let resData = swiftJson["performance"].arrayObject{
                
                self.columns = resData as! [[String:AnyObject]]
                print(self.columns)
                self.n = self.columns.count
                
                self.keyArray = self.keyArray.filter{$0 != "collegueId"}
                self.keyArray = self.keyArray.filter{$0 != "employeeId"}
                self.keyArray = self.keyArray.filter{$0 != "sprint"}
                print(self.keyArray)
                var s:String = ""
                var value:Int = 0
                var valueArray = Array(repeating: 0, count: self.keyArray.count)
                
                for i in 0..<self.keyArray.count{
                    s = self.keyArray[i]
                    for j in 0..<self.columns.count{
                        value = self.columns[j][s] as! Int
                       // print(valueArray[i])
                        valueArray[i] += value
                    };//print("\(s) \(value)")
                    
                }
                
                print("=======================================")
                for i in 0..<self.keyArray.count{
                    print("\(self.keyArray[i])  \(valueArray[i])")
                    
                    self.keyArray[i] = self.keyArray[i].replacingOccurrences(of: "_", with: " ", options: .literal, range: nil).prefix(1).uppercased() + String(self.keyArray[i].dropFirst())
                    self.valArray[i] = valueArray[i]
                }
                self.tableView.reloadData()
                
            }
            print(self.n)
            }}}
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLabel2", for: indexPath) as! Table
        cell.columnName?.text = self.keyArray[indexPath.row].replacingOccurrences(of: "_", with: " ", options: .literal, range: nil) //+ String(self.keyArray[indexPath.row].dropFirst()
        if self.valArray[indexPath.row] != 0{
            cell.rating?.text = "\(self.valArray[indexPath.row]/(n))"
        }
        return cell
    }


}
