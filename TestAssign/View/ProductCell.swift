//
//  ProductCell.swift
//  TestAssign
//
//  Created by sanju on 21/04/22.
//

import UIKit
import Agrume

class ProductCell: UITableViewCell {

    @IBOutlet weak var productNumberLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var regularPriceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var complitionHandler:((Bool)->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        productImageView.isUserInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(handleImgTap))
        productImageView.addGestureRecognizer(imgTap)
    }

    @objc func handleImgTap() {
        print("image")
        complitionHandler?(true)
        
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton){
        complitionHandler?(false)
    }
    
    
    //MARK: -- showing data of list object  -=-=-
    func setData(object:Product){
        if let id = object.id{
            productNumberLabel.text = "Product number: \(id)"
        }
        if let id = object.name{
            productNameLabel.text = "Product name: \(id)"
        }
        if let id = object.descreption{
            DescriptionLabel.text = "Description:\n \(id)"
        }
        if let id = object.regular_price{
            regularPriceLabel.text = "Regular Price: INR \(id)"
        }
        if let id = object.sale_price{
            salePriceLabel.text = "Sale Price: INR \(id)"
        }
        if let id = object.product_image{
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: id) ?? UIImage(named: "product1")
            }
        }else{
            self.productImageView.image = UIImage(named: "product1")
        }
    }
    
    
}
