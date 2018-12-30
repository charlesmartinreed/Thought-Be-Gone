//
//  Extension+UIView.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/29/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(message: String) {
        let ac = UIAlertController(title: "Uh-oh!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Alright", style: .default, handler: { (_) in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        present(ac, animated: true, completion: nil)
    }
}
