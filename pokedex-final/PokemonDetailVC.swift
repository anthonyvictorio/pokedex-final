//
//  ViewController.swift
//  pokedex-final
//
//  Created by Anthony Victorio on 4/18/24.
//

import UIKit

protocol PokemonDetailDelegate: AnyObject {
    func pokemonDetailVC(_ controller: PokemonDetailVC, addFavoritePokemon: String)
    func pokemonDetailVC(_ controller: PokemonDetailVC, removeFavoritePokemon: String)
}

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var spAttackLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var spDefenseLabel: UILabel!
    
    @IBOutlet weak var pokeImage: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var unfavoriteButton: UIButton!
    @IBOutlet weak var shinyButton: UIButton!
    
    @IBOutlet weak var firstTypeImage: UIImageView!
    @IBOutlet weak var secondTypeImage: UIImageView!
    
    var pokemon: Pokemon?
    var downloadTask: URLSessionDownloadTask?
    var favorite: Bool = false
    var delegate: PokemonDetailDelegate?
    var name = "charmander"
    var isShiny: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        let session = URLSession.shared
        unfavoriteButton.tintColor = .red
        favoriteButton.isEnabled = !favorite
        unfavoriteButton.isEnabled = favorite
        shinyButton.setTitle("✨", for: .normal)
        shinyButton.tintColor = .darkGray
        let dataTask = session.dataTask(with: url){(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
            } else {
                if let poke = self.parse(data: data!) {
                    self.pokemon = poke
                    //now that we have access to the Digimon instance, we force the UI to update on the main thread
                    DispatchQueue.main.async { [self] in
                        updateUI(pokemon: poke)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    
    func parse(data:Data) -> Pokemon? {
        do {
            let decoder = JSONDecoder()
            let pokemon = try decoder.decode(Pokemon.self, from: data)
            return pokemon
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
   
    func updateUI(pokemon: Pokemon) {
        self.label.text = pokemon.name
        if let url = URL(string: pokemon.sprites.front_default){
            downloadTask = pokeImage.loadImage(url: url)
        }
        if pokemon.types.count == 1{
            self.firstTypeImage.image = UIImage(named: "\(pokemon.types[0].type.name).png")
        }
        else if pokemon.types.count == 2{
            self.firstTypeImage.image = UIImage(named: "\(pokemon.types[0].type.name).png")
            self.secondTypeImage.image = UIImage(named: "\(pokemon.types[1].type.name).png")
        }
        updateStats(pokemon: pokemon)
        
    }
    
    
    @IBAction func markAsFavorite(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.pokemonDetailVC(self, addFavoritePokemon: self.name)
        
    }
    
    
    @IBAction func removeFavorite(_ sender: Any) {
       navigationController?.popViewController(animated: true)
        delegate?.pokemonDetailVC(self, removeFavoritePokemon: self.name)
    }
    
    
    
    
   
    func updateStats(pokemon: Pokemon){
        // var color = UIColor.black
        let green = UIColor(red: 0.3, green: 0.70, blue: 0.3, alpha: 1.0)
        let darkGreen = UIColor(red: 0.083, green: 0.49, blue: 0.33, alpha: 1.0)
        let yellow = UIColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1.0)


        var i = 0
        while i < 6{
            if pokemon.stats[i].base_stat <= 15 {
                changeTextColor(num: i, color: .systemRed)
            }
            else if pokemon.stats[i].base_stat <= 35 {
                changeTextColor(num: i, color: .systemOrange)
            }
            else if pokemon.stats[i].base_stat <= 70 {
                changeTextColor(num: i, color: yellow)
            }
            else if pokemon.stats[i].base_stat <= 100{
                changeTextColor(num: i, color: green)
            }
            else {
                changeTextColor(num: i, color: darkGreen)
            }
            i+=1
        }
        
        self.hpLabel.text = String(pokemon.stats[0].base_stat)
        self.attackLabel.text = String(pokemon.stats[1].base_stat)
        self.defenseLabel.text = String(pokemon.stats[2].base_stat)
        self.spAttackLabel.text = String(pokemon.stats[3].base_stat)
        self.spDefenseLabel.text = String(pokemon.stats[4].base_stat)
        self.speedLabel.text = String(pokemon.stats[5].base_stat)
        
        
    }
    
    func changeTextColor(num: Int, color: UIColor){
        if(num == 0){
            self.hpLabel.textColor = color
        }
        else if(num == 1){
            self.attackLabel.textColor = color
        }
        else if(num == 2){
            self.defenseLabel.textColor = color
        }
        else if(num == 3){
            self.spAttackLabel.textColor = color
        }
        else if(num == 4){
            self.spDefenseLabel.textColor = color
        }
        else{
            self.speedLabel.textColor = color
        }
    }
    
    @IBAction func shinyPressed(_ sender: Any) {
        if !isShiny {
            isShiny = true
            shinyButton.setTitle("Default", for: .normal)
            shinyButton.tintColor = .lightGray
            if let url = URL(string: self.pokemon!.sprites.front_shiny){
                downloadTask = pokeImage.loadImage(url: url)
            }
        }
        else{
            isShiny = false
            shinyButton.setTitle("✨", for: .normal)
            shinyButton.tintColor = .darkGray
            if let url = URL(string: self.pokemon!.sprites.front_default){
                downloadTask = pokeImage.loadImage(url: url)
            }
        }
    }
    
}


