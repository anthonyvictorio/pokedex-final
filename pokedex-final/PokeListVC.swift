//
//  PokeListVC.swift
//  pokedex-final
//
//  Created by Anthony Victorio on 4/26/24.
//

import UIKit

class PokeListVC: UITableViewController, PokemonDetailDelegate {
    
    func pokemonDetailVC(_ controller: PokemonDetailVC, addFavoritePokemon: String) {
        favoritePokemon.append(addFavoritePokemon)
        print("After add: ")
        print(favoritePokemon)
        tableView.reloadData()
        saveFavoritePokemon()
    }
    
    func pokemonDetailVC(_ controller: PokemonDetailVC, removeFavoritePokemon: String) {
        if let index = favoritePokemon.firstIndex(of: removeFavoritePokemon){
            favoritePokemon.remove(at: index)
        }
        print("After remove: ")
        print(favoritePokemon)
        tableView.reloadData()
        saveFavoritePokemon()
    }
    
    var pokemonListResponse: AllPokemonResponse?
    
    var favoritePokemon: [String] = []
    
    var generation: Int = 0
    var genMin: Int = 0
    var genMax: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavoritePokemon()
        
        if(generation == 0){
            genMin = 0
            genMax = 151
        } else if(generation == 1){
            genMin = 151
            genMax = 100
        } else if(generation == 2){
            genMin = 251
            genMax = 135
        } else if(generation == 3){
            genMin = 386
            genMax = 107
        }
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(genMin)&limit=\(genMax)")!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url){(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
            } else {
                if let pokeList = self.parse(data: data!) {
                    self.pokemonListResponse = pokeList
                    DispatchQueue.main.async { [self] in
                        self.tableView.reloadData()
                    }
                }
            }
        }
        dataTask.resume()
    }
  
    func parse(data:Data) -> AllPokemonResponse? {
        do {
            let decoder = JSONDecoder()
            let pokemonList = try decoder.decode(AllPokemonResponse.self, from: data)
            return pokemonList
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
    
     func documentsDirectory() -> URL {
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return paths[0]
     }
     
     func dataFilePath() -> URL {
       return documentsDirectory().appendingPathComponent("FavoritedPokemon.plist")
     }
     
    func saveFavoritePokemon() {

        let encoder = PropertyListEncoder()
        do {
            //encoder will attempt to encode the elements in listItems
            let data = try encoder.encode(favoritePokemon)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic
            )
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
     
     func loadFavoritePokemon() {
       let path = dataFilePath()
       if let data = try? Data(contentsOf: path) {
         let decoder = PropertyListDecoder()
         do {
           favoritePokemon = try decoder.decode( [String].self, from: data)
         } catch {
             print("Error decoding item array: \(error.localizedDescription)")
         }
       }
     }
     


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokemonListResponse?.results.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell", for: indexPath) as! CustomPokemonListCell
        cell.nameLabel.text = pokemonListResponse?.results[indexPath.row].name
        cell.secondLabel.text = ""
        let pokeName: String = (pokemonListResponse?.results[indexPath.row].name)!
    // ******************************************************************************************************************* //
        if isInFavoritePokemon(name: pokeName){
            cell.secondLabel.text = "⭐"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pokemonSelected = pokemonListResponse?.results[indexPath.row]
        performSegue(withIdentifier: "toPokemonDetailVC", sender: pokemonSelected?.name)
    }
    
    func isInPokeList(pokemon: String) -> Bool {
        for poke in pokemonListResponse!.results {
            if poke.name == pokemon {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! PokemonDetailVC
        let pokemonToSend = sender as! String
        destination.delegate = self
        destination.name = pokemonToSend
        
        if isInFavoritePokemon(name: destination.name){
            destination.favorite = true
        }
        
    }
    
    private func isInFavoritePokemon(name: String) -> Bool {
        for poke in favoritePokemon {
            if poke == name {
                return true
            }
        }
        return false
    }
    
    
    
}
