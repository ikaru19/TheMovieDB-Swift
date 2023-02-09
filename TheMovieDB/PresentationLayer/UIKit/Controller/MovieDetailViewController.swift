//
//  MovieDetailViewController.swift
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
    class MovieDetailViewController: UIViewController {
        private var vwContainer: UIView?
        private var ivContent: UIImageView?
        private var lbTitle: UILabel?
        private var lbReleaseDate: UILabel?
        private var lbRate: UILabel?
        private var lbCount: UILabel?
        private var lbContent: UILabel?
        private var lbTrailer: UILabel?
        private var tvComment: UITableView?
        private var lastPage = 1
        
        var data: Data.MovieEntity?
        var reviewData: [Data.ReviewEntity] = []
        var trailer: Data.VideoDataEntity?
        private var vmBag = DisposeBag()
        
        private var viewModel: MovieDetailViewModel
        
        init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: MovieDetailViewModel) {
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
            initEvents()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            subscribeViewModel()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            if let data = data {
                populateData(data)
                viewModel.getReviews(movieId: data.id, page: lastPage)
                viewModel.getVideos(movieId: data.id)
            }
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
                .reviews
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] data in
                        guard let self = self else {
                            return
                        }
                        if self.reviewData.isEmpty || self.lastPage == 1 {
                            self.initReview(data)
                        } else {
                            self.appendMoviesData(data)
                        }
                    }
                )
                .disposed(by: vmBag)
            viewModel
                .videos
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] data in
                        guard let self = self else {
                            return
                        }
                        self.searchTrailer(data)
                    }
                )
                .disposed(by: vmBag)
        }
        
        @objc
        func goToYoutube(){
            if let key = trailer?.key {
                goToWeb(key: key)
            }
        }
    }
}

// MARK: Function
private extension Presentation.UiKit.MovieDetailViewController {
    func searchTrailer(_ datas: [Data.VideoDataEntity]) {
        let trailer : [Data.VideoDataEntity] = datas.filter( { $0.type == "Trailer" })
        if trailer.isEmpty {
            lbTrailer?.isHidden = true
        } else {
            self.trailer = trailer.first
            lbTrailer?.isHidden = false
        }
    }
    
    func initReview(_ datas: [Data.ReviewEntity]) {
        self.reviewData =  datas
        tvComment?.reloadData()
    }

    func goToWeb(key: String) {
        print("goEdsgsd")
        if let url = URL(string: "https://www.youtube.com/embed/\(key)") {
            UIApplication.shared.open(url)
        }
    }
    
    func appendMoviesData(_ datas: [Data.ReviewEntity]) {
        appendTable(datas)
    }
    
    func requestLoadMore() {
        guard let data = data else {
            return
        }
        lastPage += 1
        viewModel.getReviews(movieId: data.id, page: lastPage)
    }
    
    func appendTable(
        _ datas: [Data.ReviewEntity]
    ) {
        reviewData.append(contentsOf: datas)
        tvComment?.reloadData()
        tvComment?.dequeueReusableCell(withIdentifier: CommentTableCell.identifier)
    }
}


// MARK: Function
private extension Presentation.UiKit.MovieDetailViewController {
    func populateData(_ data: Data.MovieEntity) {
        self.data = data
        lbRate?.attributedText = generateRateLabelText(rate: String(data.voteAverage))
        let url = URL(string:"https://image.tmdb.org/t/p/w500/\(data.posterPath)")
        ivContent?.sd_setImage(with: url)
        lbTitle?.text = data.title
        lbReleaseDate?.text = "Release date \(data.releaseDate)"
        lbCount?.attributedText = generateCountLabelText(count: String(data.voteCount))
        lbContent?.text = data.overview
    }
}

// MARK: UIBUILDER
private extension Presentation.UiKit.MovieDetailViewController {
    func initDesign() {
        setupBaseView()
        let vwContainer = generateContainerView()
        let ivContent = generateContentImageView()
        let lbTitle = generateTitleLabel()
        let lbReleaseDate = generateReleaseLabel()
        let lbRate = generateSubtitleDesign()
        let lbCount = generateSubtitleDesign()
        let lbContent = generateContentLabel()
        let lbTrailer = generatTrailerLabel()
        let tvComment = generateTableView()
        
        view.addSubview(vwContainer)
        vwContainer.addSubview(ivContent)
        vwContainer.addSubview(lbTitle)
        vwContainer.addSubview(lbReleaseDate)
        vwContainer.addSubview(lbRate)
        vwContainer.addSubview(lbCount)
        vwContainer.addSubview(lbContent)
        vwContainer.addSubview(tvComment)
        vwContainer.addSubview(lbTrailer)
        
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        ivContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(150)
            make.height
                .equalTo(ivContent.snp.width)
                .multipliedBy(16.0 / 9.0)
                .priority(.high)
        }
        
