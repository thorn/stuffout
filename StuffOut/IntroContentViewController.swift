//
//  IntroContentViewController.swift
//  StuffOut
//
//  Created by Arsen Shamkhalov on 20/12/14.
//  Copyright (c) 2014 Arsen. All rights reserved.
//

import UIKit

class IntroContentViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    @IBOutlet var backgroundImage: UIImageView!
    @IBAction func startButtonPressed(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("done", forKey: "intro")
        defaults.synchronize()
        self.goToStoryboard("Main", viewController: self)
    }

    var imageName: String = "" {
        didSet {
            if let imageView = backgroundImage {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage!.image = UIImage(named: imageName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func goToStoryboard(storyboardName: String, viewController: UIViewController) {
        var storyBoard:UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        var initialHelpView: UIViewController = storyBoard.instantiateInitialViewController() as UIViewController
        
        initialHelpView.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        viewController.presentViewController(initialHelpView, animated: true, completion: nil)
    }
}
