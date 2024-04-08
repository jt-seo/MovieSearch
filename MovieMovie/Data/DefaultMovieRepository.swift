//
//  DefaultMovieRepository.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/8/24.
//

import Foundation

struct DefaultMovieRepository: MovieRepository {
    func fetchList(with word: String, _ completion: (Result<[Movie], any Error>) -> Void) {
        var titleList: [String]
        if word.isEmpty {
            titleList = dataSource
        } else {
            titleList = dataSource.filter{$0.lowercased().hasPrefix(word.lowercased())}
        }
        let movieList = titleList.map{Movie.init(title: $0)}
        completion(.success(movieList))
    }
    
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
}
