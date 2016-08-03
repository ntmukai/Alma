//
//  PlayerCharacter.swift
//  Alma
//
//  Created by ntmukai on 2016/02/25.
//  Copyright © 2016年 mukaiya. All rights reserved.
//

import SpriteKit

// 向き(上右下左)
let DIRECTION_U = 0
let DIRECTION_R = 1
let DIRECTION_D = 2
let DIRECTION_L = 3

class Player {
    // ゲームシーン
    let gs: GameScene
    
    // スプライト
    let sprite: SKSpriteNode
    
    // テクスチャ
    let textures: [String: [SKTexture]]
    
    // テクスチャのサイズ
    let texture_w: Int
    let texture_h: Int

    // テクスチャ画像
    let textureImg = SKTexture(imageNamed: "Player")
    
    // テクスチャ画像の行の名前(モーション名)
    let textureImgRowNames = ["up", "right", "down", "left"]
    
    // テクスチャ画像の列数
    let textureImgColsNum = 3
    
    // キャラの向き(デフォルト:下)
    var direction = DIRECTION_D
    
    // キャラの場所
    var location: CGPoint
    
    // ==================================================
    // イニシャライザ (指定座標にキャラクターを描画)
    // ==================================================
    init(gameScene: GameScene, pop: CGPoint) {
        gs = gameScene
        
        // モーション名を取得
        let motionNames = Array(textureImgRowNames.reverse())
        
        // テクスチャ画像の行数を取得
        let textureImgRowsNum = textureImgRowNames.count
        
        // テクスチャのサイズを算出
        texture_w = Int(textureImg.size().width) / textureImgColsNum
        texture_h = Int(textureImg.size().height) / textureImgRowsNum

        // テクスチャ画像からの切り抜きサイズを算出
        let cutW = CGFloat(texture_w) / textureImg.size().width
        let cutH = CGFloat(texture_h) / textureImg.size().height

        var motions = [String: [SKTexture]]()

        // モーション毎にテクスチャを切り抜いてまとめる
        for y in 0 ..< textureImgRowNames.count {
            var motion = [SKTexture]()
            
            for x in 0 ..< textureImgColsNum {
                let x = CGFloat(x)
                let y = CGFloat(y)
                let point = CGPoint(x: x * cutW, y: y * cutH)
                let size = CGSize(width: cutW, height: cutH)
                let rect = CGRect(origin: point, size: size)
                let texture = SKTexture(rect: rect, inTexture: textureImg)
                motion.append(texture)
            }
            
            motions[motionNames[y]] = motion
        }
        
        textures = motions

        // デフォルトの向きで初期テクスチャを取得
        let texture = textures[textureImgRowNames[direction]]![0]
        
        // マップ座標を実座標に変換
        let y = Int(pop.y) * gs.tile_w + gs.tile_w / 2
        let x = Int(pop.x) * gs.tile_h + gs.tile_h / 2

        // キャラを描画
        sprite = SKSpriteNode(texture: texture)
        sprite.position = CGPointMake(CGFloat(x), CGFloat(y))
        sprite.zPosition = 3
        sprite.setScale(1)
        gs.addChild(sprite)

        // キャラ座標を更新
        location = pop
    }
    
    // ==================================================
    // クリック座標からキャラの向きを算出
    // ==================================================
    private func calcDirection(clickPoint: CGPoint) -> Int {
        let x = clickPoint.x - location.x
        let y = clickPoint.y - location.y

        if abs(x) >= abs(y) {
            if clickPoint.x >= location.x {
                return DIRECTION_R
            } else {
                return DIRECTION_L
            }
        } else {
            if clickPoint.y >= location.y {
                return DIRECTION_U
            } else {
                return DIRECTION_D
            }
        }
    }
    
    // ==================================================
    // クリック方向へキャラを向ける
    // <!>現在は変数に入れるだけ(キャラの見た目は変わらない)
    // ==================================================
    func chDirection(clickPoint: CGPoint) -> Int {
        // クリック座標から向きを算出
        direction = calcDirection(clickPoint)
        
        // テクスチャを張り替えるだけ
        switch direction {
        case DIRECTION_U:
            sprite.texture = textures["up"]![0]
            break
        case DIRECTION_R:
            sprite.texture = textures["right"]![0]
            break
        case DIRECTION_D:
            sprite.texture = textures["down"]![0]
            break
        case DIRECTION_L:
            sprite.texture = textures["left"]![0]
            break
        default:
            break
        }
        
        return direction
    }
    
    // ==================================================
    // 次の歩行先を算出
    // ==================================================
    func getNextStep(direction: Int) -> CGPoint {
        var nextStep = location
        
        switch direction {
        case DIRECTION_U:
            nextStep.y += 1
            break
        case DIRECTION_R:
            nextStep.x += 1
            break
        case DIRECTION_D:
            nextStep.y -= 1
            break
        case DIRECTION_L:
            nextStep.x -= 1
            break
        default:
            break
        }
        
        return nextStep
    }
    
    // ==================================================
    // 指定ポイントへ歩く
    // ==================================================
    func walk(point: CGPoint) {
        
        var action1 = SKAction.animateWithTextures(textures["down"]!, timePerFrame: 0.1)
        var action2 = SKAction.setTexture(textures["down"]![0])
        
        switch direction {
        case DIRECTION_U:
            action1 = SKAction.animateWithTextures(textures["up"]!, timePerFrame: 0.1)
            action2 = SKAction.setTexture(textures["up"]![0])
            break
        case DIRECTION_R:
            action1 = SKAction.animateWithTextures(textures["right"]!, timePerFrame: 0.1)
            action2 = SKAction.setTexture(textures["right"]![0])
            break
        case DIRECTION_D:
            break
        case DIRECTION_L:
            action1 = SKAction.animateWithTextures(textures["left"]!, timePerFrame: 0.1)
            action2 = SKAction.setTexture(textures["left"]![0])
            break
        default:
            break
        }

        let action = SKAction.sequence([action1, action2])
        sprite.runAction(action)

        // スプライトを移動
        let moveToX = Int(point.x) * 32 + 16
        let moveToY = Int(point.y) * 32 + 16
        let moveToPoint = CGPoint(x: moveToX, y: moveToY)
        let move = SKAction.moveTo(moveToPoint, duration: 0.5)
        sprite.runAction(move)

        // 座標を更新
        location = point
    }
}