//
//  EmojiSceneView.swift
//  EmojiScene
//
//  Created by Dumitru Gutu on 12/16/17.
//  Copyright © 2017 Dumitru Gutu. All rights reserved.
//

import UIKit

class EmojiSceneView: UIView {
    
    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
