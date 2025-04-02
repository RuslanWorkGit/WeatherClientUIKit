//
//  WeatherView.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 15.02.2025.
//


import UIKit

class WeatherView: UIViewController {
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
    
    private let showSaveData: UIButton = {
        let button = UIButton()
        button.setTitle("Show saved data", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
 

    private let viewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupBinding()
    }
    
    func setupUI() {
        
        view.addSubview(cityTextField)
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeUITextField)
        view.addSubview(searchButton)
        view.addSubview(segmentedControl)
        view.addSubview(showSaveData)
        
        view.backgroundColor = .white
        segmentedControl.selectedSegmentIndex = 0
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            showSaveData.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            showSaveData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSaveData.widthAnchor.constraint(equalToConstant: 150),
            showSaveData.heightAnchor.constraint(equalToConstant: 50)
            
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
    
    private func setupBinding() {
        viewModel.updateWeatherInfo = { [weak self] data in
            self?.showWeatherDetails(with: data)
        }
        
        viewModel.segmentChanged = { [weak self] selectIndex in
            self?.segmentUIChange(index: selectIndex)
        }
    }
    
    private func setupAction() {
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        showSaveData.addTarget(self, action: #selector(showSavedDataAction), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentControValueChange), for: .valueChanged)
    }
    
    @objc func segmentControValueChange(_ sender: UISegmentedControl){
        viewModel.selectedSegment = sender.selectedSegmentIndex
    }
    
    @objc func searchButtonAction() {
        if segmentedControl.selectedSegmentIndex == 0 {
            guard let city = cityTextField.text, !city.isEmpty else {
                assertionFailure("Please enter city name")
                return
            }
            
            viewModel.fetchByCity(withCity: city)

        } else {
            guard let latitude = latitudeTextField.text, !latitude.isEmpty else {
                assertionFailure("Please enter latitude")
                return
            }
            
            guard let longitude = longitudeUITextField.text, !longitude.isEmpty else {
                assertionFailure("Please enter longitude")
                return
            }
            
            viewModel.fetchByCoordinate(latitude: latitude, longitude: longitude)

        }
    }
    
    @objc func showSavedDataAction() {
        
        let detailVC = WeatherDetailView()
        detailVC.loadAction()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func segmentUIChange(index: Int) {
        if index == 0 {
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
    
    private func showWeatherDetails(with data: WeatherResult) {
        let detailVC = WeatherDetailView()
        detailVC.weatherData = data
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
