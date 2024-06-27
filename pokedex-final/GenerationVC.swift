//
//  TableViewController.swift
//  pokedex-final
//
//  Created by Anthony Victorio on 4/22/24.
//

import UIKit

class GenerationVC: UITableViewController {
    
    struct Generation {
        var name: String
        var image: String
    }
    
    @IBOutlet weak var image: UIImageView!
    
    
    var generations: [Generation] = [
        Generation(name:"Genration 1",image:"gen1starters"),
        Generation(name:"Genration 2",image:"gen2starters"),
        Generation(name:"Genration 3",image:"gen3starters"),
        Generation(name:"Genration 4",image:"gen4starters")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = UIImage(named: "pokeball.png")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return generations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "genCell", for: indexPath) as! CustomTableViewCell
        
        let currCell = generations[indexPath.row]
        
        cell.label.text = currCell.name
        cell.generationImage.image = UIImage(named: currCell.image)
    
        return cell
        
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        let destination = segue.destination as! PokeListVC
        destination.generation = indexPath.row
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        performSegue(withIdentifier: "toPokeList", sender: indexPath)
    }
   
}
