//
//  MovieListViewModel.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/8/24.
//

import Foundation
import Combine

protocol MovieListViewModelInput {
    func didSearch(query: String)
}

protocol MovieListViewModelOutput {
    var items: CurrentValueSubject<[Movie], Error> { get }
}

typealias MovieListViewModel = MovieListViewModelInput & MovieListViewModelOutput

final class DefaultMovieListViewModel: MovieListViewModel {
    private let movieSearchUseCase: MovieSearchUseCase
    var items = CurrentValueSubject<[Movie], Error>([])
    init(movieSearchUseCase: MovieSearchUseCase) {
        self.movieSearchUseCase = movieSearchUseCase

        movieSearchUseCase.didSearch(with: "") { [weak self] result in
            switch result {
            case .success(let list):
                self?.items.value = list
            case .failure(let err):
                self?.items.send(completion: .failure(err))
            }
        }
    }
    
    // Debouncing
//    private var searchTask: DispatchWorkItem?
//    func didSearch(query: String) {
//        searchTask?.cancel()
//        searchTask = DispatchWorkItem {
//            self.movieSearchUseCase.didSearch(with: query) { [weak self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let list):
//                        self?.items.value = list
//                    case .failure(let err):
//                        self?.items.send(completion: .failure(err))
//                    }
//                }
//            }
//        }
//        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2, execute: searchTask!)
//    }
    func didSearch(query: String) {
        movieSearchUseCase.didSearch(with: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.items.value = list
                case .failure(let err):
                    self?.items.send(completion: .failure(err))
                }
            }
        }
    }
}
