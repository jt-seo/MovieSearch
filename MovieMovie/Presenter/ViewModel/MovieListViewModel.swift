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
    var items: CurrentValueSubject<[Movie], Never> { get }
    var errorPublisher: PassthroughSubject<Void, Error> { get }
}

typealias MovieListViewModel = MovieListViewModelInput & MovieListViewModelOutput

final class DefaultMovieListViewModel: MovieListViewModel {
    private let movieSearchUseCase: MovieSearchUseCase
    var items = CurrentValueSubject<[Movie], Never>([])
    var errorPublisher = PassthroughSubject<Void, Error>()
    init(movieSearchUseCase: MovieSearchUseCase) {
        self.movieSearchUseCase = movieSearchUseCase
        movieSearchUseCase.didSearch(with: "") { [weak self] result in
            if case .success(let list) = result {
                self?.items.value = list
            }
        }
    }
    
    func didSearch(query: String) {
        movieSearchUseCase.didSearch(with: query) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let list):
                self.items.value = list
            case .failure(let err):
                print("didSearch failed.", err)
                self.errorPublisher.send(completion: .failure(err))
            }
        }
    }
}
