//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

// MARK: LIFECYCLE AND CALLBACK
extension Presentation.UiKit {
    class MovieListViewController: UIViewController {
        private var vwContainer: UIView?
        private var tvContent: UITableView?
        private var lastPage = 1
        
        var genreData: Data.GenreEntity?
        var data: [Data.MovieEntity] = []
        private var vmBag = DisposeBag()
        private var isInit = true
        
        private var viewModel: MovieViewModel
        
        init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: MovieViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            initDesign()
            initViews()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            subscribeViewModel()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            if let genreID = genreData?.id,
               isInit {
                viewModel.getGameList(withGenreId: genreID, page: lastPage)
            }
            
            isInit = false
        }
        
        private func subscribeViewModel() {
            viewModel.errors
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] error in
                        guard let self = self else {
                            return
                        }
                        self.handleError(error)
                    }
                )
                .disposed(by: vmBag)
            viewModel
                .movies
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] data in
                        guard let self = self else {
                            return
                        }
                        if self.data.isEmpty || self.lastPage == 1 {
                            self.initMovie(data)
                        } else {
                            self.appendMoviesData(data)
                        }
                    }
                )
                .disposed(by: vmBag)
        }
    }
}

// MARK: Function
private extension Presentation.UiKit.MovieListViewController {
    func initMovie(_ datas: [Data.MovieEntity]) {
        self.data =  datas
        tvContent?.reloadData()
    }

    func appendMoviesData(_ datas: [Data.MovieEntity]) {
        appendTable(datas)
    }
    
    func requestLoadMore() {
        guard let genreData = genreData else {
            return
        }
        lastPage += 1
        viewModel.getGameList(withGenreId: genreData.id, page: lastPage)
    }
    
    func appendTable(
        _ datas: [Data.MovieEntity]
    ) {
        data.append(contentsOf: datas)
        tvContent?.reloadData()
        tvContent?.dequeueReusableCell(withIdentifier: MovieTableCell.identifier)
    }
}

// MARK: DESIGN
private extension Presentation.UiKit.MovieListViewController {
    private func initDesign() {
        setupBaseView()
        
        let vwContainer = generateViewForContainerDesign()
        let tvContent = generateTableView()
        
        view.addSubview(vwContainer)
        vwContainer.addSubview(tvContent)
        
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        tvContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
        }
        
        self.vwContainer = vwContainer
        self.tvContent = tvContent
    }
    
    func setupBaseView() {
        view.backgroundColor = .white
        self.navigationItem.title = genreData?.name
    }
    
    func generateViewForContainerDesign() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }
    
    func generateTableView() -> UITableView {
        let view = UITableView(frame: .zero,style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}


// MARK: View
private extension Presentation.UiKit.MovieListViewController {
    func initViews() {
        initTableView()
    }
    
    func initTableView() {
        tvContent?.register(
            MovieTableCell.self,
                forCellReuseIdentifier: MovieTableCell.identifier
        )
        self.tvContent?.delegate = self
        self.tvContent?.dataSource = self
        tvContent?.rowHeight = UITableView.automaticDimension
        tvContent?.estimatedRowHeight = 600
    }
}


// MARK: TABLE DELEGATE
extension Presentation.UiKit.MovieListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieTableCell.identifier, for: indexPath
        ) as? MovieTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateUI(data: data[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: GOTO DETAIL
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let table = tvContent else {
            return
        }
        let y = scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.frame.size.height)
        let relativeHeight = 1 - (table.rowHeight / (scrollView.contentSize.height - scrollView.frame.size.height))
        if y >= relativeHeight{
            requestLoadMore()
        }
    }
}
