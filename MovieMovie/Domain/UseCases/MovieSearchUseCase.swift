//
//  MovieSearchUseCase.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/8/24.
//

import Foundation

protocol MovieSearchUseCase {
    func didSearch(with word: String, completion: @escaping (Result<[Movie], Error>) -> Void)
}

