//
//  ViewController.swift
//  EmojiScene
//
//  Created by Dumitru Gutu on 12/16/17.
//  Copyright © 2017 Dumitru Gutu. All rights reserved.
//

import UIKit

class EmojiSceneViewController: UIViewController, UIScrollViewDelegate {
    
    var imageFetcher: ImageFetcher!
    var emojiSceneView = EmojiSceneView()
    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiSceneView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiSceneView
    }
    
    var emojiSceneBackgroundImage: UIImage? {
        get {
            return emojiSceneView.backgroundImage
        }
        set {
            scrollView?.zoomScale = 1.0
            emojiSceneView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            emojiSceneView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
            }
        }
    }
}

//MARK: - UI Drop Interaction Delegate
extension EmojiSceneViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiSceneBackgroundImage = image
            }
            
        }
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        }
    }
    
}

