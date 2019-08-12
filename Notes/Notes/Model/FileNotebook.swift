import Foundation

class FileNotebook {
    // модификатор доступа
    public private(set) var notes : [String: Note] = [:]
    
    init(notes: [String: Note]) {
        self.notes = notes
    }
    
    // новая заметка
    public func add(_ note: Note){
        
        // проверка на уникальность
        if notes[note.uid] == nil {
            notes.updateValue(note, forKey: note.uid)
        }
        
    }
    
    // удаление заметки
    public func remove(with uid: String){
        if notes[uid] == nil {
            notes.removeValue(forKey: uid)
        }
    }
    
    // сохранение записной книжки в файл
    public func saveToFile(){
        let dirurl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        var isDir: ObjCBool = false
        
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), isDir.boolValue {
            var notesJSON = [String:Any]()
            for note in notes{
                notesJSON.updateValue(note.value.json, forKey: note.key)
            }
            do {
                let filename = dirurl.appendingPathComponent("MyNotebook.json")
                let data = try JSONSerialization.data(withJSONObject: notesJSON, options: [])
                FileManager.default.createFile(atPath: filename.absoluteString, contents: data, attributes: nil)
                
            } catch {print("error")}
            
        }
        
    }
    
    // загрузка записной книжки из файла
    public func loadFromFile(){
        let dirurl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        var isDir: ObjCBool = false
        
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), isDir.boolValue {
            do {
                let filename = dirurl.appendingPathComponent("MyNotebook.json")
                let data = FileManager.default.contents(atPath: filename.absoluteString)
                if let data = data {
                    let jsdict = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    notes.removeAll()
                    for note in jsdict{
                        let value = note.value as! Note
                        notes.updateValue(value, forKey: note.key)
                    }
                }
                
            } catch {print("error")}
        }
    }
}
