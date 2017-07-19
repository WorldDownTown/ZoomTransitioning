//
//  NavigationController.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/09/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {

    private let zoomNavigationControllerDelegate = ZoomNavigationControllerDelegate()
    private let popGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = zoomNavigationControllerDelegate
    }
    
    override func viewDidLoad() {
        let zoomInteractiveTransition = zoomNavigationControllerDelegate.zoomInteractiveTransition
        zoomInteractiveTransition.navigationController = self
        zoomInteractiveTransition.popGestureRecognizer = popGestureRecognizer
        
        popGestureRecognizer.delegate = zoomInteractiveTransition
        popGestureRecognizer.addTarget(zoomInteractiveTransition, action: #selector(ZoomInteractiveTransition.handle(recognizer:)))
        popGestureRecognizer.edges = .left
        self.view.addGestureRecognizer(popGestureRecognizer)
        
        self.interactivePopGestureRecognizer?.delegate = zoomInteractiveTransition
    }
}
