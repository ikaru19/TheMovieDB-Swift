//
//  ReviewCell.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import UIKit
import SnapKit

class CommentTableCell: UITableViewCell {
    public static let identifier: String = "CommentTableCell"
    private var vwContainer: UIView?
    private var vwAvatar: UIView?
    private var lbAvatarName: UILabel?
    private var lbName: UILabel?
    private var lbComment: UILabel?
    private var lbDate: UILabel?
    
    private var data: Data.ReviewEntity?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDesign()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDesign()
    }
    
    func updateUI(with data: Data.ReviewEntity) {
        self.data = data
        if data.authorDetails.name.isEmpty {
            lbName?.text = data.authorDetails.username
            lbAvatarName?.text = "\(data.authorDetails.username.prefix(1))"
        } else {
            lbName?.text = data.authorDetails.name
            lbAvatarName?.text = "\(data.authorDetails.name.prefix(1))"
        }
        lbComment?.text = data.content
        lbDate?.text = data.createdAt
        
    }
}

// MARK: UIKIT
private extension CommentTableCell {
    func initDesign() {
        setupBaseView()
        let vwContainer = generateContainer()
        let vwAvatar = generateAvatar()
        let lbAvatarName = generateLabel(ofSize: 24, weight: .thin, color: .white)
        let lbName = generateLabel(ofSize: 16, weight: .bold)
        let lbComment = generateLabel(ofSize: 12, weight: .regular)
        let lbDate = generateLabel(ofSize: 8, weight: .thin)
        
        contentView.addSubview(vwContainer)
        vwContainer.addSubview(vwAvatar)
        vwAvatar.addSubview(lbAvatarName)
        vwContainer.addSubview(lbName)
        vwContainer.addSubview(lbComment)
        vwContainer.addSubview(lbDate)
        
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
        }
        
        vwAvatar.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        lbAvatarName.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.center.equalToSuperview()
        }
        
        lbName.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(vwAvatar)
            make.leading.equalTo(vwAvatar.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbComment.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbName.snp.bottom).offset(4)
            make.leading.equalTo(lbName)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        lbDate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbComment.snp.bottom).offset(4)
            make.leading.equalTo(lbName)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        
        self.lbName = lbName
        self.lbComment = lbComment
        self.lbDate = lbDate
        self.lbAvatarName = lbAvatarName
    }
    
    func setupBaseView() {
        self.contentView.backgroundColor = .clear
    }
    
    func generateContainer() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func generateAvatar() -> UIView {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 25;
        view.backgroundColor = .gray.withAlphaComponent(0.7)
        return view
    }
    
    func generateLabel(ofSize fontSize: CGFloat, weight: UIFont.Weight, color: UIColor? = .black) -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        view.textColor = color
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
}
