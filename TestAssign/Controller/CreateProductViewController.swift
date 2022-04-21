//
//  CreateProductViewController.swift
//  TestAssign
//
//  Created by sanju on 20/04/22.
//

import UIKit
import CoreData
import AVFoundation


class CreateProductViewController: UIViewController {

    @IBOutlet weak var productNumberTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var DescriptionTextView: UITextView!
    @IBOutlet weak var regularPriceTextField: UITextField!
    @IBOutlet weak var salePriceTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    var imageData:Data?
    var isUpdating:Bool = false
    var dataObject:Product?
    var updateHandler:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: -- checking product is creating or updating -=-=-
        if isUpdating{
            title = "Updat Product"
            productNumberTextField.isUserInteractionEnabled = false
            if let Object = dataObject{
                setData(object:Object)
            }
        }else{
            title = "Create Product"
            DescriptionTextView.text = "Description"
            DescriptionTextView.textColor = .lightGray
        }
        
        //MARK: -- add gesture to view for hiding keyboard -=-=-
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        //MARK: -- add gesture to image view to open camera and gallery to pickup the product image -=-=-
        productImageView.isUserInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(handleImgTap))
        productImageView.addGestureRecognizer(imgTap)
        
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func handleImgTap() {
        print("image")
        cameraButtonAction()
    }
    
    //MARK: -- save button action -=-=-
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if productNumberTextField.text == ""{
            Alert(title: "Alert", msg: "Please enter product number")
            return
        }
        if productNameTextField.text == ""{
            Alert(title: "Alert", msg: "Please enter product name")
            return
        }
        if DescriptionTextView.text == ""{
            Alert(title: "Alert", msg: "Please enter product description")
            return
        }
        if regularPriceTextField.text == ""{
            Alert(title: "Alert", msg: "Please enter product regular price")
            return
        }
        if salePriceTextField.text == ""{
            Alert(title: "Alert", msg: "Please enter product sale price")
            return
        }
        if imageData == nil{
            Alert(title: "Alert", msg: "Please upload product image")
            return
        }
        
        if isUpdating{
            if let id = dataObject?.id{
                updateData(idd: id)
            }
        }else{
            saveData()
        }
    }
    
    //MARK: -- save product data -=-=-
    func saveData(){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "ProductData", in: managedContext)!
        //final, we need to add some data to our newly created record for each keys using
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(productNumberTextField.text, forKeyPath: "id")
        user.setValue(productNameTextField.text, forKey: "name")
        user.setValue(DescriptionTextView.text, forKey: "descreption")
        user.setValue(regularPriceTextField.text, forKeyPath: "regular_price")
        user.setValue(salePriceTextField.text, forKey: "sale_price")
        user.setValue(imageData, forKey: "product_image")
        //Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
            Alert(title: "Alert", msg: "Your Product Create successful",isComplete: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: -- Alert function to show error message to user -=-=-
    func Alert(title:String,msg:String,isComplete:Bool = false){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if isComplete{
                self.productNumberTextField.text = ""
                self.productNameTextField.text = ""
                self.DescriptionTextView.text = ""
                self.regularPriceTextField.text = ""
                self.salePriceTextField.text = ""
                self.imageData = nil
                self.productImageView.image = UIImage(named: "product1")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

}


extension CreateProductViewController{
    //MARK: --  show product data to update  -=-=-
    func setData(object:Product){
        if let id = object.id{
            productNumberTextField.text = id
        }
        if let id = object.name{
            productNameTextField.text = id
        }
        if let id = object.descreption{
            DescriptionTextView.text = id
        }
        if let id = object.regular_price{
            regularPriceTextField.text = id
        }
        if let id = object.sale_price{
            salePriceTextField.text = id
        }
        if let id = object.product_image{
            imageData = id
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: id) ?? UIImage(named: "product1")
            }
        }
    }
    
    //MARK: --  Updating the product -=-=-
    func updateData(idd:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ProductData")
        fetchRequest.predicate = NSPredicate(format: "id = %@", idd)
        do{
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(productNameTextField.text, forKey: "name")
            objectUpdate.setValue(DescriptionTextView.text, forKey: "descreption")
            objectUpdate.setValue(regularPriceTextField.text, forKeyPath: "regular_price")
            objectUpdate.setValue(salePriceTextField.text, forKey: "sale_price")
            objectUpdate.setValue(imageData, forKey: "product_image")
            do{
                try managedContext.save()
                updateHandler?()
                self.navigationController?.popViewController(animated: true)
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
   
    }
    
}



//MARK: --  textfield and textview delegate methods -=-=-
extension CreateProductViewController: UITextFieldDelegate,UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Description"
            textView.textColor = .lightGray
        }
    }
        
}


//MARK: --  imagePicker delegate methods to pick up the image  -=-=-
extension CreateProductViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func cameraButtonAction(){
           let optionMenuController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           let addAction = UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) -> Void in
               self.checkPremissionss()
           })
           let saveAction = UIAlertAction(title: "Gallery", style: .default, handler: {(alert: UIAlertAction!) -> Void in
               self.gallery()
           })

           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) -> Void in
               print("Cancel")
           })
           optionMenuController.addAction(addAction)
           optionMenuController.addAction(saveAction)
           optionMenuController.addAction(cancelAction)
           self.present(optionMenuController, animated: true, completion: nil)
       }
       
       func checkPremissionss(){
           AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
               if granted {
                   self.camera()
               } else {
                   print("access denied")
                   DispatchQueue.main.async {
                       UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                   }
               }
           })
       }
       
       func camera(){
           DispatchQueue.main.async {
               if UIImagePickerController.isSourceTypeAvailable(.camera) {
                   let controller = UIImagePickerController()
                   controller.sourceType = .camera
                   controller.delegate = self
                   controller.videoMaximumDuration = 10.0
                   self.present(controller, animated: true, completion: nil)
               }else {
                    print("Camera is not available")
               }
           }
       }
       
       func gallery(){
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               let controller = UIImagePickerController()
               controller.sourceType = .photoLibrary
               controller.delegate = self
               present(controller, animated: true, completion: nil)
           }
           else {
                print("Camera is not available")
           }
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
       
       open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image = info[.originalImage] as? UIImage {
               print(image)
               productImageView.image = image
               imageData = image.jpegData(compressionQuality: 0.8)
               picker.dismiss(animated: true, completion: nil)
           }
       }
}
