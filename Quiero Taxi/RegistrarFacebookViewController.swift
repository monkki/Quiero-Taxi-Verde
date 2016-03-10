//
//  RegistrarFacebookViewController.swift
//  Quiero Taxi
//
//  Created by Doctor on 12/8/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class RegistrarFacebookViewController: UIViewController, UITextFieldDelegate, EMCCountryDelegate {
    
    
    @IBOutlet var imageViewFacebook: UIImageView!
    @IBOutlet var nombreTextfield: UITextField!
    @IBOutlet var apellidoTextfield: UITextField!
    @IBOutlet var celularTextfield: UITextField!
    @IBOutlet var correoTextfield: UITextField!
    @IBOutlet var contraseñaTextfield: UITextField!
    @IBOutlet var codigoDeTelefono: UILabel!
    
    var nombre = ""
    var apellido = ""
    var celular = ""
    var correo = ""
    var contraseña = ""
    var codigoPais = ""
    
    // DATOS RECIBIDOS DE FACEBOOK
    var nombreCompletoFacebook: String!
    var nombreFacebook: String!
    var apellidoFacebook: String!
    var emailFacebook: String!
    var imagenFacebook: UIImage!
    var idFacebook: String!

    
    @IBAction func SeleccionarPais(sender: AnyObject) {
        
        
    }
    
    @IBAction func aceptarBoton(sender: AnyObject) {
        
        nombre = nombreTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        apellido = apellidoTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        celular = celularTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        correo = correoTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        //contraseña = contraseñaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        codigoPais = codigoDeTelefono.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        
        if(nombre == "" || apellido == "" || celular == "" || correo == "" || codigoPais == "" ){
            
            mostraMSJ("Favor de completar los datos!")
            
        } else if(celular.characters.count != 10) {
            
            mostraMSJ("Favor de escribir un número de 10 dígitos!")
            
        } else if(!isValidEmail(correo)) {
            
            mostraMSJ("Favor de escribir un correo válido!")
            
        } else {
            
            registrarUsuario();
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreTextfield.delegate = self
        apellidoTextfield.delegate = self
        celularTextfield.delegate = self
        correoTextfield.delegate = self
        contraseñaTextfield.delegate = self
        
        nombreTextfield.text = nombreFacebook
        apellidoTextfield.text = apellidoFacebook
        correoTextfield.text = emailFacebook
        imageViewFacebook.image = imagenFacebook
        
        //Imagen circular
        imageViewFacebook.layer.borderWidth = 2.0
        imageViewFacebook.layer.masksToBounds = false
        imageViewFacebook.layer.borderColor = UIColor.whiteColor().CGColor
        imageViewFacebook.layer.cornerRadius = imageViewFacebook.frame.size.width/2
        imageViewFacebook.clipsToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "gris")!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func registrarUsuario(){
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        // FACEBOOK LOGIN
        var idFace = NSUserDefaults.standardUserDefaults().objectForKey("idFacebookDefaults") as! String

        idFace = idFace.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        nombre = nombre.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        apellido = apellido.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        celular = celular.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        correo = correo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        //contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        codigoPais = codigoPais.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlObj = Urls();
        let urlString = urlObj.getUrlRegistroFacebook(idFace, nombre: nombre, apellidos: apellido, celular: celular, correo: correo, codigo_pais: codigoPais)
        
        let url = NSURL(string: urlString)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            do {
                
                if let data = data {
                    
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                    
                    print(jsonResult[0])
                    
                    let aux_exito: String! = jsonResult[0]["success"] as! NSString as String
                    
                    if(aux_exito == "1"){
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            if #available(iOS 8.0, *) {
                                
                                let nombre: String! = jsonResult[0]["nombre"] as! NSString as String
                                let apellidos: String! = jsonResult[0]["apellidos"] as! NSString as String
                                let email: String! = jsonResult[0]["email"] as! NSString as String
                                let ubicacion: String! = jsonResult[0]["ubicacion"] as! NSString as String
                                let telefono: String! = jsonResult[0]["telefono"] as! NSString as String
                                
                                prefs.setObject(nombre, forKey: "nombre")
                                prefs.setObject(apellidos, forKey: "apellidos")
                                prefs.setObject(email, forKey: "email")
                                prefs.setObject(ubicacion, forKey: "ubicacion")
                                prefs.setObject(telefono, forKey: "telefono")
                                prefs.setObject("-1", forKey: "statusDeServicio")
                                prefs.setObject(false, forKey: "estatusPedido")
                                prefs.setObject("0", forKey: "idServicio")
                                prefs.setObject("0", forKey: "latitudGuardada")
                                prefs.setObject("0", forKey: "longitudGuardada")
                                prefs.setObject("0", forKey: "id_carro")
                                prefs.setObject("0", forKey: "categoria")
                                
                                prefs.synchronize();

                                
                                let alertView_usuario_incorrecto = UIAlertController(title: "Registro!", message: "Se ha registrado con éxito!", preferredStyle: .Alert)
                                alertView_usuario_incorrecto.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
                                    
                                    self.performSegueWithIdentifier("loginSegueFacebook", sender: self)
                                    
                                    self.nombreTextfield.text = ""
                                    self.apellidoTextfield.text = ""
                                    self.celularTextfield.text = ""
                                    self.correoTextfield.text = ""
                                    self.contraseñaTextfield.text = ""
                                    
                                }))
                                
                                self.presentViewController(alertView_usuario_incorrecto, animated: true, completion: nil)
                                
                            } else {
                                
                                let alertView_usuario_incorrecto = UIAlertView(title: "Registro", message: "Se ha registrado con éxito!", delegate: self, cancelButtonTitle: "OK")
                                
                                alertView_usuario_incorrecto.show()
                                
                                self.performSegueWithIdentifier("loginSegueFacebook", sender: self)
                                
                                self.nombreTextfield.text = ""
                                self.apellidoTextfield.text = ""
                                self.celularTextfield.text = ""
                                self.correoTextfield.text = ""
                                self.contraseñaTextfield.text = ""
                                
                            }
                            
                        })
                        
                    } else if(aux_exito == "2") {
                        
                        self.mostraMSJ("Ya existe un Usuario con ese número de teléfono!")
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.mostraMSJ("Error al dar de alta el Usuario, vuélvalo a intentar nuevamente.")
                            
                        })
                        
                    }
                }
                
            } catch {
                
                print(error)
                
            }
            
        })
        
        jsonQuery.resume()
        
    }
    
    
    func mostraMSJ(msj: String){
        
        if #available(iOS 8.0, *) {
            
            let alertView_usuario_incorrecto = UIAlertController(title: "Alerta!", message: msj, preferredStyle: .Alert)
            
            alertView_usuario_incorrecto.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
                self.presentViewController(alertView_usuario_incorrecto, animated: true, completion: nil)
            }))
            
        } else {
            
            let alertView_usuario_incorrecto = UIAlertView(title: "Quiero Taxi Cancún", message: msj, delegate: self, cancelButtonTitle: "OK")
            alertView_usuario_incorrecto.show()
            
        }
        
        
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func countryController(sender: AnyObject!, didSelectCountry chosenCountry: EMCCountry!) {
        //  self.codigoDeTelefono.text = chosenCountry.countryCode
        
        switch chosenCountry.countryCode {
        case "MX": self.codigoDeTelefono.text = "52"
        case "AR": self.codigoDeTelefono.text = "54"
        case "AD": self.codigoDeTelefono.text = "376"
        case "AE": self.codigoDeTelefono.text = "971"
        case "AF": self.codigoDeTelefono.text = "93"
        case "AG": self.codigoDeTelefono.text = "1268"
        case "AI": self.codigoDeTelefono.text = "1264"
        case "AL": self.codigoDeTelefono.text = "355"
        case "AM": self.codigoDeTelefono.text = "374"
        case "AO": self.codigoDeTelefono.text = "244"
        case "AQ": self.codigoDeTelefono.text = "672"
        case "AS": self.codigoDeTelefono.text = "1"
        case "AT": self.codigoDeTelefono.text = "43"
        case "AU": self.codigoDeTelefono.text = "61"
        case "AW": self.codigoDeTelefono.text = "297"
        case "AX": self.codigoDeTelefono.text = "358"
        case "AZ": self.codigoDeTelefono.text = "994"
        case "BA": self.codigoDeTelefono.text = "387"
        case "BB": self.codigoDeTelefono.text = "1246"
        case "BD": self.codigoDeTelefono.text = "880"
        case "BE": self.codigoDeTelefono.text = "32"
        case "BF": self.codigoDeTelefono.text = "226"
        case "BG": self.codigoDeTelefono.text = "359"
        case "BH": self.codigoDeTelefono.text = "973"
        case "BI": self.codigoDeTelefono.text = "257"
        case "BJ": self.codigoDeTelefono.text = "229"
        case "BL": self.codigoDeTelefono.text = "229"
        case "BM": self.codigoDeTelefono.text = "1441"
        case "BN": self.codigoDeTelefono.text = "673"
        case "BO": self.codigoDeTelefono.text = "591"
        case "BQ": self.codigoDeTelefono.text = "599"
        case "BR": self.codigoDeTelefono.text = "55"
        case "BS": self.codigoDeTelefono.text = "1242"
        case "BT": self.codigoDeTelefono.text = "975"
        case "BV": self.codigoDeTelefono.text = "47"
        case "BW": self.codigoDeTelefono.text = "267"
        case "BY": self.codigoDeTelefono.text = "375"
        case "BZ": self.codigoDeTelefono.text = "501"
        case "CA": self.codigoDeTelefono.text = "001"
        case "CC": self.codigoDeTelefono.text = "61"
        case "CD": self.codigoDeTelefono.text = "243"
        case "CF": self.codigoDeTelefono.text = "236"
        case "CG": self.codigoDeTelefono.text = "242"
        case "CH": self.codigoDeTelefono.text = "41"
        case "CI": self.codigoDeTelefono.text = "225"
        case "CK": self.codigoDeTelefono.text = "682"
        case "CL": self.codigoDeTelefono.text = "56"
        case "CM": self.codigoDeTelefono.text = "237"
        case "CN": self.codigoDeTelefono.text = "86"
        case "CO": self.codigoDeTelefono.text = "57"
        case "CR": self.codigoDeTelefono.text = "506"
        case "CU": self.codigoDeTelefono.text = "53"
        case "CV": self.codigoDeTelefono.text = "238"
        case "CW": self.codigoDeTelefono.text = "599"
        case "CX": self.codigoDeTelefono.text = "61"
        case "CY": self.codigoDeTelefono.text = "357"
        case "CZ": self.codigoDeTelefono.text = "420"
        case "DE": self.codigoDeTelefono.text = "49"
        case "DJ": self.codigoDeTelefono.text = "253"
        case "DK": self.codigoDeTelefono.text = "45"
        case "DM": self.codigoDeTelefono.text = "1767"
        case "DO": self.codigoDeTelefono.text = "1"
        case "DZ": self.codigoDeTelefono.text = "21"
        case "EC": self.codigoDeTelefono.text = "593"
        case "EE": self.codigoDeTelefono.text = "372"
        case "EG": self.codigoDeTelefono.text = "20"
        case "EH": self.codigoDeTelefono.text = "212"
        case "ER": self.codigoDeTelefono.text = "291"
        case "ES": self.codigoDeTelefono.text = "34"
        case "ET": self.codigoDeTelefono.text = "251"
        case "FI": self.codigoDeTelefono.text = "358"
        case "FJ": self.codigoDeTelefono.text = "679"
        case "FK": self.codigoDeTelefono.text = "1"
        case "FM": self.codigoDeTelefono.text = "691"
        case "FO": self.codigoDeTelefono.text = "298"
        case "FR": self.codigoDeTelefono.text = "33"
        case "GA": self.codigoDeTelefono.text = "241"
        case "GB": self.codigoDeTelefono.text = "44"
        case "GD": self.codigoDeTelefono.text = "1"
        case "GE": self.codigoDeTelefono.text = "995"
        case "GF": self.codigoDeTelefono.text = "594"
        case "GG": self.codigoDeTelefono.text = "44"
        case "GH": self.codigoDeTelefono.text = "233"
        case "GI": self.codigoDeTelefono.text = "350"
        case "GL": self.codigoDeTelefono.text = "299"
        case "GM": self.codigoDeTelefono.text = "220"
        case "GN": self.codigoDeTelefono.text = "224"
        case "GP": self.codigoDeTelefono.text = "590"
        case "GQ": self.codigoDeTelefono.text = "240"
        case "GR": self.codigoDeTelefono.text = "30"
        case "GS": self.codigoDeTelefono.text = "500"
        case "GT": self.codigoDeTelefono.text = "502"
        case "GU": self.codigoDeTelefono.text = "671"
        case "GW": self.codigoDeTelefono.text = "245"
        case "GY": self.codigoDeTelefono.text = "592"
        case "HK": self.codigoDeTelefono.text = "852"
        case "HM": self.codigoDeTelefono.text = "672"
        case "HN": self.codigoDeTelefono.text = "504"
        case "HR": self.codigoDeTelefono.text = "385"
        case "HT": self.codigoDeTelefono.text = "509"
        case "HU": self.codigoDeTelefono.text = "36"
        case "ID": self.codigoDeTelefono.text = "62"
        case "IE": self.codigoDeTelefono.text = "353"
        case "IL": self.codigoDeTelefono.text = "972"
        case "IM": self.codigoDeTelefono.text = "44"
        case "IN": self.codigoDeTelefono.text = "91"
        case "IO": self.codigoDeTelefono.text = "246"
        case "IQ": self.codigoDeTelefono.text = "964"
        case "IR": self.codigoDeTelefono.text = "98"
        case "IS": self.codigoDeTelefono.text = "354"
        case "IT": self.codigoDeTelefono.text = "39"
        case "JE": self.codigoDeTelefono.text = "44"
        case "JM": self.codigoDeTelefono.text = "876"
        case "JO": self.codigoDeTelefono.text = "962"
        case "JP": self.codigoDeTelefono.text = "81"
        case "KE": self.codigoDeTelefono.text = "254"
        case "KG": self.codigoDeTelefono.text = "996"
        case "KH": self.codigoDeTelefono.text = "855"
        case "KI": self.codigoDeTelefono.text = "686"
        case "KM": self.codigoDeTelefono.text = "269"
        case "KN": self.codigoDeTelefono.text = "1"
        case "KP": self.codigoDeTelefono.text = "850"
        case "KR": self.codigoDeTelefono.text = "82"
        case "KW": self.codigoDeTelefono.text = "965"
        case "KY": self.codigoDeTelefono.text = "1"
        case "KZ": self.codigoDeTelefono.text = "7"
        case "LA": self.codigoDeTelefono.text = "856"
        case "LB": self.codigoDeTelefono.text = "961"
        case "LC": self.codigoDeTelefono.text = "1"
        case "LI": self.codigoDeTelefono.text = "423"
        case "LK": self.codigoDeTelefono.text = "94"
        case "LR": self.codigoDeTelefono.text = "231"
        case "LS": self.codigoDeTelefono.text = "266"
        case "LT": self.codigoDeTelefono.text = "370"
        case "LU": self.codigoDeTelefono.text = "352"
        case "LV": self.codigoDeTelefono.text = "371"
        case "LY": self.codigoDeTelefono.text = "21"
        case "MA": self.codigoDeTelefono.text = "212"
        case "MC": self.codigoDeTelefono.text = "33"
        case "MD": self.codigoDeTelefono.text = "373"
        case "ME": self.codigoDeTelefono.text = "382"
        case "MF": self.codigoDeTelefono.text = "262"
        case "MG": self.codigoDeTelefono.text = "261"
        case "MH": self.codigoDeTelefono.text = "692"
        case "MK": self.codigoDeTelefono.text = "389"
        case "ML": self.codigoDeTelefono.text = "223"
        case "MM": self.codigoDeTelefono.text = "95"
        case "MN": self.codigoDeTelefono.text = "976"
        case "MO": self.codigoDeTelefono.text = "853"
        case "MP": self.codigoDeTelefono.text = "81"
        case "MQ": self.codigoDeTelefono.text = "596"
        case "MR": self.codigoDeTelefono.text = "222"
        case "MS": self.codigoDeTelefono.text = "1"
        case "MT": self.codigoDeTelefono.text = "356"
        case "MU": self.codigoDeTelefono.text = "230"
        case "MV": self.codigoDeTelefono.text = "960"
        case "MW": self.codigoDeTelefono.text = "265"
        case "MY": self.codigoDeTelefono.text = "60"
        case "MZ": self.codigoDeTelefono.text = "258"
        case "NA": self.codigoDeTelefono.text = "264"
        case "NC": self.codigoDeTelefono.text = "687"
        case "NE": self.codigoDeTelefono.text = "227"
        case "NF": self.codigoDeTelefono.text = "672"
        case "NG": self.codigoDeTelefono.text = "234"
        case "NI": self.codigoDeTelefono.text = "505"
        case "NL": self.codigoDeTelefono.text = "31"
        case "NO": self.codigoDeTelefono.text = "47"
        case "NP": self.codigoDeTelefono.text = "977"
        case "NR": self.codigoDeTelefono.text = "674"
        case "NU": self.codigoDeTelefono.text = "683"
        case "NZ": self.codigoDeTelefono.text = "64"
        case "OM": self.codigoDeTelefono.text = "968"
        case "PA": self.codigoDeTelefono.text = "507"
        case "PE": self.codigoDeTelefono.text = "51"
        case "PF": self.codigoDeTelefono.text = "689"
        case "PG": self.codigoDeTelefono.text = "675"
        case "PH": self.codigoDeTelefono.text = "63"
        case "PK": self.codigoDeTelefono.text = "92"
        case "PL": self.codigoDeTelefono.text = "48"
        case "PM": self.codigoDeTelefono.text = "508"
        case "PN": self.codigoDeTelefono.text = "870"
        case "PR": self.codigoDeTelefono.text = "787"
        case "PS": self.codigoDeTelefono.text = "970"
        case "PT": self.codigoDeTelefono.text = "351"
        case "PW": self.codigoDeTelefono.text = "680"
        case "PY": self.codigoDeTelefono.text = "595"
        case "QA": self.codigoDeTelefono.text = "974"
        case "RE": self.codigoDeTelefono.text = "262"
        case "RO": self.codigoDeTelefono.text = "40"
        case "RS": self.codigoDeTelefono.text = "381"
        case "RU": self.codigoDeTelefono.text = "7"
        case "RW": self.codigoDeTelefono.text = "250"
        case "SA": self.codigoDeTelefono.text = "966"
        case "SB": self.codigoDeTelefono.text = "677"
        case "SC": self.codigoDeTelefono.text = "248"
        case "SD": self.codigoDeTelefono.text = "249"
        case "SE": self.codigoDeTelefono.text = "46"
        case "SG": self.codigoDeTelefono.text = "65"
        case "SH": self.codigoDeTelefono.text = "290"
        case "SI": self.codigoDeTelefono.text = "386"
        case "SJ": self.codigoDeTelefono.text = "47"
        case "SK": self.codigoDeTelefono.text = "421"
        case "SL": self.codigoDeTelefono.text = "232"
        case "SM": self.codigoDeTelefono.text = "39"
        case "SN": self.codigoDeTelefono.text = "231"
        case "SO": self.codigoDeTelefono.text = "252"
        case "SR": self.codigoDeTelefono.text = "527"
        case "SS": self.codigoDeTelefono.text = "211"
        case "ST": self.codigoDeTelefono.text = "239"
        case "SV": self.codigoDeTelefono.text = "503"
        case "SX": self.codigoDeTelefono.text = "590"
        case "SY": self.codigoDeTelefono.text = "963"
        case "SZ": self.codigoDeTelefono.text = "268"
        case "TC": self.codigoDeTelefono.text = "1"
        case "TD": self.codigoDeTelefono.text = "235"
        case "TF": self.codigoDeTelefono.text = "594"
        case "TG": self.codigoDeTelefono.text = "228"
        case "TH": self.codigoDeTelefono.text = "66"
        case "TJ": self.codigoDeTelefono.text = "992"
        case "TK": self.codigoDeTelefono.text = "690"
        case "TL": self.codigoDeTelefono.text = "670"
        case "TM": self.codigoDeTelefono.text = "993"
        case "TN": self.codigoDeTelefono.text = "21"
        case "TO": self.codigoDeTelefono.text = "676"
        case "TR": self.codigoDeTelefono.text = "90"
        case "TT": self.codigoDeTelefono.text = "868"
        case "TV": self.codigoDeTelefono.text = "688"
        case "TW": self.codigoDeTelefono.text = "886"
        case "TZ": self.codigoDeTelefono.text = "255"
        case "UA": self.codigoDeTelefono.text = "380"
        case "UG": self.codigoDeTelefono.text = "256"
        case "UM": self.codigoDeTelefono.text = "1"
        case "US": self.codigoDeTelefono.text = "1"
        case "UY": self.codigoDeTelefono.text = "598"
        case "UZ": self.codigoDeTelefono.text = "998"
        case "VA": self.codigoDeTelefono.text = "39"
        case "VC": self.codigoDeTelefono.text = "784"
        case "VE": self.codigoDeTelefono.text = "58"
        case "VG": self.codigoDeTelefono.text = "1"
        case "VI": self.codigoDeTelefono.text = "1"
        case "VN": self.codigoDeTelefono.text = "84"
        case "VU": self.codigoDeTelefono.text = "678"
        case "WF": self.codigoDeTelefono.text = "681"
        case "WS": self.codigoDeTelefono.text = "685"
        case "YE": self.codigoDeTelefono.text = "967"
        case "ZA": self.codigoDeTelefono.text = "243"
        case "ZM": self.codigoDeTelefono.text = "260"
        case "ZW": self.codigoDeTelefono.text = "263"
        case "YT": self.codigoDeTelefono.text = "590"
        default:
            break
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "openCountryPicker" {
            let destinoVC = segue.destinationViewController as! EMCCountryPickerController
            destinoVC.showFlags = true
            destinoVC.countryDelegate = self
            destinoVC.drawFlagBorder = true
            destinoVC.flagBorderColor = UIColor.grayColor()
            destinoVC.flagBorderWidth = 0.5
            
            
        }
    }
    
}
