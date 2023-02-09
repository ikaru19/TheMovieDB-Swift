//
//  GenreViewController.swift
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
    class GenreViewController: UIViewController {
        private var vwContainer: UIView?
        private var tvContent: UITableView?
        
        private var data: [Data.GenreEntity] = []
        private var vmBag = DisposeBag()
        
        private var viewModel: GenreViewModel
        
        
        init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: GenreViewModel) {
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
            viewModel.getGenreList()
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
                .genres
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] games in
                        guard let self = self else {
                            return
                        }
                        self.initMovieData(games)
                    }
                )
                .disposed(by: vmBag)
        }
    }
}

// MARK: Function
private extension Presentation.UiKit.GenreViewController {
    func initMovieData(_ datas: [Data.GenreEntity]) {
        self.data = datas
        tvContent?.reloadData()
    }
}
// MARK: DESIGN
private extension Presentation.UiKit.GenreViewController {
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
private extension Presentation.UiKit.GenreViewController {
    func initViews() {
        initTableView()
    }
    
    func initTableView() {
        tvContent?.register(
            GenreTableCell.self,
                forCellReuseIdentifier: GenreTableCell.identifier
        )
        self.tvContent?.delegate = self
        self.tvContent?.dataSource = self
        tvContent?.rowHeight = UITableView.automaticDimension
        tvContent?.estimatedRowHeight = 600
    }
}


// MARK: TABLE DELEGATE
extension Presentation.UiKit.GenreViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: GenreTableCell.identifier, for: indexPath
        ) as? GenreTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateUI(data: data[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = (UIApplication.shared.delegate as? ProvideViewControllerResolver)?.vcResolver.instantiateMoviewListViewController().get() else {
            fatalError("View Controller can't be nil: Genre")
        }
        vc.genreData = data[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
