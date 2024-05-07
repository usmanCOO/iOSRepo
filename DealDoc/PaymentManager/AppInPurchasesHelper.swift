//
//  AppInPurchasesHelper.swift
//  Heartzy
//
//  Created by waseeem on 1/16/23.
//

import Foundation
import StoreKit

enum PKIAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased
    
    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}


class PKIAPHandler: NSObject {
    
    //MARK:- Shared Object
    //MARK:-
    static let shared = PKIAPHandler()
    private override init() { }
    
    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = [String]()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductComplition: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductComplition: ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
    
    //MARK:- Public
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    //MARK:- Public
    
    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }

    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(product: SKProduct, complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
        
        self.purchaseProductComplition = complition
        self.productToPurchase = product

        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
        else {
            complition(PKIAPHandlerAlertType.disabled, nil, nil)
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
        
        self.fetchProductComplition = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(PKIAPHandlerAlertType.setProductIds.message)
            fatalError(PKIAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
//MARK:-
extension PKIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            if let complition = self.fetchProductComplition {
                complition(response.products)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let complition = self.purchaseProductComplition {
            complition(PKIAPHandlerAlertType.restored, nil, nil)
        }
    }
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    log("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let complition = self.purchaseProductComplition {
                        complition(PKIAPHandlerAlertType.purchased, self.productToPurchase, trans)
                        if let receiptURL = Bundle.main.appStoreReceiptURL,
                            let receiptData = try? Data(contentsOf: receiptURL) {
                            // Convert receipt data to a Base64 encoded string
                            let receiptString = receiptData.base64EncodedString()
                            
                            // Send the receiptString to your server for validation and processing
                            // You should implement server-side receipt validation for security.
                            // Do not handle sensitive data directly in the app.
                            
                            // Call a function to process the receipt and extract user details
                            processReceiptAndExtractUserDetails(receiptString)
                        }
                    }
                    break
                    
                case .failed:
                    log("Product purchase failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    log("Product restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let receiptURL = Bundle.main.appStoreReceiptURL,
                        let receiptData = try? Data(contentsOf: receiptURL) {
                        // Convert receipt data to a Base64 encoded string
                        let receiptString = receiptData.base64EncodedString()
                        
                        // Send the receiptString to your server for validation and processing
                        // You should implement server-side receipt validation for security.
                        // Do not handle sensitive data directly in the app.
                        
                        // Call a function to process the receipt and extract user details
                        processReceiptAndExtractUserDetails(receiptString)
                    }
                    break
                    
                default: break
                }}}
    }
    // Function to process transaction and receipt data
    private func processTransactionAndReceiptData(_ transaction: SKPaymentTransaction) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL),
              let product = productToPurchase else {
            // Unable to get receipt data or product information
            return
        }

        // Extract transaction details
        let transactionID = transaction.transactionIdentifier ?? ""
        let originalTransactionID = transaction.original?.transactionIdentifier ?? ""
        
        // Extract subscription period information
        let subscriptionPeriod = product.subscriptionPeriod
        
        // Calculate subscription end date based on the purchase date
        let purchaseDate = transaction.transactionDate ?? Date()
        let calendar = Calendar.current
        var subscriptionEndDate: Date?
        if let numberOfUnits = subscriptionPeriod?.numberOfUnits,
           let unit = subscriptionPeriod?.unit {
            // Map SKProduct.PeriodUnit to Calendar.Component
            var component: Calendar.Component = .day
            switch unit {
                case .day: component = .day
                case .week: component = .weekOfMonth
                case .month: component = .month
                case .year: component = .year
            }
            subscriptionEndDate = calendar.date(byAdding: component, value: numberOfUnits, to: purchaseDate)
        }
        
        // Extract platform subscription name from the product localized title
        let platformSubscriptionName = product.localizedTitle
        
        // Perform your desired operations with the extracted data
        performOperationsWithTransaction(transactionID: transactionID,
                                         originalTransactionID: originalTransactionID,
                                         subscriptionEndDate: subscriptionEndDate,
                                         platformSubscriptionName: platformSubscriptionName)

        // Convert receipt data to a Base64 encoded string
        let receiptString = receiptData.base64EncodedString()

        // Send the receiptString to your server for validation and processing
        processReceiptAndExtractUserDetails(receiptString)
    }
    
    private func performOperationsWithTransaction(transactionID: String,
                                                 originalTransactionID: String,
                                                 subscriptionEndDate: Date?,
                                                 platformSubscriptionName: String) {
        // Perform your custom operations with the extracted data
        print("Transaction ID: \(transactionID)")
        print("Original Transaction ID: \(originalTransactionID)")
        
        if let endDate = subscriptionEndDate {
            print("Subscription End Date: \(endDate)")
        }
        
        print("Platform Subscription Name: \(platformSubscriptionName)")
        // You can save these values to variables, databases, etc.
    }
    // Function to process receipt and extract user details
    private func processReceiptAndExtractUserDetails(_ receiptString: String) {
        // Send the receiptString to your server for receipt validation and processing
        // Implement server-side receipt validation to ensure security and extract user details
        
        // Example implementation (You should replace this with your own server-side code)
        // For demonstration purposes, we are simply printing the receiptString here.
        print("Receipt String: \(receiptString)")
    }

}
