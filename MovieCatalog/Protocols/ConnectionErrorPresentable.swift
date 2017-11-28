//
//  ConnectionErrorPresentable.swift
//  MovieCatalog
//
//  Created by Aleksei Penzentcev on 28/11/2017.
//  Copyright © 2017 lexpenz.com. All rights reserved.
//

import UIKit

protocol ConnectionErrorPresentable: class {}

extension ConnectionErrorPresentable where Self: UIViewController {
    func showConnectionErrorAlert(title: String = NSLocalizedString("No connection!", comment: ""), message: String = NSLocalizedString("Hey, I need Internet to work properly!", comment: "")) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
