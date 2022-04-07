//
//  ViewController.swift
//  Swift-API-The-Rick-and-Morty
//
//  Created by Luccas Santana Marinho on 06/04/22.
//

import UIKit

class ViewController: UIViewController {

struct Post: Codable {
    let name: String
    let status: String
    let gender: String
    let image: String
    let url: String
    let created: String
}
    
    private lazy var image: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var labelOne: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelTwo: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelThree: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelFour: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()

    private lazy var labelFive: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()
    
    func insertViews() {
        self.view.addSubview(image)
        self.view.addSubview(labelOne)
        self.view.addSubview(labelTwo)
        self.view.addSubview(labelThree)
        self.view.addSubview(labelFour)
        self.view.addSubview(labelFive)
        
        makeRequest { (posts) in
            DispatchQueue.main.async {
                print(String(describing: posts))
                
                self.labelOne.text = "NAME: \(String(describing: posts.name))"
                self.labelTwo.text = "STATUS: \(String(describing: posts.status))"
                self.labelThree.text = "GENDER: \(String(describing: posts.gender))"
                self.labelFour.text = "URL: \(String(describing: posts.url))"
                self.labelFive.text = "CREATED: \(String(describing: posts.created))"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        insertViews()
        
        let urlString = URL(string: "https://rickandmortyapi.com/api/character/avatar/738.jpeg")
        image.downloaded(from: urlString!)
        
        NSLayoutConstraint.activate([

            image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            image.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.heightAnchor.constraint(equalToConstant: 200),
            
            labelOne.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            labelOne.topAnchor.constraint(equalTo: self.image.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            labelOne.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            labelTwo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            labelTwo.topAnchor.constraint(equalTo: self.labelOne.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelTwo.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            labelThree.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            labelThree.topAnchor.constraint(equalTo: self.labelTwo.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelThree.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            labelFour.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            labelFour.topAnchor.constraint(equalTo: self.labelThree.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelFour.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            labelFive.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            labelFive.topAnchor.constraint(equalTo: self.labelFour.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelFive.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    //MARK: - Chamando Api

    
    func makeRequest(completion: @escaping (Post) -> ()) {
        let url = URL(string: "https://rickandmortyapi.com/api/character/738")!
        
        let task = URLSession.shared.dataTask(with: url) { (data,
        response, error) in
            guard let responseData = data else { return }
            do {
                let posts = try JSONDecoder().decode(Post.self, from: responseData)
                completion(posts)
            } catch let error {
                print("error: \(error)")
            }
        }
        task.resume()
    }
}

    //MARK: - Extensao UIImageView

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
