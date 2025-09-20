//
//  versiculo.swift
//  POC-API-bibleStudyDiary
//
//  Created by Bruna Veiga Chalegre de Lira on 19/09/25.
//
import Foundation

struct Versiculo: Codable {
    var traducao: String
    var livro: String
    var capítulo: Int
    var versiculo: Int
    var texto: String
}

struct Versao: Codable {
    var version: String
    var verses: Int
}

struct AuthRequest: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    var name: String
    var email: String
    var token: String
}

struct Book: Codable {
    var abbrev: Abbrev
    var author: String
    var chapters: Int
    var group: String
    var name: String
    var testament: String
}

struct Book2: Codable {
    var abbrev: Abbrev
    var name: String
    var author: String
    var group: String
    var version: String
}

struct Abbrev: Codable {
    let pt: String
    let en: String
}

struct Chapter: Codable {
    let number: Int
    let verses: Int
}

struct Verse2: Codable {
    let number: Int
    let text: String
}

struct Capitulo: Codable {
    let book: Book2
    let chapter: Chapter
    let verses: [Verse2]
}

struct Verse: Codable {
    var book: Book2
    var chapter: Int
    var number: Int
    var text: String
}
