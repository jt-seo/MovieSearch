//
//  DefaultMovieSearchUseCase.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/8/24.
//

import Foundation

class DefaultMovieSearchUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
}

extension DefaultMovieSearchUseCase: MovieSearchUseCase {
    func didSearch(with word: String, completion: @escaping (Result<[Movie], any Error>) -> Void) {
        movieRepository.fetchList(with: word, completion)
    }
}
