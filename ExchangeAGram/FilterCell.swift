//
//  FilterCell.swift
//  ExchangeAGram
//
//  Created by Thomas Grant on 07/07/2015.
//  Copyright (c) 2015 Thomas Grant. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    
    var imageView: UIImageView!
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(imageView)
        
    }
    
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
