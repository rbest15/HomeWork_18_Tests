import Foundation

class WeatherData {
    let api: String
    var weatherData : Weather? = nil
    func getData() {
        var dataTemp = Weather()
        guard let url = URL(string: api) else {
            fatalError()
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                fatalError("Data error")
            }
            guard error == nil else {
                fatalError("\(String(describing: error))")
            }
            do {
                dataTemp = try JSONDecoder().decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData = dataTemp
                    print(dataTemp)
                }
                
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    init(api: String) {
        self.api = api
    }
}




