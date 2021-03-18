//
//  ColorExtention.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 16.03.21.
//

import Foundation
import UIKit

extension UIButton {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, gradientbrake: [NSNumber], startX: Double, startY: Double, endX: Double, endY: Double){
    
        let gradientLayer = CAGradientLayer()
        
        // this meand the gradient layer is the same size as the object its in
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        // for making sure where the gradientbrake is! right now its 50-50
        gradientLayer.locations = gradientbrake
        
        // to determine where your starting and endcolor are! here its diagonal
        gradientLayer.startPoint = CGPoint(x: startX, y: startY)
        gradientLayer.endPoint = CGPoint(x: endX, y: endY)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

extension UIView {
    func setGradientViewBackground(colorOne: UIColor, colorTwo: UIColor, gradientbrake: [NSNumber], startX: Double, startY: Double, endX: Double, endY: Double){
    
        let gradientLayer = CAGradientLayer()
        
        // this meand the gradient layer is the same size as the object its in
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        // for making sure where the gradientbrake is! right now its 50-50
        gradientLayer.locations = gradientbrake
        
        // to determine where your starting and endcolor are! here its diagonal
        gradientLayer.startPoint = CGPoint(x: startX, y: startY)
        gradientLayer.endPoint = CGPoint(x: endX, y: endY)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

