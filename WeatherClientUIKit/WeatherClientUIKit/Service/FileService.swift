//
//  FileService.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 17.02.2025.
//

import Foundation

protocol FileServiceProtocol {
    func save<T: Encodable>(object: T, fileName: String) throws
    func load<T: Decodable>(type: T.Type, fileName: String) throws -> T
}

class FileService: FileServiceProtocol {
    
    let fileManager = FileManager.default
    
    func save<T>(object: T, fileName: String) throws where T : Encodable {
        let filePathUrl = try getDocumentDirectori().appendingPathComponent(fileName)
        let data = try JSONEncoder().encode(object)
        try data.write(to: filePathUrl)
        
    }
    
    func load<T>(type: T.Type, fileName: String) throws -> T where T : Decodable {
        let filePathUrl = try getDocumentDirectori().appendingPathComponent(fileName)
        let data = try Data(contentsOf: filePathUrl)
        let decodeObject = try JSONDecoder().decode(T.self, from: data)
        return decodeObject
    }
    
    private func getDocumentDirectori() throws -> URL {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first!
        
        return documentDirectory
    }
    
    

    
    
}
