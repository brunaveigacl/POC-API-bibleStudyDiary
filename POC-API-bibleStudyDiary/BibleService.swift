//
//  BibleService.swift
//  POC-API-bibleStudyDiary
//
//  Created by Bruna Veiga Chalegre de Lira on 19/09/25.
//
import SwiftUI
import Foundation

class BibleService {
    
    private var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHIiOiJGcmkgU2VwIDE5IDIwMjUgMjA6NDQ6MDQgR01UKzAwMDAuNjhjNDg1ZGYxOWQzMDEwMDI4YjA1ZDE3IiwiaWF0IjoxNzU4MzE0NjQ0fQ.AecWiwHae71AkncdF4VvDxCja_2VDgQwo4occV1NU9U"
    
    /// Obtém um token de autenticação para um usuário.
    ///
    /// Esta função envia uma requisição `PUT` para a API da Bíblia Digital
    /// com as credenciais fornecidas e retorna o token de autenticação do usuário.
    ///
    /// Use esta função para autenticar um usuário e recuperar o `token`
    /// necessário para chamadas subsequentes na API da Bíblia Digital.
    ///
    /// O token é retornado de forma assíncrona através do parâmetro `completion`.
    ///
    /// Caso a autenticação falhe (por exemplo, email/senha inválidos ou problemas
    /// de rede), o `completion` será chamado com `nil` no lugar do token e com
    /// um objeto `Error` descrevendo a falha.
    ///
    /// - Parameters:
    ///   - email: O endereço de email do usuário.
    ///   - password: A senha do usuário.
    ///   - completion: Closure chamada ao final da requisição.
    ///                 - `String?`: O token de autenticação, se disponível.
    ///                 - `Error?`: O erro ocorrido durante a requisição, se houver.
    /// - Note: A função não lança erros diretamente. Os erros são propagados
    ///         apenas via `completion`.
    func getUserToken(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        
        guard let url = URL(string: "https://www.abibliadigital.com.br/api/users/token") else {
            print("URL inválida")
            return
        }
        
        let auth = AuthRequest(email: email, password: password)
        
        guard let jsonData = try? JSONEncoder().encode(auth) else {
            print("Erro ao codificar JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let data else {
                print("Nenhum dado recebido.")
                completion(nil, nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["token"] as? String {
                    print("Token recebido:", token)
                    completion(token, nil)
                } else {
                    print("Resposta inesperada:", String(data: data, encoding: .utf8) ?? "")
                    completion(nil, nil)
                }
            } catch {
                print("Erro ao decodificar JSON:", error.localizedDescription)
                completion(nil, error)
            }
        }.resume()
    }
    
    public func getBibleTranslations(completion: @escaping([Versao]?, Error?) -> Void) {
        
        let urlString = "https://www.abibliadigital.com.br/api/versions"
        
        guard let url = URL(string: urlString) else {
            print ("URL Inválido")
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                return
            }
            guard let data else {
                print("Nenhum dado recebido.")
                return
            }
            
            do {
                let result = try JSONDecoder().decode([Versao].self, from: data)
                completion(result, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
        }
        .resume()
    }
    
    public func getBooks(completion: @escaping([Book]?, Error?) -> Void) {
        
        let urlString = "https://www.abibliadigital.com.br/api/books"
        
        guard let url = URL(string: urlString) else {
            print ("URL Inválido")
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                return
            }
            guard let data else {
                print("Nenhum dado recebido.")
                return
            }
            
            do {
                let result = try JSONDecoder().decode([Book].self, from: data)
                completion(result, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
        }
        .resume()
    }
    
    public func getChapter(version: String, abbrev: String, chapter: Int, completion: @escaping(Capitulo?, Error?) -> Void) {
        
        let urlString = "https://www.abibliadigital.com.br/api/verses/\(version)/\(abbrev)/\(chapter)"
        
        guard let url = URL(string: urlString) else {
            print ("URL Inválido")
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                return
            }
            guard let data else {
                print("Nenhum dado recebido.")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Capitulo.self, from: data)
                completion(result, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
        }
        .resume()
    }
    
    public func getVerse(version: String, abbrev: String, chapter: Int, number: Int, completion: @escaping(Verse?, Error?) -> Void) {
        
        let urlString = "https://www.abibliadigital.com.br/api/verses/\(version)/\(abbrev)/\(chapter)/\(number)"
        
        guard let url = URL(string: urlString) else {
            print ("URL Inválido")
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição:", error.localizedDescription)
                return
            }
            guard let data else {
                print("Nenhum dado recebido.")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Verse.self, from: data)
                completion(result, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
        }
        .resume()
    }
    
}
