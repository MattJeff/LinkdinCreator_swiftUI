//
//  VideoViewModel.swift
//  LinkdinCreator
//
//  Created by Mathis Higuinen on 07/09/2023.
//

import Foundation

class VideoViewModel: ObservableObject {
    
    @Published var videoData: VideoData?
    @Published var isFetching: Bool = false
    @Published var error: String?

    func fetchVideoData(from youtubeURL: String) {
        // L'URL de votre API Python
        guard let apiURL = URL(string: "http://127.0.0.1:5000/transcribe") else {
            self.error = "URL invalide."
            return
        }

        self.isFetching = true

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        let body = ["url": youtubeURL]
        request.httpBody = try? JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 600 // 10 minutes
        let session = URLSession(configuration: configuration)


        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isFetching = false
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.error = "Erreur du serveur : \(httpResponse.statusCode)"
                    }
                    return
                }
            }


            if let error = error {
                DispatchQueue.main.async {
                    self.error = "Erreur lors de la requête : \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data {
                // Convertir les données en chaîne et les afficher
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON reçu: \(jsonString)")
                }
                
                do {
                    let videoData = try JSONDecoder().decode(VideoData.self, from: data)
                    DispatchQueue.main.async {
                        self.videoData = videoData
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error = "Erreur lors de la décodage de données : \(error.localizedDescription)"
                    }
                }
            }


        }

        task.resume()
    }
}
