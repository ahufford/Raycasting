//
//  Ray.swift
//  RayCastingEngine
//
//  Created by Alec on 5/12/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
//

import Foundation
import SpriteKit

class Ray: SKShapeNode {

    // draw the ray to the point of intersection
    var castToIntersect = true

    var dir: CGPoint

    init(position: CGPoint, angle: CGFloat) {
        dir = CGPoint.init(angle: angle)
        super.init()
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func draw() {
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: 0, y: 0))
        pathToDraw.addLine(to: CGPoint(x: 0, y: 0) + self.dir * 20)
        self.path = pathToDraw
        self.strokeColor = .green
    }

    func drawToIntersect(point: CGPoint) {
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: 0, y: 0))
        pathToDraw.addLine(to: point - self.position)
        self.path = pathToDraw
        self.strokeColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
    }

    func lookAt(pos: CGPoint) {
        dir.x = pos.x - position.x
        dir.y = pos.y - position.y
        dir = dir.normalize()
    }

    func cast(boundry: Boundry) -> CGPoint? {
        let x1 = boundry.a.x
        let y1 = boundry.a.y
        let x2 = boundry.b.x
        let y2 = boundry.b.y

        let x3 = self.position.x
        let y3 = self.position.y
        let x4 = self.position.x + dir.x
        let y4 = self.position.y + dir.y

        // denomator is the same for both equations

        let denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        // this means they are paralell
        if denominator == 0 {
            return nil
        }

        let t = ( (x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
        let u = -1 * ((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator

        // If they intersect
        // we also only need u > 0 as we are a ray not a line segemnt
        if t > 0 && t < 1 && u > 0 {
            let intersectingPoint = CGPoint(x: x1 + t * (x2 - x1), y: y1 + t * (y2 - y1))
            if (castToIntersect) {
                drawToIntersect(point: intersectingPoint)
            }
            return intersectingPoint
        }

        return nil
    }
}
