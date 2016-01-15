//
//  ViewController.swift
//  Color
//
//  Created by Andrew Theken on 1/14/16.
//  Copyright © 2016 Andrew Theken. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }


    private var hue:CGFloat = 0.5 {
        didSet{
            UIView.animateWithDuration(0.25){
                self.animateColorChanges()
            }
        }
    }

    private var value:CGFloat = 1.0 {
        didSet{
            UIView.animateWithDuration(0.25){
                self.animateColorChanges()
            }
        }
    }

    private var saturation:CGFloat = 1.0 {
        didSet{
            UIView.animateWithDuration(0.25){
                self.animateColorChanges()
            }
        }
    }

    @IBOutlet weak var colorCollection: UIStackView!

    func animateColorChanges(){
        let views = self.colorCollection.arrangedSubviews
        let viewCount = CGFloat(views.count)
        let mod = 1.0/viewCount
        var index = 0
        for i in views {
            var hue = self.hue
            var saturation = self.saturation
            var value = self.value
            switch currentParameter {
                case "Hue":
                    hue = fixRange(hue + (mod * CGFloat(index)))
                case "Saturation":
                    saturation = fixRange(saturation - ((saturation/viewCount) * CGFloat(index)))
                case "Value":
                    value = fixRange(value - ((value/viewCount) * CGFloat(index)))
                default:
                    break
            }

            i.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: value, alpha: 1.0)
            index = index + 1
        }
    }

    var startLocation:CGPoint?
    var startingColors:(CGFloat,CGFloat,CGFloat) = (1.0,1.0,0.5)

    func fixRange(colorValue: CGFloat) -> CGFloat {
        var colorValue = colorValue

        if colorValue > 1 { colorValue = colorValue - 1 }
        else if colorValue < 0 { colorValue = colorValue + 1 }

        if colorValue < 0 || colorValue > 1 {
            print(colorValue)
        }

        return colorValue
    }

    @IBOutlet weak var valueSlider: UISlider!

    var currentParameter = "Hue" {
        didSet {
            UIView.animateWithDuration(0.25){
                self.animateColorChanges()
            }
        }
    }

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

            let current = self.colorCollection.arrangedSubviews.count
            if current + 1 > 5 {
                UIView.animateWithDuration(0.25){
                    self.colorCollection.removeArrangedSubview(self.colorCollection.arrangedSubviews.last!)
                    self.colorCollection.removeArrangedSubview(self.colorCollection.arrangedSubviews.last!)
                    self.colorCollection.removeArrangedSubview(self.colorCollection.arrangedSubviews.last!)
                    self.colorCollection.removeArrangedSubview(self.colorCollection.arrangedSubviews.last!)
                    self.animateColorChanges()
                }
            }else{
                UIView.animateWithDuration(0.25){
                    self.colorCollection.addArrangedSubview(UIView())
                    self.animateColorChanges()
                }
            }
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorCollection.addArrangedSubview(UIView())
        self.animateColorChanges()
    }
}

