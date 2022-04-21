//
//  ViewController.swift
//  TestAssign
//
//  Created by sanju on 20/04/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: -- show button Action -=-=-
    @IBAction func showProductButtonAction(_ sender: UIButton) {
        guard let nextvc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductListViewController") as? ProductListViewController else {return}
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    //MARK: -- create button Action -=-=-
    @IBAction func createProductButtonAction(_ sender: UIButton) {
        guard let nextvc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateProductViewController") as? CreateProductViewController else {return}
        self.navigationController?.pushViewController(nextvc, animated: true)
    }

}

