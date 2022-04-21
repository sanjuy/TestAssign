//
//  ProductDestailsViewController.swift
//  TestAssign
//
//  Created by sanju on 21/04/22.
//

import UIKit
import Agrume

class ProductDestailsViewController: UIViewController {

    @IBOutlet weak var productNumberTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var DescriptionTextView: UITextView!
    @IBOutlet weak var regularPriceTextField: UITextField!
    @IBOutlet weak var salePriceTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    var dataObject:Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Details"
        // Do any additional setup after loading the view.
        if let Object = dataObject{
            setData(object:Object)
        }
        
        //MARK: -- add gesture to image view to show image full -=-=-
        productImageView.isUserInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(handleImgTap))
        productImageView.addGestureRecognizer(imgTap)
        
    }
    
    //MARK: --  show product details  -=-=-
    func setData(object:Product){
        if let id = object.id{
            productNumberTextField.text = "Product number: \(id)"
        }
        if let id = object.name{
            productNameTextField.text = "Product name: \(id)"
        }
        if let id = object.descreption{
            DescriptionTextView.text = "Description:\n \(id)"
        }
        if let id = object.regular_price{
            regularPriceTextField.text = "Regular Price: INR \(id)"
        }
        if let id = object.sale_price{
            salePriceTextField.text = "Sale Price: INR \(id)"
        }
        if let id = object.product_image{
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: id) ?? UIImage(named: "product1")
            }
        }
    }

    @objc func handleImgTap() {
        print("image")
        let agrume = Agrume(image: self.productImageView.image ?? UIImage(),background: .blurred(.regular))
        agrume.show(from: self)        
    }
    
    

}
