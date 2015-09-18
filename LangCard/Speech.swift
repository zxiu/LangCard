//
//  Speech.swift
//  LangCard
//
//  Created by Zhou Xiu on 18/09/15.
//  Copyright © 2015 ZX. All rights reserved.
//
 
import AVFoundation

class Speech{
    static let synthesizer = AVSpeechSynthesizer()
    static func talk(text:String, var locale:NSLocale?){
        if (locale == nil){
            locale = NSLocale(localeIdentifier: "en_US")
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.3
        utterance.voice = AVSpeechSynthesisVoice(language:locale?.localeIdentifier)
        synthesizer.speakUtterance(utterance)

    }
}