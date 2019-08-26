import UIKit
import Alamofire
import SwiftyJSON
import QuartzCore
var IP1:String = "https://ancient-peak-62543.herokuapp.com"
var IP:String = "http://172.20.0.142:9920"
class LoginController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIColor borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        
        userName.layer.cornerRadius = 10
        userPassword.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        userName.layer.borderWidth = 1
        userName.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        userPassword.layer.borderWidth = 1
        userPassword.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        let backgroundImage = UIImage.init(named: "login3")
        let backgroundImageView = UIImageView.init(frame: self.view.frame)
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.5
        
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    var pid:Int = 0
    var name:String = ""
    var id:Int = 0
    var position:String = ""
    @IBAction func login(_ sender: Any) {
        let user = self.userName.text!
        let pass = self.userPassword.text!
        print(user)
        print(pass)
        var status:Int?
//        var empData:String = ""
        AF.request(IP+"/login", method: .post, parameters: ["username":user,"password":pass]).responseJSON{response in
            print(response)
            let swiftJson = JSON(response.data as Any)
            print(swiftJson)
            print("Your employee Id \(swiftJson["employee"]["id"].intValue)")
//            empData = swiftJson["employee"].stringValue
            status = swiftJson["status"].intValue
//            print(type(of:status))
            print("new ",status)
            let code:Int = 200
            if(status==code){
//                print("into if")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
                //                let next = self.storyboard?.instantiateInitialViewController()
                self.pid = swiftJson["employee"]["projectId"].intValue
                self.name = swiftJson["employee"]["name"].stringValue
                self.id = swiftJson["employee"]["id"].intValue
                self.position = swiftJson["employee"]["position"].stringValue
                self.performSegue(withIdentifier: "loginsegue", sender: self)
//                self.navigationController?.pushViewController(nextViewControler, animated: true)
                //                self.present(nextViewControler, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Enter Valid UserName", message: "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
                self.present(alertController,animated: true)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UITabBarController
        let dest = vc.viewControllers?[0] as! TestViewController
        let dest2 = vc.viewControllers?[1] as! ProfileViewController
        
        dest.projectId = pid
        dest.name = name
        dest.id = id
        dest.position = self.position
        
        dest2.projectId = pid
        dest2.name = name
        dest2.id = id
        dest2.position = self.position
    }
    }

//     ------------------------------------------------------------------------------------------------

//
//    let user = self.userName.text!
//    let pass = self.userPassword.text!
//    let url = URL(string: "http://localhost:8088/login?user=\(user)&pass=\(pass)")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//    let task = URLSession.shared.dataTask(with: request) {data, response, error in
//
//        guard let data = data,
//            let response = response as? HTTPURLResponse,
//            error == nil else {                        // check for fundamental networking error
//                print("error", error ?? "Unknown error")
//                return
//        }
//        guard (200 ... 299) ~= response.statusCode else {             // check for http errors
//            print("statusCode should be 2xx, but is \(response.statusCode)")
//            print("response = \(response)")
//            return
//        }
//
//        let responseString = String(data: data, encoding: .utf8)
//        if response.statusCode == 200{
//            //                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            //                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "EmployeeDataViewController") as! EmployeeDataViewController
//            //                self.present(nextViewControler, animated: true, completion: nil)
//            print("responseString = \(response.statusCode)")
//        }
//
//    }
//    task.resume()
//

//    ------------------------------------------------------------------------------------------------



//    @IBAction func loginButton(_ sender: Any) {


//        let urlPath = URL(string: "http://localhost:8082/validate?user=\(user)&password=\(pass)")

//validate here





//            if let httpResponse = response as? HTTPURLResponse {
//                print("statusCode: \(httpResponse.statusCode)")
//                if httpResponse.statusCode == 200{
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "EmployeeDataViewController") as! EmployeeDataViewController
//                    self.present(nextViewControler, animated: true, completion: nil)
//                    print("statusCode: \(httpResponse.statusCode)")
//
//                }
//
//            }else{
//            let alertController = UIAlertController(title: "Alert", message: "Error", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: nil))
//            self.present(alertController,animated: true)
//        }
//        }
//        task.resume()



