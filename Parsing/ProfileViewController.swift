//
//  ProfileViewController.swift
//  Parsing
//
//  Created by Apple on 22/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var bestSprint: Int = 1
    var worstSprint: Int = 1
    var projectId:Int = 0
    var id:Int = 0
    var managerId: Int = 0
    var manager: String = ""
    var name: String = ""
    var position: String = ""
    var ratinginspring = [[String:AnyObject]]()
    var overallrating: Double = 0
    var currentrating: Double = 0
    var bestrating: Double = 0
    var avgrating : Double = 0
    var worstrating: Double = 100
    var currentsprint: Int = 0
    var size1:Int = 0
    var performanceField = [String]()
    var i:Int = 0
    var selectedSprint: Int = 0
    var sprintarr = Array(repeating: 0, count: 100)
    var j:Double = 0.0
    
    @IBOutlet weak var best: UIButton!
    @IBOutlet weak var worst: UIButton!
    @IBOutlet weak var avg: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var managerName: UILabel!
    @IBOutlet weak var projectID: UILabel!
    @IBOutlet weak var EmpId: UILabel!
    @IBOutlet weak var EmpName: UILabel!
    @IBOutlet weak var role: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating labels in circle
        self.applyRoundCorner(best)
        self.applyRoundCorner(avg)
        self.applyRoundCorner(worst)
        role.text = self.position
        
//        self.bestLabel.clipsToBounds = true
//        self.bestLabel.layer.cornerRadius = self.bestLabel.font.pointSize * 10
//        self.bestLabel.backgroundColor = UIColor.white
//        self.bestLabel.textColor = UIColor.red
//        self.bestLabel.text = " 9.25 "
//        self.staticManagerFeild.layer.cornerRadius = 10
//        self.staticNameFeild.layer.cornerRadius = 10
//        self.staticProjectId.layer.cornerRadius = 10
//        self.staticProjectName.layer.cornerRadius = 10
//        self.staticRoleFeild.layer.cornerRadius = 10
//        self.nameLabel.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        
        picker.delegate = self
        picker.dataSource = self
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            print("Hi", self.projectId)
            AF.request(IP+"/getProjectInfo?projectId=\(self.projectId)").responseJSON{
                response in
                let swiftJson = JSON(response.data as Any)
                
                self.managerId = swiftJson["project"]["managerId"].intValue
                print("manager id",self.managerId)
                self.currentsprint = swiftJson["project"]["currentSprint"].intValue
                self.sprintarr = Array(repeating: 0, count: self.currentsprint)
                for j in 0..<self.currentsprint
                {
                    self.sprintarr[j] = j+1
                    print(self.sprintarr[j])
                }
                //     print(self.currentsprint)
                group.leave()
            }}
        group.enter()
        DispatchQueue.main.async {
            
            AF.request(IP+"/getPerformanceFields").responseJSON{
                response in
                //  print(response)
                let swiftJson = JSON(response.data as Any)
                
                self.performanceField = swiftJson["performance_columns"].arrayValue.map {$0.stringValue}}
            group.leave()
        }
        group.enter()
        DispatchQueue.main.async {
            AF.request(IP+"/AllEmployeePerformance?employeeId=\(self.id)").responseJSON{
                response in
                let swiftJson = JSON(response.data as Any)
                // print("AF")
                if let resData = swiftJson["performance"].arrayObject{
                    self.ratinginspring = resData as! [[String:AnyObject]]
                    self.size1 = self.ratinginspring.count
                    // print("current sprint", self.currentsprint, self.size1)
                    for index in 1...self.currentsprint
                    {   var i = 0.0
                        self.currentrating = 0.0
                        self.overallrating = 0.0
                        self.j = self.j + 1
                        //  print(self.size1,self.currentsprint)
                        for index2 in 0..<self.size1
                        {  // print(self.ratinginspring[index2]["sprint"] as! Int)
                            if index == self.ratinginspring[index2]["sprint"] as! Int{
                                // print("sprint",self.j)
                                i = i+1
                                self.currentrating = 0.0
                                for index3 in 0..<self.performanceField.count{
                                    self.currentrating += self.ratinginspring[index2][self.performanceField[index3]] as! Double}
                                
                                self.currentrating = self.currentrating/Double(self.performanceField.count)
                                print(self.currentrating)
                                self.overallrating = (self.overallrating + self.currentrating)
                                
                                
                            }}
                        self.overallrating = self.overallrating/i
                        print("sprint", self.j , "  ", self.overallrating)
                        self.avgrating = (self.avgrating + self.overallrating)
                        
                        
                        //   print("overallrating: ", self.overallrating )
                        
                        
                        if self.worstrating > self.overallrating
                        {
                            self.worstrating = self.overallrating
                            self.worstSprint = index
                        }
                        
                        
                        
                        
                        if self.bestrating < self.overallrating
                        {
                            self.bestrating = self.overallrating
                            self.bestSprint = index
                        }
                        
                    }
                    self.avgrating = self.avgrating/self.j
                    print("\(round(100*self.avgrating)/100)", "\(round(100*self.bestrating)/100)", "\(round(100*self.worstrating)/100)")
//                    self.avg.text = "\(round(100*self.avgrating)/100)"
//                    self.best.text = "\(round(100*self.bestrating)/100)"
//                    self.worst.text = "\(round(100*self.worstrating)/100)"
                }}
            group.leave()
        }
        // does not wait. But the code in notify() gets run
        // after enter() and leave() calls are balanced
        
        group.notify(queue: .main) {
            AF.request(IP+"/getEmployeeDetails?employeeId=\(self.managerId)").responseJSON{
                response in
                let swiftJson = JSON(response.data as Any)
                print(self.managerId)
                print(swiftJson)
                self.manager = swiftJson["employee"]["name"].stringValue
                print("manager name \(self.manager)")
                self.managerName?.text = "\(self.manager)"
                
            }
            self.EmpName?.text = "\(self.name)"
            self.EmpId?.text = "\(self.id)"
            self.projectID?.text = "\(self.projectId)"
            self.picker.reloadAllComponents()
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    //        return 1
    //    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentsprint
    }
    //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    //        return currentsprint
    //    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        i = i+1
        return "\(sprintarr[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSprint = picker.selectedRow(inComponent: 0)
    }
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        i = i+1
    //        return "\(i)"
    //    }
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //
    //        selectedSprint = picker.selectedRow(inComponent: 0)
    //    }
    
    
//    @IBAction func submit(_ sender: Any) {
//        print(selectedSprint+1,name,id )
//    }
    
    
    @IBAction func worstScoreDisplay(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Worst Score", message: "\(round(100*self.worstrating)/100) in sprint \(self.worstSprint)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
        self.present(alertController,animated: true)

        
    }
    
    @IBAction func avgScoreDisplay(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Average Score is \(round(100*self.avgrating)/100)", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
        self.present(alertController,animated: true)

        
    }
    @IBAction func bestScoreDisplay(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Best Score", message: "\(round(100*self.bestrating)/100) in sprint \(self.bestSprint)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
        self.present(alertController,animated: true)
        
    }
    @IBAction func submit(_ sender: Any) {
        print(selectedSprint+1,name,id )
        self.performSegue(withIdentifier: "getDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! EmployeeSprintPerformanceViewController
        vc.empId = id
        vc.empName = name
        vc.sprint = selectedSprint+1
        vc.empPosition = position
    }
    
    func applyRoundCorner(_ object: AnyObject){
        object.layer?.cornerRadius = (object.frame?.size.width)! / 2
        object.layer?.masksToBounds = true
    }
}
