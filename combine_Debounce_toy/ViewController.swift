//
//  ViewController.swift
//  combine_Debounce_toy
//
//  Created by MAC on 11/29/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var label: UILabel!
    
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchBar.searchTextField
            .myDebouncePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                print("내가받은 값은 --> \(value)")
                self?.label.text = value
            }
            .store(in: &bag)
    }


    
   
}

extension UISearchTextField {
    var myDebouncePublisher: AnyPublisher<String , Never> {
        
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .compactMap{$0.object as? UISearchTextField}
            .map{$0.text ?? ""}
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .filter{ $0.count > 0 }
            .eraseToAnyPublisher()
    }
}

