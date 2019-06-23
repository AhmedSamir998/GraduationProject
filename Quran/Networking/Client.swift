//
//  Client.swift
//  Quran
//
//  Created by Eyad Shokry on 3/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class Client: NSObject {
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    class func shared() -> Client {
        struct Singleton {
            static var shared = Client()
        }
        return Singleton.shared
    }
    
    func getDataFromURLUsingCity(city: String, completionHandler: @escaping (_ result: CityDateTimeData?, _ error: NSError?) -> Void) {
        let url = buildURLFromParameters(["city": city], apiScheme: PrayerTimesConstants.APIScheme, apiHost: PrayerTimesConstants.APIHost, apiPath: PrayerTimesConstants.APIPath)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "getDataFromURLUsingCity", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("An error happened with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code other than 2XX!")
                
                return
            }
            
            guard let data = data else {
                sendError("No Data returned from your Request")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(PrayTimesDataCity.self, from: data)
                let results = result.results
                let dateTime = results.datetime
                let times = dateTime[0]
                completionHandler(times, nil)
            } catch let error as NSError {
                sendError("An Error happend while decoding data: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    

    func getDataFromURLUsingLocation(longitude: Double, latitude: Double, elevation: Double, completionHandler: @escaping (_ result: DateTimeData?, _ error: NSError?) -> Void) {
        //let url = URL(string: urlString+userCity)
        let url = buildURLFromParameters(["longitude": String(longitude),
                                          "latitude": String(latitude),
                                          "elevation": String(elevation),
                                          "timeformat": "1",
                                          ], apiScheme: PrayerTimesConstants.APIScheme, apiHost: PrayerTimesConstants.APIHost, apiPath: PrayerTimesConstants.APIPath)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "getDataFromURLUsingLocation", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("An error happened with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code other than 2XX!")
                return
            }
            
            guard let data = data else {
                sendError("No Data returned from your Request")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(PrayTimesDataLocation.self, from: data)
                print(result)
                let results = result.results
                let dateTime = results.datetime
                let times = dateTime[0]
                print("done")
                completionHandler(times, nil)
                } catch let error as NSError {
                    sendError("An Error happend while decoding data: \(error.localizedDescription)")
                }
            
        }.resume()
        
    }
    
    func getDataFromTopicAyatAPI(topic: String, completionHandler: @escaping (_ result: TopicResponse?, _ error: NSError?) -> Void) {
    //    let url = buildURLFromParameters(["query": topic.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!], apiScheme: TopicSearchingConstants.APIScheme, apiHost: TopicSearchingConstants.APIHost, apiPath: TopicSearchingConstants.TopicAPIPath)
        let url = "http://127.0.0.1:5000/api/v1/resources/topic?query=" + topic.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "getDataFromTopicAyatAPI", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("An error happened with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code other than 2XX!")
                
                return
            }
            
            guard let data = data else {
                sendError("No Data returned from your Request")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TopicResponse.self, from: data)
                completionHandler(result, nil)
            } catch let error as NSError {
                sendError("An Error happend while parsing data: \(error)")
            }
            
            }.resume()
    }
    
    
    func getDataFromMostSimilarTopicsAPI(query: String, completionHandler: @escaping(_ result: [SimilarTopicsResponse]?, _ error: NSError?) -> Void) {
        let url = "http://127.0.0.1:5000/api/v1/resources/topics?query=" + query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "getDataFromTopicAyatAPI", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("An error happened with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code other than 2XX!")
                
                return
            }
            
            guard let data = data else {
                sendError("No Data returned from your Request")
                return
            }
            
            do {
                let result = try JSONDecoder().decode([SimilarTopicsResponse].self, from: data)
                completionHandler(result, nil)
            } catch let error as NSError {
                sendError("An Error happend while parsing data: \(error)")
            }
            
            }.resume()

    }
    
    

    private func buildURLFromParameters(_ parameters: [String: String], apiScheme: String, apiHost: String, apiPath: String) -> URL {
        var components = URLComponents()
        components.scheme = apiScheme
        components.host = apiHost
        components.path = apiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value)
            components.queryItems?.append(queryItem)
        }
        print(components.url!)
        return components.url!
    }
    
}


