//
//  ViewController.swift
//  Meme Me
//
//  Created by Ryan Ballenger on 5/20/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    
    @IBOutlet weak var topBarNav: UINavigationItem!
    @IBOutlet weak var bottomBarNav: UINavigationItem!
    
    
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UINavigationBar!

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var cameraButtonBool = false
    
    var moveKeyboard = false
    
    
    /***** 
     * save meme
     */
    struct Meme {
        var topText : String
        var bottomText : String
        var image : UIImage
        var memedImage : UIImage
    }
    var meme: Meme!
    
    func save() {
        //Create the meme
        meme = Meme( topText: topText.text!, bottomText: bottomText.text!, image: imageView.image!, memedImage: generateMemedImage())
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
    
    
    func pickAnImageFromEither(camera: Bool) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if(camera){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImageFromEither(false)
        
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        pickAnImageFromEither(true)
        
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
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButtonBool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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

