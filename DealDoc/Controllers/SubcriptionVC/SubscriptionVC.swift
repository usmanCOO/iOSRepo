//
//  SubscriptionVC.swift
//  DealDoc
//
//  Created by Asad Khan on 1/19/23.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import Alamofire

struct SubcriptionModel {
    var productId:String
    var productTitle:String
    var productPrice:String
}
class SubscriptionVC: UIViewController {

    var isSubscribed:Bool = false
    var subscriptionProducts = [SubcriptionModel]()
    var createPaymentObj =  AddSubscriptionResponse()
    var productIds = [String]()
    var products: [SKProduct]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productIds.removeAll()
               
        productIds.append("com.medpicc.dealDoc.monthlyprice1")
        subscriptionProducts = [.init(productId: "com.medpicc.dealDoc.monthlyprice1", productTitle: "DealDocMonthlyPrice1", productPrice: "6.99$")]
        PKIAPHandler.shared.setProductIds(ids: productIds)
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
                guard let sSelf = self else {return}
                   print(products)
            }

    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func termToUsePolicyButtonTapped (_ sender: UIButton) {
        let url: URL = URL(string: "https://admin.davidweisssales.com/termsofuse")!
        UIApplication.shared.open(url)
    }
    @IBAction func saveNowButtonTapped(_ sender: Any) {
        
        subscriptionProducts = [.init(productId: "com.medpicc.dealDoc.monthlyprice1", productTitle: "DealDocMonthlyPrice1", productPrice: "6.99$")]
        purchaseProduct(subscriptproduct: subscriptionProducts.first!)
        
        subscriptionProducts = [.init(productId: "1Day", productTitle: "OneDayPlan", productPrice: "$0.99")]
        purchaseProduct(subscriptproduct: subscriptionProducts.first!)
    }

    
    
    
    
    func createPayment() {
        guard let token  = UserDefaults.standard.string(forKey: "token")else {
            return
        }
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let bodyParameters:[String:Any] = ["status" :true,"duration": "20"]
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.addSubscription, method: .post, parameters: bodyParameters, encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
            case .success:
                let json = response.data
                print(response.result.value!)
                do{
                    let decoder = JSONDecoder()
                    self.createPaymentObj = try decoder.decode(AddSubscriptionResponse.self, from: json!)
                    if self.createPaymentObj.success ?? false{
                        PopupHelper.showToast(message: self.createPaymentObj.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            self.dismiss(animated: true)
                        }
                    }
                    else {
                        PopupHelper.showToast(message: self.createPaymentObj.message ?? "")
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



extension SubscriptionVC {
    
    func mapPeriodUnitToCalendarUnit(periodUnit: SKProduct.PeriodUnit) -> NSCalendar.Unit {
        switch periodUnit {
        case .day: return .day
        case .week: return .weekOfMonth
        case .month: return .month
        case .year: return .year
        @unknown default:
            fatalError("Unhandled case of SKProduct.PeriodUnit")
        }
    }
    
    func purchaseProduct(subscriptproduct:SubcriptionModel) {

        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        SwiftyStoreKit.retrieveProductsInfo([subscriptproduct.productId]) { result in
            if let product = result.retrievedProducts.first {
                        // Purchase the product
                        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                            switch result {
                            case .success(let purchase):
                                // Verify the purchase
                                PaymentManager.shared.verifyPurchase(productId: purchase.productId) { status in
                                    PopupHelper.ActivityIndicator.shared.removeSpinner()
                                    UserDefaults.standard.set(true, forKey: "isSubscribed")
                                    self.createPayment()
                                    self.createPaymentAndPostSubscriptionDetails(purchase: purchase, product: product)
//                                    // Extract values from the purchase object and product object
//                                    if let originalTransactionId = purchase.originalTransaction?.transactionIdentifier,
//                                       let subscriptionStartDate = purchase.originalTransaction?.transactionDate {
//                                        let productTitle = product.localizedTitle
//                                        let subscriptionPeriod = product.subscriptionPeriod
//
//                                        // Inside your purchaseProduct function
//                                        var subscriptionEndDate: Date?
//                                        if let numberOfUnits = subscriptionPeriod?.numberOfUnits,
//                                           let unit = subscriptionPeriod?.unit {
//                                            let calendarComponent: Calendar.Component
//                                            switch unit {
//                                            case .day: calendarComponent = .day
//                                            case .week: calendarComponent = .weekOfMonth
//                                            case .month: calendarComponent = .month
//                                            case .year: calendarComponent = .year
//                                            @unknown default:
//                                                fatalError("Unhandled case of SKProduct.PeriodUnit")
//                                            }
//
//                                            subscriptionEndDate = Calendar.current.date(byAdding: calendarComponent, value: numberOfUnits, to: subscriptionStartDate)
//                                        }
//
//
//                                        print("Original Transaction ID: \(originalTransactionId)")
//                                        print("Subscription Start Date: \(subscriptionStartDate)")
//                                        print("Platform Subscription Name: \(productTitle)")
//                                        if let endDate = subscriptionEndDate {
//                                            print("Subscription End Date: \(endDate)")
//                                        }
//                                    }
                                    
                                    // Dismiss the view controller after a short delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.dismiss(animated: true)
                                    }
                                }
                        print("Purchase Success: \(purchase.productId)")
                        print("Purchase Success: \(String(describing: purchase.originalTransaction?.transactionState))")
                    case .error(let error):
                        PopupHelper.ActivityIndicator.shared.removeSpinner()
                        switch error.code {
                        case .unknown:
                            PopupHelper.showToast(message: "Unknown error. Please contact support")
                            //alertWithMsg(vc: self, msg: "Unknown error. Please contact support", title: "Alert")
                        case .clientInvalid:
                            PopupHelper.showToast(message: "Not allowed to make the payment")
                            //alertWithMsg(vc: self, msg: "Not allowed to make the payment", title: "Alert")

                        case .paymentCancelled: break
                        case .paymentInvalid:
                            PopupHelper.showToast(message: "The purchase identifier was invalid")
                            //alertWithMsg(vc: self, msg: "The purchase identifier was invalid", title: "Alert")
                        case .paymentNotAllowed:
                            PopupHelper.showToast(message: "The device is not allowed to make the payment")
                           // alertWithMsg(vc: self, msg: "The device is not allowed to make the payment", title: "Alert")

                        case .storeProductNotAvailable:
                            PopupHelper.showToast(message: "The product is not available in the current storefront")
                           // alertWithMsg(vc: self, msg: "The product is not available in the current storefront", title: "Alert")

                        case .cloudServicePermissionDenied:
                            PopupHelper.showToast(message: "Access to cloud service information is not allowed")
                            //alertWithMsg(vc: self, msg: "Access to cloud service information is not allowed", title: "Alert")

                        case .cloudServiceNetworkConnectionFailed:
                            PopupHelper.showToast(message: "Could not connect to the network")
                            //alertWithMsg(vc: self, msg: "Could not connect to the network", title: "Alert")

                        case .cloudServiceRevoked:
                            PopupHelper.showToast(message: "User has revoked permission to use this cloud service")
                            //alertWithMsg(vc: self, msg: "User has revoked permission to use this cloud service", title: "Alert")
                            

                        default:
                            PopupHelper.showToast(message: (error as NSError).localizedDescription)
                            //alertWithMsg(vc: self, msg: (error as NSError).localizedDescription, title: "Alert")

                        }
                    }
                }
            }
        }
    }
    
    func createPaymentAndPostSubscriptionDetails(purchase: PurchaseDetails, product: SKProduct) {
        if let originalTransactionId = purchase.originalTransaction?.transactionIdentifier,
           let subscriptionStartDate = purchase.originalTransaction?.transactionDate,
           let subscriptionEndDate = calculateSubscriptionEndDate(from: subscriptionStartDate, product: product) {
            
            // Since localizedTitle is not an optional property, no need for conditional binding here
            let productTitle = product.localizedTitle
            print("Original Transaction ID: \(originalTransactionId)")
            print("Subscription Start Date: \(subscriptionStartDate)")
            print("Platform Subscription Name: \(productTitle)")
            print("Subscription End Date: \(subscriptionEndDate)")
            sendSubscriptionDetailsToAPI(originalTransactionId: originalTransactionId,
                                         subscriptionStartDate: subscriptionStartDate,
                                         subscriptionEndDate: subscriptionEndDate,
                                         productTitle: productTitle)
        }
    }
    func sendSubscriptionDetailsToAPI(originalTransactionId: String, subscriptionStartDate: Date, subscriptionEndDate: Date, productTitle: String) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formattedStartDate = dateFormatter.string(from: subscriptionStartDate)
        let formattedEndDate = dateFormatter.string(from: subscriptionEndDate)
        
        let bodyParameters: [String: Any] = [
            "originalTransactionId": originalTransactionId,
            "subscriptionStartDate": formattedStartDate,
            "subscriptionEndDate": formattedEndDate,
            "platformSubscriptionName": productTitle
        ]
        
        let apiUrl = "https://api.dealdoc.app/api/app/addsubscriptionrecord"
        
        Alamofire.request(apiUrl, method: .post, parameters: bodyParameters, encoding: JSONEncoding.default, headers: header).responseData { response in
            switch response.result {
            case .success:
                let json = response.data
                do {
                    let decoder = JSONDecoder()
                    let createPaymentObj = try decoder.decode(addReceiptResponse.self, from: json!)
                    if createPaymentObj.success ?? false {
                        PopupHelper.showToast(message: createPaymentObj.message ?? "")
                        print("RECEIPT ADDED SUCCESSFULLYs")
                    } else {
                        PopupHelper.showToast(message: createPaymentObj.message ?? "")
                    }
                } catch {
                    NSLog("Error in decoding JSON response: \(error)")
                }
            case .failure(let error):
                print("API Error: \(error.localizedDescription)")
                // Handle API error here
            }
        }
    }
    func calculateSubscriptionEndDate(from startDate: Date, product: SKProduct) -> Date? {
        guard let subscriptionPeriod = product.subscriptionPeriod else {
            return nil
        }

        let numberOfUnits = subscriptionPeriod.numberOfUnits
        let unit = subscriptionPeriod.unit

        var calendarComponent: Calendar.Component = .day

        switch unit {
        case .day: calendarComponent = .day
        case .week: calendarComponent = .weekOfMonth
        case .month: calendarComponent = .month
        case .year: calendarComponent = .year
        @unknown default:
            fatalError("Unhandled case of SKProduct.PeriodUnit")
        }

        return Calendar.current.date(byAdding: calendarComponent, value: numberOfUnits, to: startDate)
    }

    func handlePurchaseError(_ error: SKError) {
        PopupHelper.showToast(message: error.localizedDescription)
        switch error.code {
        case .paymentCancelled: break
        case .unknown, .clientInvalid, .paymentInvalid, .paymentNotAllowed, .storeProductNotAvailable,
             .cloudServicePermissionDenied, .cloudServiceNetworkConnectionFailed, .cloudServiceRevoked:
            PopupHelper.showToast(message: "Unknown error. Please contact support")
        @unknown default:
            PopupHelper.showToast(message: "Unknown error. Please contact support")
        }
    }
    
}


