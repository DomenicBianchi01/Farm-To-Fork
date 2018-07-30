//
//  ProgrssButton.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class ProgressButton: UIButton {
    // MARK: - Properties
    private var activityIndicator: UIActivityIndicatorView
    private var originalTitle: String? = nil
    
    // MARK: - Lifecycle Functions
    override init(frame: CGRect) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .white
        self.activityIndicator = activityIndicator
        super.init(frame: frame)
        addSubview(activityIndicator)
        addConstraints(to: self.activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .white
        self.activityIndicator = activityIndicator
        super.init(coder: aDecoder)
        addSubview(activityIndicator)
        addConstraints(to: self.activityIndicator)
    }
    
    // MARK: - Activity Indicator Functions
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.originalTitle = self.titleLabel?.text
            self.setTitle(nil, for: .normal)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.setTitle(self.originalTitle, for: .normal)
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Private Helper Functions
    private func addConstraints(to activityIndicator: UIActivityIndicatorView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([xCenterConstraint, yCenterConstraint])
    }
}
