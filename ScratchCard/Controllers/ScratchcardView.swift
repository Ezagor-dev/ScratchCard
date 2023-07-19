import UIKit

class ScratchcardView: UIView {
    
    private let images: [UIImage] = [
        UIImage(named: "prize_10000")!,
        UIImage(named: "prize_5000")!,
        UIImage(named: "prize_2000")!,
        UIImage(named: "prize_1000")!,
        UIImage(named: "no_prize")!
    ]
    private var playAgainHandler: (() -> Void)?
    private let prizes: [Int] = [10000, 5000, 2000, 1000, 0]
    private let probabilities: [Int] = [
        2, 3, 5, 50, 40
    ]
    private let scratchWidth: CGFloat = 30.0
    private var revealedPercentage: CGFloat = 0.0
    private var backgroundImage: UIImageView!
    private var foregroundImageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        isUserInteractionEnabled = true
        
        // Find the index of the desired prize image
        let prizeIndex = prizes.firstIndex(where: { $0 == 5000 || $0 == 2000 || $0 == 1000 || $0 == 0 }) ?? (prizes.count - 1)
        print("setupUI prizeIndex: \(prizeIndex)")
        // Add background image (prize image)
        let backgroundImage = UIImageView(image: images[prizeIndex])
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = bounds
        addSubview(backgroundImage)
        
        // Add foreground image (hexagram)
        let foregroundImageView = UIImageView(image: UIImage(named: "hexagram"))
        foregroundImageView.contentMode = .scaleAspectFill
        foregroundImageView.frame = bounds
        addSubview(foregroundImageView)
        
        let scratchGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleScratch(_:)))
        addGestureRecognizer(scratchGestureRecognizer)
    }

    
    private var isScratching = false
    private var scratchedPoints = Set<CGPoint>()
    private var totalArea: CGFloat {
        return bounds.width * bounds.height
    }
    
    @objc private func handleScratch(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start scratching
            isScratching = true
            scratchedPoints.removeAll()
            
        case .changed:
            
                let point = recognizer.location(in: self)
                let convertedPoint = convert(point, to: self)
                scratchedPoints.insert(convertedPoint)
                revealedPercentage = calculateRevealedPercentage()
                
                // Update the foreground image's alpha based on the revealed percentage
                if let foregroundImageView = foregroundImageView {
                    foregroundImageView.alpha = 1.0 - revealedPercentage*100
                }
                
                // Print the revealed percentage
                print("Revealed Percentage: \(revealedPercentage * 100)%")
                
                // Check if the revealed percentage exceeds 80%
                if revealedPercentage >= 0.8 {
                    recognizer.isEnabled = false
                    // Call revealImage to display the final result
                    revealImage()
                }
            
            
        case .ended, .cancelled:
            isScratching = false
            
        default:
            break
        }
    }




    private func resetScratchcard() {
        // Remove the revealed image and foreground image
        subviews.forEach { $0.removeFromSuperview() }
        
        // Add the background image (prize image)
        let prizeIndex = prizes.firstIndex(where: { $0 == 5000 || $0 == 2000 || $0 == 1000 || $0 == 0 }) ?? (prizes.count - 1)
        let image = images[prizeIndex]
        backgroundImage = UIImageView(image: image)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = bounds
        addSubview(backgroundImage)
        
        // Add the foreground image (hexagram)
        foregroundImageView = UIImageView(image: UIImage(named: "hexagram"))
        foregroundImageView.contentMode = .scaleAspectFill
        foregroundImageView.frame = bounds
        addSubview(foregroundImageView)
        
        // Reset the scratched points and revealed percentage
        scratchedPoints.removeAll()
        revealedPercentage = 0.0
    }

    
    private func calculateRevealedPercentage() -> CGFloat {
        let revealedArea = calculateRevealedArea()
        return min(revealedArea / totalArea, 1.0)
    }

    private func calculateRevealedArea() -> CGFloat {
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = CGFloat.leastNormalMagnitude
        var maxY = CGFloat.leastNormalMagnitude
        
        for point in scratchedPoints {
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }
        
        let width = maxX - minX
        let height = maxY - minY
        
        return width * height
    }

    
    
    
    private func revealImage() {
        let revealedPercentage = calculateRevealedPercentage()
        
        if revealedPercentage >= 0.008 {
            let randomIndex = weightedRandomIndex(with: probabilities)
            let imageIndex = prizes[randomIndex] == 0 ? images.count - 1 : randomIndex
            let image = images[imageIndex]
            let prize = prizes[randomIndex]
            
            // Remove the foreground image if it exists
            foregroundImageView?.removeFromSuperview()
            
            // Create a new image view for the revealed image (prize image)
            let revealedImageView = UIImageView(frame: bounds)
            revealedImageView.image = image
            addSubview(revealedImageView)
            
            // Set the alpha value of the revealed image
            revealedImageView.alpha = 1.0
            
            awardMetaBytes(amount: prize)
            
            // Show alert with winning amount
            let alertMessage: String
            let titleMessage: String
            if prize == 0 {
                alertMessage = "Better luck next time!"
                titleMessage = "Don't be sorry!"
            } else {
                titleMessage = "Congratulations!"
                alertMessage = "You have won \(prize) MetaBytes."
            }
            
            let alertController = UIAlertController(title: titleMessage, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if prize > 0 {
                alertController.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
                    self.resetScratchcard()
                }))
            } else {
                alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
                    self.resetScratchcard()
                }))
            }
            
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        }
        
        // Print the revealed percentage
        print("Revealed Percentage: \(revealedPercentage * 100)%")
    }


    
    var onPlayAgain: (() -> Void)?
    
    
    func reset() {
        resetScratchcard()
    }
    
    
    
    private func showImage(_ image: UIImage) {
        let imageView = UIImageView(frame: bounds)
        imageView.image = image
        addSubview(imageView)
    }
    
    private func awardMetaBytes(amount: Int) {
        // Update the balance of MetaBytes or perform any other actions
        print("Congratulations! You've won \(amount) MetaBytes.")
    }
    private func weightedRandomIndex(with probabilities: [Int]) -> Int {
        let total = probabilities.reduce(0, +)
        let random = Int.random(in: 1...total)
        
        var sum = 0
        for (index, probability) in probabilities.enumerated() {
            sum += probability
            if random <= sum {
                return index
            }
        }
        
        return 0
    }
    
    
}
extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
