//
//  mainScreenCustomSegue.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 3/19/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit

class MainPerformSegue: UIStoryboardSegue {
    override func perform() {
        Destination()
    }
    
    
    func Destination() {
        // Setting the Views
        let sourceViewController = self.source.view as UIView
        let destinationViewController = self.destination.view as UIView
        // Getting the Width and Height of the Screen
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        // Animation to start
        let firstAnimation = CGRect(x: 75, y: 75, width: screenWidth - 150, height: screenHeight - 150)
        // Window of Screen
        let window = UIApplication.shared.keyWindow
        
        destinationViewController.frame = CGRect(x: screenWidth, y: 0.0, width: screenWidth, height: screenHeight)
        
        window?.insertSubview(destinationViewController, aboveSubview: sourceViewController)
        
        // Makes the Source View smaller and Starts off the Segue
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.source.view.layoutIfNeeded()
            sourceViewController.frame = firstAnimation
        }) { (_) in
            self.movingSourceViewOut(controller: sourceViewController, width: screenWidth, height: screenHeight)
        }
    } // Function End
    
    // Moves the View out of the way
    func movingSourceViewOut(controller viewController: UIView, width: CGFloat, height: CGFloat) {
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            viewController.frame = CGRect(x: -width, y: 75, width: width - 150, height: height - 150)
        }) { (_) in
            self.movingDestinationIntoView(controller: viewController)
        }
    }
    
    // Moving the next view in.
    func movingDestinationIntoView(controller: UIView?) {
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.destination.view.transform = CGAffineTransform(translationX: -controller!.frame.width, y: 0)
            self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        })
    }
}
