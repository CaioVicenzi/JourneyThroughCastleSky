//
//  FriendlySystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 30/09/24.
//

import Foundation

class FriendlySystem {
    var gameScene : TopDownScene? = nil
    var friendlies : [Friendly] = []
    var integerMaster : Int = 0
    
    init(friendlies: [Friendly]) {
        self.friendlies = friendlies
    }
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func isFriendlyNearUser (_ friendly : Friendly) -> Bool {
        return PositionSystem.isOtherNearPlayer(friendly.positionComponent, range: 50)
    }
    
    func isAnyFriendlyNear () -> Bool {
        var isAnyNear = false
        
        friendlies.forEach { friendly in
            if isFriendlyNearUser(friendly) {
                isAnyNear = true
            }
        }
        
        return isAnyNear
    }
    
    func talkToNearestFriendly () {
        friendlies.forEach { friendly in
            if isFriendlyNearUser(friendly) {
                talkToFriendly(friendly)
            }
        }
    }
    
    private func talkToFriendly (_ friendly : Friendly) {
        if GameProgressionSystem.singleton.estage > 0 {
            delieverCrystal()
        } else {
            dialogue()
            GameProgressionSystem.singleton.upStage()
        }
    }
    
    func delieverCrystal () {
        // primeiramente verifica se o usuário tem algum cristal
        if User.singleton.inventoryComponent.itens.contains(where: { item in item.consumableComponent?.effect.type == .UP_LEVEL}) {
            User.singleton.inventoryComponent.itens.removeAll { item in item.consumableComponent?.effect.type == .UP_LEVEL}
            dialogue()
            GameProgressionSystem.singleton.upStage()
            
            if GameProgressionSystem.singleton.isMaxStage() {
                gameScene?.endGame()
            }
        } else {
            print("Não tem cristal para entregar")
        }
    }
    
    private func dialogue () {
        var dialogueSequence : [Dialogue] = []
        
        
        
        switch GameProgressionSystem.singleton.estage {
            case 0: dialogueSequence = dialogues1()
            case 1: dialogueSequence = dialogues2()
            case 2: dialogueSequence = dialogues3()
        default:
            break
        }
        
        self.gameScene?.dialogSystem.inputDialogs(dialogueSequence)
        gameScene?.dialogSystem.nextDialogue()
    }
    
    func dialogues1 () -> [Dialogue] {
        return [
            Dialogue(text: "Irmão!", person: "Weerdman"),
                Dialogue(text: "Eu não sou seu irmão.", person: "Você"),
                Dialogue(text: "É o meu jeito de me expressar.", person: "Weerdman"),
                Dialogue(text: "Certo… Quem é você?", person: "Você"),
                Dialogue(text: "Weerdman, à sua disposição. O que um soldado com uma bela e brilhante armadura está fazendo aqui nas ruínas esquecidas desse antigo mundo?", person: "Weerdman"),
                Dialogue(text: "Eu não sei.", person: "Você"),
                Dialogue(text: "Você não sabe?", person: "Weerdman"),
                Dialogue(text: "Eu não me lembro… Eu não me lembro de nada…", person: "Você"),
                Dialogue(text: "Interessante! Memerance, talvez… Sim, sim… Memerance! Posso ver os seus olhos brilharem com a corrupção blasfema de Leville. Ela te envolve como um véu invisível. Fascinante!", person: "Weerdman"),
                Dialogue(text: "O que é isso?", person: "Você"),
                Dialogue(text: "Ah… Memerance! Maldito feitiço! Apaga sua memória. É como o vento soprando grãos de areia. Faz com que seu cérebro se torne um quebra-cabeças a ser desvendado. Um sussurro etéreo distante nas profundezas do seu ser. Apenas eu posso desfazê-lo!", person: "Weerdman"),
                Dialogue(text: "Você?", person: "Você"),
                Dialogue(text: "Sim! Quem mais? Mas… Preciso de um favor, ou melhor, favores em troca.", person: "Weerdman"),
                Dialogue(text: "E se eu não aceitar?", person: "Você"),
                Dialogue(text: "Bom… então vague por essas terras sozinho. E procure por alguém gentil o suficiente para ajudá-lo. Não creio que encontrará, irmão. Tolo é aquele que tem uma joia rara nas mãos e sai para procurar pedras.", person: "Weerdman"),
                Dialogue(text: "Hum… e você acha que eu vou conseguir realizar esses favores para você?", person: "Você"),
                Dialogue(text: "Olha para você! Quase um herói de armadura! Parece que veio diretamente de um conto de fadas.", person: "Weerdman"),
                Dialogue(text: "De que favores estamos falando?", person: "Você"),
                Dialogue(text: "Preciso que recupere cristais. Pedras antigas de uma era distante!", person: "Weerdman"),
                Dialogue(text: "Entendo… Parece ser uma troca justa.", person: "Você"),
                Dialogue(text: "Esse é o espírito! Ah, mas esteja avisado. Não sou nenhum tolo. Existem quatro cristais. A cada cristal que pegar, eu tiro um pouco da corrupção. No final, será novinho em folha! He he…", person: "Weerdman"),
                Dialogue(text: "Entendo. Por onde eu começo?", person: "Você"),
                Dialogue(text: "O primeiro cristal está no calabouço. Mas tome cuidado… Mítico é o herói que busca o perigo sem se importar com sua reputação, armado apenas com bravura e caráter e a vontade de mudar o mundo. E no seu caso… uma espada!", person: "Weerdman"),
                Dialogue(text: "Certo?...", person: "Você"),
                Dialogue(text: "Vá com cuidado, irmão! Mantenha seu corpo e mente afiados.", person: "Weerdman"),
                Dialogue(text: "Antes de ir, com o que esse cristal se parece?", person: "Você"),
                Dialogue(text: "Você saberá quando vê-lo. Seu brilho pode ser visto pelos reinos como o Bombardeamento Celeste na era de Skyrise. Boa sorte!", person: "Weerdman")        ]
    }
    
