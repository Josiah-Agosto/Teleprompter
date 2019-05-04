//
//  SecondUnwindSegue.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 4/27/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit

class MainUnwindSegue: UIStoryboardSegue {
    override func perform() {
        transitionOut()
    }
    
    
    func transitionOut() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            // Moving the previous view out, by going up and out of view.
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: fromViewController.view.frame.origin.y + fromViewController.view.frame.height)
            fromViewController.view.layer.opacity = 0
            fromViewController.dismiss(animated: false, completion: nil)
        }) { (_) in
            // Completing the View, or Presenting the new View
            UIView.animate(withDuration: 0.3, delay: 0.5, animations: {
                toViewController.view.transform = CGAffineTransform(translationX: fromViewController.view.frame.width, y: 0)
                fromViewController.present(toViewController, animated: false, completion: nil)
            })
        }
    } // Function End
}
