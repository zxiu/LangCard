//
//  SoundUtil.swift
//  LangCard
//
//  Created by Zhou Xiu on 21/09/15.
//  Copyright © 2015 ZX. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundUtil{
    static func play(){
        AudioServicesPlayAlertSound(SystemSoundID(1000))
    }
}