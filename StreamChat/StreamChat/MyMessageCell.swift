//
//  TableViewCell.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/17.
//

import UIKit

final class MyMessageCell: UITableViewCell {
    static let reuseIfentifier = "myMessageCell"

    let messageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_right")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    let messageLable: UILabel = {
        let label = UILabel()
        label.text = "placeholder send Message"
        label.numberOfLines = 0
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "receive Time"
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupMessage(message: String, time: Date) {
        contentView.addSubview(messageView)
        contentView.addSubview(messageLable)
        contentView.addSubview(timeLabel)

        messageLable.text = message
        timeLabel.text = DateToStringFormatter.sherd.dateToStringTime(at: time)

        messageView.snp.makeConstraints { imageView in
            imageView.top.equalToSuperview().inset(5)
            imageView.trailing.equalTo(self).inset(5)
            imageView.leading.greaterThanOrEqualTo(self).inset(100)
        }

        messageLable.snp.makeConstraints { label in
            label.top.bottom.equalTo(messageView).inset(5)
            label.leading.trailing.equalTo(messageView).inset(10)
        }

        timeLabel.snp.makeConstraints { label in
            label.top.equalTo(messageView.snp.bottom).offset(3)
            label.trailing.equalTo(messageLable.snp.trailing).offset(3)
            label.bottom.equalToSuperview().inset(5)
        }
    }

}