//
//  AppDetailController.swift
//  appstore
//
//  Created by Paul Dong on 14/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let headerId = "headerId"
    private let screenshotsCellId = "cellId"
    private let descCellId = "descCellId"
    
    var app: App? {
        didSet {
            navigationItem.title = "Detail"
            
            if app?.screenshots != nil {
                return
            }
            
            if let id = app?.id {
                let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
                
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let err = error {
                            print("******** error ********")
                            print(err)
                            return
                        }
                        
                        do {
                            if let unwrappedData = data {
                                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as! [String: AnyObject]
                                
                                let appDetail = App()
                                appDetail.setValuesForKeys(json)
                                self.app = appDetail
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                                
                            }
                            
                        } catch let err {
                            print(err)
                        }
                    }.resume()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: screenshotsCellId)
        
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descCellId)
        collectionView?.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return CGSize(width: view.frame.width, height: 150)
        case 1:
            let dummySize = CGSize(width: view.frame.width - 16, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributeText().boundingRect(with: dummySize, options: options, context: nil)
            return CGSize(width: view.frame.width, height: rect.height + 30)
        default:
            return CGSize()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.item {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descCellId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributeText()
            return cell
        case 2:
            return UICollectionViewCell()
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenshotsCellId, for: indexPath) as! ScreenshotsCell
            
            cell.app = self.app
            return cell
        }
    }
    
    private func descriptionAttributeText() -> NSAttributedString {
        let attributeText = NSMutableAttributedString(string: "Description", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributeText.string.characters.count)
        attributeText.setAttributes([NSParagraphStyleAttributeName : style], range: range)
        
        if let desc = app?.desc {
            attributeText.append(NSAttributedString(string: "\n"))
            attributeText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName : UIColor.darkGray]))
        }
        
        return attributeText
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
}

class AppDetailHeader: BaseCell {
    
    var app: App? {
        didSet {
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            
            if let name = app?.name {
                nameLabel.text = name
                nameLabel.frame = CGRect(x: 128, y: 14, width: frame.width, height: 40)
                nameLabel.sizeToFit()
            }
            
            if let price = app?.price?.stringValue {
                buyButton.setTitle("$\(price)", for: .normal)
            }else{
                buyButton.setTitle("Get", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = UIColor.gray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.layer.borderColor = UIColor.rgb(red: 0, green: 129, blue: 250).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        addConstraints(format: "H:|-14-[v0(100)]-14-[v1]-14-|", views: imageView, nameLabel)
        addConstraints(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraints(format: "H:[v0(60)]-14-|", views: buyButton)
        addConstraints(format: "H:|-2-[v0]-2-|", views: dividerLineView)
        
        addConstraints(format: "V:|-14-[v0(40)]", views: nameLabel)
        addConstraints(format: "V:[v0(32)]-56-|", views: buyButton)
        addConstraints(format: "V:|-14-[v0(100)]-14-[v1(34)]-8-[v2(1)]", views: imageView, segmentedControl, dividerLineView)
    }
}

class AppDetailDescriptionCell: BaseCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "sample"
        return tv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        addSubview(dividerLineView)
        
        addConstraints(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraints(format: "H:|-4-[v0]-4-|", views: dividerLineView)
        addConstraints(format: "V:|-4-[v0]-4-[v1(1)]-4-|", views: textView, dividerLineView)
        
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
    }
    
}
