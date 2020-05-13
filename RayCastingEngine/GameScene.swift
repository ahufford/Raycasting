//
//  GameScene.swift
//  RayCastingEngine
//
//  Created by Alec on 5/11/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {


    var touchPos: CGPoint?
    var screenBounds: CGRect = CGRect.zero
    var twoDBounds: CGRect = CGRect.zero

    //movment
    var turnRight = false
    var turnLeft = false
    var goForward = false
    var goBack = false

    var threeDBounds: CGRect = CGRect.zero
    var wallLines: [SKShapeNode] = []

    var viewController: GameViewController!

    var b: Boundry!
    var r: Ray!

    var boundries: [Boundry] = []

    var particle: Particle!

    override func didMove(to view: SKView) {
        screenBounds = view.bounds
        twoDBounds = CGRect(origin: screenBounds.origin, size: CGSize(width: screenBounds.width, height: screenBounds.height / 2))
        threeDBounds = CGRect(origin: CGPoint(x: 0.0, y: screenBounds.height / 2), size: CGSize(width: screenBounds.width, height: screenBounds.height / 2))
        print(twoDBounds)
        print(threeDBounds)
        touchPos = nil

        randomWalls()
        edgeWalls()
        
        r = Ray(position: CGPoint(x: 60.0, y: 400.0), angle: 0)
        //addChild(r)

        particle = Particle(position: CGPoint(x: 50, y: 200), screenWidth: threeDBounds.width)

        addChild(particle)
        for r in particle.rays {
            addChild(r)
        }
    }


    func randomWalls() {
        for _ in 0...5 {
            let x1 = CGFloat.random(in: 0...twoDBounds.width)
            let y1 = CGFloat.random(in: 0...twoDBounds.height)
            let x2 = CGFloat.random(in: 0...twoDBounds.width)
            let y2 = CGFloat.random(in: 0...twoDBounds.height)

            b = Boundry(start: CGPoint(x: x1, y: y1), end: CGPoint(x: x2, y: y2), color: getRandomColor())
            boundries.append(b)
        }

        for b in boundries {
            addChild(b)
        }

    }
    func getRandomColor() -> SKColor {
        let rand = Int.random(in: 1...4)
        switch rand {
        case 1:
            return .blue
        case 2:
            return .red
        case 3:
            return .green
        case 4:
            return .orange
        default:
            return .white
        }
    }

    func edgeWalls() {
        let bottomLeft = CGPoint.zero
        let topLeft = CGPoint(x: 0, y: twoDBounds.height)
        let topRight = CGPoint(x: twoDBounds.width, y: twoDBounds.height)
        let bottomRight = CGPoint(x: twoDBounds.width, y: 0
        )
        let leftWall = Boundry(start:bottomLeft, end: topLeft, color: .white)
        let topWall = Boundry(start:topLeft, end: topRight, color: .white)
        let rightWall = Boundry(start:topRight, end: bottomRight, color: .white)
        let bottomWall = Boundry(start:bottomRight, end: bottomLeft, color: .white)

        boundries.append(leftWall)
        boundries.append(topWall)
        boundries.append(rightWall)
        boundries.append(bottomWall)
        addChild(leftWall)
        addChild(topWall)
        addChild(rightWall)
        addChild(bottomWall)

    }

    func touchDown(atPoint pos : CGPoint) {
        touchPos = pos



    }

    func squareSprite(point: CGPoint, color: UIColor) {
        let centerSprite = SKSpriteNode(color: color, size: CGSize(width: 4, height: 4))
        centerSprite.position = point

        let wait = SKAction.wait(forDuration: 0.00001)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([wait, remove])
        centerSprite.run(seq)
        addChild(centerSprite)
    }

    func touchMoved(toPoint pos : CGPoint) {
        touchPos = pos
        if twoDBounds.contains(pos) {
            particle.position = pos
        }

    }
    
    func touchUp(atPoint pos : CGPoint) {
        touchPos = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if r == nil {
            return
        }

        if turnLeft {
            particle.turn(right: false)
        } else if turnRight {
            particle.turn(right: true)
        }

        if goForward {
            let vel = particle.dir * particle.moveSpeed
            particle.position = particle.position + vel
        } else if goBack {
            let vel = particle.dir * -particle.moveSpeed
            particle.position = particle.position + vel
        }


        particle.draw()

        let detects = particle.detectBoundry(boundries: boundries)
        //let distances = distanceFrom(position: particle.position , detections: detects)
        let distances = projectedDistance(position: particle.position, angle: particle.dir.angle, detections: detects)
        var colors: [SKColor] = []
        for d in detects {
            colors.append(d.boundryTouching.color)
        }
        draw3d(distances: distances, colors: colors)


        //for p in detects {
        //    squareSprite(point: p, color: .orange)
        //}
        //r.draw()
        //let intersect = r.cast(boundry: b)
        //if intersect != nil {
            //quareSprite(point: intersect!, color: .orange)
        //}

    }

    func distanceFrom(position: CGPoint, detections: [CGPoint]) -> [CGFloat]? {
        if detections.count == 0 {
            return nil
        }
        var distances: [CGFloat] = []
        for det in detections {
            distances.append(det.distanceTo(position))
        }
        return distances
    }
    // this is the projection of the ray to the view

    func projectedDistance(position: CGPoint, angle: CGFloat, detections: [Particle.RayInfo]) -> [CGFloat]? {
        if detections.count == 0 {
            return nil
        }
        var distances: [CGFloat] = []
        for det in detections {
            var d = position.distanceTo(det.point)
            let a = det.dir.angle - angle
            d *= cos(a)
            distances.append(d)
        }
        return distances
    }

    func draw3d(distances: [CGFloat]?, colors: [SKColor]) {
        for wall in wallLines {
            wall.removeFromParent()
        }
        wallLines.removeAll()
        let maxViewDistance = max(twoDBounds.width, twoDBounds.height)

        if distances == nil {
            return
        }
        for i in 0...distances!.count - 1 {
            let d = distances![i]
            let wallLine = SKShapeNode()
            let pathToDraw = CGMutablePath()
            let drawLength = threeDBounds.height * (1 - (d / maxViewDistance))
            pathToDraw.move(to: CGPoint(x: threeDBounds.width - CGFloat(i), y: threeDBounds.origin.y + threeDBounds.height / 2 - drawLength / 2))
            pathToDraw.addLine(to: CGPoint(x: threeDBounds.width - CGFloat(i), y: threeDBounds.origin.y + threeDBounds.height / 2 + drawLength / 2))
            wallLine.path = pathToDraw

            var color = colors[i]
            color = color.withAlphaComponent( 1 - (d/maxViewDistance) )
            wallLine.strokeColor = color

            wallLines.append(wallLine)
            addChild(wallLine)
        }


    }

}
