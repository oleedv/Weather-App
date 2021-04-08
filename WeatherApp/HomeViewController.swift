//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Ole Edvard Nørholm on 11/19/20.
//

import UIKit
import Alamofire
import GoogleMaps
import CoreLocation
import GooglePlaces
class HomeViewController: UIViewController {
//MARK:- IB outlets
    @IBOutlet weak var mapView:UIView!
    @IBOutlet weak var weatherView:UIView!
    @IBOutlet weak var mapKitView:GMSMapView!
    @IBOutlet weak var homeView:UIView!
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var textlbl:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var daylbl:UILabel!
    @IBOutlet weak var yourLocationlbl:UILabel!
    
    @IBOutlet weak var mapContentView:UIView!
    @IBOutlet weak var weatherContentView:UIView!
    @IBOutlet weak var homeContenView:UIView!
    
    @IBOutlet weak var headerLabel:UILabel!
    //MARK:- Vairables
    var weatherData = [WeatherData]()
    var unitDictionary: NSDictionary?
    var showCordinatesFlag = false
    var showLongitudeVal: String?
    var showLatitudeVal: String?
    var locationManager = CLLocationManager()
    var MainWeatherData = [WeatherData]()
    var LocationCordinate:CLLocationCoordinate2D?
    var isCurrentLocation = false
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        getdata(lat: "59.911166", long: "10.744810", completion: {_ in
            self.MainWeatherData = self.weatherData
            self.tableView.reloadData()
        })
        startUpdatingLocation()
    }
    func startUpdatingLocation(){
    
           locationManager.delegate = self
           locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
           locationManager.startUpdatingLocation()
    }
    func setupUI(){
        let mapVieww = UITapGestureRecognizer(target: self, action: #selector(showMapView))
        self.mapView.isUserInteractionEnabled = true
        self.mapView.addGestureRecognizer(mapVieww)
        
        let homeVieww = UITapGestureRecognizer(target: self, action: #selector(showHomeView))
        self.homeView.isUserInteractionEnabled = true
        self.homeView.addGestureRecognizer(homeVieww)
        
        let weatherVieww = UITapGestureRecognizer(target: self, action: #selector(showWeatherView))
        self.weatherView.isUserInteractionEnabled = true
        self.weatherView.addGestureRecognizer(weatherVieww)
    }
    func updateuI(){
        
        let data = weatherData[0]
        let date = toString(date: Date())
        daylbl.text = date
        
        if data.next_6_symbol_code == "cloudy" {
            self.imgView.image = UIImage(named: "cloudy")
            textlbl.text = "cloudy Weather"
            
        }else if data.next_6_symbol_code == "partlycloudy_day" || data.next_12_symbol_code == "partlycloudy_day" {
            self.imgView.image = UIImage(named: "partly_cloud")
            textlbl.text = "Partly Cloudy Weather"
            
        }else if data.next_6_symbol_code == "rain" || data.next_12_symbol_code == "rain" {
            self.imgView.image = UIImage(named: "umberalla_icon")
            textlbl.text = "Bring an umbrella, Today it's rainy day!"
            
        }else if data.next_6_symbol_code == "clearsky_day" || data.next_12_symbol_code == "clearsky_day" {
            self.imgView.image = UIImage(named: "clear_sky")
            textlbl.text = "Sun today, no umbrella :) "
            //mainView.backgroundColor = UIColor.yellow.withAlphaComponent(0.1)
            
        }else if data.next_6_symbol_code == "lightrain" || data.next_12_symbol_code == "lightrain" {
            self.imgView.image = UIImage(named: "umberalla_icon")
            textlbl.text = "Bring an umbrella today, it will rain!"
            
        }else if data.next_6_symbol_code == "cloudy" || data.next_12_symbol_code == "cloudy"{
            self.imgView.image = UIImage(named: "cloudy")
            textlbl.text = "Cloudy"
        }else if data.next_6_symbol_code == "partlycloudy_night" || data.next_12_symbol_code == "partlycloudy_night"{
            self.imgView.image = UIImage(named: "cloudy")
            textlbl.text = "Cloudy"
        }
        else if data.next_6_symbol_code == "clearsky_night" || data.next_12_symbol_code == "clearsky_night"{
            self.imgView.image = UIImage(named: "clearSky")
            textlbl.text = "Clear Sky night"
        }
        else if data.next_6_symbol_code == "fog" || data.next_12_symbol_code == "fog"{
            self.imgView.image = UIImage(named: "fog")
            textlbl.text = "Fog"
        }else {
            textlbl.text = "Error, cant get weather data"
        }
    
    }
    func toString(date:Date)->String{
        let formmatter = DateFormatter()
        formmatter.dateFormat = "EEEE"
        let str = formmatter.string(from: date)
        return str
    }
    //MARK:- Methods
    @objc func showMapView(){
        homeContenView.isHidden = true
        mapContentView.isHidden = false
        weatherContentView.isHidden = true
        isCurrentLocation = true
    }
    
    @objc func showHomeView(){
        homeContenView.isHidden = false
        mapContentView.isHidden = true
        weatherContentView.isHidden = true
    }
    @objc func showWeatherView(){
        homeContenView.isHidden = true
        mapContentView.isHidden = true
        weatherContentView.isHidden = false
        if isCurrentLocation {
        getdata(lat: showLatitudeVal ?? "" , long: showLongitudeVal ?? "" , completion:  {_ in
            self.MainWeatherData.removeAll()
            self.MainWeatherData = self.weatherData
            self.yourLocationlbl.isHidden  = false
            self.yourLocationlbl.text = "Your location: \(self.showLatitudeVal ?? "") \(self.showLongitudeVal ?? "" )"
            self.tableView.reloadData()
        })
        }
    }
    private func getdata(lat:String,long:String, completion: @escaping (Bool) -> Void){
        //        let json: [String: Any] = ["lat":lat, "lon":long]
        weatherData.removeAll()
        let url: String  =  "\(appurl!)" + "lat=\(lat)&lon=\(long)"
        
        Util.customActivityIndicatory(self.view, startAnimate: true)
        Alamofire.request(url,method:.get).responseJSON { response in
            
            Util.customActivityIndicatory(self.view, startAnimate: false)
            
            if response.error != nil {
                print(response.description )
            }
            
            if  let value = response.result.value as? NSDictionary{
                
                if let propertiesDict = value["properties"] as?  NSDictionary {
                    var air_pressure_at_sea_levelUnit = ""
                    var air_temperatureUnit = ""
                    var cloud_area_fractionUnit = ""
                    var precipitation_amountUnit = ""
                    var relative_humidityUnit = ""
                    var wind_from_directionUnit = ""
                    var wind_speedUnit = ""
                    
                    if let metaDict = propertiesDict["meta"] as? NSDictionary {
                        
                        if let unitDict = metaDict["units"] as? NSDictionary {
                            air_pressure_at_sea_levelUnit = unitDict["air_pressure_at_sea_level"] as! String
                            air_temperatureUnit = unitDict["air_temperature"] as! String
                            cloud_area_fractionUnit = unitDict["cloud_area_fraction"] as! String
                            relative_humidityUnit = unitDict["relative_humidity"] as! String
                            precipitation_amountUnit = unitDict["precipitation_amount"] as! String
                            wind_from_directionUnit = unitDict["wind_from_direction"] as! String
                            wind_speedUnit = unitDict["wind_speed"] as! String
                            self.unitDictionary = unitDict
                        }
                    }
                    
                    if let timeseriesDict = propertiesDict["timeseries"] as?  NSArray {
                        var next_12_symbol_code = ""
                        var next_6_symbol_code = ""
                        var next_1_symbol_code = ""
                        let next_12_precipitation_amount:Double = 0
                        var next_1_precipitation_amount:Double = 0
                        var next_6_precipitation_amount:Double = 0
                        let dataDict = timeseriesDict[0] as? NSDictionary
                        
                        if let dataDictt = dataDict?["data"] as? NSDictionary{
                            
                            if let instantDict = dataDictt["instant"] as? NSDictionary{
                                self.weatherData.removeAll()
                                
                                if let detailsdict = instantDict["details"] as? NSDictionary{
                                    print(detailsdict)
                                    let air_pressure_at_sea_level = detailsdict["air_pressure_at_sea_level"] as? Double
                                    let air_temperature = detailsdict["air_temperature"] as? Double
                                    let cloud_area_fraction = detailsdict["cloud_area_fraction"] as? Double
                                    let relative_humidity = detailsdict["relative_humidity"] as? Double
                                    let wind_from_direction = detailsdict["wind_from_direction"] as? Double
                                    let wind_speed = detailsdict["wind_speed"] as? Double
                                    
                                    if let next_12_hoursDict = dataDictt["next_12_hours"] as? NSDictionary{
                                        let summary = next_12_hoursDict["summary"] as? NSDictionary
                                        next_12_symbol_code = summary?["symbol_code"] as! String
                                        
                                    }
                                    
                                    if let next_1_hoursDict = dataDictt["next_1_hours"] as? NSDictionary{
                                        let summary = next_1_hoursDict["summary"] as? NSDictionary
                                        next_1_symbol_code = summary?["symbol_code"] as! String
                                        
                                        
                                        let details = next_1_hoursDict["details"] as? NSDictionary
                                        next_1_precipitation_amount = details?["precipitation_amount"] as! Double
                                        
                                    }
                                    
                                    if let next_6_hours = dataDictt["next_6_hours"] as? NSDictionary{
                                        let summary = next_6_hours["summary"] as? NSDictionary
                                        next_6_symbol_code = summary?["symbol_code"] as! String
                                        
                                        
                                        let details = next_6_hours["details"] as? NSDictionary
                                        next_6_precipitation_amount = details?["precipitation_amount"] as! Double
                                        
                                    }
                                    let data = WeatherData(air_pressure_at_sea_level: air_pressure_at_sea_level ?? 0, air_temperature: air_temperature ?? 0 , cloud_area_fraction: cloud_area_fraction ?? 0 , relative_humidity: relative_humidity ?? 0, wind_from_direction: wind_from_direction ?? 0, wind_speed: wind_speed ?? 0, next_1_symbol_code: next_1_symbol_code, next_12_symbol_code: next_12_symbol_code, next_6_symbol_code:  next_6_symbol_code, next_12_precipitation_amount: next_12_precipitation_amount, next_1_precipitation_amount: next_1_precipitation_amount, next_6_precipitation_amount: next_6_precipitation_amount,air_pressure_at_sea_levelUnit: air_pressure_at_sea_levelUnit, air_temperatureUnit: air_temperatureUnit, cloud_area_fractionUnit: cloud_area_fractionUnit, precipitation_amountUnit: precipitation_amountUnit, relative_humidityUnit: relative_humidityUnit, wind_from_directionUnit: wind_from_directionUnit, wind_speedUnit: wind_speedUnit)
                                    self.weatherData.append(data)
                                }
                            }
                            
                        }
                        DispatchQueue.main.async {
                            completion(true)
                          //  self.updateuI()
                        }
                    }
                    
                }
                
            }
        }
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! weatherCell
        let data = MainWeatherData[indexPath.row]
        
       cell.label3 .text = "\(Int((data.air_temperature ?? 0 ).rounded(toPlaces: 0)))  \(data.air_temperatureUnit)"
        cell.symbolCode .text = "\(data.next_1_symbol_code ?? "")"
        cell.symbolCode1 .text = "\(data.next_6_symbol_code ?? "")"
        cell.symbolCode2 .text = "\(data.next_12_symbol_code ?? "")"
        cell.amount_max.text = "\(String(describing: Int(data.next_1_precipitation_amount ?? 0))) \(unitDictionary?.value(forKey: "precipitation_amount") ?? " ")"
        cell.amount_max1.text = "\(String(describing: Int(data.next_6_precipitation_amount ?? 0))) \(unitDictionary?.value(forKey: "precipitation_amount") ?? " ")"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
}
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
//MARK:- CLLocation Manager Delegate
extension HomeViewController: CLLocationManagerDelegate {

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

            let location = locationManager.location?.coordinate
            print(location as Any)

            cameraMoveToLocation(toLocation: location)

        }
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            let camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 16)
            mapKitView.camera = camera
            mapKitView.isMyLocationEnabled = true
            mapKitView.settings.compassButton = true
            mapKitView.settings.myLocationButton = true
            mapKitView.padding = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
            let marker = GMSMarker()
            marker.isDraggable = true
            marker.map = mapKitView
           showLatitudeVal = "\(toLocation!.latitude)"
          showLongitudeVal = "\(toLocation!.longitude)"
            getdata(lat: "\(toLocation!.latitude)", long: "\(toLocation!.longitude)", completion: {_ in
                self.updateuI()

            })
          
           // navigationController?.popViewController(animated: true)
        }


    }
}
