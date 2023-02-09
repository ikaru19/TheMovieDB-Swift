//
//  GenreTableCell.swift
//  TheMovieDB
//
//  Created by Muhammad Syafrizal on 09/02/23.
//

import Foundation
import UIKit
import SnapKit

class GenreTableCell: UITableViewCell {
    public static let identifier: String = "GenreTableCell"
    private var vwContainer: UIView?
    private var ivChevron: UIImageView?
    private var lbTitle: UILabel?
    
    private var data: Data.GenreEntity?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDesign()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDesign()
    }
    
    func updateUI(data: Data.GenreEntity) {
        self.data = data
        lbTitle?.text = data.name
    }
}

// MARK: UIKIT
private extension GenreTableCell {
    func initDesign() {
        setupBaseView()
        let vwContainer = generateContainer()
        let ivChevron = generateContentImageView()
        let lbTitle = generateTitleLabel()
        
        contentView.addSubview(vwContainer)
        vwContainer.addSubview(ivChevron)
        vwContainer.addSubview(lbTitle)

        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
        }
        
        ivChevron.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }

        lbTitle.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.lessThanOrEqualTo(ivChevron.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        self.lbTitle = lbTitle
        self.ivChevron = ivChevron
        self.vwContainer = vwContainer
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
        view.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    func generateContentImageView() -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .systemBlue
        return view
    }
}