public extension SKProduct {
 
convenience init(identifier: String, price: String, priceLocale: Locale) {
 self.init()
 self.setValue(identifier, forKey: "productIdentifier")
 self.setValue(NSDecimalNumber(string: price), forKey: "price")
 self.setValue(priceLocale, forKey: "priceLocale")
 }
}


class addReceiptResponse : Codable {
    var message : String?
    var success : Bool?
    var Receipt : TransactionReceipt?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case Receipt = "Receipt"
    }
}

struct TransactionReceipt : Codable {
    
    let originalTransactionId       : String?
    let subscriptionStartDate       : String?
    let subscriptionEndDate         : String?
    let platformSubscriptionName    : String?

//    enum CodingKeys: String, CodingKey {
//
//        case originalTransactionId    = "originalTransactionId"
//        case subscriptionStartDate    = "subscriptionStartDate"
//        case subscriptionEndDate      = "subscriptionEndDate"
//        case platformSubscriptionName = "platformSubscriptionName"
//    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        originalTransactionId = try values.decodeIfPresent(Int.self, forKey: .originalTransactionId)
//        subscriptionStartDate = try values.decodeIfPresent(String.self, forKey: .subscriptionStartDate)
//        subscriptionEndDate = try values.decodeIfPresent(String.self, forKey: .subscriptionEndDate)
//        platformSubscriptionName = try values.decodeIfPresent(String.self, forKey: .platformSubscriptionName)
//    }

}
