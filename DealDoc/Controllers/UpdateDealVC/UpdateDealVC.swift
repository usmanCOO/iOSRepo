//
//  UpdateDealVC.swift
//  DealDoc
//
//  Created by Asad Khan on 11/8/22.
//


import UIKit
import Alamofire

protocol updateDealData: AnyObject {
    func updateDealNameData()
}
class UpdateDealVC: UIViewController , UITextFieldDelegate{
    
    var deal_ID: Int?
    var deal_Value: Int?
    var deal_Name: String?
    var closeDate: String?
    var createDealResponse: CreateDealResponse?
    @IBOutlet weak var updateDealTextField: UITextField!
    @IBOutlet weak var updateDealValueTextField: UITextField!
    @IBOutlet weak var updateCloseDateTextField: UITextField!
    var datePicker = UIDatePicker()
    var delegate : updateDealData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.updateDealValueTextField.delegate = self
        DispatchQueue.main.async {
            self.updateDealTextField.text = self.deal_Name ?? ""
            self.updateDealValueTextField.text = String(self.deal_Value?.delimiter ?? "")
            if  let close =  self.closeDate?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"){
                let formattedDate  = close.getFormattedDate(format: "MM/dd/yyyy")
                self.updateCloseDateTextField.text = formattedDate
            }
           
        }
        datePicker.datePickerMode = .dateAndTime
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
    @IBAction func closeDealButtonTapped (_ sender: UIButton) {
        // Create an alert controller with the date picker as the content view
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
         datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        alertController.view.addSubview(datePicker)
        
        // Add a "Done" button to the alert controller
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            // Handle the selected date and time
            let selectedDate = self.datePicker.date
            self.updateCloseDateTextField.text = selectedDate.toString(format: "MM/dd/yyyy HH:mm:ss")
            print("Selected date: \(selectedDate)")
        }))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func updateButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
        if !updateDealTextField.text!.isEmpty {
            
            let numberString = updateDealValueTextField.text
            let cleanedNumberString = numberString!.replacingOccurrences(of: ",", with: "")
            print(cleanedNumberString) // prints "1234567"
            
            if Connectivity.isConnectedToInternet() {
                updateDealName(deal_ID: deal_ID ?? 0, deal_name: updateDealTextField.text ?? "", deal_Value: Int(cleanedNumberString) ?? 0,closeDate: updateCloseDateTextField.text ?? "")
            }else{
                PopupHelper.showToast(message: "No internet Connection")
            }
           
        }else {
            PopupHelper.showToast(message: "Enter Deal Name")
        }
       
    }
    
    @IBAction func cancelButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
       // self.navigationController?.popViewController(animated: true)
            dismiss(animated: true)
    }
    
    
    
    func updateDealName(deal_ID: Int,deal_name: String,deal_Value:Int,closeDate: String) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let bodyParameters:[String:Any] = ["deal_name" :deal_name,"investment_size":deal_Value,"closed_date": closeDate]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request("\(URLPath.updateDeal)/\(deal_ID)", method: .patch, parameters: bodyParameters, encoding: JSONEncoding.default, headers: header).responseJSON {
            
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
                
            case .success:
                
                let json = response.data
                print(response.result.value!)
                
                do{
                    let decoder = JSONDecoder()
                    let dealResp = try decoder.decode(CreateDealResponse.self, from: json!)
                    if dealResp.success ?? false {
                        PopupHelper.showToast(message: dealResp.message ?? "")
                        self.delegate?.updateDealNameData()
                        self.dismiss(animated: true)
                    }else  {
                        PopupHelper.showToast(message: dealResp.message ?? "")
                    }
                }
                catch {
                    print("JSON Error")
                }
            case .failure(let error):
                print("Data is not saved \(error.localizedDescription)")
                
            }
        }
        
    }
}
