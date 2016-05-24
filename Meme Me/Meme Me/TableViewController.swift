//
//  TableViewController.swift
//  Meme Me
//
//  Created by Ryan Ballenger on 5/23/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    
    
    let cellReuseIdentifier = "MyCellReuseIdentifier"
    
    let model = [
        ["text" : "Do", "detail" : "A deer. A female deer."],
        ["text" : "Re", "detail" : "A drop of golden sun."],
        ["text" : "Mi", "detail" : "A name, I call myself."],
        ["text" : "Fa", "detail" : "A long long way to run."],
        ["text" : "So", "detail" : "A needle pulling thread."],
        ["text" : "La", "detail" : "A note to follow So."],
        ["text" : "Ti", "detail" : "A drink with jam and bread."]
    ]
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // Add the two essential table data source methods here
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier)! as UITableViewCell
        
        let theMeme = self.memes[indexPath.row]
        
        cell.textLabel?.text = theMeme.topText
        cell.detailTextLabel?.text = theMeme.bottomText
        cell.imageView?.image = theMeme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewControllerClass

        newViewController.num = indexPath.item

        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = false
        
        self.tableView.reloadData()
    }
    
    
    func transition(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func move(){
        
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        
        self.navigationController?.pushViewController(newViewController!, animated: true)

    }

    @IBOutlet weak var navItemTwo: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "move")
        
        navItemTwo.setRightBarButtonItem(barButton, animated: true)

    }
    
    
    
}

