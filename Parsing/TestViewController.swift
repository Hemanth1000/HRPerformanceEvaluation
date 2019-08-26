import UIKit
import Alamofire
import SwiftyJSON

class TableViewCell : UITableViewCell{
    
    @IBOutlet weak var colleagues: UILabel!
    
}

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sprintNo:Int = 0
    var projectId:Int = 0
    var id:Int = 0
    var colleagueId:Int = 0
    var name: String = ""
    var userName: String = ""
    var position: String = ""
    var colleagueName:String = ""
//    var role:String = ""
    
    var employeeDetails = [[String:AnyObject]]()
    var projectDetails = [[String:AnyObject]]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var projectIdOutlet: UILabel!
    @IBOutlet weak var userNameOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        projectIdOutlet?.text = "\(projectId)"
        userNameOutlet?.text = "\(name)"
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated: true)
        
        //get project details
        AF.request(IP+"/getProjectInfo?projectId=\(projectId)").responseJSON{
            response in
            let swiftJson = JSON(response.data as Any)
            self.sprintNo = swiftJson["project"]["currentSprint"].intValue
            print(self.sprintNo)
            if let resData = swiftJson["project"].arrayObject{
                self.projectDetails = resData as! [[String:AnyObject]]
                self.tableView.reloadData()
            }
            
        }
        
        
        //get employee details
        AF.request(IP+"/DisplayData?projectId=\(projectId)").responseJSON{
            response in
            let swiftJson = JSON(response.data as Any)
            if let resData = swiftJson["employees"].arrayObject{
                
                self.employeeDetails = resData as! [[String:AnyObject]]
                for i in 0..<self.employeeDetails.count{
                    if self.employeeDetails[i]["name"] as? String == self.name{
                        self.employeeDetails.remove(at: i)
                        print(self.employeeDetails)
                        break
                    }
                }
                self.tableView.reloadData()
                
            }
            
        }}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeDetails.count
    }
    var deleteIndex:Int = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLabel", for: indexPath) as! TableViewCell
        if(name == self.employeeDetails[indexPath.row]["name"] as? String){
            //            deleteIndex = indexPath.row
        }else{
            cell.colleagues?.text = self.employeeDetails[indexPath.row]["name"] as? String
        }
        return cell
    }
    
    
    
    var check = [String:AnyObject]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        colleagueId = (self.employeeDetails[indexPath.row]["id"] as? Int)!
        //check if the employee is already rated in current sprint
        colleagueName = (self.employeeDetails[indexPath.row]["name"] as? String)!
        AF.request(IP+"/checkIfRated?employeeId=\(self.id)&colleagueId=\(self.colleagueId)&currentSprint=\(self.sprintNo)").responseJSON{
            response in
            let swiftJson = JSON(response.data as Any)
            var checkIf: Bool = true
            checkIf = swiftJson["isRated"].boolValue
            print(checkIf,self.id,self.colleagueId,self.sprintNo)
            if(!checkIf){
                self.performSegue(withIdentifier: "segue", sender: self)
            }else{
                let alertController = UIAlertController(title: "You have already rated the employee in the current sprint", message: "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
                self.present(alertController,animated: true)
            }
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ColleagueRatingViewController
        vc.empId = id
        vc.colleagueId = colleagueId
        vc.sprintNo = sprintNo
        vc.colleagueNameField = colleagueName
        vc.projectId = projectId
        vc.name = name
        vc.position = position
    }
    
}
