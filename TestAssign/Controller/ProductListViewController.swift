//
//  ProductListViewController.swift
//  TestAssign
//
//  Created by sanju on 20/04/22.
//

import UIKit
import CoreData
import Agrume

class ProductListViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    var list:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Product List"
        // Do any additional setup after loading the view.
        retrieveData()
        
        //MARK: --  registering cell fot tableView  -=-=-
        productsTableView.register(UINib(nibName: "ProductCell", bundle: Bundle.main), forCellReuseIdentifier: "ProductCell")
        
    }
    

    //MARK: --  getting products data from storage  -=-=-
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductData")

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let obj = Product.init(id: data.value(forKey: "id") as? String, name: data.value(forKey: "name") as? String, descreption: data.value(forKey: "descreption") as? String, regular_price: data.value(forKey: "regular_price") as? String, sale_price: data.value(forKey: "sale_price") as? String,product_image: data.value(forKey: "product_image") as? Data)
                list.append(obj)
            }
            self.productsTableView.isHidden = list.count == 0 ? true:false
            DispatchQueue.main.async {
                self.productsTableView.reloadData()
            }
            
        } catch {
            print("Failed")
        }
    }

}


//MARK: --  table view dataSource and Delegate methods  -=-=-
extension ProductListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        cell.setData(object: list[indexPath.row])
        cell.complitionHandler = { isShow in
            if isShow{
                let agrume = Agrume(image: cell.productImageView.image ?? UIImage(),background: .blurred(.regular))
                agrume.show(from: self)
            }else{
                self.menuList(indx: indexPath.row)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextvc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductDestailsViewController") as? ProductDestailsViewController else {return}
        nextvc.dataObject = list[indexPath.row]
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    
    //MARK: --  show ActionSheet to show update and delete buttons  -=-=-
    func menuList(indx:Int){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { (action: UIAlertAction!) in
            print("update")
            guard let nextvc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateProductViewController") as? CreateProductViewController else {return
            }
            nextvc.updateHandler = {
                self.list = []
                self.retrieveData()
            }
            nextvc.isUpdating = true
            nextvc.dataObject = self.list[indx]
            self.navigationController?.pushViewController(nextvc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { (action: UIAlertAction!) in
            print("delete")
            self.deleteData(indx: indx)
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: { (action: UIAlertAction!) in
            print("cancle")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: --  function to delete product from local storage and product list  -=-=-
    func deleteData(indx:Int){
        let data = list[indx]
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       let managedContext = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductData")
        fetchRequest.predicate = NSPredicate(format: "id = %@", data.id!)
       do{
           let test = try managedContext.fetch(fetchRequest)
           let objectToDelete = test[0] as! NSManagedObject
           managedContext.delete(objectToDelete)
           do{
               try managedContext.save()
               list.remove(at: indx)
               self.productsTableView.isHidden = list.count == 0 ? true:false
               DispatchQueue.main.async {
                   self.productsTableView.reloadData()
               }
           }
           catch{
               print(error)
           }
       }
       catch{
           print(error)
       }
   }
    
    
    
}
