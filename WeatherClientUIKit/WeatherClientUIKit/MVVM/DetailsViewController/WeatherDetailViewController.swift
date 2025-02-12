//
//  WeatherDetailViewController.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 28.01.2025.
//


import UIKit



class WeatherDetailViewController: UIViewController {
    
    private let temperatureLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let pressureLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let humidityLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let descriptionLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.numberOfLines = 0
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let windLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var weatherData: WeatherResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        view.addSubview(temperatureLable)
        view.addSubview(pressureLable)
        view.addSubview(humidityLable)
        view.addSubview(descriptionLable)
        view.addSubview(windLable)
        
        NSLayoutConstraint.activate([
            temperatureLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            temperatureLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            temperatureLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pressureLable.topAnchor.constraint(equalTo: temperatureLable.bottomAnchor, constant: 20),
            pressureLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pressureLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            humidityLable.topAnchor.constraint(equalTo: pressureLable.bottomAnchor, constant: 20),
            humidityLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            humidityLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLable.topAnchor.constraint(equalTo: humidityLable.bottomAnchor, constant: 20),
            descriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            windLable.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 20),
            windLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            windLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
            
        ])
    }
    
    private func updateUI() {
        guard let weatherData = weatherData else {
            return
        }
        temperatureLable.text = "Temperature: \(weatherData.main.temp) C"
        pressureLable.text = "Preasure: \(weatherData.main.pressure)"
        humidityLable.text = "Humidity: \(weatherData.main.humidity)"
        descriptionLable.text = "Weather: \(weatherData.weather[0].description)"
        windLable.text = "Wind: \(windDirection(deg: weatherData.wind.deg))"

    }
    
    private func windDirection(deg: Int) -> String {
        switch deg {
        case 337...360, 0..<22:
            return "North"
        case 22..<67:
            return "North-East"
        case 67..<112:
            return "East"
        case 112..<157:
            return "South-East"
        case 157..<202:
            return "South"
        case 202..<247:
            return "South-West"
        case 247..<292:
            return "West"
        case 292..<337:
            return "North-West"
        default:
            return "Unknown"
        }

    }
}
