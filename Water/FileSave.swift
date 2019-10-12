//
//  FileSave.swift
//  Water
//
//  Created by Максим Томилов on 10/10/2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import Foundation

class FileSave{
    private let fileName = "WaterCounter.json"
    private(set) var waterData: [DataWater] = []
    
    init() {
        loadFromFile()
    }
    
    public func addWaterData(newData: DataWater) {
        waterData.append(newData)
        saveToFile()
        loadFromFile()
    }
    
    
    private func saveToFile() {
        if let url = getFileUrl() {
            if waterData.count > 0 {
                let data = try? JSONEncoder().encode(waterData)
                do {
                    if FileManager.default.fileExists(atPath: url.path) {
                        try FileManager.default.removeItem(at: url)
                    }
                    FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
                } catch {
                    print("Ошибка записи в файл, \(error)")
                }
            }
            
        }
    }
    
    private func loadFromFile() {
        
        if let fileUrlValue = getFileUrl() {
            guard let data = FileManager.default.contents(atPath: fileUrlValue.path) else { return }
            do {
                let decodeResult = try JSONDecoder().decode([DataWater].self, from: data)
                waterData.removeAll()
                waterData = decodeResult
            } catch {
                print("Ошибка загрузки данных из файла: \(fileUrlValue)")
            }
        }
    }
    
    private func getFileUrl() -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        var isDir: ObjCBool = false
        let dirUrl = path.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Ошибка создания директории \(error)")
                return nil
            }
        }
        
        let fileUrl = dirUrl
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        return fileUrl
    }
}
