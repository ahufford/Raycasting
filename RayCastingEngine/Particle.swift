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

    let turnRate: CGFloat = 0.025
    let moveSpeed: CGFloat = 3


    var rays: [Ray] = []
    var screenWidth: CGFloat = 0.0
    var FOV:CGFloat = 40.0
    var dir: CGPoint = CGPoint.zero

    init(position: CGPoint, screenWidth: CGFloat) {
        super.init()
        self.position = position
        self.screenWidth = screenWidth
        setFOV(degrees: 40.0)
        self.dir = CGPoint(angle: 0)
    }

    func setFOV(degrees: CGFloat){

        FOV = degrees

        let step = FOV / screenWidth
        let sequence = stride(from: -1 * (FOV / 2), to: (FOV / 2), by: step)

        for ang in sequence {
            let center = self.position + CGPoint(x: 10, y:10)
            rays.append(Ray(position: center, angle: CGFloat(self.deg2rad(Double(ang)))))
        }
    }

    func turn(right: Bool) {
        if right {
            for ray in rays {
                let angle = ray.dir.angle - turnRate
                let newPoint = CGPoint(angle: angle)
                ray.lookAt(pos: newPoint + ray.position)
            }
            let newDir = dir.angle - turnRate
            let newDirPoint = CGPoint(angle: newDir)
            dir = newDirPoint
        } else {
            for ray in rays {
                let angle = ray.dir.angle + turnRate
                let newPoint = CGPoint(angle: angle)
                ray.lookAt(pos: newPoint + ray.position)
            }
            let newDir = dir.angle + turnRate
            let newDirPoint = CGPoint(angle: newDir)
            dir = newDirPoint
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

    struct RayInfo {
        let point: CGPoint
        let dir: CGPoint
        let boundryTouching: Boundry
    }

    func detectBoundry(boundries: [Boundry]) -> [RayInfo] {
        var points: [RayInfo] = []
        for ray in rays {
            var closest: CGPoint? = nil
            var boundry: Boundry? = nil

            var record = CGFloat.infinity
            for b in boundries {
                let point = ray.cast(boundry: b)
                if (point != nil) {
                    let distance = self.position.distanceTo(point!)
                    if distance < record {
                        record = distance
                        closest = point
                        boundry = b
                    }
                }
            }
            if closest != nil {
                ray.drawToIntersect(point: closest!)
                points.append(RayInfo(point: closest!, dir: ray.dir, boundryTouching: boundry!))
            }
        }
        return points
    }


    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
}

