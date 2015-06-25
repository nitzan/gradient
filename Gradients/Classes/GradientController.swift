import Cocoa

public class GradientController: NSObject {

    var hue = 100;
    var hueShift = 0;
    var view: GradientView!

    @IBOutlet weak var mainView: GradientView!
    @IBOutlet weak var previewView: GradientView!

    var colour: NSColor!
    var rightColour: NSColor!

    @IBAction func changeHue(sender: NSMenuItem) {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let huePercent = numberFormatter.numberFromString(sender.title)

        view.contentFilters = [hueShiftFilter(huePercent!)]
    }

    public func createNewGradient() {
        hue = 360.randomLowerInt()
        makeColour()
        drawColour()
        view.displayIfNeeded()
    }

    override public func awakeFromNib() {
        view = mainView;
        view.frame = NSMakeRect(0, 0, 2000, 2000);
        makeColour()
        drawColour()
    }

    func hueShiftFilter(percent:NSNumber) -> CIFilter {
        hueShift = Int(360.0 * percent.floatValue) - 180
        return CIFilter(name: "CIHueAdjust", withInputParameters: ["inputAngle": hueShift])
    }

    func switchViews() {
        previewView.contentFilters = mainView.contentFilters

        if view == mainView {
            view = previewView
        } else {
            view = mainView;
        }
        drawColour()
    }

    func makeColour() {
        let calibratedHue = CGFloat(hue) / 360.0
        colour = NSColor(calibratedHue:calibratedHue, saturation: 0.398, brightness: 0.773, alpha: 1.0)

        let red = CGFloat(Float(100.randomLowerInt()) / 100.0)
        let green = CGFloat(Float(100.randomLowerInt()) / 100.0)
        let blue = CGFloat(Float(100.randomLowerInt()) / 100.0)

        rightColour = NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }

    func drawColour() {
        let point = GradientPoint(startColour: colour, endColour:rightColour);

        view.empty()
        view.addGradientPoint(point)
    }

    func randPointAroundBounds() -> NSPoint {
        let bounds = view.bounds
        return NSMakePoint (
            CGRectGetWidth(bounds).randomPushingOutwards(40),
            CGRectGetHeight(bounds).randomPushingOutwards(40)
        )
    }
}

extension Int {

    func randomLowerInt() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

extension CGFloat {
    func randomLowerInt() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }

    func randomPushingOutwards(outer: Int) -> CGFloat {
        let upper = self + CGFloat(outer * 2)
        return CGFloat(upper.randomLowerInt() - outer)
    }
}

extension ClosedInterval {
    func randomInt() -> Int {
        let x = start as! Int
        let y = end as! Int
        return Int(arc4random_uniform(UInt32(x))) - y
    }

    func randomRange() -> Range<Int> {
        let x = start as! Int
        let y = end as Int
        let top = Int(x + y).randomLowerInt() - x
        return Range(start: x, end: top)
    }
}

