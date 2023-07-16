import UIKit

class ScratchcardView: UIView {
    
    private let images: [UIImage] = [
        UIImage(named: "prize_10000")!,
        UIImage(named: "prize_5000")!,
        UIImage(named: "prize_2000")!,
        UIImage(named: "prize_1000")!,
        UIImage(named: "no_prize")!
    ]
    
    private let prizes: [Int] = [10000, 5000, 2000, 1000, 0]
    private let probabilities: [Int] = [
        2, 3, 5, 50, 40
    ]
    private let scratchWidth: CGFloat = 30.0
    private var revealedPercentage: CGFloat = 0.0
    
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
        backgroundColor = .white
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.black.cgColor
        
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
            isScratching = true
            
        case .changed:
            if isScratching {
                let point = recognizer.location(in: self)
                let convertedPoint = convert(point, to: self)
                revealImage(at: convertedPoint)
            }
        case .ended, .cancelled:
            isScratching = false
        default:
            break
        }
    }

    
    
    private func revealImage(at point: CGPoint) {
        if scratchedPoints.contains(point) {
            return
        }
        
        scratchedPoints.insert(point)
        let revealedArea = calculateRevealedArea()
        let revealedPercentage = min(revealedArea / totalArea, 1.0)

        if revealedPercentage >= 0.8 {
            let randomIndex = weightedRandomIndex(with: probabilities)
            let imageIndex = prizes[randomIndex] == 0 ? images.count - 1 : randomIndex
            let image = images[imageIndex]
            let prize = prizes[randomIndex]

            // Remove all existing subviews
            subviews.forEach { $0.removeFromSuperview() }

            // Display the revealed image and award MetaBytes
            let imageView = UIImageView(frame: bounds)
            imageView.image = image
            addSubview(imageView)

            awardMetaBytes(amount: prize)

            // Show alert with winning amount
            let alertMessage: String
            if prize == 0 {
                alertMessage = "Better luck next time!"
            } else {
                alertMessage = "You have won \(prize) MetaBytes."
            }
            
            let alertController = UIAlertController(title: "Congratulations!", message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        }

        // Print the revealed percentage
        print("Revealed Percentage: \(revealedPercentage * 100)%")
    }



    
    private func calculateScratchedArea(in rect: CGRect) -> CGFloat {
        let intersectionRect = rect.intersection(bounds)
        return intersectionRect.width * intersectionRect.height
    }

    
    private func calculateRevealedArea() -> CGFloat {
        let path = UIBezierPath()
        path.move(to: scratchedPoints.first ?? CGPoint.zero)
        scratchedPoints.forEach { path.addLine(to: $0) }
        path.close()

        return path.bounds.size.width * path.bounds.size.height
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
