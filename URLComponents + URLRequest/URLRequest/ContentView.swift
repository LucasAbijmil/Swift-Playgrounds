//
//  ContentView.swift
//  URLRequest
//
//  Created by Lucas Abijmil on 29/08/2020.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Text("Hello, world!")
        .padding()
    }
    .onAppear {
      let url = try? generateURL()
      guard let bis = url else { return }
      callApi(with: bis)
      let postURl = try? postURL()
      guard let purl = postURl else { return }
      postApi(with: purl)
    }
  }
  func generateURL() throws -> URL {
    // Création d'une URL solid via URLComponents
    var components = URLComponents()
    // scheme
    components.scheme = "https"
    // "site"
    components.host = "jsonplaceholder.typicode.com"
    // "chemin"
    components.path = "/users"

    // Check en cas d'erreur
    guard let url = components.url else {
      throw URLError.uknwown("")
    }

    return url
  }

  func postURL() throws -> URL {
    // Création d'une URL solid via URLComponents
    var components = URLComponents()
    // scheme
    components.scheme = "https"
    // "site"
    components.host = "jsonplaceholder.typicode.com"
    // chemin
    components.path = "/posts"

    guard let url = components.url else {
      throw URLError.uknwown("")
    }

    return url
  }

  func callApi(with url: URL) {
    // si méthode get pas nécessaire de faire une URLRequest
    URLSession.shared.dataTask(with: url) { data, response, error in
      print(url)
      if let response = response {
        print(response)
      }

      if let error = error {
        print(error)
      }

      if let data = data {
        print(data)
        do {
          // convertion : bytes --> JSON format pas de parsing en format interne app
          let json = try JSONSerialization.jsonObject(with: data, options: [])
          print(json)
        } catch {
          print(error.localizedDescription)
        }
      }
    }
    // ne pas oublie de resume la dataTask
    .resume()
  }

  func postApi(with url: URL) {

    // dictionnaire qui contient les informations nécessaires envoyé au serveur
    let paramaters = ["username": "lucasAbijmil", "tweet" : "je suis le meilleur dév iOS de France"]

    // convertion : dictionnaire ––> JSONFormat
    guard let httpBody = try? JSONSerialization.data(withJSONObject: paramaters, options: []) else { return }

    // création de l'URLRequest
    var request = URLRequest(url: url)
    // On pourrai faire une URLRequest pour la méthode GET mais pas obligatoire
    request.httpMethod = "POST"
    // on fournit les data (JSON)
    request.httpBody = httpBody
    // permet générer un JSON interprétable pour l'API
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    print(url)
    print(request)




    URLSession.shared.dataTask(with: request) { data, response, error in

      if let response = response {
        print(response)
      }

      if let data = data {
        print(data)
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: [])
          print(json)
        } catch {
          print(error.localizedDescription)
        }
      }


      if let error = error {
        print(error)
      }
    }
    // ne pas oublie de resume la dataTask
    .resume()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


enum URLError: Error {
  case uknwown(String)
}