    func dialogues2 () -> [Dialogue] {
        return [
            Dialogue(text: "O soldado errante retorna! He he", person: "Weerdman"),
            Dialogue(text: "Não esperava que eu conseguisse?", person: "Você"),
            Dialogue(text: "Claro que esperava. Já disse, você parece ter vindo direto de um conto de fadas. Não se lembra?", person: "Weerdman"),
            Dialogue(text: "Hum…", person: "Você"),
            Dialogue(text: "Então, onde está o cristal?", person: "Weerdman"),
            Dialogue(text: "Você é bem direto ao ponto quando quer.", person: "Você"),
            Dialogue(text: "Você acaba de me lembrar de uma antiga história.", person: "Weerdman"),
            Dialogue(text: "Uma história?", person: "Você"),
            Dialogue(text: "Ah, sim! O nome do protagonista é Pebas. Um grande mágico de GranStoed!", person: "Weerdman"),
            Dialogue(text: "Lá vamos nós.", person: "Você"),
            Dialogue(text: "Pebas fazia espetáculos ao longo de toda GranStoed, entretia crianças a rodo e os adultos também. Até que… um certo dia, um homem adentrou o camarim de Pebas e viu que o que ele fazia não era magia. Eram truques baratos de alquimia.", person: "Weerdman"),
            Dialogue(text: "Hum…", person: "Você"),
            Dialogue(text: "Ele ficou chocado! Para ser honesto, até eu ficaria. Pebas era conhecido como um grande feiticeiro conhecido por toda Azoria, ele contava histórias para as crianças de como tinha sido ensinado pelos grandes dragões ancestrais de Skyrise sobre o poder da Vita Mater. A força vital de todo o universo!", person: "Weerdman"),
            Dialogue(text: "Certo…", person: "Você"),
            Dialogue(text: "Pebas perdeu sua reputação e logo em seguida foi encontrado morto nos esgotos de GranStoed. Há quem diga que foi morto por um cliente insatisfeito. Eu prefiro acreditar que ele não conseguiu viver sabendo quem era.", person: "Weerdman"),
            Dialogue(text: "O que está tentando dizer?", person: "Você"),
            Dialogue(text: "Pebas usava uma máscara. Mas ele era Azoriano. E todos os Azorianos estão confinados à ampulheta cósmica do espaço-tempo. Uma hora ou outra, a máscara cai. O que você vai fazer quando ela cair?", person: "Weerdman"),
            Dialogue(text: "Isso foi enigmático… para a minha pouca surpresa.", person: "Você"),
            Dialogue(text: "He he…", person: "Weerdman"),
            Dialogue(text: "Aí está! Te cansei?", person: "Weerdman"),
            Dialogue(text: "Você tentou?", person: "Você"),
            Dialogue(text: "Eu sou um sábio em uma terra desolada. Eu não converso com ninguém há muito tempo. O que espera de mim?", person: "Weerdman"),
            Dialogue(text: "Hum…", person: "Você"),
            Dialogue(text: "Me esqueci que você é um homem de poucas palavras. E agora… hora da mágica. Está pronto?", person: "Weerdman")
        ]
        
        
        
        
        
    }
    
    func dialogues3 () -> [Dialogue] {
        return [
            Dialogue(text: "Terceiro diálogo, obrigado pelos cristais, otário", person: "Weerdman", velocity: 50)
        ]
    }
    
    func changeDialogueMaster() {
        integerMaster += 1
    }
}
