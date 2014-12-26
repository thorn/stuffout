//
//  SignUpViewController.swift
//  StuffOut
//
//  Created by Arsen Shamkhalov on 21/12/14.
//  Copyright (c) 2014 Arsen. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, FBLoginViewDelegate, VKSdkDelegate {

    @IBOutlet var fbLoginView: FBLoginView!
    var defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email"]
        VKSdk.initializeWithDelegate(self, andAppId: "4692005")
        if self.defaults.objectForKey("userInfo") != nil {
            self.goToThanksForOrderController(animated: false)
        }

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!);
    }

    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        self.defaults.setObject(userEmail, forKey: "userInfo")
        self.defaults.synchronize()
        self.goToThanksForOrderController(animated: true)
    }

    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }

    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    @IBAction func loginVK(sender: AnyObject) {
        VKSdk.authorize(["email"])
    }

    func vkSdkReceivedNewToken(newToken: VKAccessToken!) {
        print(newToken)
        var vkReq = VKApi.users().get()
        vkReq.executeWithResultBlock({(response: VKResponse?) in
            println(response)
            self.defaults.setObject(response?.json, forKey: "userInfo")
            self.defaults.synchronize()
            self.goToThanksForOrderController(animated: true)
            }, errorBlock: {(error: NSError?) in
        })
    }

    func vkSdkUserDeniedAccess(authorizationError: VKError!) {
        print("User denied access")
    }

    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc.presentIn(self)
    }

    func vkSdkTokenHasExpired(expiredToken: VKAccessToken!) {
        
    }

    func vkSdkShouldPresentViewController(controller: UIViewController!) {
    }

    func vkSdkIsBasicAuthorization() -> Bool {
        return false
    }

    func goToThanksForOrderController(#animated: Bool) {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ThanksForOrderViewController") as ThanksForOrderViewController
        self.navigationController?.pushViewController(vc, animated: animated)
    }
}
