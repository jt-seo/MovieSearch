//
//  MovieRepository.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/8/24.
//

import Foundation

protocol MovieRepository {
    func fetchList(with word: String, _ completion: (Result<[Movie], Error>) -> Void)
}
