//
//  ViewController.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/4/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var viewModel: MovieListViewModel = DefaultMovieListViewModel(movieSearchUseCase: DefaultMovieSearchUseCase(movieRepository: DefaultMovieRepository()))
    @IBOutlet weak var tableView: UITableView!
    private var trie = Trie()
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.items.sink { err in
            print("error occurred: \(err)")
        } receiveValue: { [weak self] movieList in
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    @IBOutlet weak var textField: UITextField!
    
    let videoUrl = "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8"

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.didSearch(query: text)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.items.value[indexPath.row].title
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected \(indexPath)")
        guard let url = URL(string: videoUrl) else { return }
        let playerVC = MoviePlayerViewController(url: url)
        navigationController?.pushViewController(playerVC, animated: false)
        
    }
    
}

