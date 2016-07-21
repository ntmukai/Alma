//
//  NonScrollMap.swift
//  Alma
//
//  Created by ntmukai on 2016/03/02.
//  Copyright © 2016年 mukaiya. All rights reserved.
//

import SpriteKit

class NonScrollMap {
    // ゲームシーン
    let gs: GameScene
    
    // マップ配列
    let map: [[Int]]
    
    // マップオブジェ配列
    let mapObjCsv: [[Int]] = [
        [1,1,1,1,1,-1,-1,-1,-1,-1],
        [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
        [-1,-1,-1,1,1,1,-1,-1,-1,-1],
        [-1,-1,-1,1,1,1,1,-1,-1,-1],
        [-1,-1,-1,-1,-1,1,1,-1,-1,-1],
        [-1,-1,-1,-1,-1,1,1,-1,-1,-1],
        [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
        [-1,-1,-1,-1,1,1,1,1,1,1],
        [-1,-1,-1,-1,1,1,1,1,1,1],
        [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
    ]

    // 侵入可能座標値
    let isWalkAbleObj = -1
    
    // マップ座標の最大値
    var maxX: Int
    var maxY: Int
    
    // ==================================================
    // イニシャライザ (初期マップを描画)
    // ==================================================
    init(gameScene: GameScene) {
        gs = gameScene
        
        // タイルの大きさを取得
        let tile_w = gs.tile_w
        let tile_h = gs.tile_h

        // マップ座標の最大値を算出
        maxX = Int(gs.frame.maxX) / tile_w - 1
        maxY = Int(gs.frame.maxY) / tile_h - 1

        // フィールド全体に草原を敷き詰める
        for x in 0 ... maxX {
            for y in 0 ... maxY {
                let x = CGFloat(x * tile_w + tile_w / 2)
                let y = CGFloat(y * tile_h + tile_h / 2)
                let glass = SKSpriteNode(imageNamed: "Glass")
                glass.position = CGPointMake(x, y)
                glass.zPosition = 1
                gs.addChild(glass)
            }
        }
        
        // マップ座標とマップオブジェ配列の添字を揃える
        map = mapObjCsv.reverse()
        
        // マップにオブジェを配置する
        for (y, line) in map.enumerate() {
            for (x, v) in line.enumerate() {
                // -1は配置なし
                if (v == -1) {
                    continue
                }

                // 今のところ山オブジェのみ
                let x = CGFloat(x * tile_w + tile_w / 2)
                let y = CGFloat(y * tile_h + tile_h / 2)
                let mt = SKSpriteNode(imageNamed: "Mountain")
                mt.position = CGPointMake(x, y)
                mt.zPosition = 2
                gs.addChild(mt)
            }
        }
    }
    
    // ==================================================
    // 指定座標が侵入可能か
    // ==================================================
    func isWalkable(point: CGPoint) -> Bool {
        let x = Int(point.x)
        let y = Int(point.y)

        // マップより外は不可
        if (y < 0) && (maxY < y) {
            return false
        }
        if (x < 0) && (maxX < x) {
            return false
        }

        // あとは侵入可能かどうかの判定
        if map[y][x] == isWalkAbleObj {
            return true
        } else {
            return false
            
        }
    }
    
    // ==================================================
    // ランダムなマップ座標を生成する
    // ==================================================
    func genRandomPoint() -> CGPoint {
        var point: CGPoint
        
        // 侵入可能なマップ座標を算出
        repeat {
            let x = arc4random_uniform(UInt32(maxX))
            let y = arc4random_uniform(UInt32(maxY))
            point = CGPointMake(CGFloat(x), CGFloat(y))
        } while (!isWalkable(point))

        return point
    }
}