//
//  PetDBModel.swift
//  dogtor
//
//  Created by Jasper Oh on 2021/08/05.
//

import Foundation


class PetDBModel : NSObject {
    var PetId : String?
    var PetName : String?
    var PetImage : String?
    var PetSpecies : String?
    var PetGender : String?
    var PetAge : String?
    
    
    override init() {
        
    }
    
    init(PetId : String, PetName : String , PetImage : String , PetSpecies : String , PetGender : String , PetAge : String) {
        self.PetId = PetId
        self.PetName = PetName
        self.PetImage = PetImage
        self.PetSpecies = PetSpecies
        self.PetGender = PetGender
        self.PetAge = PetAge
    }
    
}
