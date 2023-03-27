//
//  MovieViewController.swift
//  CodingProject
//
//  Created by Tung Truong on 24/03/2023.
//

import UIKit

class MovieViewController: UIViewController {
    var image: UIImage = UIImage(named: "img_placeholder")!
    lazy var movieImage: UIImageView = {
        let movieImage = UIImageView()
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        return movieImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupView()
        
    }
    
    private func setupView() {
        self.view.addSubview(movieImage)
        movieImage.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        movieImage.backgroundColor = .red
        movieImage.image = self.image
    }
}
