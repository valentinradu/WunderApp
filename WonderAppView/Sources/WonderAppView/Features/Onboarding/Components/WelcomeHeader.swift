//
//  WelcomeHeader.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SFSafeSymbols
import SpriteKit
import SwiftUI

private final class WelcomeScene: SKScene {
    enum Category {
        static let none: UInt32 = 0
        static let all: UInt32 = .max
        static let wheel: UInt32 = 0b1000
        static let van: UInt32 = 0b0100
        static let floor: UInt32 = 0b0010
        static let rock: UInt32 = 0b0001
    }

    var duration: TimeInterval = 3
    var touchOrigin: CGPoint = .zero

    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0),
                                    to: CGPoint(x: size.width, y: 0))
        physicsBody?.categoryBitMask = Category.floor

        let floorSize = CGSize(width: size.width, height: 3)
        let floor = SKSpriteNode(color: .ds.white, size: floorSize)
        floor.anchorPoint = .zero

        addChild(floor)

        let rock = SKSpriteNode(texture: SKTexture(image: .ds.rock))
        let rockPhysicsBody = SKPhysicsBody(texture: rock.texture!, size: rock.texture!.size())
        rockPhysicsBody.affectedByGravity = false
        rockPhysicsBody.isDynamic = false
        rockPhysicsBody.categoryBitMask = Category.rock
        rock.position.x = 0.7 * size.width
        rock.position.y = rock.size.height / 2
        rock.physicsBody = rockPhysicsBody
        rock.run(
            .repeatForever(
                .sequence(
                    [
                        .moveTo(x: -rock.size.width, duration: duration * 0.7),
                        .moveTo(x: size.width, duration: 0),
                        .moveTo(x: size.width * 0.7, duration: duration * 0.3),
                    ]
                )
            )
        )
        addChild(rock)

        let van = SKSpriteNode(texture: SKTexture(image: .ds.van))
        let vanPhysicsBody = SKPhysicsBody(texture: van.texture!, size: van.texture!.size())
        vanPhysicsBody.categoryBitMask = Category.van
        vanPhysicsBody.collisionBitMask = Category.none
        vanPhysicsBody.restitution = 5
        vanPhysicsBody.angularDamping = 10
        van.physicsBody = vanPhysicsBody
        van.position.x = size.width * 0.15 + van.size.width / 2
        van.position.y = van.size.height / 2 + 10
        van.name = "van"
        van.constraints = [
            SKConstraint.positionX(.init(constantValue: van.position.x)),
            SKConstraint.positionY(.init(lowerLimit: van.size.height / 2 + 10))
        ]
        addChild(van)

        let surf = SKSpriteNode(texture: SKTexture(image: .ds.surf))
        let surfPhysicsBody = SKPhysicsBody(rectangleOf: surf.size, center: surf.position)
        surfPhysicsBody.collisionBitMask = Category.van
        surf.position.x = van.position.x
        surf.position.y = van.frame.maxY + surf.size.height / 2 + 3
        surf.physicsBody = surfPhysicsBody
        surf.constraints = [
            SKConstraint.positionX(.init(constantValue: surf.position.x)),
            SKConstraint.positionY(.init(lowerLimit: surf.position.y))
        ]
        addChild(surf)

        let surfPinJoint = SKPhysicsJointPin.joint(withBodyA: vanPhysicsBody,
                                                   bodyB: surfPhysicsBody,
                                                   anchor: surf.position)
        physicsWorld.add(surfPinJoint)

        let tree = SKSpriteNode(texture: SKTexture(image: .ds.tree))
        tree.anchorPoint = .zero
        tree.zPosition = -1
        tree.position.x = 0.55 * size.width
        tree.run(
            .repeatForever(
                .sequence(
                    [
                        .moveTo(x: -tree.size.width, duration: duration * 1),
                        .moveTo(x: size.width, duration: 0),
                        .moveTo(x: size.width * 0.55, duration: duration * 0.7),
                    ]
                )
            )
        )
        addChild(tree)

        let sky = SKSpriteNode()
        let cloudsTexture = SKTexture(image: .ds.clouds)
        let cloudsTextureWidth = cloudsTexture.size().width
        sky.zPosition = -2
        sky.position.y = size.height * 0.35
        sky.position.x = -200
        sky.run(
            .repeatForever(
                .sequence(
                    [
                        .moveTo(x: sky.position.x - cloudsTextureWidth - 80, duration: duration * 2.5),
                        .moveTo(x: sky.position.x, duration: 0)
                    ]
                )
            )
        )

        for i in 0 ..< 3 {
            let clouds = SKSpriteNode(texture: cloudsTexture)
            clouds.anchorPoint = .zero
            clouds.position.x = CGFloat(i) * (clouds.size.width + 80)
            sky.addChild(clouds)
        }

        addChild(sky)

        let pickMeUp = SKSpriteNode(texture: SKTexture(image: .ds.pickMeUp))
        pickMeUp.anchorPoint = .zero
        pickMeUp.position.y = van.frame.maxY + 30
        pickMeUp.position.x = van.frame.maxX

        addChild(pickMeUp)

        let wheelTexture = SKTexture(image: .ds.wheel)
        let frontWheelX = van.frame.maxX - wheelTexture.size().width / 2 - 5
        let backWheelX = van.frame.minX + wheelTexture.size().width / 2 + 20
        let wheels = [frontWheelX, backWheelX].enumerated().map { i, x in
            let wheel = SKSpriteNode(texture: wheelTexture)
            let wheelPhysicsBody = SKPhysicsBody(circleOfRadius: wheel.size.width / 2,
                                                 center: wheel.position)
            wheelPhysicsBody.categoryBitMask = Category.wheel
            wheelPhysicsBody.collisionBitMask = Category.floor | Category.rock
            wheelPhysicsBody.allowsRotation = false
            wheel.physicsBody = wheelPhysicsBody
            wheel.position.x = x
            wheel.position.y = 10
            wheel.constraints = [
                SKConstraint.positionX(.init(constantValue: wheel.position.x)),
                SKConstraint.positionY(.init(lowerLimit: 0))
            ]

            return wheel
        }

        for wheel in wheels {
            addChild(wheel)

            let wheelPinJoint = SKPhysicsJointPin.joint(withBodyA: wheel.physicsBody!,
                                                        bodyB: vanPhysicsBody,
                                                        anchor: wheel.position)
            physicsWorld.add(wheelPinJoint)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first,
           let van = childNode(withName: "van") {
            let location = touch.location(in: self)
            touchOrigin = location
            van.physicsBody?.isDynamic = false
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let van = childNode(withName: "van") {
            let location = touch.location(in: self)
            let newPosition = CGPoint(x: location.x, y: location.y)
            van.position = newPosition
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let van = childNode(withName: "van") {
            van.physicsBody?.isDynamic = true
        }
    }
}

struct WelcomeHeader: View {
    var body: some View {
        GeometryReader { geo in
            SpriteView(scene: _scene(bounds: geo.size))
                .background(Color.ds.oceanBlue900.edgesIgnoringSafeArea(.all))
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
    }

    private func _scene(bounds size: CGSize) -> SKScene {
        let scene = WelcomeScene()
        scene.size = CGSize(width: size.width, height: size.height)
        scene.backgroundColor = UIColor.ds.oceanBlue900
        scene.scaleMode = .resizeFill
        return scene
    }
}

struct WelcomeHeaderPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            WelcomeHeader()
            Spacer()
        }
        .background(Color.ds.oceanBlue900)
    }
}
