//
//  ViewController.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 26.01.2025.
//

import UIKit



class ViewController: UIViewController {
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "city Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "latitude"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let longitudeUITextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "longitude"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search 🔎", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["City", "Coordinates"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        return segmentController
    }()
    
    private var cityConstraint: [NSLayoutConstraint] = []
    private var coordinateConstraint: [NSLayoutConstraint] = []
    private var network = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    func setupUI() {
        
        view.addSubview(cityTextField)
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeUITextField)
        view.addSubview(searchButton)
        view.addSubview(segmentedControl)
        
        segmentedControl.selectedSegmentIndex = 0
        
        
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        cityConstraint = [
            cityTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        coordinateConstraint = [
            longitudeUITextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            longitudeUITextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeUITextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            latitudeTextField.topAnchor.constraint(equalTo: longitudeUITextField.bottomAnchor, constant: 20),
            latitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchButton.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(cityConstraint)
        

    }
    
    private func setupAction() {
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentControValueChange), for: .valueChanged)
    }
    
    @objc func segmentControValueChange(_ sender: UISegmentedControl){
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cityTextField.isHidden = false
            longitudeUITextField.isHidden = true
            latitudeTextField.isHidden = true
            
            NSLayoutConstraint.deactivate(coordinateConstraint)
            NSLayoutConstraint.activate(cityConstraint)
        } else {
            cityTextField.isHidden = true
            longitudeUITextField.isHidden = false
            latitudeTextField.isHidden = false
            
            NSLayoutConstraint.deactivate(cityConstraint)
            NSLayoutConstraint.activate(coordinateConstraint)
            
        }
    }
    
    @objc func searchButtonAction() {
        if segmentedControl.selectedSegmentIndex == 0 {
            guard let city = cityTextField.text, !city.isEmpty else {
                assertionFailure("Please enter city name")
                return
            }
            
            network.fetchWeather(byCyti: city) { result in
                self.showWeatherDetails(with: result)
            }
            
//            fetchWeather(byCyti: city)
        } else {
            guard let latitude = latitudeTextField.text, !latitude.isEmpty else {
                assertionFailure("Please enter latitude")
                return
            }
            
            guard let longitude = longitudeUITextField.text, !longitude.isEmpty else {
                assertionFailure("Please enter longitude")
                return
            }
            
//            fetchWeather(byLatitude: latitude, byLongitude: longitude)
            network.fetchWeather(byLatitude: latitude, byLongitude: longitude) { result in
                self.showWeatherDetails(with: result)
            }
            

        }
    }
    
    private func showWeatherDetails(with data: WeatherResult) {
        let detailVC = WeatherDetailView()
        detailVC.weatherData = data
        present(detailVC, animated: true, completion: nil)
    }



}

