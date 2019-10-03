//
//  DepositionPointAnnotationView.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import MapKit

class DepositionPointAnnotationView: MKAnnotationView {
    private let boxInset: CGFloat = 10
//    private let interItemSpacing = CGFloat(10)
//    private let maxContentWidth = CGFloat(90)
    private let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [label, imageView])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .top
//        stackView.spacing = interItemSpacing
//
//        return stackView
//    }()
//
//    lazy var label: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.textColor = UIColor.white
//        label.lineBreakMode = .byWordWrapping
//        label.backgroundColor = UIColor.clear
//        label.numberOfLines = 2
//        label.font = UIFont.preferredFont(forTextStyle: .caption1)
//
//        return label
//    }()
        
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        // Anchor the top and leading edge of the stack view to let it grow to the content size.
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
        // Limit how much the content is allowed to grow.
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        label.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        clusteringIdentifier = DepositionPointAnnotationView.defaultReuseIdentifier
        displayPriority = .defaultLow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
//        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // The stack view will not have a size until a `layoutSubviews()` pass is completed. As this view's overall size is the size
        // of the stack view plus a border area, the layout system needs to know that this layout pass has invalidated this view's
        // `intrinsicContentSize`.
//        invalidateIntrinsicContentSize()
//
//        // The annotation view's center is at the annotation's coordinate. For this annotation view, offset the center so that the
//        // drawn arrow point is the annotation's coordinate.
//        let contentSize = intrinsicContentSize
//        centerOffset = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
        
        // Now that the view has a new size, the border needs to be redrawn at the new size.
//        setNeedsDisplay()
    }
    
//    override var intrinsicContentSize: CGSize {
//        var size = imageView.bounds.size
//        size.width += contentInsets.left + contentInsets.right
//        size.height += contentInsets.top + contentInsets.bottom
//        return size
//    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        // Used to draw the rounded background box and pointer.
//        UIColor.darkGray.setFill()
//
//        // Draw the pointed shape.
//        let pointShape = UIBezierPath()
//        pointShape.move(to: CGPoint(x: 14, y: 0))
//        pointShape.addLine(to: CGPoint.zero)
//        pointShape.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
//        pointShape.fill()
//
//        // Draw the rounded box.
//        let box = CGRect(x: boxInset, y: 0, width: rect.size.width - boxInset, height: rect.size.height)
//        let roundedRect = UIBezierPath(roundedRect: box, cornerRadius: 5)
//        roundedRect.lineWidth = 2
//        roundedRect.fill()
//    }
}

