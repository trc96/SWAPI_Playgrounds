import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        //1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        print(finalURL)
        //Contact the server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //Handle errors
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            //Check for data
            guard let data = data else {return}
            
            //Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person?.self, from: data)
                return completion(person)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        //Contact Server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            //Handle Error
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            //Check for data
            guard let data = data else {return}
            
            do {
                let film = try JSONDecoder().decode(Film?.self, from: data)
                return completion(film)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
}

SwapiService.fetchPerson(id: 2) { (person) in
    if let person = person {
        print(person.name)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
        }
    }
}
