import UIKit
import Alamofire
import SwiftyJSON

class TableViewCellRating : UITableViewCell{
    
    @IBOutlet weak var peroformanceLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var performanceLabel: UILabel!
    @IBAction func giveRating(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        performanceLabel.text = "\(currentValue)"
    }
}

class ColleagueRatingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ratingValues = [Int]()
    @IBOutlet weak var tableView: UITableView!
    var empId:Int = 0
    var colleagueId:Int = 0
    var sprintNo:Int = 0
    var colleagueNameField:String = ""
    var name: String = ""
    var projectId:Int = 0
    var position:String = ""
    
    var performanceArray = [String]()
    
    var colleagueDetails = [[String:AnyObject]]()
    
    @IBOutlet weak var colleagueName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        colleagueName?.text = "\(colleagueNameField)"
        
        
        AF.request(IP+"/getPerformanceFields").responseJSON{
            response in
            print(response)
            let swiftJson = JSON(response.data as Any)
            print(swiftJson["performance_columns"])
            self.performanceArray = swiftJson["performance_columns"].arrayValue.map {$0.stringValue}
            print(self.performanceArray)
            
            self.tableView.reloadData()
        }}
    
    var CollectionOfCell = [TableViewCellRating]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performanceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var st = self.performanceArray[indexPath.row].replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLabel1", for: indexPath) as! TableViewCellRating
        
        cell.peroformanceLabel?.text = st
        CollectionOfCell.append(cell)
        
        return cell
    }
    var val = "value"
    
    
    
    
    //get data from each cell and store the rating values in an array
    
    var arrData = [String]()
    var sendingArrayValues = [Int]()
    var i:Int = 0
    @IBAction func submitData(_ sender: UIButton) {
        CollectionOfCell.forEach { cell in
            arrData.append("\(cell.performanceLabel.text!)")
            print(cell.performanceLabel.text!)
            print("----------------------")
        }
        var boolVariable = true
        for p in 0..<performanceArray.count{
            if arrData[p] == ""{
                boolVariable = false
                print(boolVariable)
            }
        }
        
        if(boolVariable){
            
            for j in 0..<performanceArray.count{
                sendingArrayValues.append(Int(arrData[j])!)
                print("\(type(of: sendingArrayValues[j])) + \(sendingArrayValues[j])")
            }
            
            var parameters = [String:Int]()
            for k in 0..<performanceArray.count{
                parameters[performanceArray[k] as String] = Int(sendingArrayValues[k])
            }
            parameters["employeeId"] = empId
            parameters["collegueId"] = colleagueId
            parameters["sprint"] = sprintNo
            for (a,b) in parameters{
                print("\(a) : \(b)")
            }
            AF.request(IP+"/rateEmployee", method: .post, parameters: parameters).response(){ response in
                
                print("Values Inserted")
            }
            self.performSegue(withIdentifier: "submit1", sender: self)
           // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         //   let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
         //   nextViewControler.projectId = projectId
           // nextViewControler.name = name
            //nextViewControler.id = empId
            //self.navigationController?.pushViewController(nextViewControler, animated: true)
//            showToast(message: "You have successfully rated \(colleagueNameField) in the current sprint")
            //        self.present(nextViewControler, animated: true, completion: nil)
            print("Values are inserted")
            print(projectId,name,empId)
            
        }
        else{
            print("Values are being inserted")
            
            let alertController = UIAlertController(title: "Please rate all the fields", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
            self.present(alertController,animated: true)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! UITabBarController
       let dest = vc.viewControllers?[0] as! TestViewController
        let dest2 = vc.viewControllers?[1] as! ProfileViewController
        dest.id = empId
        dest.colleagueId = colleagueId
        dest.sprintNo = sprintNo
        dest.projectId = projectId
        dest.name = name
        
        dest2.projectId = projectId
        dest2.name = name
        dest2.id = empId
        dest2.position = position
        
//        dest.id = id
    }
    
    
}



