//
//  File.swift
//  pokedex-final
//
//  Created by Anthony Victorio on 4/29/24.
//

import Foundation

struct PokemonSprite: Codable {
    var front_default: String
}

struct Pokemon: Codable, Equatable {
    
    var base_experience: Int
    var height: Int
    var id: Int
    var is_default: Bool
    var location_area_encounters: String
    var name: String
    var order: Int
    var sprites: PokeSprites
    var stats: [PokeStats]
    var types: [PokeTypes]
    var weight: Int
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        if(lhs.id == rhs.id){
            return true
        }
        return false
    }
}

struct PokeSprites: Codable {
    var front_default: String
    var front_female: String?
    var front_shiny: String
    var front_shiny_female: String?
}

struct PokeStats: Codable, Equatable {
    static func == (lhs: PokeStats, rhs: PokeStats) -> Bool {
        if lhs.stat.name == rhs.stat.name{
            return true
        }
        return false
    }
    
    var base_stat: Int
    var effort: Int
    var stat: PokemonStat
}

struct PokemonStat: Codable {
    var name: String
}

struct PokeTypes: Codable {
    var slot: Int
    var type: PokemonType
}

struct PokemonType: Codable {
    var name: String
}

// **************************************************************************************************************//
// **************************************************************************************************************//
// **************************************************************************************************************//


struct AllPokemonResponse: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokeInList]
    
}

struct PokeInList: Codable {
    var name: String
    var url: String
}

// **************************************************************************************************************//
// **************************************************************************************************************//
// **************************************************************************************************************//

