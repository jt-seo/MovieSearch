//
//  ViewController.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/4/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var trie = Trie()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        for word in dataSource {
            trie.insert(word)
        }
        
        filteredVideos = dataSource
    }
    @IBOutlet weak var textField: UITextField!
    
    var dataSource = [
        "The Shawshank Redemption",
        "The Godfather",
        "The Dark Knight",
        "The Godfather Part II",
        "12 Angry Men",
        "Schindler's List",
        "The Lord of the Rings: The Return of the King",
        "Pulp Fiction",
        "The Good, the Bad and the Ugly",
        "The Lord of the Rings: The Fellowship of the Ring"
    ]
    
    private var filteredVideos = [String]()
    
    let videoUrl = "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8"

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        if text.isEmpty {
            filteredVideos = dataSource
        } else {
            filteredVideos = trie.search(prefix: text)
        }
        
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredVideos[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected \(indexPath)")
        guard let url = URL(string: videoUrl) else { return }
        let playerVC = MoviePlayerViewController(url: url)
        navigationController?.pushViewController(playerVC, animated: false)
        
    }
    
}

