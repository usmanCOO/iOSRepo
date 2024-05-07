//
//  ShareDealVC.swift
//  DealDoc
//
//  Created by Asad Khan on 10/12/22.
//

import UIKit
import Alamofire

class ShareDealVC: UIViewController, UITextViewDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var msgTextView: UITextView!
    var dealID : Int?
    var shareDealResponse: ShareDealResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTextView.delegate  = self
        msgTextView.text = "you can share deal details here \n *If the person you are sending this to doesn’t have DealDoc please ask them to download it.*Also, remember to change your email address in your profile to the correct one."
       
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == msgTextView {
        self.msgTextView.text = ""
       }
    }
    @IBAction func backButtonTapped (_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func saveButtonTapped (_ sender: UIButton) {
        if !emailTextField.text!.isEmpty  && !msgTextView.text!.isEmpty {
            saveSharedDeal(dealID: dealID,email: emailTextField.text ?? "", message : msgTextView.text ?? "")
        }else {
            PopupHelper.showToast(message: "Enter Email that you want to share deal with")
        }
    }
    
    func saveSharedDeal(dealID: Int?,email: String, message : String) {
        
        guard let token  = UserDefaults.standard.string(forKey: "token") , let dealID = dealID else {
            // Show Alert of Unknow Error
            return
        }

        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let param : [String: Any] = ["dealId" :dealID ,"email":email,"message":message]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.share_deal, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
            case .success(let data):
                print(String(data: data, encoding: .utf8)!)
                do{
                    let decoder = JSONDecoder()
                    self.shareDealResponse = try decoder.decode(ShareDealResponse.self, from: data)
                    if self.shareDealResponse?.status == false {
                        PopupHelper.showToast(message:  "User not found")
                    }
                    else {
                        PopupHelper.showToast(message: "Deal Successfully Shared")
                        self.dismiss(animated: true)
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
}
