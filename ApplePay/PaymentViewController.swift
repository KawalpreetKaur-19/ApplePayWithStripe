//
//  PaymentViewController.swift
//  ApplePay
//
//  Created by Kawalpreet Kaur on 1/7/19.
//  Copyright © 2019 Kawalpreet Kaur. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: BaseViewController ,PKPaymentAuthorizationViewControllerDelegate{
  
    @IBOutlet weak var paymentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //STPApplePayPaymentMethod.init()
        Stripe.deviceSupportsApplePay()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionForPayment(_sender: UIButton){
        let merchantIdentifier = "merchant.com.MakePayment"
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
        
        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Fancy Hat", amount: 50.00),
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "iHats, Inc", amount: 50.00),
        ]
        if Stripe.canSubmitPaymentRequest(paymentRequest) {
            // Setup payment authorization view controller
            let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthorizationViewController?.delegate = self
            
            // Present payment authorization view controller
            present(paymentAuthorizationViewController!, animated: true)
        }
        else {
            // There is a problem with your Apple Pay configuration
        }
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                return
            }
            print("Token: \(token)")
            
//            submitTokenToBackend(token, completion: { (error: Error?) in
//                if let error = error {
//                    // Present error to user...
//                    
//                    // Notify payment authorization view controller
//                    completion(.failure)
//                }
//                else {
//                    // Save payment success
//                    paymentSucceeded = true
//                    
//                    // Notify payment authorization view controller
//                    completion(.success)
//                }
//            })
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: {
//            if (paymentSucceeded) {
//                // Show a receipt page...
//            }
        })
    }
  
}
