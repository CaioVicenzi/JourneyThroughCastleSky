//
//  CutsceneSceneOne.swift
//  JourneyThroughCastleSky
//
//  Created by João Ângelo on 03/10/24.
//

import Foundation
import SpriteKit

class CutsceneScenes: SKScene{
    var isFirstScene : Bool = true
    //var countCutscene: Int = 0
    var cutscene: CutsceneComponent?
    //var cutsceneTimer: Timer?
    var previousScene : TopDownScene? = nil
    var scenes : [Cutscene] = []
    var dialogsAfterCutscene : [Dialogue] = []
    var timerCount = 1

    
    var clickMessage: SKLabelNode = {
        let label = SKLabelNode(text: "Clique na tela e aperte ESPAÇO para passar as cutscenes")
    
        
        label.fontColor = .red
        label.fontSize = 20
        label.fontName = "Helvetica-Bold"
        return label
    }()
    
    func config (_ previousScene : TopDownScene, scenes : [Cutscene], dialogsAfterCutscene : [Dialogue]) {
        clickMessage.position = CGPoint(x: size.width/2, y: size.height - 100)
        self.previousScene = previousScene
        self.scenes = scenes
        self.dialogsAfterCutscene = dialogsAfterCutscene
    }
    
    override func didMove(to view: SKView) {

        BackgroundMusicHelper.singleton.stopMusic()
        self.displayNextCutscene()

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
            
            
            self?.timerCount += 1
            
            if self?.timerCount == 3 {
                self?.timerCount = 1
                self?.displayNextCutscene()
            }
        }
    }
    
    @objc func displayNextCutscene(_ timer: Timer? = nil){
        setupCutscene(timer)
    }
    
    private func setupCutscene (_ timer: Timer? = nil) {
        guard let firstScene = scenes.first else {
            timer?.invalidate()
            goBackToScene()
            return
        }
        
        let backgroundNode = firstScene.background
        let subtitle = firstScene.displayText
        
        cutscene = CutsceneComponent(background: backgroundNode, subtitles: subtitle)
        
        
        cutscene?.displayCutscene(scene: self)
        
        //if (countCutscene == 0) {
            //addChild(clickMessage)
        //}
        
        scenes.removeFirst()
        //countCutscene += 1
    }
    
    override func mouseDown(with event: NSEvent) {
        clickMessage.removeFromParent()
    }
    
    override func keyDown(with event: NSEvent) {
        
        
        
        if event.keyCode == 49 {
            displayNextCutscene()
            timerCount = 0
        }
    }
    
    override func willMove(from view: SKView) {
        //cutsceneTimer?.invalidate()
        //cutsceneTimer = nil
    }
    
    private func goBackToScene () {
        if GameProgressionSystem.singleton.isMaxStage() {
            let youFinishedScene = YouWinScene(size: self.size)
            youFinishedScene.scaleMode = .aspectFill
            self.view?.presentScene(youFinishedScene)
        } else {
            if let previousScene {
                let positionComponent = User.singleton.positionComponent
                let cgPoint = CGPoint(x: CGFloat(positionComponent.xPosition), y: CGFloat(positionComponent.yPosition))
                previousScene.spawnLocation = cgPoint
                
                self.view?.presentScene(previousScene, transition: SKTransition.fade(withDuration: 2.0))
                let spawn = previousScene.childNode(withName: "spawn")
                spawn?.removeFromParent()
            } else {
                print("Não tem cena anterior.")
            }
            previousScene?.configDialogs(self.dialogsAfterCutscene)
        }
    }
    
}
