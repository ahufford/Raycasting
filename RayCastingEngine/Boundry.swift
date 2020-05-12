//
//  Bpundry.swift
//  RayCastingEngine
//
//  Created by Alec on 5/11/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
//

import Foundation
import SpriteKit

class Boundry: SKShapeNode {
    var a: CGPoint
    var b: CGPoint


    init(start: CGPoint, end: CGPoint) {
        a = start
        b = end

        super.init()

        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: a)
        pathToDraw.addLine(to: b)
        self.path = pathToDraw
        self.strokeColor = .red

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
