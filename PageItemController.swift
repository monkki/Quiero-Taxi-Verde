//
//  PageItemController.swift
//  Quiero Taxi
//
//  Created by Doctor on 12/2/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//


import UIKit

class PageItemController: UIViewController {
    
    @IBOutlet var tipoLabel: UILabel!
    @IBOutlet var capacidadLabel: UILabel!
    @IBOutlet var vehiculoLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - Variables
    var itemIndex: Int!
    var imagenes: UIImage!
    var capacidad: String!
    var tipoAuto: String!
    var nombreVehiculo: String!
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = imagenes
            }
            
        }
    }
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        index = itemIndex
        contentImageView!.image = imagenes
        vehiculoLabel.text = nombreVehiculo
        tipoLabel.text = tipoAuto
        capacidadLabel.text = capacidad
        print("Index en Pagina detalle es: \(index)")
    }
        
    @IBAction func seleccionarBoton(sender: AnyObject) {
        
       self.dismissViewControllerAnimated(true) { () -> Void in
        
        //let destinoVC = SolicitarTaxiViewController2()
        //destinoVC.index = self.itemIndex
        
        
        }
        
    }
    
}
