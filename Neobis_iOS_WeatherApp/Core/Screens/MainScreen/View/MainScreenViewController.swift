//
//  ViewController.swift
//  Neobis_iOS_WeatherApp
//
//  Created by G G on 25.04.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {
    
    var viewModel: MainScreenViewModel
    
    private let searchLogo: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let temperatureView = TemperatureView()
    
    private let fiveDaysView = FiveDaysView()
    
    private let dateLabel = CustomLabel(font: Resources.Fonts.Name.regular,
                                        size: Resources.Fonts.Size.regular3,
                                        text: "Today, May 7th, 2021", color: .white)
    
    private let city = CustomLabel(font: Resources.Fonts.Name.bold,
                                   size: Resources.Fonts.Size.title3,
                                   text: "Barcelona", color: .white)
    
    private let country = CustomLabel(font: Resources.Fonts.Name.regular,
                                      size: Resources.Fonts.Size.title1,
                                      text: "Spain", color: .white)
    
    private let windStatus = CustomLabel(font: Resources.Fonts.Name.bold,
                                         size: Resources.Fonts.Size.regular3,
                                         text: "Wind status", color: .white)
    
    private let windSpeed = CustomLabel(font: Resources.Fonts.Name.regular,
                                        size: Resources.Fonts.Size.title1,
                                        text: "7 mph", color: .white)
    
    private let visibility = CustomLabel(font: Resources.Fonts.Name.regular,
                                         size: Resources.Fonts.Size.regular3,
                                         text: "Visibility", color: .white)
    
    private let visibilityRange = CustomLabel(font: Resources.Fonts.Name.regular,
                                              size: Resources.Fonts.Size.title1,
                                              text: "6.4 miles", color: .white)
    
    private let humidity = CustomLabel(font: Resources.Fonts.Name.regular,
                                       size: Resources.Fonts.Size.regular3,
                                       text: "Humidity", color: .white)
    
    private let humidityValue = CustomLabel(font: Resources.Fonts.Name.regular,
                                            size: Resources.Fonts.Size.title1,
                                            text: "85%", color: .white)
    
    private let airPressure = CustomLabel(font: Resources.Fonts.Name.regular,
                                          size: Resources.Fonts.Size.regular3,
                                          text: "Air pressure", color: .white)
    
    private let airPressureValue = CustomLabel(font: Resources.Fonts.Name.regular,
                                               size: Resources.Fonts.Size.title1,
                                               text: "998 mb", color: .white)
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupUI()
    }
        
    private func setupUI() {
        
        view.addSubViews(subViews: [
            searchLogo, dateLabel, city, country, temperatureView, windStatus, windSpeed, visibility, visibilityRange, humidity, humidityValue, airPressure, airPressureValue, fiveDaysView,
        ])
        
        searchLogo.addTarget(self, action: #selector(searchCity), for: .touchUpInside)
        searchLogo.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
                .inset(30)
            make.size.equalTo(75)
        }
        
        let date = Date(timeIntervalSince1970: viewModel.weatherData?.list.first?.dt ?? 0.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        
        
        dateLabel.text = dateFormatter.string(from: date)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                .offset(10)
        }
        
        city.text = viewModel.location?.name
        city.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom)
        }
        
        country.text = viewModel.location?.country
        country.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(city.snp.bottom)
        }
        
        temperatureView.temperature.text = "\(Int(viewModel.weatherData?.list.first?.main["temp"] ?? 0))°C"
        temperatureView.layer.cornerRadius = self.temperatureView.bounds.width / 2
        
        var icon = ""
        icon =  "\(viewModel.weatherData?.list.first?.weather.first?.icon ?? "")"
        temperatureView.cloudImage.loadImage(from: "https://openweathermap.org/img/wn/\(icon).png")
        temperatureView.snp.makeConstraints { make in
            make.top.equalTo(country.snp.bottom)
                .offset(Resources.Constraints.temperatureViewTop)
            make.left.right.equalToSuperview()
                .inset(Resources.Constraints.temperatureViewLeft)
            make.height.equalTo(temperatureView.snp.width)
        }
        
        windStatus.snp.makeConstraints { make in
            make.top.equalTo(temperatureView.snp.bottom)
                .offset(Resources.Constraints.attTitleTop)
            make.left.equalToSuperview()
            make.right.equalTo(view.snp.centerX)
        }
        
        windSpeed.text = String(viewModel.weatherData?.list.first?.wind["speed"] ?? 0.0)
        windSpeed.snp.makeConstraints { make in
            make.top.equalTo(windStatus.snp.bottom)
                .offset(Resources.Constraints.attValueTop)
            make.centerX.equalTo(windStatus.snp.centerX)
        }
        
        visibility.snp.makeConstraints { make in
            make.top.equalTo(temperatureView.snp.bottom)
                .offset(Resources.Constraints.attTitleTop)
            make.right.equalToSuperview()
            make.left.equalTo(view.snp.centerX)
        }
        
        visibilityRange.text = String(viewModel.weatherData?.list.first?.visibility ?? 0.0)
        visibilityRange.snp.makeConstraints { make in
            make.top.equalTo(visibility.snp.bottom)
                .offset(Resources.Constraints.attValueTop)
            make.centerX.equalTo(visibility.snp.centerX)
        }
        
        humidity.snp.makeConstraints { make in
            make.centerX.equalTo(windStatus.snp.centerX)
            make.top.equalTo(windSpeed.snp.bottom).offset(20)
        }
        
        humidityValue.text = String(viewModel.weatherData?.list.first?.main["humidity"] ?? 0.0)
        humidityValue.snp.makeConstraints { make in
            make.top.equalTo(humidity.snp.bottom)
                .offset(Resources.Constraints.attValueTop)
            make.centerX.equalTo(humidity.snp.centerX)
        }
        
        airPressure.snp.makeConstraints { make in
            make.centerX.equalTo(visibility.snp.centerX)
            make.top.equalTo(visibilityRange.snp.bottom).offset(20)
        }
        
        airPressureValue.text = String(viewModel.weatherData?.list.first?.main["pressure"] ?? 0.0)
        airPressureValue.snp.makeConstraints { make in
            make.top.equalTo(airPressure.snp.bottom)
                .offset(Resources.Constraints.attValueTop)
            make.centerX.equalTo(airPressure.snp.centerX)
        }
        
        fiveDaysView.configureView(data: viewModel.weatherData?.list ?? [])
        fiveDaysView.snp.makeConstraints { make in
            make.top.equalTo(humidityValue.snp.bottom)
                .offset(30)
            make.bottom.left.right.equalToSuperview()
        }
        
    }
   
    
    @objc private func searchCity() {
        viewModel.searchCity()
    }
}