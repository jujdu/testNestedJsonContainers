//
//  ViewController.swift
//  jsonTest
//
//  Created by Michael Sidoruk on 20.12.2019.
//  Copyright © 2019 Michael Sidoruk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData { (result) in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


    func fetchData(completion: @escaping (Result<Feed, Error>) -> ()) {
        guard let url = Bundle.main.url(forResource: "json", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(Feed.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
