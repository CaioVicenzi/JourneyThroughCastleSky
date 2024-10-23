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
                switch integerMaster {
                    case 0:
                    let dialogueSequence: [Dialogue] = [Dialogue(text: "Irmão!", person: "Weerdman", velocity: 50), Dialogue(text: "Eu não sou seu irmão.", person: "O Desconhecido", velocity: 50),Dialogue(text: "É o meu jeito de me expressar.", person: "Weerdman", velocity: 50),Dialogue(text: "Certo... Quem é você?", person: "O Desconhecido", velocity: 50),Dialogue(text: "Weerdman, à sua disposição. O que um soldado com uma bela e brilhante armadura está fazendo aqui nas ruínas esquecidas desse antigo mundo?", person: "Weerdman", velocity: 50),Dialogue(text: "Eu não sei.", person: "O Desconhecido", velocity: 50),Dialogue(text: "Você não sabe?", person: "Weerdman", velocity: 50),Dialogue(text: "Eu não me lembro… Eu não me lembro de nada…", person: "O Desconhecido", velocity: 50),Dialogue(text: "Interessante! Memorance, talvez… Sim, sim… Memorance! Posso ver os seus olhos brilharem com a corrupção blasfema de Leville. Ela te envolve como um véu invisível. Fascinante!", person: "Weerdman", velocity: 50),Dialogue(text: "O que é isso?.", person: "O Desconhecido", velocity: 50),Dialogue(text: "Ah… Memorance! Maldito feitiço! Apaga sua memória. É como o vento soprando grãos de areia. Faz com que seu cérebro se torne um quebra-cabeças a ser desvendado. Um sussurro etéreo distante nas profundezas do seu ser. Apenas eu posso desfazê-lo!", person: "Weerdman", velocity: 50), Dialogue(text: "Você?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Sim! Quem mais? Mas… Preciso de um favor, ou melhor, favores em troca.", person: "Weerdman", velocity: 50), Dialogue(text: "E se eu não aceitar?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Bom… então vague por essas terras sozinho. E procure por alguém gentil o suficiente para ajudá-lo. Não creio que encontrará, irmão. Tolo é aquele que tem uma joia rara nas mãos e sai para procurar pedras.", person: "Weerdman", velocity: 50),Dialogue(text: "Hum… e você acha que eu vou conseguir realizar esses favores para você?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Olha para você! Quase um herói de armadura! Parece que veio diretamente de um conto de fadas.", person: "Weerdman", velocity: 50), Dialogue(text: "De que favores estamos falando?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Preciso que recupere cristais. Pedras antigas de uma era distante!", person: "Weerdman", velocity: 50), Dialogue(text: "Entendo… Parece ser uma troca justa.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Esse é o espírito! Ah, mas esteja avisado. Não sou nenhum tolo. Existem quatro cristais. A cada cristal que pegar, eu tiro um pouco da corrupção. No final, será novinho em folha! He he…", person: "Weerdman", velocity: 50), Dialogue(text: "Entendo. Por onde eu começo?", person: "O Desconhecido", velocity: 50), Dialogue(text: "O primeiro cristal está no calabouço. Mas tome cuidado… Mítico é o herói que busca o perigo sem se importar com sua reputação, armado apenas com bravura e caráter e a vontade de mudar o mundo. E no seu caso… uma espada!", person: "Weerdman", velocity: 50), Dialogue(text: "Certo?...", person: "O Desconhecido", velocity: 50), Dialogue(text: "Vá com cuidado, irmão! Mantenha seu corpo e mente afiados.", person: "Weerdman", velocity: 50), Dialogue(text: "Antes de ir, com o que esse cristal se parece?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Você saberá quando vê-lo. Seu brilho pode ser visto pelos reinos como o Bombardeamento Celeste na era de Skyrise. Boa sorte!", person: "Weerdman", velocity: 50)]
                    self.gameScene?.dialogSystem.inputDialogs(dialogueSequence)
                    case 1:
                    let dialogueSequenceTwo: [Dialogue] = [Dialogue(text: "O soldado errante retorna! He he", person: "Weerdman", velocity: 50), Dialogue(text: "Não esperava que eu conseguisse?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Claro que esperava. Já disse, você parece ter vindo direto de um conto de fadas. Não se lembra?", person: "Weerdman", velocity: 50), Dialogue(text: "Hum…", person: "O Desconhecido", velocity: 50), Dialogue(text: "Então, onde está o cristal?", person: "Weerdman", velocity: 50), Dialogue(text: "Você é bem direto ao ponto quando quer.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Você acaba de me lembrar de uma antiga história.", person: "Weerdman", velocity: 50), Dialogue(text: "Uma história?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Ah, sim! O nome do protagonista é Pebas. Um grande mágico de GranStoed!", person: "Weerdman", velocity: 50), Dialogue(text: "Lá vamos nós.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Pebas fazia espetáculos ao longo de toda GranStoed, entretia crianças a rodo e os adultos também. Até que… um certo dia, um homem adentrou o camarim de Pebas e viu que o que ele fazia não era magia. Eram truques baratos de alquimia.", person: "Weerdman", velocity: 50), Dialogue(text: "Hum…", person: "O Desconhecido", velocity: 50), Dialogue(text: " Ele ficou chocado! Para ser honesto, até eu ficaria. Pebas era conhecido como um grande feiticeiro conhecido por toda Azoria, ele contava histórias para as crianças de como tinha sido ensinado pelos grandes dragões ancestrais de Skyrise sobre o poder da Vita Mater. A força vital de todo o universo!", person: "Weerdman", velocity: 50), Dialogue(text: "Certo…", person: "O Desconhecido", velocity: 50), Dialogue(text: "Pebas perdeu sua reputação e logo em seguida foi encontrado morto nos esgotos de GranStoed. Há quem diga que foi morto por um cliente insatisfeito. Eu prefiro acreditar que ele não conseguiu viver sabendo quem era.", person: "Weerdman", velocity: 50), Dialogue(text: "O que está tentando dizer? ", person: "O Desconhecido", velocity: 50), Dialogue(text: "Pebas usava uma máscara. Mas ele era Azoriano. E todos os Azorianos estão confinados à ampulheta cósmica do espaço-tempo. Uma hora ou outra, a máscara cai. O que você vai fazer quando ela cair?", person: "Weerdman", velocity: 50), Dialogue(text: "Isso foi enigmático… para a minha pouca surpresa.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Aí está! Te cansei?", person: "Weerdman", velocity: 50), Dialogue(text: "Você tentou?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Eu sou um sábio em uma terra desolada. Eu não converso com ninguém há muito tempo. O que espera de mim?", person: "Weerdman", velocity: 50), Dialogue(text: "Hum…", person: "O Desconhecido", velocity: 50), Dialogue(text: "Me esqueci que você é um homem de poucas palavras. E agora… hora da mágica. Está pronto?", person: "Weerdman", velocity: 50), Dialogue(text: "O que viu?", person: "Weerdman", velocity: 50), Dialogue(text: "Parece que fui capturado… por soldados.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Eu sinto muito por isso. ", person: "Weerdman", velocity: 50), Dialogue(text: "Eu acho que tinha uma filha… eles… me levaram para longe dela.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Você deve estar falando do exército imperial. Eles são bem conhecidos por suas práticas expansionistas… ", person: "Weerdman", velocity: 50), Dialogue(text: "Eu perdi minha filha.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Não se sinta culpado. Muitas vezes, forças mais fortes que nós entrarão em cena. Mas não se preocupe, a hora de revidar sempre chega.", person: "Weerdman", velocity: 50), Dialogue(text: "Eu preciso saber mais. Preciso saber o que aconteceu com minha filha.", person: "O Desconhecido", velocity: 50), Dialogue(text: "E eu vou ajudá-lo nisso. Mas não se esqueça dos cristais.", person: "Weerdman", velocity: 50), Dialogue(text: "Cumprirei meu lado do acordo.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Tenho certeza que vai. Você já deve ter visto a segunda porta para o Hall de relíquias. Basta ir.", person: "Weerdman", velocity: 50)]
                    self.gameScene?.dialogSystem.inputDialogs(dialogueSequenceTwo)
                    print("Two")
                    case 2:
                    let dialogueSequenceThree: [Dialogue] = [Dialogue(text: "asdjanddaskd", person: "Ahubiuo", velocity: 50)]
                    self.gameScene?.dialogSystem.inputDialogs(dialogueSequenceThree)
                    print("Three")
                    default:
                        break
                    }
                changeDialogueMaster()
                
                gameScene?.dialogSystem.inputDialogs(friendly.dialogueComponent.dialogs)
                gameScene?.dialogSystem.nextDialogue()
            }
        }
    }
    
    func changeDialogueMaster() {
        integerMaster += 1
    }
}
