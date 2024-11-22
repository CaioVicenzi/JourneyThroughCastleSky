//
//  BackgroundMusicHelper.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 05/11/24.
//

import Foundation
import AVFoundation

class BackgroundMusicHelper {
    static let singleton = BackgroundMusicHelper()
    var audioPlayer : AVAudioPlayer?
    
    var audioFileName: String?
    
    func playMusic (_ filename : String) {
        guard let soundURL = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Arquivo não encontrado")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 1
            audioPlayer?.play()
            audioFileName = filename
        } catch {
            print("Erro ao inicializar o AVAudioPlayer")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        audioFileName = nil 
    }
    
    func pauseMusic () {
        audioPlayer?.pause()
    }
}
