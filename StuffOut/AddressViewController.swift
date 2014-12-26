//
//  AddressViewController.swift
//  StuffOut
//
//  Created by Arsen Shamkhalov on 20/12/14.
//  Copyright (c) 2014 Arsen. All rights reserved.
//

import UIKit

class AddressViewController: UITableViewController {
    var datePickerIsShown: Bool = false
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var addressTextField: UITextView!
    
    let dateFormatter = NSDateFormatter()
    
    override func viewWillLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
    }
    
    override func viewDidLoad() {
        var imageView = UIImageView(image: UIImage(named: "background.png")!)
        self.tableView.backgroundView = imageView;
        self.dateFormatter.dateFormat = "EEE, MMM d HH:mm"
        self.dateLabel.text = self.dateFormatter.stringFromDate(NSDate())
    }

    @IBAction func tapped(sender: AnyObject) {
        self.view.endEditing(true)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if datePickerIsShown {
                return 2
            } else {
                return 1
            }
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.grayColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            self.datePickerIsShown = !self.datePickerIsShown

            tableView.beginUpdates();
            if datePickerIsShown {
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            tableView.endUpdates()

            self.tableView.reloadData()
        }
    }

    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        self.dateLabel.text = self.dateFormatter.stringFromDate(self.datePicker.date)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.dateLabel.text, forKey: "order.date")
        defaults.setObject(self.phoneTextField.text, forKey: "order.phone")
        defaults.setObject(self.addressTextField.text,forKey: "order.address")
        defaults.synchronize()
    }
}