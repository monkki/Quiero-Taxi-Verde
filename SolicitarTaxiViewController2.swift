//
//  SolicitarTaxiViewController2.swift
//  Quiero Taxi
//
//  Created by Doctor on 12/1/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit
import MapKit

// Index
var index: Int = 0

class SolicitarTaxiViewController2: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, HWViewPagerDelegate {
    
    
    // Outlets
    @IBOutlet var direccionTextfield: UITextField!
    @IBOutlet var numeroExteriorTexfield: UITextField!
    @IBOutlet var coloniaTextfield: UITextField!
    @IBOutlet var referenciasTextfield: UITextField!
    @IBOutlet var sliderAutos: HWViewPager!

    
    // Variables para pedir taxi
    var valorNumerico = "1"
    var direccion = ""
    var colonia = ""
    var numeroExterior = ""
    var referencias = ""
    var telefono: String!
    
    // Loader
    var progressHUD: UIView!
    
    // Variables de ubicacion
    var latitudeRecibida: String!
    var longitudeRacibida: String!
    
    
    // Informacion Carros Black
    var latitudArray: [String] = []
    var longitudArray: [String] = []
    var categoriaArray: [String] = []
    var vehiculoArray: [String] = []
    var capacidadArray: [String] = []
    var id_carroArray: [String] = []
    var imagenArray: [String] = []
    var distanceArray: [String] = []
    var imagenesUIImages: [UIImage] = []
    
    
    @IBAction func cancelarBoton(sender: AnyObject) {
        
        
    }
    
    
    @IBAction func aceptarBoton(sender: AnyObject) {
       
        
        numeroExterior = numeroExteriorTexfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        referencias = referenciasTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        direccion = direccionTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        colonia = coloniaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        valorNumerico = valorNumerico.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        latitudeRecibida = latitudeRecibida.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        longitudeRacibida = longitudeRacibida.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        telefono = telefono.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        //numeroExterior == "" ||
        
        if(referencias == "" || direccion == "" || colonia == "" || valorNumerico == ""){
            mostraMSJ("Favor de completar los datos!")
            
        }else {
            
            
            if #available(iOS 8.0, *) {
                // Loader
                progressHUD = ProgressHUD(text: "Obteniendo ubicacion")
                self.view.addSubview(progressHUD)
                
            }
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            solicitarTaxi();
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegados de textfields
        direccionTextfield.delegate = self
        numeroExteriorTexfield.delegate = self
        referenciasTextfield.delegate = self
        coloniaTextfield.delegate = self
        
        // Gesture para ocultar teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "irASegueSliderAutos")
       
        sliderAutos.addGestureRecognizer(tap2)
        
        // Se asigna valores recibidos del mapa
        direccionTextfield.text = direccion
        coloniaTextfield.text = colonia
        
        // Se asigna la imagen de fondo
        view.backgroundColor = UIColor.darkTextColor()
        
        obtenerCarrosBlack()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("Index en Solicitar Taxi es: \(index)")
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //self.sliderAutos.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // FUNCION PARA SOLICITAR TAXIS
    
    func solicitarTaxi(){
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        var categoria = categoriaArray[index] as String
        var idCarro = id_carroArray[index] as String
        
        categoria = categoria.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        idCarro = idCarro.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        direccion = direccion.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        //colonia = colonia.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        //numeroExterior = numeroExterior.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        referencias = referencias.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        latitudeRecibida = latitudeRecibida.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        longitudeRacibida = longitudeRacibida.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        telefono = telefono?.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        var numeroYColonia = numeroExterior + " Col: " + colonia
        numeroYColonia = numeroYColonia.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        
        let urlObj = Urls();
        let urlString = urlObj.getUrlPedirTaxi(direccion, numero: numeroYColonia, referencia: referencias, longitud: longitudeRacibida, latitud: latitudeRecibida, categoria: categoria , id_carro: idCarro, telefono: telefono!)
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
                            
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            let idServicio: String! = jsonResult[0]["id_servicio"] as! NSString as String
                            let categoria: String! = jsonResult[0]["categoria"] as! NSString as String
                            let idCarro: String! = jsonResult[0]["id_carro"] as! NSString as String
                            
                            NSUserDefaults.standardUserDefaults().setObject(idServicio, forKey: "idServicio")
                            NSUserDefaults.standardUserDefaults().setObject(categoria, forKey: "categoria")
                            NSUserDefaults.standardUserDefaults().setObject(idCarro, forKey: "id_carro")
                            NSUserDefaults.standardUserDefaults().setObject("0", forKey: "statusDeServicio")
                            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "estatusPedido")
                            
                            if #available(iOS 8.0, *) {
                                
                                let progrees = self.progressHUD as! ProgressHUD
                                progrees.hide()
                                
                            }
                            
