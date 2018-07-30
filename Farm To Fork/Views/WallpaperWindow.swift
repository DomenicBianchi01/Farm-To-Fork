//
//  WallpaperWindow.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class WallpaperWindow: UIWindow {
    // MARK: - Properties
    private let wallpaper = UIImageView(image: #imageLiteral(resourceName: "Splash"))
    
    // MARK: - Lifecycle Functions
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        wallpaper.contentMode = .scaleAspectFill
        wallpaper.translatesAutoresizingMaskIntoConstraints = false
        
        insertSubview(wallpaper, at: 0)
        
        let topConstraint = NSLayoutConstraint(item: wallpaper, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: wallpaper, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: wallpaper, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: wallpaper, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
