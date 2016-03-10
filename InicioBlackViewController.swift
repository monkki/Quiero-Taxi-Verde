//
//  InicioBlackViewController.swift
//  Quiero Taxi
//
//  Created by Doctor on 12/2/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class InicioBlackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "Segue", userInfo: nil, repeats: false)
    }
    
    func Segue() {
        
        self.performSegueWithIdentifier("segue", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
