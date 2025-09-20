//
//  Autenticacao.swift
//  POC-API-bibleStudyDiary
//
//  Created by Bruna Veiga Chalegre de Lira on 19/09/25.
//
import Foundation
import SwiftUI

struct User: Codable {
    let name: String
    let email: String
    let password: String
    let notifications: Bool
}

struct UserResponse: Codable {
    let name: String
    let email: String
    let token: String
    let notifications: Bool
}

class Autenticacao {
    static let signUpURL = "https://www.abibliadigital.com.br/api/users"
    
    static func createUser(
        nome: String,
        email: String,
        senha: String,
        notificacoes: Bool,
        completion: @escaping (String?, Error?) -> Void
    ){
        guard let url = URL(string: signUpURL) else {
            print("URL inválida")
            return
        }
        
        let user = User(name: nome, email: email, password: senha, notifications: notificacoes)
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            print("erro ao codificar JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")  // aceita receber formato JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")  // ninha requisicao esta em formato JSON
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Erro na requisição", error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let data else {
                print("Nenhum dado recebido.")
                completion(nil, nil)
                return
            }
            
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                print("Usuário criado com sucesso! Token:", userResponse.token)
                completion(userResponse.token, nil)
            } catch {
                print("Erro ao decodificar JSON:", error.localizedDescription)
                completion(nil, error)
            }
            
        }.resume()
    }
}
