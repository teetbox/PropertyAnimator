//
//  ViewController.swift
//  PropertyAnimator
//
//  Created by Matt Tian on 2018/5/22.
//  Copyright © 2018 TTSY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transform = UIBarButtonItem(title: "Transform", style: .plain, target: self, action: #selector(handleTransform))
        navigationItem.rightBarButtonItem = transform
        
        let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.leftBarButtonItem = reset
        
        setupViews()
    }
    
    @objc func handleTransform() {
        // Normal way
        /*
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut], animations: {
            self.rectView.transform = CGAffineTransform(translationX: 200, y: 0)
            self.rectView.alpha = 0.5
        }, completion: nil)
        */
        
        // Animator
        let animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeOut) {
            self.rectView.transform = CGAffineTransform(translationX: 200, y: 0)
            self.rectView.alpha = 0.5
        }
        animator.startAnimation()
    }
    
    @objc func handleReset() {
        rectView.transform = CGAffineTransform(translationX: 0, y: 0)
        rectView.alpha = 1
    }
    

    let rectView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fromHEX(string: "#327EEB")
        return view
    }()
    
    func setupViews() {
        view.addSubview(rectView)
        view.addConstraints(format: "H:|[v0(100)]", views: rectView)
        view.addConstraints(format: "V:[v0(100)]", views: rectView)
        rectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        rectView.addGestureRecognizer(panGesture)
    }
    
    var panAnimator = UIViewPropertyAnimator()
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            panAnimator = UIViewPropertyAnimator(duration: 1.5, curve: .easeOut, animations: {
                self.rectView.transform = CGAffineTransform(translationX: 200, y: 0)
                self.rectView.alpha = 0
            })
            panAnimator.startAnimation()
            panAnimator.pauseAnimation()
        case .changed:
            panAnimator.fractionComplete = recognizer.translation(in: rectView).x / 200
        case .ended:
            panAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            return
        }
    }
    
}

