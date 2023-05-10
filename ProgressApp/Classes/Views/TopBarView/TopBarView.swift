//
//  TopBarView.swift
//  ProgressApp
//
//  Created by Aliaksandr on 3.05.23.
//

import UIKit

protocol TopBarViewEventHandler {
    
    func back()
}

final class TopBarView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var eventHandler: TopBarViewEventHandler?
    
    @IBAction func backTapped(_ sender: Any) {
        eventHandler?.back()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TopBarView", owner: self)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func configure(
        title: String,
        isBackButtonHidden: Bool = true,
        eventHandler: TopBarViewEventHandler? = nil
    ) {
        titleLabel.text = title
        backButton.isHidden = isBackButtonHidden
        titleLabel.textAlignment = isBackButtonHidden ? .center : .left
        self.eventHandler = eventHandler
    }
}
