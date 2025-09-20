//
//  ContentView.swift
//  POC-API-bibleStudyDiary
//
//  Created by Bruna Veiga Chalegre de Lira on 19/09/25.
//

import SwiftUI

struct ContentView: View {
    
    var service = BibleService()
    @State private var translations: [Versao] = []
    @State private var books: [Book] = []
    @State private var capitulos: Int = 1
    @State private var versos: Int = 1
    @State var updanting: Bool = true
    
    @State var translation: String = "nvi"
    @State var book: String = "Gênesis"
    @State var abbrev: Abbrev = Abbrev(pt: "gn", en: "gn")
    @State var chapter: Int = 1
    @State var versiculo: Int = 1
    @State var texto: String = ""
    
    var body: some View {
        VStack {
            if translations.isEmpty {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Carregando...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onAppear {
                    loadTranslations()
                    loadBooks()
                    getVerse()
//                    getToken()
                }
            } else {
                Spacer()
                
                Picker("Tradução", selection: $translation) {
                    ForEach(translations.indices, id: \.self) { index in
                        Text(translations[index].version).tag(translations[index].version)
                            .font(.headline)
                    }
                }
                .onChange(of: translation) { oldValue, newValue in
                    getVerse()
                }
                
                Picker("Livro", selection: $book) {
                    ForEach(books.indices, id: \.self) { index in
                        Text(books[index].name).tag(books[index].name)
                            .font(.headline)
                    }
                }
                .onChange(of: book) { oldValue, newValue in
                    if let livro = books.first(where: { $0.name == newValue }) {
                        capitulos = livro.chapters
                        abbrev = livro.abbrev
                        chapter = 1
                    }
                    getVerse()
                }
                
                Picker("Capítulo", selection: $chapter) {
                    ForEach(1 ... capitulos, id: \.self) { index in
                        Text(String(index)).tag(index)
                            .font(.headline)
                    }
                }
                .onChange(of: chapter) { oldValue, newValue in
                    service.getChapter(version: translation, abbrev: abbrev.pt, chapter: newValue) { cap, error in
                        if let cap {
                            versos = cap.verses.count
                        }
                    }
                    getVerse()
                }
                
                Picker("Versículo", selection: $versiculo) {
                    ForEach(1 ... versos, id: \.self) { index in
                        Text(String(index)).tag(index)
                            .font(.headline)
                    }
                }
                .onChange(of: versiculo) { oldValue, newValue in
                    getVerse()
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.gray)
                    
                    if updanting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text(texto)
                            .font(.headline)
                            .foregroundStyle(Color.black)
                            .padding()
                            
                    }
                }
                .frame(width: 350, height: 300)
            }
        }
    }
    
    private func getToken() {
        service.getUserToken(email: "bvcl2@cin.ufpe.br", password: "12345") { token, error in
            if let token {
                print("Token:", token)
            }
        }
    }
    
    private func loadTranslations() {
        service.getBibleTranslations { versoes, error in
            if let versoes {
                DispatchQueue.main.async {
                    self.translations = versoes
                }
            }
        }
    }
    
    private func loadBooks() {
        service.getBooks { livros, error in
            if let livros {
                DispatchQueue.main.async {
                    self.books = livros
                }
            }
        }
    }
    
    private func getVerse() {
        service.getVerse(version: translation, abbrev: abbrev.pt, chapter: chapter, number: versiculo) { verse, error in
            if let verse {
                texto = verse.text
                updanting = false
            }
        }
    }
}

#Preview {
    ContentView()
}
