//
//  DialogHelper.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 29/10/24.
//

import Foundation

class DialogHelper {
    let firstDialogs : [Dialogue] = [
        Dialogue(text: "Irmão!", person: "Weerdman"),
        
    ]
    let secondDialogs : [Dialogue] = [
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

    let secondDialogsAfterCutscene : [Dialogue] = [
        Dialogue(text: "O que viu?", person: "Weerdman"),
        Dialogue(text: "Parece que fui capturado… por soldados.", person: "Você"),
        Dialogue(text: "Eu sinto muito por isso.", person: "Weerdman"),
        Dialogue(text: "Eu acho que tinha uma filha… eles… me levaram para longe dela.", person: "Você"),
        Dialogue(text: "Você deve estar falando do exército imperial. Eles são bem conhecidos por suas práticas expansionistas…", person: "Weerdman"),
        Dialogue(text: "Eu perdi minha filha.", person: "Você"),
        Dialogue(text: "Não se sinta culpado. Muitas vezes, forças mais fortes que nós entrarão em cena. Mas não se preocupe, a hora de revidar sempre chega.", person: "Weerdman"),
        Dialogue(text: "Eu preciso saber mais. Preciso saber o que aconteceu com minha filha.", person: "Você"),
        Dialogue(text: "E eu vou ajudá-lo nisso. Mas não se esqueça dos cristais.", person: "Weerdman"),
        Dialogue(text: "Cumprirei meu lado do acordo.", person: "Você"),
        Dialogue(text: "Tenho certeza que vai. Você já deve ter visto a segunda porta para o Hall de relíquias. Basta ir.", person: "Weerdman"),
        Dialogue(text: "Bom trabalho, irmão!", person: "Weerdman"),
        Dialogue(text: "Aqui está.", person: "Você"),
        Dialogue(text: "Você encontrou alguém ao longo do caminho?", person: "Weerdman"),
        Dialogue(text: "Não. Eu deveria?", person: "Você"),
        Dialogue(text: "Não. Mas eu queria sanar minha curiosidade.", person: "Weerdman"),
        Dialogue(text: "Certo…? E agora…", person: "Você"),
        Dialogue(text: "Você é apressado, irmão. Mas eu não te culpo. Afinal de contas, perder a memória é uma péssima experiência. Teve uma vez em um pub que eu…", person: "Weerdman"),
        Dialogue(text: "UHUM!", person: "Weerdman"),
        Dialogue(text: "Ok. Ok. Lá vamos nós!", person: "Weerdman")
    ]

    let thirdDialogs : [Dialogue] = [
        Dialogue(text: "Bom trabalho, irmão!", person: "Weerdman"),
        Dialogue(text: "Aqui está.", person: "Você"),
        Dialogue(text: "Você encontrou alguém ao longo do caminho?", person: "Weerdman"),
        Dialogue(text: "Não. Eu deveria?", person: "Você"),
        Dialogue(text: "Não. Mas eu queria sanar minha curiosidade.", person: "Weerdman"),
        Dialogue(text: "Certo…? E agora…", person: "Você"),
        Dialogue(text: "Você é apressado, irmão. Mas eu não te culpo. Afinal de contas, perder a memória é uma péssima experiência. Teve uma vez em um pub que eu…", person: "Weerdman"),
        Dialogue(text: "UHUM!", person: "Weerdman"),
        Dialogue(text: "Ok. Ok. Lá vamos nós!", person: "Weerdman")
    ]

    let thirdDialogsAfterCutscene : [Dialogue] = [
        Dialogue(text: "E aí, irmão?", person: "Weerdman"),
        Dialogue(text: "Prefiro não falar o que vi.", person: "Você"),
        Dialogue(text: "Tudo bem, irmão.", person: "Weerdman"),
        Dialogue(text: "Eu preciso saber mais. Onde está o próximo fragmento?", person: "Você"),
        Dialogue(text: "O próximo fragmento está na minha casa, irmão. Quer dizer… no que antes era minha casa.", person: "Weerdman"),
        Dialogue(text: "Não é mais?", person: "Você"),
        Dialogue(text: "Já deixou de ser há muito tempo. Aprendi muito lá… talvez mais do que deveria em alguns aspectos.", person: "Weerdman"),
        Dialogue(text: "O que quer dizer com isso?", person: "Você"),
        Dialogue(text: "Isso é uma história para outro momento, irmão. Foque no objetivo!", person: "Weerdman"),
        Dialogue(text: "Certo! Você tem mais alguma coisa para me dizer?", person: "Você"),
        Dialogue(text: "Sim! Aquele lugar não costuma ser o que era. Tome muito cuidado, irmão. Se perder lá é fácil. Em outras palavras. Preste muita atenção para onde está andando…", person: "Weerdman"),
        Dialogue(text: "Ok.", person: "Você")
    ]
}


