import Foundation
import Alamofire

typealias WebServiceResponse = ([[String: Any]], Error) -> Void

class GeoDBCitiesClient {
    let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?namePrefix=les"
    let url = URL(string: urlString)
    
    func fetchCities(by subString: String, completion: WebServiceResponse {
        Alamofire.request("", parameters: [:])
    }
}

let client = GeoDBCitiesClient()

let comlpetionHandler: WebServiceResponse = { WebServiceResponse in
    print("Start")
    return
}

client.fetchCities(by: "les", completion: comlpetionHandler)
