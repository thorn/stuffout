//
//  ThanksForOrderViewController.swift
//  StuffOut
//
//  Created by Arsen Shamkhalov on 21/12/14.
//  Copyright (c) 2014 Arsen. All rights reserved.
//

import UIKit

class ThanksForOrderViewController: UIViewController, VKSdkDelegate {

    @IBOutlet var fbShareButton: UIView!
    @IBOutlet var vkShareButton: UIView!

    let shareText = "Текст для расшаривания"
    let shareLink = "http://example.com"
    let shareLinkText = "StuffOut"
    let shareDescription = "Описание ссылки"
    let pictureUrl = "http://picture.url"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.

        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: Selector("facebookShare:"))
        self.fbShareButton.userInteractionEnabled = true
        self.fbShareButton.addGestureRecognizer(recognizer)

        let vkRecognizer = UITapGestureRecognizer()
        vkRecognizer.addTarget(self, action: Selector("vkontakteShare:"))
        self.vkShareButton.userInteractionEnabled = true
        self.vkShareButton.addGestureRecognizer(vkRecognizer)

        VKSdk.initializeWithDelegate(self, andAppId: "4692005")
        
        self.sendOrder()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!);
        var button = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.Plain, target: self, action: "goToStart")
        self.navigationItem.rightBarButtonItem = button
    }

    func goToStart() {
        var vc = self.storyboard?.instantiateInitialViewController() as UIViewController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func facebookShare(sender: UITapGestureRecognizer!) {
        var params = FBLinkShareParams()
        params.link = NSURL(string: self.shareLink)

        if FBDialogs.canPresentShareDialogWithParams(params) {
            FBDialogs.presentShareDialogWithLink(params.link, handler: { (fbAppCall : FBAppCall!, [NSObject : AnyObject]!, error : NSError!) -> Void in
                if (error != nil) {
                    println("Error publishing on Facebook \(error.description)")
                } else {
                    println("Success")
                }
            })
        } else {
            let params = [
                "name": self.shareLinkText,
                "caption": self.shareLinkText,
                "description": self.shareDescription,
                "link": self.shareLink,
                "picture": self.pictureUrl
            ]
            FBWebDialogs.presentFeedDialogModallyWithSession(nil, parameters: params, handler: { (result: FBWebDialogResult!, resultUrl: NSURL!, error: NSError!) -> Void in
                if error != nil {
                    println("Error publishing throught Facebook web dialog: \(error.description)")
                } else {
                    if result == FBWebDialogResult.DialogNotCompleted {
                        println("User canceled facebook share")
                    } else {
                        println("Posted successfully")
                    }
                }
            })
        }
    }

    func vkontakteShare(sender: UITapGestureRecognizer!) {
        var shareDialog = VKShareDialogController()
        shareDialog.text = "Hello"
        shareDialog.shareLink = VKShareLink(title: "Title", link: NSURL(string: "http://example.com"))
        shareDialog.completionHandler = { (result: VKShareDialogControllerResult) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(shareDialog, animated: true, completion: nil)
    }

    func vkSdkIsBasicAuthorization() -> Bool {
        return false
    }
    func vkSdkReceivedNewToken(newToken: VKAccessToken!) {
        print(newToken)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sendOrder() {
        let url = NSURL(string: "http://asham.me:4567")
        
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            var defaults = NSUserDefaults.standardUserDefaults()
            var stuffCount = defaults.objectForKey("stuffCount") as String
            var clothesSwitch = defaults.objectForKey("clothesSwitch") as Bool
            var furnitureSwitch = defaults.objectForKey("furnitureSwitch") as Bool
            var electronicsSwitch = defaults.objectForKey("electronicsSwitch") as Bool
            var userInfo: String = defaults.objectForKey("userInfo") as String
            
            var url = "http://asham.me:4567/ios_app"
            self.post(["order": "Число вещей: \(stuffCount)\nОдежда: \(clothesSwitch)\nМебель:\(furnitureSwitch)\nЭлектроника: \(electronicsSwitch)", "user_info": "\(userInfo)"] as Dictionary, url: url)
        }
    }

    func post(params : Dictionary<String, String>, url : String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"

        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)

        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
        })
        
        task.resume()
    }
}
