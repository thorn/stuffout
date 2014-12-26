//
//  StuffOptions.swift
//  StuffOut
//
//  Created by Arsen Shamkhalov on 21/12/14.
//  Copyright (c) 2014 Arsen. All rights reserved.
//

import UIKit

class StuffOptions: UITableViewController {
    @IBAction func tapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBOutlet var stuffCount: UITextField!

    @IBOutlet var clothesSwitch: UISwitch!
    @IBOutlet var furnitureSwitch: UISwitch!
    @IBOutlet var electronicsSwitch: UISwitch!
    
    override func viewWillLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
    }

    override func viewDidLoad() {
        var imageView = UIImageView(image: UIImage(named: "background.png")!)
        self.tableView.backgroundView = imageView;
//        self.navigationItem.hidesBackButton = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(stuffCount.text, forKey: "stuffCount")
        defaults.setObject(clothesSwitch.enabled, forKey: "clothesSwitch")
        defaults.setObject(furnitureSwitch.enabled, forKey: "furnitureSwitch")
        defaults.setObject(electronicsSwitch.enabled, forKey: "electronicsSwitch")
        defaults.synchronize()
    }
}
