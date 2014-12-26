//
//  IntroViewController.swift
//  StuffOut
//
//  Created by Arsen Shamkhalov on 20/12/14.
//  Copyright (c) 2014 Arsen. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIPageViewControllerDataSource {
    
    var images: [String] = ["Page1", "Page2", "Page3", "Page4"]
    var pageViewController: UIPageViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createPageViewController()
        setupPageControl()
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as UIPageViewController
        
        if images.count > 0 {
            let firstController = getItemController(0)!
            self.automaticallyAdjustsScrollViewInsets = false;
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        pageViewController?.dataSource = self
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as IntroContentViewController

        if itemController.index > 0 {
            return getItemController(itemController.index - 1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as IntroContentViewController
        if itemController.index + 1 < images.count {
            return getItemController(itemController.index + 1)
        } else {
            itemController.startButton.hidden = false
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> IntroContentViewController? {
        
        if itemIndex < images.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as IntroContentViewController
            pageItemController.index = itemIndex
            pageItemController.imageName = images[itemIndex]
            return pageItemController
        }
        
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return images.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
