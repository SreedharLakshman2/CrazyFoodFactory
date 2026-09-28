import SwiftUI
import UIKit
import LinkPresentation

struct ShareItem: Identifiable {
    let id = UUID()
    let image: UIImage
}

enum RewardCardRenderer {
    @MainActor
    static func image(for reward: Reward) -> UIImage {
        let size = CGSize(width: 720, height: 900)
        let card = RewardShareCard(reward: reward)
            .frame(width: size.width, height: size.height)
        let renderer = ImageRenderer(content: card)
        renderer.proposedSize = ProposedViewSize(width: size.width, height: size.height)
        renderer.scale = 2
        renderer.isOpaque = true
        if let image = renderer.uiImage, image.size.width > 8 {
            return image
        }
        return fallbackImage(for: reward, size: size)
    }

    @MainActor
    static func pngData(for reward: Reward) -> Data? {
        image(for: reward).pngData()
    }

    @MainActor
    private static func fallbackImage(for reward: Reward, size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 2
        format.opaque = true
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            let colors = [
                UIColor(red: 0.36, green: 0.78, blue: 1, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.90, blue: 0.42, alpha: 1).cgColor,
                UIColor.white.cgColor
            ]
            if let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0, 0.55, 1]
            ) {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: .zero,
                    end: CGPoint(x: 0, y: size.height),
                    options: []
                )
            }

            let titleStyle: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 54, weight: .heavy),
                .foregroundColor: UIColor(red: 0.09, green: 0.20, blue: 0.36, alpha: 1)
            ]
            (Brand.name as NSString).draw(
                in: CGRect(x: 40, y: 70, width: size.width - 80, height: 70),
                withAttributes: centered(titleStyle)
            )
            ("Reward Unlocked!" as NSString).draw(
                in: CGRect(x: 40, y: 150, width: size.width - 80, height: 40),
                withAttributes: centered([
                    .font: UIFont.systemFont(ofSize: 26, weight: .bold),
                    .foregroundColor: UIColor(red: 0.09, green: 0.20, blue: 0.36, alpha: 0.7)
                ])
            )

            if let food = reward.food, let art = UIImage(named: GameArt.food(food)) {
                art.draw(in: CGRect(x: 210, y: 230, width: 300, height: 300))
            } else if let star = UIImage(systemName: "star.fill") {
                star.withTintColor(UIColor(red: 1, green: 0.60, blue: 0.12, alpha: 1), renderingMode: .alwaysOriginal)
                    .draw(in: CGRect(x: 260, y: 270, width: 200, height: 200))
            }

            (reward.title as NSString).draw(
                in: CGRect(x: 40, y: 560, width: size.width - 80, height: 80),
                withAttributes: centered(titleStyle)
            )
            (reward.subtitle as NSString).draw(
                in: CGRect(x: 50, y: 650, width: size.width - 100, height: 80),
                withAttributes: centered([
                    .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                    .foregroundColor: UIColor(red: 0.09, green: 0.20, blue: 0.36, alpha: 0.75)
                ])
            )
            (Brand.copyright as NSString).draw(
                in: CGRect(x: 40, y: 820, width: size.width - 80, height: 30),
                withAttributes: centered([
                    .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                    .foregroundColor: UIColor(red: 0.09, green: 0.20, blue: 0.36, alpha: 0.45)
                ])
            )
        }
    }

    private static func centered(_ attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        var next = attributes
        next[.paragraphStyle] = style
        return next
    }
}

final class ShareImageSource: NSObject, UIActivityItemSource {
    let image: UIImage
    let title: String

    init(image: UIImage, title: String = "Kido Chef Reward") {
        self.image = image
        self.title = title
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        image
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        image
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        title
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        thumbnailImageForActivityType activityType: UIActivity.ActivityType?,
        suggestedSize size: CGSize
    ) -> UIImage? {
        image
    }

    func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.imageProvider = NSItemProvider(object: image)
        return metadata
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let image = items.compactMap { $0 as? UIImage }.first
        let payload: [Any]
        if let image {
            payload = [ShareImageSource(image: image)]
        } else {
            payload = items
        }
        let controller = UIActivityViewController(activityItems: payload, applicationActivities: nil)
        controller.excludedActivityTypes = [.assignToContact, .addToReadingList, .print]
        return controller
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {
        if let popover = controller.popoverPresentationController {
            popover.sourceView = controller.view
            let bounds = controller.view.bounds
            popover.sourceRect = CGRect(x: bounds.midX, y: max(12, bounds.midY - 80), width: 8, height: 8)
            popover.permittedArrowDirections = []
        }
    }
}
