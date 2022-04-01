//
//  PullRequestTableViewCell.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import UIKit

class PullRequestTableViewCell: UITableViewCell {
    let titleLabel = UILabel.init()
    let createdLabel = UILabel.init()
    let closedLabel = UILabel.init()
    init() {
        super.init(style: .default, reuseIdentifier: "pull")
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell() {
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5), titleLabel.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor), titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor), titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)])
        titleLabel.sizeToFit()
        self.contentView.addSubview(createdLabel)
        createdLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([createdLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5), createdLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25), createdLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor), createdLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)])
        self.contentView.addSubview(closedLabel)
        closedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([closedLabel.leadingAnchor.constraint(equalTo: createdLabel.trailingAnchor, constant: 5), closedLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25), closedLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor), closedLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)])
    }
    
    func setCreatedTime(time: String?, fontSize: CGFloat = 12) {
        createdLabel.attributedText = NSAttributedString.init(string: time ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize), NSAttributedString.Key.foregroundColor: Color.sharedColor.createdColor])
    }
    
    func setClosedTime(time: String?, fontSize: CGFloat = 12) {
        closedLabel.attributedText = NSAttributedString.init(string: time ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize), NSAttributedString.Key.foregroundColor: Color.sharedColor.closedColor])
    }
}


