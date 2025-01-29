//
//  ViewController.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 26.01.2025.
//

import UIKit

enum ConstantLink: String {
    case mainLink = "https://api.openweathermap.org/data/2.5/weather?"
    case city = "q="
    case latitude = "lat="
    case longitude = "lon="
    case appid = "appid=9150ef8248678c9c51a5dfe2d87e208d"
    case metrics = "units=metric"
}

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
            fetchWeather(byCyti: city)
        } else {
            guard let latitude = latitudeTextField.text, !latitude.isEmpty else {
                assertionFailure("Please enter latitude")
                return
            }
            
            guard let longitude = longitudeUITextField.text, !longitude.isEmpty else {
                assertionFailure("Please enter longitude")
                return
            }
            
            fetchWeather(byLatitude: latitude, byLongitude: longitude)
            

        }
    }
    
    private func fetchWeather(byCyti city: String) {
        let linkApi = ConstantLink.mainLink.rawValue + ConstantLink.city.rawValue + "\(city)" + "&" + ConstantLink.appid.rawValue + "&" + ConstantLink.metrics.rawValue
        
        guard let url = URL(string: linkApi) else {
            assertionFailure("Wrong link Api \(linkApi)")
            return
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let responseError = error {
                assertionFailure("\(responseError)")
            }
            
            guard let responseData = data else {
                assertionFailure("Problem with data")
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(WeatherResult.self, from: responseData)
//                print(decodeData)
                
                DispatchQueue.main.async {
                    self.showWeatherDetails(with: decodeData)
                }
                
            } catch(let parseError){
                print(parseError)
            }
        }
        task.resume()
  
        print("Fetching weather for city: \(city)")
    }
    
    private func fetchWeather(byLatitude latitude: String, byLongitude longitude: String) {
        
        let linkApi = ConstantLink.mainLink.rawValue + ConstantLink.latitude.rawValue + "\(latitude)" + "&" + ConstantLink.longitude.rawValue + "\(longitude)" + "&" + ConstantLink.appid.rawValue + "&" + ConstantLink.metrics.rawValue
        
        
        guard let url = URL(string: linkApi) else {
            assertionFailure("Wring url link: \(linkApi)")
            return
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let responseError = error {
                assertionFailure("\(responseError)")
            }
            
            guard let responseData = data else {
                assertionFailure("No data")
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(WeatherResult.self, from: responseData)
                print(decodeData)
                
                DispatchQueue.main.async {
                    self.showWeatherDetails(with: decodeData)
                }
                
            } catch(let parseError) {
                print(parseError)
            }
        }
        task.resume()
        
        print("Fetching weather for latitude: \(latitude), longitude: \(longitude)")
    }
    
    private func showWeatherDetails(with data: WeatherResult) {
        let detailVC = WeatherDetailViewController()
        detailVC.weatherData = data
        present(detailVC, animated: true, completion: nil)
    }



}

