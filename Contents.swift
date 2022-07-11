//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        var imageView = UIImageView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        
        let size = CGSize(width: 300, height: 300)
        let image = UIImage(named: "wallpaper01.jpg")?.cropImage(toGivenSize: size)
        imageView = UIImageView(image: image)
        self.view.addSubview(imageView)
        
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

 extension UIImage {
    func cropImage(toGivenSize: CGSize) -> UIImage {
    
        guard let cgImage = self.cgImage else { return self }
        
        let contextOriginalImage = UIImage(cgImage: cgImage)
        
        guard let newlyCGImage = contextOriginalImage.cgImage else {
            return self
        }
        
        let contextImageSize: CGSize = contextOriginalImage.size
        
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = toGivenSize.width / toGivenSize.height
        
        var cropWidth: CGFloat = toGivenSize.width
        var cropHeight: CGFloat = toGivenSize.height
        
        if toGivenSize.width > toGivenSize.height{ //landiscape
            cropWidth = contextImageSize.width
            cropHeight = contextImageSize.width / cropAspect
            posY = (contextImageSize.height - cropHeight)/2
        }
        else if (toGivenSize.width < toGivenSize.height){
            cropHeight = contextImageSize.height
            cropWidth = contextImageSize.height * cropAspect
            posX = (contextImageSize.width - cropWidth) / 2
        }
        else{ //square
            if contextImageSize.width >= contextImageSize.height { //Square on landscape (or square)
                        cropHeight = contextImageSize.height
                        cropWidth = contextImageSize.height * cropAspect
                        posX = (contextImageSize.width - cropWidth) / 2
                    }else{ //Square on portrait
                        cropWidth = contextImageSize.width
                        cropHeight = contextImageSize.width / cropAspect
                        posY = (contextImageSize.height - cropHeight) / 2
                    }
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newlyCGImage.cropping(to: rect) else {
            return self
        }
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        UIGraphicsBeginImageContextWithOptions(toGivenSize, false, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: toGivenSize.width, height: toGivenSize.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

        return resized ?? self
    }
}
