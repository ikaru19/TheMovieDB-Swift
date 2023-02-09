//
//  MovieTableCell.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class MovieTableCell: UITableViewCell {
    public static let identifier: String = "MovieTable"
    private var vwContainer: UIView?
    private var ivContent: UIImageView?
    private var lbTitle: UILabel?
    private var lbReleaseDate: UILabel?
    private var lbRate: UILabel?
    
    private var data: Data.MovieEntity?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDesign()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDesign()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateUI(data: Data.MovieEntity) {
        self.data = data
        lbRate?.attributedText = generateRateLabelText(rate: String(data.voteAverage))
        let url = URL(string:"https://image.tmdb.org/t/p/w500/\(data.posterPath)")
        ivContent?.sd_setImage(with: url)
        lbTitle?.text = data.title
        lbReleaseDate?.text = "Release date \(data.releaseDate)"
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
}

// MARK: UIKIT
private extension MovieTableCell {
    func initDesign() {
        setupBaseView()
        let vwContainer = generateContainer()
        let ivContent = generateContentImageView()
        let lbTitle = generateTitleLabel()
        let lbReleaseDate = generateSubtitleDesign()
        let lbRate = generateSubtitleDesign()
        
        contentView.addSubview(vwContainer)
        vwContainer.addSubview(ivContent)
        vwContainer.addSubview(lbTitle)
        vwContainer.addSubview(lbReleaseDate)
        vwContainer.addSubview(lbRate)
        
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }

        ivContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(100)
            make.height
                .equalTo(ivContent.snp.width)
                .multipliedBy(16.0 / 9.0)
                .priority(.high)
        }
        
        lbTitle.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.leading.equalTo(ivContent.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(ivContent).offset(2)
        }
        
        lbReleaseDate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.leading.equalTo(lbTitle)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.top.equalTo(lbTitle.snp.bottom).offset(2)
        }
        
        lbRate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.leading.equalTo(lbTitle)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.top.equalTo(lbReleaseDate.snp.bottom).offset(2)
        }
        
        self.vwContainer = vwContainer
        self.ivContent = ivContent
        self.lbTitle = lbTitle
        self.lbReleaseDate = lbReleaseDate
        self.lbRate = lbRate
    }
    
    func setupBaseView() {
        self.contentView.backgroundColor = .clear
    }
    
    func generateContainer() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        
        return view
    }
    
    func generateTitleLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
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
    
    func generateContentImageView() -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sd_imageIndicator = SDWebImageActivityIndicator.gray
        return view
    }
}
