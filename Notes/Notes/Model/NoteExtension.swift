import Foundation

extension Note{
    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json["uid"] as? String else {
            return nil
        }
        
        guard let title = json["title"] as? String else{
            return nil
        }
        
        guard let content = json["content"] as? String else{
            return nil
        }
        
        var color:UIColor = .white
        if json["color"] != nil {
            let clr = json["color"] as! [CGFloat]
            color = UIColor(red: clr[0], green: clr[1], blue: clr[2], alpha: clr[3])
        }
        
        var importance:Importance = .normal
        if let imp = json["importance"] as? String {
            if imp == "important"{
                importance = .important
            }
            else if imp == "unimportant"{
                importance = .unimportant
            }
        }
        
        var date:Date? = nil
        if let seconds = json["selfDestructionDate"] as? Double{
            date = Date(timeIntervalSince1970: seconds)
        }
        
        let note = Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructionDate: date)
        
        return note
    }
    
    var json: [String: Any] {
        get {
            var note = [String:Any]()
            note.updateValue(uid, forKey: "uid")
            note.updateValue(content, forKey: "content")
            note.updateValue(title, forKey: "title")
            if color != .white {
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                let rgba = [red,green,blue,alpha]
                
                note.updateValue(rgba, forKey: "color")
            }
            if let date = selfDestructionDate {
                note.updateValue(date.timeIntervalSince1970, forKey: "selfDestructionDate")
            }
            if importance != .normal {
                note.updateValue(importance.rawValue, forKey: "importance")
            }
            return note
        }
    }
}
