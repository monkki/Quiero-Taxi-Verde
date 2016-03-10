//
//  PaginasViewController.swift
//  Quiero Taxi
//
//  Created by Doctor on 12/2/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class PaginasViewController: UIViewController, UIPageViewControllerDataSource {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    var vehiculosRecibidos = [String]()
    var latitudesRecibidas: [String] = []
    var longitudRecibidas: [String] = []
    var categoriaRecibidas: [String] = []
    var capacidadRecibidas: [String] = []
    var id_carroRecibidas: [String] = []
    var imagenRecibidas: [String] = []
    var distanceRecibidas: [String] = []
    var imagenesRecibidas: [UIImage] = []
    
    var indexRecibido: Int!
   
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Index en Paginas es:  \(index)")
        createPageViewController()
        setupPageControl()
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if imagenesRecibidas.count > 0 {
            let firstController = getItemController(indexRecibido)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.lightGrayColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < imagenesRecibidas.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        
        indexRecibido = itemIndex
        
        if itemIndex < imagenesRecibidas.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            pageItemController.itemIndex = indexRecibido
            pageItemController.imagenes = imagenesRecibidas[itemIndex]
            pageItemController.nombreVehiculo = vehiculosRecibidos[itemIndex]
            pageItemController.capacidad = capacidadRecibidas[itemIndex]
            pageItemController.tipoAuto = vehiculosRecibidos[itemIndex]
            
            return pageItemController
        }
        
        return nil
    }
    
    
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return imagenesRecibidas.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return indexRecibido
    }
    
    
}

