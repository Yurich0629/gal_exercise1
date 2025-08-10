import UIKit

struct VideoItem {
    let thumbnailName: String
    let avatarName: String
    let title: String
    let dateAndViews: String
    let category: String
    
    init(thumbnailName: String, avatarName: String, title: String, dateAndViews: String, category: String) {
        self.thumbnailName = thumbnailName
        self.avatarName = avatarName
        self.title = title
        self.dateAndViews = dateAndViews
        self.category = category
    }
}
//

