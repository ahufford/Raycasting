//
//  GameViewController.swift
//  RayCastingEngine
//
//  Created by Alec on 5/11/20.
//  Copyright © 2020 Huff Limitied. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(size:view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .aspectFit
        scene!.viewController = self

        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func rightPressed(_ sender: UIButton) {
        scene!.turnRight = true
    }
    @IBAction func rightCanceled(_ sender: UIButton) {
        scene!.turnRight = false

    }
    @IBAction func leftPressed(_ sender: UIButton) {
        scene!.turnLeft = true

    }
    @IBAction func leftCanceled(_ sender: UIButton) {
        scene!.turnLeft = false

    }

    @IBAction func forwardPressed(_ sender: UIButton) {
        scene!.goForward = true
    }
    @IBAction func forwardCanceled(_ sender: UIButton) {
        scene!.goForward = false

    }
    @IBAction func backPressed(_ sender: UIButton) {
        scene!.goBack = true

    }
    @IBAction func backCanceled(_ sender: UIButton) {
        scene!.goBack = false

    }

}
