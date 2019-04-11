//
//  mainScreenCustomSegue.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 3/19/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

// Removed

import UIKit

class PerformCustomSegue: UIStoryboardSegue {
    override func perform() {
        goToOtherView()
    }
    
    
    func goToOtherView() {
        let toViewController = self.destination
        let fromViewController = self.source
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(translationX: -toViewController.view.frame.width, y: 0)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            // Moving the previous view out, by going up and out of view.
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: fromViewController.view.frame.origin.y - fromViewController.view.frame.height)
            fromViewController.view.layer.opacity = 0
        }) { (_) in
            // Moving the next view in.
            UIView.animate(withDuration: 0.3, animations: {
                toViewController.view.transform = CGAffineTransform(translationX: -toViewController.view.frame.width, y: 0)
                fromViewController.present(toViewController, animated: false, completion: nil)
            })
        }
    } // Function End
}

// Changing back to a Veiw Controller
class UnwindSegue: UIStoryboardSegue {
    override func perform() {
        transitionOut()
    }
    
    
    func transitionOut() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.3, animations: {
            // Moving the previous view out, by going up and out of view.
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: fromViewController.view.frame.origin.y + fromViewController.view.frame.height)
            fromViewController.view.layer.opacity = 0
            fromViewController.dismiss(animated: false, completion: nil)
        }) { (_) in
            // Completing the View, or Presenting the new View
            UIView.animate(withDuration: 0.3, animations: {
                toViewController.view.transform = CGAffineTransform(translationX: fromViewController.view.frame.width, y: 0)
                fromViewController.present(toViewController, animated: false, completion: nil)
            })
        }
    } // Function End
}
