//
//  ViewController.swift
//  Color
//
//  Created by Andrew Theken on 1/14/16.
//  Copyright © 2016 Andrew Theken. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var colorCollection: UIStackView!

    @IBAction func changeParameter(sender: UIButton) {
        switch sender.titleLabel?.text ?? "Hue" {
        case "Hue":
            currentParameter = "Saturation"
            valueSlider.value = Float(saturation)
        case "Saturation":
            currentParameter = "Value"
            valueSlider.value = Float(value)
        case "Value":
            currentParameter = "Hue"
            valueSlider.value = Float(hue)
        default:
            break
        }
        sender.setTitle(currentParameter, forState: .Normal)
    }

    @IBAction func changeColorProperty(sender: UISlider) {
        switch currentParameter {
        case "Hue":
            hue = CGFloat(sender.value)
        case "Saturation":
            saturation = CGFloat(sender.value)
        case "Value":
            value = CGFloat(sender.value)
        default:
            break
        }
    }

    @IBAction func changeColorCount(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {

            let colorViews = self.colorCollection.arrangedSubviews
            let colorViewCount = colorViews.count

            //if this will put us over 5 color views, reduce to 1.
            if colorViewCount == 5 {
                animate{
                    for i in colorViews.reverse().prefix(4) {
                        self.colorCollection.removeArrangedSubview(i)
                    }
                    self.applyColorChanges()
                }
            }else{
                animate{
                    self.colorCollection.addArrangedSubview(UIView())
                    self.applyColorChanges()
                }
            }
        }
    }

    var currentParameter = "Hue" {
        didSet {
            animate{ self.applyColorChanges() }
        }
    }

    private var hue:CGFloat = 0.5 {
        didSet{
            animate{ self.applyColorChanges() }
        }
    }

    private var value:CGFloat = 1.0 {
        didSet{
            animate{ self.applyColorChanges() }
        }
    }

    private var saturation:CGFloat = 1.0 {
        didSet{
            animate{ self.applyColorChanges() }
        }
    }


    private func applyColorChanges(){
        let views = self.colorCollection.arrangedSubviews
        let viewCount = CGFloat(views.count)
        var index = 0
        for i in views {
            var hue = self.hue
            var saturation = self.saturation
            var value = self.value
            switch currentParameter {
                case "Hue":
                    // Hue rotates on 360 degrees, and we want to "go around the horn"
                    // when scrubbing through the hues.
                    hue = fixRange(hue + (1.0/viewCount * CGFloat(index)))
                case "Saturation":
                    // We want saturation decreasing to zero from the current absolute value.
                    saturation = fixRange(saturation - ((saturation/viewCount) * CGFloat(index)))
                case "Value":
                    // We want value decreasing to zero from the current absolute value.
                    value = fixRange(value - ((value/viewCount) * CGFloat(index)))
                default:
                    break
            }

            i.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: value, alpha: 1.0)
            index = index + 1
        }
    }

    private func fixRange(colorValue: CGFloat) -> CGFloat {
        var colorValue = colorValue

        if colorValue > 1 { colorValue = colorValue - 1 }
        else if colorValue < 0 { colorValue = colorValue + 1 }

        if colorValue < 0 || colorValue > 1 {
            print(colorValue)
        }

        return colorValue
    }

    // Standardizes the animation quality and makes a shorthand for executing them.
    private func animate(animations:()->()){
        UIView.animateWithDuration(0.25, animations: animations)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorCollection.addArrangedSubview(UIView())
        self.applyColorChanges()
    }
}

