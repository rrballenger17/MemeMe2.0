//
//  CollectionViewController.swift
//  Meme Me
//
//  Created by Ryan Ballenger on 5/23/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation

import UIKit

class CollectionViewController: UICollectionViewController{
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    @IBOutlet weak var navItemTwo: UINavigationItem!
    
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.memes.count;
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let meme = memes[indexPath.item]

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ReuseIdentifier", forIndexPath: indexPath) as! CustomItem
        
        cell.imageView.contentMode = .ScaleAspectFit
        cell.imageView.image = meme.memedImage
    
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewControllerClass
        
        newViewController.num = indexPath.item
        //newViewController!.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }



    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionViewOutlet.reloadData()
        
        navigationController?.navigationBarHidden = false
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "move")
        
        navItemTwo.setRightBarButtonItem(barButton, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        tabBarController!.tabBar.hidden = false
        
    }
    
    func move(){

        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController

        self.navigationController?.pushViewController(newViewController!, animated: true)

    }


}