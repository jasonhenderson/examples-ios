//
//  SearchHistoryTableViewCell.swift
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//
import UIKit

@objc(SearchHistoryTableViewCell)
class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var data: [String:Any?]!
    
    // Static and lazy load the formatter...big overhead with constructing formatters
    private static var dateFormatter: DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "M/dd/yyyy h:mm a"
        _dateFormatter.locale = Locale.init(identifier: "en_US")
        return _dateFormatter
    }()
    
    /// We call this function once all the data is assigned, and bind the data to the cell views
    func bind() {
        searchTextLabel.text = self.data?["searchText"] as! String?
        dateLabel.text = SearchHistoryTableViewCell.dateFormatter.string(from: (self.data?["date"] as! Date?)!)
    }
}
