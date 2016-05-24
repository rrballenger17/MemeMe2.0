//
//  ViewController.swift
//  Meme Me
//
//  Created by Ryan Ballenger on 5/20/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBAction func cancelAction(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
        
        //navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var topBarNav: UINavigationItem!
    @IBOutlet weak var bottomBarNav: UINavigationItem!
    
    
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UINavigationBar!

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    
    var editOption = false
    
    var itemNumber : Int!
    
    
    var cameraButtonBool = false
    
    var moveKeyboard = false
    
    
    /***** 
     * save meme
     */
   
    var meme: Meme!
    

    func save() {
        //Create the meme
        meme = Meme( topText: topText.text!, bottomText: bottomText.text!, image: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        
    }
    
    func generateMemedImage() -> UIImage {
        
        topBar.hidden = true
        bottomBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topBar.hidden = false
        bottomBar.hidden = false
        
        
        return memedImage
    }

    
    
    
    
    /*****
     * text fields
     */
    func textFieldDidBeginEditing(textField: UITextField){
        
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = "";
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.textAlignment = .Center
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        
        moveKeyboard = false
        
        if(textField == bottomText){
            moveKeyboard = true
        }
     
        return true
    }
    
    
    /*****
     * image view
     */
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]){
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.contentMode = .ScaleAspectFit
                imageView.image = image
                
                let barButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareMeme:")
                topBarNav.setLeftBarButtonItem(barButton, animated: true)
            }
            
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    /*****
     * share
     */
    
    
    @IBAction func shareMeme (sender: AnyObject) {
        
        save()
        
        let sharer = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
        sharer.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            sharer.dismissViewControllerAnimated(true, completion: nil)
            
        }
        presentViewController(sharer, animated: true, completion: nil)
    }
    
    /*****
     * load, etc.
     */
    
    let memeTextAttributes = [
        NSStrokeWidthAttributeName: NSNumber(float: -4.0),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSBackgroundColorAttributeName: UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    
    @IBAction func doNothing() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBarHidden = true
        
        
        
        
        imageView.backgroundColor = UIColor.blackColor()
        
        topText.defaultTextAttributes = memeTextAttributes
        topText.delegate = self
        
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.delegate = self
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "doNothing")
        barButton.tintColor = UIColor.grayColor()
        topBarNav.setLeftBarButtonItem(barButton, animated: true)
        
        let albumButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "pickAnImageFromAlbum:")
        bottomBarNav.setLeftBarButtonItem(albumButton, animated: true)
        
        var cameraButton : UIBarButtonItem!
        
        if(cameraButtonBool){
            cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "pickAnImageFromCamera:")
        }else{
            cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "doNothing")
            cameraButton.tintColor = UIColor.grayColor()
        }
        bottomBarNav.setRightBarButtonItem(cameraButton, animated: true)

        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        bottomText.textAlignment = .Center
        topText.textAlignment = .Center

        topText.minimumFontSize = 30.0
        bottomText.minimumFontSize = 30.0
        
        topText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if(editOption){
            imageView.contentMode = .ScaleAspectFit
            imageView.image = memes[itemNumber].image
            topText.text = memes[itemNumber].topText
            bottomText.text = memes[itemNumber].bottomText
            
            let barButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareMeme:")
            topBarNav.setLeftBarButtonItem(barButton, animated: true)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        
        tabBarController?.tabBar.hidden = true
        
        
        subscribeToKeyboardNotifications()
        
        cameraButtonBool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        tabBarController?.tabBar.hidden = false

    }
    
    
    /*****
     * keyboard
     */
    func keyboardWillShow(notification: NSNotification) {
        if(moveKeyboard == true){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(moveKeyboard == true){
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    
    /*
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var topBar: UINavigationBar!
    
    @IBOutlet weak var bottomBar: UIToolbar!






*/

}

