//
//  BaseVC.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Show Alert
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
}
