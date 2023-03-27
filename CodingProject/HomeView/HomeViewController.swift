//
//  ViewController.swift
//  CodingProject
//
//  Created by Tung Truong on 23/03/2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    lazy var indicatorView: UIActivityIndicatorView? = nil
    var image: UIImage?
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self,
                           forCellReuseIdentifier: HomeTableViewCell.identifier)
        return tableView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Sorry, we couldn’t find any movies with this keyword. Please try with another keyword."
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        setupView()
        
    }
    
    private func setupView() {
        //setup Loading Indicator + Navigation
        
        let indicatorView = self.activityIndicator(style: .large,
                                                           center: self.view.center)
        self.view.addSubview(indicatorView)
        self.indicatorView = indicatorView
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Home"
        
        //setup Search bar
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        //setup TableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        view.bringSubviewToFront(indicatorView)
    }
    
    private func pushToMovieVC(image: UIImage) {
        DispatchQueue.main.async {
            self.indicatorView?.stopAnimating()
            let vc = MovieViewController()
            vc.image = image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indicatorView?.startAnimating()
        if let model = viewModel.listMovies {
            self.viewModel.fetchImage(imageString:model[indexPath.row].poster) {[weak self] imageData in
                switch imageData {
                case .success(let data):
                    guard let self = self else { return }
                    self.image = UIImage(data: data)
                    self.pushToMovieVC(image: self.image ?? UIImage(named: "img_placeholder")!)
                case .failure(let error):
                    guard let self = self else { return }
                    print(error)
                    self.pushToMovieVC(image: UIImage(named: "img_placeholder")!)
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}
        guard let model = viewModel.listMovies, model.count != 0 else { return UITableViewCell() }
        cell.config(model: model[indexPath.row])
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchMovieResult(urlString: APIService.urlString(keyword: searchText))
        tableView.isHidden = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if viewModel.listMovies?.count == 0 {
            tableView.isHidden = true
            searchBar.resignFirstResponder()
        } else {
            searchBar.resignFirstResponder()
            tableView.reloadData()
        }
   }
}

extension HomeViewController {
    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                       frame: CGRect? = nil,
                                       center: CGPoint? = nil) -> UIActivityIndicatorView {

        let activityIndicatorView = UIActivityIndicatorView(style: style)
        
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        
        if let center = center {
            activityIndicatorView.center = center
        }
        activityIndicatorView.color = .black
        return activityIndicatorView
    }
}
