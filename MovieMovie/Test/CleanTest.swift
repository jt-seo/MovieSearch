//
//  CleanTest.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/9/24.
//

import Foundation

// refactor with clean architecture + MVVM
// extract viewModel from view

// update view base on the binding to vm
class TextSearchView {
    let vm: SearchViewModel = DefaultSearchViewModel(searchUseCase: DefaultSearchUseCase(textSearchRepository: DefaultTextSearchRepository(networkService: DefaultNetworkService())))
    // var cancellables = [AnyCancellable]()
    
    init() {
        // vm.items.sink { results in
        //     print(results)
        // }.store(&cancellables)
        
        vm.items.observe { [weak self] results in
            print("search result: ", results)
            _ = self?.vm
        }
    }
    
    func search(with word: String) {
        vm.didSearch(with: word)
    }
}


protocol SearchViewModel {
    // in
    func didSearch(with word: String)
    
    // out
    // var items : CurrentValueSubject<[String], Error> { get }
    var items: Observable<[String]> { get }
}

class DefaultSearchViewModel: SearchViewModel {
    let searchUseCase: SearchUseCase
    // in
    func didSearch(with word: String) {
        print("didSearch: ", word)
        searchUseCase.didSearch(with: word) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let textList):
                    self.items.value = textList.map{ $0.text }
                case .failure(let err):
                    print("search failed", err)
            }
        }
    }
    
    // out
    // var items = CurrentValueSubject<[String], Error>()
    var items: Observable<[String]>
    
    init(searchUseCase: SearchUseCase) {
        // items = Observable<[String]>(initialValue: dataSource)
        items = Observable<[String]>(initialValue: [])
        self.searchUseCase = searchUseCase
    }
}



// define domain
// 1. entity (Text)
struct Text {
    var text: String
}
// 2. use cases (search)
protocol SearchUseCase {
    func didSearch(with word: String, completion: @escaping (Result<[Text], Error>) -> Void)
}
class DefaultSearchUseCase: SearchUseCase {
    let textSearchRepository: TextSearchRepository
    init(textSearchRepository: TextSearchRepository) {
        self.textSearchRepository = textSearchRepository
    }

    func didSearch(with word: String, completion: @escaping (Result<[Text], Error>) -> Void) {
        textSearchRepository.fetchList(with: word, completion: completion)
    }
}

// 3. interface to adaptors
protocol TextSearchRepository {
    func fetchList(with word: String, completion: @escaping (Result<[Text], Error>) -> Void)
}

// move data to data layer (fetch with word)
// ------------------------ Data Layer -----------------------------
struct SearchRequestDTO: Encodable {
    let text: String
    private enum CodingKeys: String, CodingKey {
        case text = "search_keyword"
    }
}
extension SearchRequestDTO {
    static func fromDomain(domain: Text) -> SearchRequestDTO {
        SearchRequestDTO(text: domain.text)
    }
}
struct SearchResponseDTO: Decodable {
    let results: [String]
    private enum CodingKeys: String, CodingKey {
        case results = "title"
    }
}
extension SearchResponseDTO {
    func toDomain() -> [Text] {
        self.results.map{Text(text: $0)}
    }
}

class DefaultTextSearchRepository: TextSearchRepository {
    let networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    func fetchList(with word: String, completion: @escaping (Result<[Text], Error>) -> Void) {
        let requestDTO = SearchRequestDTO(text: word)
        networkService.request(with: requestDTO) { result in
            switch result {
                case .success(let response):
                    completion(.success(response.toDomain()))
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
}

// --------------------- Infrastructure --------------------------
protocol NetworkService {
    func request(with dto: SearchRequestDTO, completion: @escaping (Result<SearchResponseDTO, Error>) -> Void)
}

class DefaultNetworkService: NetworkService {
    var dataSource = ["title1", "title2", "title3", "title4", "table", "tiaaaa"]
    func request(with dto: SearchRequestDTO, completion: @escaping (Result<SearchResponseDTO, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(dto)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString as Any)
        } catch {
            print(error)
        }
        
        let titleList = dataSource.filter{$0.lowercased().hasPrefix(dto.text.lowercased())}
        completion(.success(SearchResponseDTO(results: titleList)))
    }
}

// Observable
class Observable<Value> {
    var value: Value {
        didSet {
            handler?(value)
        }
    }
    
    init(initialValue: Value) {
        self.value = initialValue
    }
    
    var handler: ((Value) -> Void)?
    
    func observe(handler: @escaping (Value) -> Void) {
        self.handler = handler
    }
}

func cleanTest() {
    let search = TextSearchView()
    search.search(with: "ti")
    search.search(with: "ta")
    print("----------- end of program ----------------")
}
