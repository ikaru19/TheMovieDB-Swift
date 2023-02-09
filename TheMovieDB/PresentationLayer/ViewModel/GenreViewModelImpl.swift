//
//  GenreViewModelImpl.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import RxSwift
import RxRelay

class GenreViewModelImpl: GenreViewModel {
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _genreList: PublishRelay<[Data.GenreEntity]> = PublishRelay()
    private var disposeBag = DisposeBag()
    
    var genreRepository: GenreRepository
    
    init(genreRepository: GenreRepository) {
        self.genreRepository = genreRepository
    }
    
    var errors: RxSwift.Observable<Error> {
        _errors.asObservable()
    }
    
    var genres: RxSwift.Observable<[Data.GenreEntity]> {
        _genreList.asObservable()
    }
    
    func getGenreList() {
        genreRepository
            .getGenre()
            .subscribe(
                onSuccess: { [weak self] data in
                    self?._genreList.accept(data)
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