                            self.performSegueWithIdentifier("taxiSolicitado", sender: self)
                            
                        })
                        
                    } else if(aux_exito == "2"){
                        
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        self.mostraMSJ("Lo sentimos su usuario esta inactivo")
                    
                        if #available(iOS 8.0, *) {
                            
                            let progrees = self.progressHUD as! ProgressHUD
                            progrees.hide()
                            
                        }
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            self.mostraMSJ("Error al pedir su Taxi, intente nuevamente mas tarde.");
                            
                            if #available(iOS 8.0, *) {
                                
                                let progrees = self.progressHUD as! ProgressHUD
                                progrees.hide()
                                
                            }
                        })
                        
                    }
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        self.mostraMSJ("Por favor compruebe su conexion a Internet");
                        
                        if #available(iOS 8.0, *) {
                            
                            let progrees = self.progressHUD as! ProgressHUD
                            progrees.hide()
                            
                        }
                    })
                    
                }
                
                
            } catch {
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                print(error)
                
            }
            
        })
        
        jsonQuery.resume()
    }
    
    
    func mostraMSJ(msj: String){
        
        if #available(iOS 8.0, *) {
            
            let alertView_usuario_incorrecto = UIAlertController(title: "Alerta!", message: msj, preferredStyle: .Alert)
            alertView_usuario_incorrecto.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertAction) -> Void in
            }))
            self.presentViewController(alertView_usuario_incorrecto, animated: true, completion: nil)
            
        } else {
            
            let alertView_usuario_incorrecto = UIAlertView(title: "Alerta!", message: msj, delegate: self, cancelButtonTitle: "OK")
            
            alertView_usuario_incorrecto.show()
            
        }
        
    }
    
    // FUNCIONES DEL SELECCIONADOR DE AUTOS
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Celda", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.imagenView.image = imagenesUIImages[indexPath.row]
        cell.label1.text = vehiculoArray[indexPath.row]
        cell.label2.text = capacidadArray[indexPath.row]
        cell.label3.text = distanceArray[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return vehiculoArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detalleAuto", sender: self)
    }
    
    
    func pagerDidSelectedPage(selectedPage: Int) {
        
        //print("Pagina seleccionada: \(selectedPage)")
        index = selectedPage
        print("Index al hace slider es:  \(index)")

        
    }
    

    func obtenerCarrosBlack() {
        
        let urls = Urls()
        
        let urlString = urls.getCarrosBlack(latitudeRecibida, longitud: longitudeRacibida)
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                } else {
                    
                    do {
                        
                        if let data = data {
                        
                            let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                        
                            // print(jsonResponse[0])
                            let aux_exito: String! = jsonResponse[0]["success"] as! NSString as String
                            print(aux_exito)
                        
                            if(aux_exito == "1"){
                            
                                //  let jsonResult = jsonResponse[0]["mensaje"] as? NSMutableArray
                                if let carrosArray = jsonResponse[0]["carros"] as? NSMutableArray {
                            
                                    //  print(carrosArray!)
                            
                                    for carros in carrosArray as NSMutableArray! {
                                
                                        let latitud = carros["latitud"] as! String
                                        let longitud = carros["longitud"] as! String
                                        let categoria = carros["categoria"] as! String
                                        let vehiculo = carros["vehiculo"] as! String
                                        let capacidad = carros["capacidad"] as! String
                                        let id_carro = carros["id_carro"] as! String
                                        let imagen = carros["imagen"] as! String
                                        let distance = carros["distance"] as! String
                                
                                
                                        self.latitudArray.append(latitud)
                                        self.longitudArray.append(longitud)
                                        self.categoriaArray.append(categoria)
                                        self.vehiculoArray.append(vehiculo)
                                        self.capacidadArray.append(capacidad)
                                        self.id_carroArray.append(id_carro)
                                        self.imagenArray.append(imagen)
                                        self.distanceArray.append(distance)
                                
                                    }
                                
                                }
                            
                                //print(self.imagenArray)
                            
                            } else if(aux_exito == "2"){
                            
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.mostrarMensaje("De momento no encontramos autos cercanos", titulo:"Quiero Taxi")
                                })
                            
                            } else if(aux_exito == "0"){
                            
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.mostrarMensaje("Intente nuevamente mas tarde", titulo:"Error al obtener datos")
                                })
                            
                            }
                        
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.mostraMSJ("Por favor compruebe su conexion a Internet");
                            })
                            
                        }
                            
                    } catch {}
                    
                    
                    
                    for imagenes in self.imagenArray {
                        
                        let decodedData = NSData(base64EncodedString: imagenes, options: NSDataBase64DecodingOptions(rawValue: 0))
                        let decodedimage = UIImage(data: decodedData!)
                        
                        if let decodedImagen = decodedimage {
                            self.imagenesUIImages.append(decodedImagen)
                        }
                        
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self.sliderAutos.reloadData()
                    
                })
                
            }
            
            task.resume()
            
        }
        
    }
    
    
    func mostrarMensaje(mensaje: String, titulo: String){
        
        if #available(iOS 8.0, *) {
            let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alerta, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let alerta = UIAlertView(title: titulo, message: mensaje, delegate: self, cancelButtonTitle: "Aceptar")
            alerta.show()
        }
        
        
    }

    
    // SEGUE DETALLE DE AUTOS 
    
    func irASegueSliderAutos() {
        
        self.performSegueWithIdentifier("segueDetalleAuto", sender: self)
        
    }

    
        // MARK: - Navigation
    
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "segueDetalleAuto" {
                let destinoVC = segue.destinationViewController as! PaginasViewController
                
                destinoVC.vehiculosRecibidos = vehiculoArray
                destinoVC.imagenesRecibidas = imagenesUIImages
                destinoVC.vehiculosRecibidos = vehiculoArray
                destinoVC.capacidadRecibidas = capacidadArray
                destinoVC.latitudesRecibidas = latitudArray
                destinoVC.longitudRecibidas = longitudArray
                destinoVC.categoriaRecibidas = categoriaArray
                destinoVC.id_carroRecibidas = id_carroArray
                destinoVC.distanceRecibidas = distanceArray
                destinoVC.indexRecibido = index

            }
        }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
        
    }
    
}
