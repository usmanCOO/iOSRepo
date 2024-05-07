//
//  SharedDealAnalysisVC.swift
//  DealDoc
//
//  Created by Asad Khan on 4/20/23.
//

import UIKit

class SharedDealAnalysisVC: UIViewController {
    
    var deal_Value: Int?
    var deal_Name: String?
    var closeDate: String?
    var updatedDate: String?
    var sharedBYMe: String?
    var sharedWithMe: String?
    
    @IBOutlet weak var dealNameTextField: UITextField!
    @IBOutlet weak var dealValueTextField: UITextField!
    @IBOutlet weak var closeDateTextField: UITextField!
    @IBOutlet weak var updatedDateTextField: UITextField!
    @IBOutlet weak var sharedDealWithMeTextField: UITextField!
    @IBOutlet weak var sharedDealByMeTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
       
        DispatchQueue.main.async {
            self.dealNameTextField.text = self.deal_Name ?? ""
            self.dealValueTextField.text = "$\(self.deal_Value?.delimiter ?? "")"
            if  let close =  self.closeDate?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"), let updated = self.updatedDate?.getDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"){
                let formattedCloseDate  = close.getFormattedDate(format: "MM/dd/yyyy")
                let formattedUpdatedDate  = updated.getFormattedDate(format: "MM/dd/yyyy")
                self.closeDateTextField.text = "Closed Date: \(formattedCloseDate)"
                self.updatedDateTextField.text = "Updated Date: \(formattedUpdatedDate)"
            }
            self.sharedDealWithMeTextField.text = "Deal Shared With: \(self.sharedWithMe ?? "NA")"
            self.sharedDealByMeTextField.text   = "Deal Shared By: \(self.sharedBYMe ?? "NA")"
           
        }
       
    }
        
    @IBAction func cancelButtonTapped (_ sender: UIButton) {
        sender.zoomInWithEasing()
       // self.navigationController?.popViewController(animated: true)
            dismiss(animated: true)
    }

}
