//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Thomas Grant on 03/07/2015.
//  Copyright (c) 2015 Thomas Grant. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var feedArray:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let request = NSFetchRequest(entityName: "FeedItem")
        
        // get the managed object contect
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        // populate the feed array with the returned items from the request
        feedArray = context.executeFetchRequest(request, error: nil)!
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
    
    
    @IBAction func snapBarButtonItemTapped(sender: AnyObject) {
        
        // if the app is running on a real device
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            // create a camera controller
            var cameraController = UIImagePickerController()
            cameraController.delegate = self
            
            // set the source type of the camera controller to an image
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = mediaTypes
            cameraController.allowsEditing = false
            
            // present the controller
        
            self.presentViewController(cameraController, animated: true, completion: nil)
        }
            
        // else if the app is running on the simulator 
            
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            // create the photo library controller
            var photoLibraryController = UIImagePickerController()
            photoLibraryController.delegate = self
            
            // set source to photo library
            photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            photoLibraryController.mediaTypes = mediaTypes
            photoLibraryController.allowsEditing = false
            
            // present the view controller
            self.presentViewController(photoLibraryController, animated: true, completion: nil)
        }
        // else if it all goes to pot...show an alert view
        else {
            var alertView = UIAlertController(title: "Alert", message: "Your device does not support the camera or photo library", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    
    // UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // get the photo that was selected
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // convert image to NSData as CoreData model expects
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        // grab our managedObejctContext from the App Delegate
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Create the entity description - describes an entity in core data
        let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
        
        // create the feed item and insert into context
        let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        // set properties on the feedItem
        feedItem.image = imageData
        feedItem.caption = "test caption"
        
        // save the context once the properties are set
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        // append the item to the feed array
        feedArray.append(feedItem)
        
        // dismiss the image picker
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // reload the data of the collection view
        self.collectionView.reloadData()
        
    }
    
    // UICollectionViewDataSource
    
    // number of sections in collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of items in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    // return UICollectionView cell for index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // create the cell
        var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FeedCell
        
        // get the item from the feed array
        let thisItem = feedArray[indexPath.row] as! FeedItem
        
        // set the imgae of the cell using the NSData representation of the FeedItem
        cell.imageView.image = UIImage(data: thisItem.image)
        cell.captionLabel.text = thisItem.caption
        
        return cell
    }
    
    // UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // grab the item out of the feed array at the selected index path
        let thisItem = feedArray[indexPath.row] as! FeedItem
        
        // create filter view controller
        var filterVC = FilterViewController()
        
        // throw in the image
        filterVC.thisFeedItem = thisItem
        
        // push filterVC onto the stack
        self.navigationController?.pushViewController(filterVC, animated: false)
    }
    
    

}
