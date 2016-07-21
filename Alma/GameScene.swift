//
//  GameScene.swift
//  Alma
//
//  Created by ntmukai on 2015/11/15.
//  Copyright (c) 2015年 mukaiya. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var map: NonScrollMap?
    var pc: Player?
    var spaceShip: SKSpriteNode?
    var field: SKSpriteNode?
    var slime: SKSpriteNode?

    // タイルの大きさ
    let tile_w = 32
    let tile_h = 32
    
    let manCategory: UInt32 = 0x1 << 0
    let slimeCategory: UInt32 = 0x1 << 1
    
    // スライムを描画する
    func drawSlime() {
        self.slime = SKSpriteNode(imageNamed: "Slime")
        self.slime!.position = CGPointMake(50, 50) // 場所は適当
        self.slime!.zPosition = 4
        self.slime!.physicsBody = SKPhysicsBody(rectangleOfSize: self.slime!.size) // 衝突範囲
        self.slime!.physicsBody?.affectedByGravity = false // 重力影響
        self.slime!.physicsBody?.dynamic = false // 衝突時動くか
        //self.slime!.physicsBody?.categoryBitMask = self.slimeCategory
        self.slime!.physicsBody?.contactTestBitMask = 1
        self.addChild(self.slime!)
        NSLog("drawSlime")
    }
    
    override func didMoveToView(view: SKView) {
        // マップを読み込む
        map = NonScrollMap(gameScene: self)
        
        // ランダムなマップ座標を取得
        let location = map!.genRandomPoint()

        // プレイヤーキャラクターを描画する
        pc = Player(gameScene: self, pop: location)

        // スライムを描画する
        self.drawSlime()
        
        NSLog("\(self.frame.minX)")
        NSLog("\(self.frame.minY)")
        NSLog("\(self.frame.maxX)")
        NSLog("\(self.frame.maxY)")
        
    }
    
    // ==================================================
    // クリックでPCを移動
    // ==================================================
    override func mouseDown(event: NSEvent) {
        // イベント座標を取得
        let location = event.locationInNode(self)

        // ゲーム座標に変換
        let x = Int(floor(location.x / 32))
        let y = Int(floor(location.y / 32))
        let clickPoint = CGPoint(x: x, y: y)
        
        // キャラの向きを変更
        let direction = pc!.chDirection(clickPoint)
        
        // 次の歩行先を算出
        let nextStep = pc!.getNextStep(direction)
        
        // 歩行可能なら歩行
        if map!.isWalkable(nextStep) {
            pc!.walk(nextStep)
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        NSLog("shototsu!")
    }
    
    
    override func mouseMoved(theEvent: NSEvent) {
        //let location = theEvent.locationInNode(self)
        //NSLog("\(location.x) \(location.y)")
        //NSLog("??")
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
      //  self.pc!.hidden = false
    }
}


//// クリックポイントへ向きを変えながら移動する宇宙船を描画する
//override func mouseDown(theEvent: NSEvent) {
//    let location = theEvent.locationInNode(self)
//    
//    let x = location.x - self.spaceShip!.position.x
//    let y = location.y - self.spaceShip!.position.y
//    
//    let radian = -atan2(x, y)
//    
//    let rotate = SKAction.rotateToAngle(radian, duration: 0.5, shortestUnitArc: true)
//    let move = SKAction.moveTo(location, duration: 1)
//    let sequence = SKAction.sequence([rotate, move])
//    self.spaceShip!.runAction(sequence)
//    
//    NSLog("OH")
//}












