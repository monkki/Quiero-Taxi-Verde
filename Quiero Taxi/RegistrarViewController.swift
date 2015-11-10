//
//  RegistrarViewController.swift
//  Quiero Taxi
//
//  Created by Roberto Gutierrez on 09/11/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class RegistrarViewController: UIViewController {
    
    
    @IBOutlet var nombreTextfield: UITextField!
    @IBOutlet var apellidoTextfield: UITextField!
    @IBOutlet var celularTextfield: UITextField!
    @IBOutlet var correoTextfield: UITextField!
    @IBOutlet var contraseñaTextfield: UITextField!
    
    
    @IBAction func aceptarBoton(sender: AnyObject) {
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    

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
