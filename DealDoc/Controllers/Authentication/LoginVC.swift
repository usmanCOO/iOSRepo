//
//  LoginVC.swift
//  Meddpicc App
//
//  Created by Asad Khan on 8/30/22.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Alamofire
class LoginVC: UIViewController {
    
    var currentNonce: String?
    var loginResponse :LoginResponse?
    @IBOutlet weak var loginProviderStackView: UIStackView!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupProviderLoginView()
        appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.backgroundColor = .gray
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        //  request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @IBAction func privacyPolicyButtonTapped (_ sender: UIButton) {
        let url: URL = URL(string: "https://admin.davidweisssales.com/privacypolicy")!
        UIApplication.shared.open(url)
    }
    @IBAction func termAndConditionButtonTapped (_ sender: UIButton) {
        let url: URL = URL(string: "https://admin.davidweisssales.com/terms&conditions")!
        UIApplication.shared.open(url)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    
    func SignInWithAppleEmail(email:String?,userId:String) {
       // clientappleID = "001867.15d819a6d6864e5b964b944b0651bda6.1929"
       // salmanID = "001952.452d1f8450b54ea1b77865c8c3cbf684.1237" // Company ID
        // asadID  =   001368.87c767d761fd41c8a7262eee85271270.1809
        PopupHelper.ActivityIndicator.shared.showSpinner(onView: self.view)
        Alamofire.request(URLPath.applesignin, method: .post, parameters: ["email": email ?? "" , "appleID" : userId], encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            PopupHelper.ActivityIndicator.shared.removeSpinner()
            switch response.result {
            case .success:
                let json = response.data
                print(response.result.value!)
                do{
                    let decoder = JSONDecoder()
                    self.loginResponse = try decoder.decode(LoginResponse.self, from: json!)
                    if self.loginResponse?.success == false {
                        PopupHelper.showToast(message: self.loginResponse?.message ?? "")
                    }
                    else {
                        UserDefaults.standard.set(self.loginResponse?.token, forKey: "token")
                        DealDocSessionManager.shared.saveUser(value: self.loginResponse?.data)
                        PopupHelper.showToast(message: self.loginResponse?.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
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


extension LoginVC: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        if Connectivity.isConnectedToInternet(){
            if appleIDCredential.email != nil {
                SignInWithAppleEmail(email: appleIDCredential.email ?? "", userId: appleIDCredential.user.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .whitespacesAndNewlines))
            }else {
                SignInWithAppleEmail(email: nil, userId: appleIDCredential.user.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .whitespacesAndNewlines))
                print(appleIDCredential.user)
            }
        }else {
            PopupHelper.showToast(message: "No internet Connection")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginVC : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
