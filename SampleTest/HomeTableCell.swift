//
//  HomeTableCell.swift
//  SampleTest
//
//  Created by differenz189 on 23/02/22.
//

import UIKit
import Kingfisher

protocol HomeTableCellDelegate: AnyObject {
    func selected(postData: PostModel, isLiked: Bool)
}

class HomeTableCell: UITableViewCell {
    
    private var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sample"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var imgView: UIImageView = {
        let imgVw = UIImageView()
        let img = UIImage(systemName: "circle.fill")
        imgVw.image = img
        imgVw.contentMode = .scaleAspectFill
        imgVw.clipsToBounds = true
        imgVw.translatesAutoresizingMaskIntoConstraints = false
       return imgVw
    }()
    
    private var likeButton: UIButton = {
       let btn = UIButton()
        let img = UIImage(systemName: "circle.fill")
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var likeLabel: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
    }()
    
    private var isLiked: Bool = false
    weak var delegate: HomeTableCellDelegate?
//    private var commentButton: UIButton = {
//        let btn =  UIButton()
//        let img = UIImage(systemName: "circle.fill")
//        btn.setImage(img, for: .normal)
//
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
    private var post = PostModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(likeLabel)
//        self.addSubview(commentButton)
        self.setConstraints()
        
        self.likeButton.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            
            self.imgView.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 8),
            self.imgView.leadingAnchor.constraint(equalTo: self.label.leadingAnchor),
            self.imgView.trailingAnchor.constraint(equalTo: self.label.trailingAnchor),
            self.imgView.heightAnchor.constraint(equalToConstant: 100),
            
            self.likeButton.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 8),
            self.likeButton.leadingAnchor.constraint(equalTo: self.label.leadingAnchor),
            self.likeButton.heightAnchor.constraint(equalToConstant: 32),
            self.likeButton.widthAnchor.constraint(equalTo: self.likeButton.heightAnchor),
            self.likeButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            
            self.likeLabel.topAnchor.constraint(equalTo: self.likeButton.topAnchor),
            self.likeLabel.bottomAnchor.constraint(equalTo: self.likeButton.bottomAnchor),
            self.likeLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: 4),
//            self.likeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
//            self.likeLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: 2),
        ])
    }
    
    func configCell(withPost post: PostModel, isLiked: Bool) {
        self.post = post
        self.label.text = post.auther
        self.imgView.kf.setImage(with: URL(string: post.imageUrl ?? ""))
        self.likeLabel.text = "\(post.like ?? 0)"
        self.isLiked = isLiked
        self.likeButton.tintColor = isLiked ? .red : .blue
    }

    @objc private func likeButtonClick() {
        isLiked = !isLiked
        delegate?.selected(postData: self.post, isLiked: isLiked)
    }
}


//productImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
