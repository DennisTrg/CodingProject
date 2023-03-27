//
//  HomeTableViewCell.swift
//  CodingProject
//
//  Created by Tung Truong on 24/03/2023.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    static let identifier = "HomeCollectionViewCell"
    let movieImage = UIImageView()
    let movieName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImage.image = nil
        self.movieName.text = nil
    }
    
    private func setupView(){
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(movieImage)
        movieImage.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(view.snp.width).dividedBy(3)
        }
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        self.movieImage.image = UIImage(named: "img_placeholder")
        
        view.addSubview(movieName)
        movieName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(movieImage.snp.right).offset(20)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(35)
        }
        movieName.numberOfLines = 0
        movieName.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func config(model: Movie) {
        movieName.text = model.title
        guard let imageUrl = URL(string: model.poster) else { return }

        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else { return }
               DispatchQueue.main.async() { [weak self] in
                   guard let self = self else { return }
                   self.movieImage.image = image
               }
        }
        task.resume()
    }
}
