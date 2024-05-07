//
//  ProfileVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/1/22.
//

import UIKit
import Alamofire
import SDWebImage
class ProfileVC: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userImagePickerButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var userResponse :LoginResponse?
    var userUpdateResponse :UpdateUserResponse?
    var selectedImage:UIImage?
    var isEditable: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        userImagePickerButton.addTarget(self, action: #selector(imagePicker(sender:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        
        if Connectivity.isConnectedToInternet() {
            getUserData()
        }else{
            PopupHelper.showToast(message: "No internet Connection")
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    func setupUI() {
        editButton.setTitle("Edit", for: .normal)
        titleLabel.text = "Profile"
        fullNameTextField.isEnabled = false
        phoneNoTextField.isEnabled = false
        companyNameTextField.isEnabled = false
        emailTextField.isEnabled =  false
        userImagePickerButton.isEnabled = false
        userImageView.image = selectedImage
    }
   
    @objc func imagePicker(sender: UIButton) {
        takePhoto(btn: sender)
    }
    @IBAction func deleteUserButtonTapped(sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete Account?", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            self.deleteUser()
            
        }))
        
    }
    @IBAction func updateUserButtonTapped(sender: UIButton) {
        sender.zoomInWithEasing()
        isEditable = true
        
        if isEditable {
            titleLabel.text = "Edit Profile"
            fullNameTextField.isEnabled = true
            phoneNoTextField.isEnabled = true
            companyNameTextField.isEnabled = true
            emailTextField.isEnabled =  true
            userImagePickerButton.isEnabled = true
            editButton.setTitle("Save", for: .normal)
            if (editButton.titleLabel?.text == "Save") {
                if fullNameTextField.text != "" || phoneNoTextField.text != "" || emailTextField.text != "" || !emailTextField.text!.isValidEmail() || companyNameTextField.text != "" {
                    updateUserData(email: emailTextField.text!, fullName: fullNameTextField.text!, phoneNo: phoneNoTextField.text!,company: companyNameTextField.text!)
                }
                else {
                    PopupHelper.showToast(message: "All Field are Required")
                }
            }else {
                print("")
            }
        }
    }
    func getUserData() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        DispatchQueue.main.async {
            PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        }
        Alamofire.request(URLPath.getUser, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            DispatchQueue.main.async {
                PopupHelper.ActivityIndicator.shared.removeSpinner()
            }
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    self.userResponse = try decoder.decode(LoginResponse.self, from: json!)
                    if self.userResponse?.success == false {
                            PopupHelper.showToast(message:  "Something wrong")
                    }
                    else {
                        DispatchQueue.main.async { [self] in
                            self.emailLabel.text           =  self.userResponse?.data?.email
                            self.emailTextField.text       = self.userResponse?.data?.email
                            self.fullNameLabel.text        = self.userResponse?.data?.fullName
                            self.fullNameTextField.text    =  self.userResponse?.data?.fullName
                            self.phoneNoTextField.text     = self.userResponse?.data?.phone_no
                            self.companyNameTextField.text = self.userResponse?.data?.company
                            print("\(BASEURL.profileImageUrl)\(self.userResponse?.data?.profilePhoto ?? "")")
                            let url = "\(BASEURL.profileImageUrl2)\(self.userResponse?.data?.profilePhoto ?? "")"
                           // self.userImageView.loadImage(url, .scaleAspectFill,(UIImage(named: "userPlaceholder-1"))!) {  (_, _, _) in
                           // }
//                            self.userImageView.sd_setImage(with: URL(string: "\(url.replacingOccurrences(of: " ", with: "%20"))"), placeholderImage: #imageLiteral(resourceName: "userPlaceholder-1"))
                            self.userImageView.sd_setImage(with: URL(string: "\(url.replacingOccurrences(of: " ", with: "%20"))"), placeholderImage: #imageLiteral(resourceName: "userPlaceholder-1"))
                        }
                    }
                    print(json ?? "Error")
                }
                catch(let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure:
                print("Data is not saved")
                
            }
        }
    }
    
    
    func deleteUser() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        DispatchQueue.main.async {
            PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        }
        Alamofire.request((URLPath.deleteuser), method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            DispatchQueue.main.async {
                PopupHelper.ActivityIndicator.shared.removeSpinner()
            }
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(LoginResponse.self, from: json!)
                    if resp.success ?? false{
                        PopupHelper.showToast(message: resp.message ?? "")
                        DealDocSessionManager.shared.removeUserData()
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let dashboardViewController = storyboard.instantiateViewController(identifier: "LoginVC")
                        UIApplication.shared.windows.first?.rootViewController = dashboardViewController
                    }else {
                        PopupHelper.showToast(message: resp.message ?? "")
                    }
                    print(resp)
                }
                catch {
                    print("JSON Error")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    func updateUserData(email: String ,fullName: String, phoneNo: String,company: String) {
        
        let bodyParameter:[String:Any]
        if email == userResponse?.data?.email{
            bodyParameter = ["fullName": fullName ,"phone_no" : Int(phoneNo) ?? 0,"company": company]
        }
        else{
            bodyParameter = ["email": email,"fullName": fullName ,"phone_no" : Int(phoneNo) ?? 0,"company": company]
        }
         
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
            "x-access-token": "\(token)"
        ]
        
        let url = URLPath.updateuser
        print(url)
        DispatchQueue.main.async {
            PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        }
        Alamofire.request(url, method: .put, parameters: bodyParameter , encoding: JSONEncoding.default, headers: header).responseData(completionHandler: {
            response in
            DispatchQueue.main.async {
                  PopupHelper.ActivityIndicator.shared.removeSpinner()
            }
            print(response.result)
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                self.uploadImage(Image: (self.selectedImage ?? UIImage(systemName: "person.circle"))!)
                do{
                    let decoder = JSONDecoder()
                    self.userUpdateResponse = try decoder.decode(UpdateUserResponse.self, from: json!)
                    if self.userUpdateResponse?.success == false {
                        PopupHelper.showToast(message: self.userUpdateResponse?.message ?? "")
                    }
                    else {
                        self.userResponse?.data = self.userUpdateResponse.map({$0.data!})
                        DealDocSessionManager.shared.saveUser(value:  self.userResponse?.data)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                                self.getUserData()
                        }
                        PopupHelper.showToast(message: self.userUpdateResponse?.message ?? "")
                        self.setupUI()
                    }
                    print(json ?? [])
                }
                catch DecodingError.keyNotFound(let key, let context) {
                    Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(let context) {
                    Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                } catch let error as NSError {
                    NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                }
            case .failure(let error):
                PopupHelper.showToast(message: "Data is not saved \(error.localizedDescription)")
            }
        })
    }
    
    
    func getTimeStampMili() -> Int{
        let currentTime = NSDate().timeIntervalSince1970 * 1000
        return Int(currentTime)
    }
    
    
    func uploadImage(Image: UIImage) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data;boundary=" + fileUploader.boundaryConstant
        ]
        
        let fileName = "img_\(self.getTimeStampMili()).jpeg"
        var files: KeyValuePairs <String , File> = [:]
        let file = File(image: Image, fileName: fileName)
        files = ["photo": file]
        fileUploader.uploadFiles(URLPath.uploadImage,headers: header, params: nil, files: files) { result in
            
            switch result {
            case .success(let  data):
                guard let jData = data as? Data else {
                    print("Type Does not matched")
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: jData, options: []) as? [String: Any] {
                        let success = json["status"] as? Bool
                        if success ?? false{
                            PopupHelper.showToast(message: "Image Saved Successfully")
                        }
                    }
                } catch (let error) {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                PopupHelper.showAlertControllerWithSuccessDismiss(Message: "Error while saving Data: \(error?.localizedDescription ?? "")", forViewController: self)
            case .none:
                break
            }
        }
    }
}

extension ProfileVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage =  image
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func hideKeyboardTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardd))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboardd() {
        view.endEditing(true)
    }
}

