//
//  HomeVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/1/22.
//

import UIKit
import Alamofire

class HomeVC: UIViewController,UITextFieldDelegate {
    
    var isSubs : Bool = false
    var createDealResponse: CreateDealResponse?
    var subscriptionData = GetSubscriptionResponse()
    
    var get_DealStatus = GetDealStatus()
    
    @IBOutlet weak var createDealTextField: UITextField!
    @IBOutlet weak var investmentDealTextField: UITextField!
    @IBOutlet weak var closeDateTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    var datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.investmentDealTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        datePicker.datePickerMode = .date
    }
    
    
    let isSubscribed = UserDefaults.standard.bool(forKey: "isSubscribed")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyFields()
        getDealsStatus()
        
        if subscriptionData.success == true {
            getSubscriptionData2()
        } else {
            getSubscriptionData2()
        }
    }
    
    func emptyFields() {
        createDealTextField.text?.removeAll()
        investmentDealTextField.text?.removeAll()
        closeDateTextField.text?.removeAll()
    }
    
    
    func getDealsStatus() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        DispatchQueue.main.async {
            PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        }
       let urlString =  "\(URLPath.deal_Status)"
       
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
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
                    let dealResp = try decoder.decode(GetDealStatus.self, from: json!)
                    self.get_DealStatus = dealResp
                }
                catch (let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                }
               
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    func createDeal(dealName: String?, deal_size: Int) {
        
        guard let token  = UserDefaults.standard.string(forKey: "token"), let dealName = dealName else {
            // Show Alert of Unknow Error
            return
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let bodyParameters:[String:Any] = ["deal_name" :dealName,"investment_size": deal_size , "status":"Active","closed_date": closeDateTextField.text ?? ""]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.create_deal, method: .post, parameters: bodyParameters, encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    self.createDealResponse = try decoder.decode(CreateDealResponse.self, from: json!)
                    if self.createDealResponse?.success == false {
                        PopupHelper.showToast(message: self.createDealResponse?.message ?? "")
                    }
                    else {
                        self.emptyFields()
                        // DealDocSessionManager.shared.saveUser(value: self.createDealResponse)
                        let dateString : String = self.createDealResponse?.data?.createdAt ?? ""
                        let fulldate = dateString.components(separatedBy: "T")
                        
                        var dateNew: String = fulldate[0]
                        var timeNew: String = fulldate[1]
                        print("The New Time is ",timeNew)
                        if  let date =  self.createDealResponse?.data?.createdAt?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                            print(date)
                            let formattedDate  = date.getFormattedDate(format: "MM/dd/yyyy")
                            let formattedTime = date.formattedWith("hh:mm a")
                            print(formattedDate,formattedTime)
                        }
                        PopupHelper.showToast(message: self.createDealResponse?.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DealMenuVC") as! DealMenuVC
//                            vc.dealName = dealName
//                            vc.dealID = self.createDealResponse?.data?.id
//                            self.navigationController?.pushViewController(vc, animated: true)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "YourDealVC") as! YourDealVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
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
                print("Data is not saved \(error.localizedDescription)")
            }
        })
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        // Get the new text that would result from the replacement
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Limit the text field to a maximum of 12 characters
        let maxLength = 11
        let newLength = newText.count
        if newLength > maxLength {
            return false
        }
        
        // Add commas after every three digits
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let formattedNumber = formatter.number(from: newText.replacingOccurrences(of: ",", with: "")) {
            textField.text = formatter.string(from: formattedNumber)
        } else {
            textField.text = newText
        }
        
        return false
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        let formatter = NumberFormatter()
    //        formatter.numberStyle = .decimal
    //        var text = textField.text ?? ""
    //        text = (text as NSString).replacingCharacters(in: range, with: string)
    //        text = text.replacingOccurrences(of: ",", with: "")
    //        if let number = formatter.number(from: text) {
    //            text = formatter.string(from: number) ?? ""
    //        }
    //        textField.text = text
    //        return self.textLimit(existingText: textField.text,newText: string,limit: 8)
    //    }
    //
    //    private func textLimit(existingText: String?,newText: String,limit: Int) -> Bool {
    //        let text = existingText ?? ""
    //        let isAtLimit = text.count + newText.count <= limit
    //        return isAtLimit
    //    }
    
    
    @IBAction func closeDealButtonTapped (_ sender: UIButton) {
        
        calendarView.isHidden = false
        // Create an alert controller with the date picker as the content view
        //        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        //         datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        //        alertController.view.addSubview(datePicker)
        //
        //        // Add a "Done" button to the alert controller
        //        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
        //            // Handle the selected date and time
        //            let selectedDate = self.datePicker.date
        //            self.closeDateTextField.text = selectedDate.toString(format: "MM/dd/yyyy HH:mm:ss")
        //            print("Selected date: \(selectedDate)")
        //        }))
        //
        //        // Present the alert controller
        //        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped (_ sender: UIButton) {
        let selectedDate = self.datePickerView.date
        self.closeDateTextField.text = selectedDate.toString(format: "MM/dd/yyyy")
        print("Selected date: \(selectedDate)")
        DispatchQueue.main.async {
            self.calendarView.isHidden = true
        }
    }
    
    
    //MARK: showSubscriptionScreen
    func showSubscriptionScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    //MARK: Subscription true or false
    func getSubscriptionData() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        print(header)
        
        let url = URLPath.getSubscription
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let subsResp = try decoder.decode(GetSubscriptionResponse.self, from: json!)
                    self.subscriptionData = subsResp
                    print(self.subscriptionData.subscriptionended ?? false)
                    if self.subscriptionData.message == "Subscription record not found" || self.subscriptionData.message == "User subscription is ended"{
                        self.showSubscriptionScreen()
                    }else {
                        print(self.subscriptionData.message ?? "")
                    }
                }
                catch (let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    func getSubscriptionData2() {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        //client's token
//        let header: HTTPHeaders = [
//            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InVzZXJJZCI6NTF9LCJpYXQiOjE2ODkwNjEwOTcsImV4cCI6MTY5NDI0NTA5N30.iz9V0XQL35FqmosNlMIlbCo1ZSoYOw1om_hCXd34j30",
//            "Content-Type": "application/json"
//        ]
        print(header)
        
        let url = URLPath.getSubscription
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
                
            case .success:
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let subsResp = try decoder.decode(GetSubscriptionResponse.self, from: json!)
                    self.subscriptionData = subsResp
                    print(self.subscriptionData.subscriptionended ?? false)
                    if self.subscriptionData.message == "Subscription record not found" {
                       // self.showSubscriptionScreen()
                    }else {
                        print(self.subscriptionData.message ?? "")
                    }
                }
                catch (let error){
                    print("JSON Error \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    
    @IBAction func createDealButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        
        let numberString = investmentDealTextField.text
        let cleanedNumberString = numberString!.replacingOccurrences(of: ",", with: "")
        print(cleanedNumberString) // prints "1234567"
        
        
        if createDealTextField.text != "" && cleanedNumberString != ""  && closeDateTextField.text != ""{
            if Connectivity.isConnectedToInternet(){

                if get_DealStatus.success == true {
                    createDeal(dealName: createDealTextField.text!, deal_size: Int(cleanedNumberString) ?? 0)
                } else if get_DealStatus.success == false {
                    if subscriptionData.success == true {
                        createDeal(dealName: createDealTextField.text!, deal_size: Int(cleanedNumberString) ?? 0)
                    } else {
                        print("Please get subscription")
                        self.getSubscriptionData()
                    }
                } else {
                    self.getSubscriptionData()
                }
                
                
//                if  get_DealStatus.success == true
//                {
//                    createDeal(dealName: createDealTextField.text!,deal_size: Int(cleanedNumberString) ?? 0)
//                }
//                else if get_DealStatus.success == false
//                {
//                    if subscriptionData.success == true
//                    {
//                        createDeal(dealName: createDealTextField.text!,deal_size: Int(cleanedNumberString) ?? 0)
//                    }
//                    else
//                    {
//                        print("please get subscription")
//                        self.getSubscriptionData()
//                    }
//                    //self.getSubscriptionData()
//                }
//                else
//                {
//                    self.getSubscriptionData()
//                }
   
                
            }else{
                PopupHelper.showToast(message: "No internet Connection")
            }
        }else {
            if createDealTextField.text == "" {
                PopupHelper.showToast(message: "Enter Deal Name")
            }else if investmentDealTextField.text == ""{
                PopupHelper.showToast(message: "Enter investment Amount")
            }else{
                PopupHelper.showToast(message: "Enter Close Date")
            }
            
        }
    }
}
