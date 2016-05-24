//
//  detailsViewController.swift
//  Meme Me
//
//  Created by Ryan Ballenger on 5/24/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import UIKit
import Foundation



class DetailsViewControllerClass: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    var num : Int!
    
    
    func editThisMeme(){
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        
        newViewController?.editOption = true
        newViewController?.itemNumber = num
        
        self.navigationController?.pushViewController(newViewController!, animated: true)
        
    }
    
    func goBack(){
         navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = memes[num].memedImage
        
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.hidden = true
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editThisMeme")
        
        navItem.setRightBarButtonItem(button, animated: true)
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        
        navItem.setLeftBarButtonItem(backButton, animated: true)

    }
    
    override func viewWillAppear(animated: Bool) {
        
        tabBarController?.tabBar.hidden = true

    }
    
    override func viewWillDisappear(animated: Bool) {
      
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.hidden = false
    }
    
    
    
}
