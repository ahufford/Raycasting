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
    var viewController: GameViewController!

    var b: Boundry!
    var r: Ray!

    var boundries: [Boundry] = []

    var particle: Particle!

    override func didMove(to view: SKView) {
        screenBounds = view.bounds
        touchPos = nil

        randomWalls()
        edgeWalls()
        
        r = Ray(position: CGPoint(x: 60.0, y: 400.0), angle: 0)
        //addChild(r)

        particle = Particle(position: CGPoint(x: 50, y: 200))
        addChild(particle)
        for r in particle.rays {
            addChild(r)
        }
    }

    func randomWalls() {
        for _ in 0...5 {
            let x1 = CGFloat.random(in: 0...screenBounds.width)
            let y1 = CGFloat.random(in: 0...screenBounds.height)
            let x2 = CGFloat.random(in: 0...screenBounds.width)
            let y2 = CGFloat.random(in: 0...screenBounds.height)
            b = Boundry(start: CGPoint(x: x1, y: y1), end: CGPoint(x: x2, y: y2))
            boundries.append(b)
        }

        for b in boundries {
            addChild(b)
        }

    }
    func edgeWalls() {
        let bottomLeft = CGPoint.zero
        let topLeft = CGPoint(x: 0, y: screenBounds.height)
        let topRight = CGPoint(x: screenBounds.width, y: screenBounds.height)
        let bottomRight = CGPoint(x: screenBounds.width, y: 0
        )
        let leftWall = Boundry(start:bottomLeft, end: topLeft)
        let topWall = Boundry(start:topLeft, end: topRight)
        let rightWall = Boundry(start:topRight, end: bottomRight)
        let bottomWall = Boundry(start:bottomRight, end: bottomLeft)

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
        //r.lookAt(pos: pos)

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
        //r.lookAt(pos: pos)
        particle.position = pos

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
        particle.draw()

        let detects = particle.detectBoundry(boundries: boundries)

        //for p in detects {
        //    squareSprite(point: p, color: .orange)
        //}
        //r.draw()
        //let intersect = r.cast(boundry: b)
        //if intersect != nil {
            //quareSprite(point: intersect!, color: .orange)
        //}

    }
}
