//
//  Particle.swift
//  RayCastingEngine
//
//  Created by Alec on 5/12/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
//

import Foundation
import SpriteKit

class Particle: SKShapeNode {

    var rays: [Ray] = []

    init(position: CGPoint) {
        super.init()
        self.position = position

        let sequence = stride(from: 0, to: 360, by: 0.5)

        for ang in sequence {
            let center = self.position + CGPoint(x: 10, y:10)
            rays.append(Ray(position: center, angle: CGFloat(self.deg2rad(Double(ang)))))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func draw() {
        let path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 20)), transform: nil)
        self.path = path
        self.strokeColor = .green

        for r in rays {
            r.position = self.position + CGPoint(x: 10, y:10)
            r.draw()
        }
    }

    func detectBoundry(boundries: [Boundry]) -> [CGPoint] {
        var points: [CGPoint] = []
        for ray in rays {
            var closest: CGPoint? = nil
            var record = CGFloat.infinity
            for b in boundries {
                let point = ray.cast(boundry: b)
                if (point != nil) {
                    let distance = self.position.distanceTo(point!)
                    if distance < record {
                        record = distance
                        closest = point
                    }
                }
            }
            if closest != nil {
                ray.drawToIntersect(point: closest!)
                points.append(closest!)
            }
        }
        return points
    }


    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
}

