//
//  ViewController.swift
//  Quiero Taxi
//
//  Created by Roberto Gutierrez on 09/11/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celularTextfield: UITextField!
    @IBOutlet var contraseñaTextfield: UITextField!
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var vistaRecuperarContraseña: UIView!
    @IBOutlet var ingresaTuNumero: UITextField!
    
    
    @IBAction func IniciarSesionBoton(sender: AnyObject) {
        let celular = celularTextfield.text;
        let contraseña = contraseñaTextfield.text;
        
        if(celular != "" && contraseña != ""){
            // HACER EL LOGIN DE USUARIO
            loginWS(celular!, auxContraseña: contraseña!);
          
  
            
        } else {
            if #available(iOS 8.0, *) {
                let alerta = UIAlertController(title: "Aviso", message: "Ingresa tus datos correctamente", preferredStyle: UIAlertControllerStyle.Alert)
                alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alerta, animated: true, completion: nil)
                
            } else {
                // Fallback on earlier versions
                
            }
            
        }
        
        
    }
    
    @IBAction func registrarBoton(sender: AnyObject) {
        
        
    }
    
    @IBAction func recuperarContraseña(sender: AnyObject) {
        
//        if #available(iOS 8.0, *) {
//            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = view.bounds
//            blurEffectView.addSubview(vistaRecuperarContraseña)
//            self.view.addSubview(blurEffectView)
//        } else {
//            // Fallback on earlier versions
//        }
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.vistaRecuperarContraseña.transform = CGAffineTransformConcat(scale, translate)
            
            }, completion: nil)

        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        celularTextfield.delegate = self
        contraseñaTextfield.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        vistaRecuperarContraseña.transform = CGAffineTransformConcat(scale, translate)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    
    ////// Botones de Vista - Recuperar contraseña
    
    @IBAction func cancelarRecuperarContraseña(sender: AnyObject) {
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        vistaRecuperarContraseña.transform = CGAffineTransformConcat(scale, translate)
        
    }
    
    
    @IBAction func aceptarRecuperarContraseña(sender: AnyObject) {
        
        
    }
    
    func mostrarMensaje(mensaje: String){
    
    }
    
    
    func loginWS(var auxTelefono: String, var auxContraseña: String){
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var device_token:String
        
        if (prefs.objectForKey("DEVICETOKEN") != nil){
            
            device_token = prefs.objectForKey("DEVICETOKEN") as! String
        }
        else{
            device_token = ""
        }
        
        
        var customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        auxTelefono = auxTelefono.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        auxContraseña = auxContraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://quierotaxiservicios.dctimx.com/ios/verde/inicio_sesion.php?celular=" + auxTelefono + "&contrasena=" + auxContraseña + "&device_token=\(device_token)";
        
        
        let url = NSURL(string: urlString)!
        let urlSession = NSURLSession.sharedSession()

        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            var err: NSError?
            
            // 3
            var jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSMutableArray
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            
            print(jsonResult[0])
            
            let aux_exito: String! = jsonResult[0]["success"] as! NSString as! String
            
            
            
            if(aux_exito == "1"){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                })
                
                
            }
            else{
                
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let alertView_usuario_incorrecto = UIAlertController(title: "Error al iniciar sesion", message: "Celular y/o Contraseña.", preferredStyle: .Alert)
                    alertView_usuario_incorrecto.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (alertAction) -> Void in
                        print("")
                    }))
                    //alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    self.presentViewController(alertView_usuario_incorrecto, animated: true, completion: nil)
                    
                })
                
                
            }
            
            
            
        })
        // 5
        jsonQuery.resume()
    
    }
    
}