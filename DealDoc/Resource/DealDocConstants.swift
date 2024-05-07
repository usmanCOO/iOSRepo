//
//  Meddpicc AppConstants.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/6/22.
//

import Foundation
import Alamofire

struct BASEURL {
    // https://api.dealdoc.app/api
    //https://api.davidweisssales.com/api/
    //https://api.dealdoc.app//Images/
    
    static let ImageUrl        = "https://api.dealdoc.app//Images/"
    static let profileImageUrl = "https://api.dealdoc.app/api/"
    
    static let profileImageUrl2 = "https://admin.dealdoc.app/"
    static let url             = "https://api.dealdoc.app/api/"
    static let adminUrl        = "https://admin.davidweisssales.com/api/"
    
    
//    static let ImageUrl        = "https://admin.davidweisssales.com/Images/"
//    static let profileImageUrl = "https://admin.davidweisssales.com/"
//    static let url             = "https://api.davidweisssales.com/api/"
//    static let adminUrl        = "https://admin.davidweisssales.com/api/"
}

struct URLPath {
    
    static let applesignin                  = "\(BASEURL.url)auth/applesignin"
    static let updateuser                   = "\(BASEURL.url)auth/updateuser"
    static let deleteuser                   = "\(BASEURL.url)auth/deluser"
    static let create_deal                  = "\(BASEURL.url)app/create_deal"
    static let share_deal                   = "\(BASEURL.url)app/deals/shareDeal"
    static let deals_shared_with_me         = "\(BASEURL.url)app/deals_shared"
    static let deals_shared_by_me           = "\(BASEURL.url)app/my_shared_deals"
    static let delete_deals_shared_with_me  = "\(BASEURL.url)app/delete_deals_shared"
    static let delete_deals_shared_by_me    = "\(BASEURL.url)app/delete_my_deals_shared"
    static let shareddealpage               = "\(BASEURL.url)app/shareddealpage"
    static let get_deal_questions           = "\(BASEURL.url)app/get_deal_questions"
    static let saveDeal                     = "\(BASEURL.url)app/deals/save"
    static let draftDeal                    = "\(BASEURL.url)app/deals/draft"
    static let submitDealForReview          = "\(BASEURL.url)app/deals/submit"
    static let getUser                      = "\(BASEURL.url)auth/getuser"
    static let logout                       = "\(BASEURL.url)logout"
    static let getAllDeals                  = "\(BASEURL.url)app/deals"
    static let getUserDeals                 = "\(BASEURL.url)app/userdeals"
    static let updateDeal                   = "\(BASEURL.url)app/deals/update"
    static let updateDealDate               = "\(BASEURL.url)app/updatedatedeal"
    static let updateDealStatus             = "\(BASEURL.url)app/deals/status"
    static let addComments                  = "\(BASEURL.url)app/comment"
    static let getComments                  = "\(BASEURL.url)app/comment"
    static let getUnreadComments            = "\(BASEURL.url)notification/viewnotifications"
    static let getReadComments              = "\(BASEURL.url)notification/readnotification"
    static let createPaymentIntent          = "\(BASEURL.url)app/createpaymentintent"
    static let createpaymentlog             = "\(BASEURL.url)app/createpaymentlog"
    static let uploadImage                  = "\(BASEURL.url)app/upload"
    static let getVideos                    = "\(BASEURL.url)app/getvideosforapp"
    static let createLogs                   = "\(BASEURL.url)app/createlog"
    static let getLogs                      = "\(BASEURL.url)app/getlogs"
    static let getusersessions              = "\(BASEURL.adminUrl)app/getusersessions"
    static let getSubscription              = "\(BASEURL.url)auth/getsubscription"
    static let addSubscription              = "\(BASEURL.url)auth/postsubscription"
    static let deal_Status                  = "\(BASEURL.url)deal/isuserfirstdeal"
    
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