        lbTitle.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(ivContent)
            make.leading.equalTo(ivContent.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbReleaseDate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbTitle.snp.bottom).offset(8)
            make.leading.equalTo(ivContent.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbRate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbReleaseDate.snp.bottom).offset(8)
            make.leading.equalTo(ivContent.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbCount.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbRate.snp.bottom).offset(8)
            make.leading.equalTo(ivContent.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbTrailer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbCount.snp.bottom).offset(8)
            make.leading.equalTo(ivContent.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        
        lbContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(ivContent.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        tvComment.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbContent.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.vwContainer = vwContainer
        self.ivContent = ivContent
        self.lbTitle = lbTitle
        self.lbReleaseDate = lbReleaseDate
        self.lbRate = lbRate
        self.lbCount = lbCount
        self.lbContent = lbContent
        self.tvComment = tvComment
        self.lbTrailer = lbTrailer
    }
    
    func setupBaseView() {
        view.backgroundColor = .white
        self.navigationItem.title = "Detail"
    }
    
    func generateContainerView() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func generateScrollView() -> UIScrollView {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.bounces = true
        return view
    }
    
    func generateContentImageView() -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func generateTitleLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateReleaseLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.6)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generatTrailerLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.textColor = .systemBlue
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "Trailer"
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }
    
    func generateSubtitleDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.7)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }

    func generateContentLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateTableView() -> UITableView {
        let view = UITableView(frame: .zero,style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

// MARK: VIEW
private extension Presentation.UiKit.MovieDetailViewController {
    func initEvents() {
        let trailerTapped = UITapGestureRecognizer(target: self, action: #selector(goToYoutube))
        lbTrailer?.addGestureRecognizer(trailerTapped)
    }
    
    func initViews() {
        initTableView()
    }
    
    func initTableView() {
        tvComment?.register(
            CommentTableCell.self,
                forCellReuseIdentifier: CommentTableCell.identifier
        )
        self.tvComment?.delegate = self
        self.tvComment?.dataSource = self
        tvComment?.rowHeight = UITableView.automaticDimension
        tvComment?.estimatedRowHeight = 600
    }
    
    private func generateRateLabelText(rate: String) -> NSMutableAttributedString {
        let fullText = NSMutableAttributedString(string: "")

        let checkIcon = NSTextAttachment()
        checkIcon.image = UIImage(systemName: "star.fill")?.withTintColor(.orange)

        let labelFont = UIFont.systemFont(ofSize: 12, weight: .light)
        let imageSize = CGSize(width: 12, height: 12)
        checkIcon.bounds = CGRect(
            x: 0,
            y: (labelFont.capHeight - imageSize.height) / 2,
            width: imageSize.width,
            height: imageSize.height
        )

        let checkedString = NSAttributedString(attachment: checkIcon)

        fullText.append(checkedString)
        fullText.append(NSAttributedString(string: "  "))
        fullText.append(NSAttributedString(string: rate))
        return fullText
    }
    
    private func generateCountLabelText(count: String) -> NSMutableAttributedString {
        let fullText = NSMutableAttributedString(string: "")

        let checkIcon = NSTextAttachment()
        checkIcon.image = UIImage(systemName: "popcorn.fill")

        let labelFont = UIFont.systemFont(ofSize: 12, weight: .light)
        let imageSize = CGSize(width: 12, height: 12)
        checkIcon.bounds = CGRect(
            x: 0,
            y: (labelFont.capHeight - imageSize.height) / 2,
            width: imageSize.width,
            height: imageSize.height
        )

        let checkedString = NSAttributedString(attachment: checkIcon)

        fullText.append(checkedString)
        fullText.append(NSAttributedString(string: "  "))
        fullText.append(NSAttributedString(string: count))
        fullText.append(NSAttributedString(string: " vote"))
        return fullText
    }
}


// MARK: TABLE DELEGATE
extension Presentation.UiKit.MovieDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewData.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentTableCell.identifier, for: indexPath
        ) as? CommentTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateUI(with: reviewData[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let table = tvComment else {
            return
        }
        let y = scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.frame.size.height)
        let relativeHeight = 1 - (table.rowHeight / (scrollView.contentSize.height - scrollView.frame.size.height))
        if y >= relativeHeight{
            requestLoadMore()
        }
    }
}
