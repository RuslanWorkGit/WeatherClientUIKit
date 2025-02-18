//
//  WeatherDetailViewController.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 28.01.2025.
//


import UIKit

class WeatherDetailView: UIViewController {
    
    private let cityLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
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
    
    private let saveData: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadData: UIButton = {
        let button = UIButton()
        button.setTitle("Load", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveTimeLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var weatherData: WeatherResult?
    
    var storedWeather: StoredWeatherData?
    private let viewModel = WeatherDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
        setupAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAndUpdateWeather()

    }
    
    private func setupUI() {
        view.addSubview(cityLable)
        view.addSubview(temperatureLable)
        view.addSubview(pressureLable)
        view.addSubview(humidityLable)
        view.addSubview(descriptionLable)
        view.addSubview(windLable)
        view.addSubview(saveTimeLable)
        view.addSubview(saveData)
        view.addSubview(loadData)
        
        NSLayoutConstraint.activate([
            cityLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            cityLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            temperatureLable.topAnchor.constraint(equalTo: cityLable.bottomAnchor, constant: 20),
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
            windLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveTimeLable.topAnchor.constraint(equalTo: windLable.bottomAnchor, constant: 20),
            saveTimeLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveTimeLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loadData.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            loadData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadData.heightAnchor.constraint(equalToConstant: 50),
            loadData.widthAnchor.constraint(equalToConstant: 150),
            
            saveData.bottomAnchor.constraint(equalTo: loadData.topAnchor, constant: -30),
            saveData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveData.heightAnchor.constraint(equalToConstant: 50),
            saveData.widthAnchor.constraint(equalToConstant: 150)
            
            
        ])
    }
    
    private func updateUI() {
        guard let weatherData = weatherData else {
            temperatureLable.text = "No Data"
            return
        }
        
        cityLable.text = "City: \(weatherData.name)"
        temperatureLable.text = "Temperature: \(weatherData.main.temp) C"
        pressureLable.text = "Preasure: \(weatherData.main.pressure)"
        humidityLable.text = "Humidity: \(weatherData.main.humidity)"
        descriptionLable.text = "Weather: \(weatherData.weather[0].description)"
        windLable.text = "Wind: \(windDirection(deg: weatherData.wind.deg))"
        
        if let storedWeather = storedWeather {
            saveTimeLable.text = "Saved: \(formateDate(timeInterval: storedWeather.time))"
        } else {
            saveTimeLable.text = "Saved: No data"
        }

    }
    

    
    private func setupAction() {
        saveData.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        loadData.addTarget(self, action: #selector(loadAction), for: .touchUpInside)
    }
    
    
    @objc func saveAction() {
        Task {
            guard let weatherData = weatherData else {
                temperatureLable.text = "No Data"
                return
            }
            
            storedWeather = StoredWeatherData(weather: weatherData, time: Date().timeIntervalSince1970)
            
            guard let storedWeather = storedWeather else {
                temperatureLable.text = "No Data"
                return
            }
            
            viewModel.saveWeather(weather: storedWeather)
            
        }
        
    }
    
    @objc func loadAction() {
        checkAndUpdateWeather()
    }
    
    
    private func checkAndUpdateWeather() {
        Task {
            if let storedWeather = viewModel.loadWeather() {
                
                if viewModel.shouldUpdateWeather(storedWeather: storedWeather) {
                    
                    print("Data need to update")
                    viewModel.fetchWeather(for: storedWeather.weather.name) { [weak self] result in
                        guard let newWeather = result else { return }
                        
                        let newStoredWeather = StoredWeatherData(weather: newWeather, time: Date().timeIntervalSince1970)
                        self?.viewModel.saveWeather(weather: newStoredWeather)
                        self?.weatherData = newWeather
                        self?.storedWeather = newStoredWeather
                        self?.updateUI()
                    }
                } else {
                    
                    print("Data is up to date")
                    self.weatherData = storedWeather.weather
                    self.storedWeather = storedWeather
                    self.updateUI()
                }
                
            } else {
                
                print("Data not found")
            }
        }
    }
    
    
    private func formateDate(timeInterval: TimeInterval) -> String{
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
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
