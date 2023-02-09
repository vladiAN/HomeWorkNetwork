//
//  NewTabBarController.swift
//  HomeWorkNetworking
//
//  Created by Алина Андрушок on 07.02.2023.
//

import UIKit

class NewTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    setTabBar()
    }
    
    private func setTabBar() {
        let positionX: CGFloat = 10
        let positionY: CGFloat = 14
        let widht = tabBar.bounds.width - positionX * 2
        let height = tabBar.bounds.height + positionY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionX,
                y: tabBar.bounds.minY - positionY,
                width: widht,
                height: height
            ),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = widht / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
    
}

extension UIColor {
    static var tabBarItemAccent: UIColor {
        #colorLiteral(red: 0.2618551552, green: 0.2592443824, blue: 0.8865405321, alpha: 1)
    }
    static var mainWhite: UIColor {
        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    static var tabBarItemLight: UIColor {
        #colorLiteral(red: 0.4245075583, green: 0.4002028108, blue: 0.8823996186, alpha: 0.5)
    }
}
