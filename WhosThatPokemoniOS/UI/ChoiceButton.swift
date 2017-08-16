//
//  ChoiceButton.swift
//  WhosThatPokemoniOS
//
//  Created by Dylan Conway on 16/08/2017.
//  Copyright © 2017 Routematch Ireland. All rights reserved.
//

import UIKit

@IBDesignable
class ChoiceButton: UIButton {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var title: String = "" {
        didSet {
            self.setTitle(title, for: .normal)
            self.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = self.cornerRadius
        self.setTitleColor(UIColor.black, for: .normal)
        
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.black.cgColor
    }
    
    func reset() {
        setup()
    }
}
