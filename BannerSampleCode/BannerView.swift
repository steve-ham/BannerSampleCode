//
//  BannerView.swift
//  BikeDeposit
//
//  Created by steve on 07/02/2019.
//  Copyright © 2019 BrainTools. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(frame: bounds)
    }
    
    private func setup(frame: CGRect) {
        backgroundColor = .red
        clipsToBounds = true
        
        let navigationBarHeight = frame.size.height - UIApplication.shared.statusBarFrame.height
        let errorLabelContainerView = UIView(frame: CGRect(x: 0.0, y: UIApplication.shared.statusBarFrame.height, width: frame.size.width, height: navigationBarHeight))
        
        let errorLabel = UILabel(frame: .zero)
        errorLabel.text = "Banner test."
        errorLabel.textColor = .white
        errorLabelContainerView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leadingAnchor.constraint(equalTo: errorLabelContainerView.leadingAnchor, constant: 8).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: errorLabelContainerView.centerYAnchor).isActive = true
        
        addSubview(errorLabelContainerView)
    }
    
}
