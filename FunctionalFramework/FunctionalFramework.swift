//
//  FunctionalFramework.swift
//  FunctionalFramework
//
//  Created by William Cheek on 4/29/19.
//  Copyright © 2019 William Cheek. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

//  Functions for easily building UI Elements

public func Label(withText text: String?, size: CGFloat = 17, alignment: NSTextAlignment = .left) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.font = label.font.withSize(size)
    label.textAlignment = alignment
    return label
}

//public func Labels(_ inputs: [String]) -> [UILabel] {
//    return inputs.map { $0 |> Label }
//}

public func Button(withTitle title: String?) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(title, for: .normal)
    return button
}

public func StackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.alignment = alignment
    stackView.distribution = distribution
    return stackView
}

public func ScrollView() -> UIScrollView {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
}

public func View(backgroundColor: UIColor, height: CGFloat? = nil, width: CGFloat? = nil) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = backgroundColor
    if let height = height {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height)])
    }
    if let width = width {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: width)
            ])
    }
    return view
}

public func ImageView(named: String) -> UIImageView {
    return UIImageView(image: UIImage(named: named))
}

// An extension to UIView will take a childView and a group of constraints.  The 'constraints' will actually be functions which return functions which take two views and makes an NSLayoutConstraint.  Those functions will take a keypath or two and a constant and return the function for two views.  Taken from: http://chris.eidhof.nl/post/micro-autolayout-dsl/

public typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

public func equal<Anchor, Axis>(_ keyPath: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { child, parent in
        child[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], constant: constant)
    }
}

public func equal<Anchor, Axis>(_ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant)
}

public extension UIView {
    func addSubview(_ child: UIView, constraints: [Constraint]){
        child.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(child)
        NSLayoutConstraint.activate( constraints.map { $0(child, self) } )
    }
    
    func constrain(_ sibling: UIView, _ constraints: [Constraint]){
        NSLayoutConstraint.activate( constraints.map { $0(sibling, self) } )
    }
}

public func leading(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.leadingAnchor, constant: constant)
}

public func top(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: constant)
}

public func trailing(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.trailingAnchor, constant: constant)
}

public func bottom(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.bottomAnchor, constant: constant)
}

public func topToBottom(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.topAnchor, \.bottomAnchor, constant: constant)
}

public func leadingToTrailing(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.trailingAnchor, \.leadingAnchor, constant: constant)
}

public func centerX(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.centerXAnchor, constant: constant)
}

public func centerY(_ constant: CGFloat = 0) -> Constraint {
    return equal(\.centerYAnchor, constant: constant)
}

// Functional Constraints

public func top(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.topAnchor.constraint(equalTo: v2.topAnchor, constant: constant)
            ])
    }
}

public let top: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.topAnchor.constraint(equalTo: v2.topAnchor)])
}

public func leading(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.leadingAnchor.constraint(equalTo: v2.leadingAnchor, constant: constant)
            ])
    }
}

public let leading: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.leadingAnchor.constraint(equalTo: v2.leadingAnchor)])
}

public func trailing(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.trailingAnchor.constraint(equalTo: v2.trailingAnchor, constant: -constant)
            ])
    }
}

public let trailing: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.trailingAnchor.constraint(equalTo: v2.trailingAnchor)])
}

public func bottom(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor, constant: constant)
            ])
    }
}

public let bottom: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor)])
}

public func topToBottom(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.topAnchor.constraint(equalTo: v2.bottomAnchor, constant: constant)
            ])
    }
}

public let topToBottom: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.topAnchor.constraint(equalTo: v2.bottomAnchor)])
}

public func leadingToTrailing(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.leadingAnchor.constraint(equalTo: v2.trailingAnchor, constant: constant)
            ])
    }
}

public let leadingToTrailing: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.leadingAnchor.constraint(equalTo: v2.trailingAnchor)])
}

public func centerX(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.centerXAnchor.constraint(equalTo: v2.centerXAnchor, constant: constant)
            ])
    }
}

public let centerX: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.centerXAnchor.constraint(equalTo: v2.centerXAnchor)])
}

public func centerY(_ constant: CGFloat) -> (UIView, UIView) -> Void {
    return { v1, v2 in
        NSLayoutConstraint.activate([
            v1.centerYAnchor.constraint(equalTo: v2.centerYAnchor, constant: constant)
            ])
    }
}

public let centerY: (UIView, UIView) -> Void = { v1, v2 in
    NSLayoutConstraint.activate([v1.centerYAnchor.constraint(equalTo: v2.centerYAnchor)])
}

public func height(_ height: CGFloat) -> (UIView) -> Void {
    return { v in
        NSLayoutConstraint.activate([v.heightAnchor.constraint(equalToConstant: height)])
    }
}

public func width(_ width: CGFloat) -> (UIView) -> Void {
    return { v in
        NSLayoutConstraint.activate([v.widthAnchor.constraint(equalToConstant: width)])
    }
}

public let bottomBaseline: (UIView, UIView) -> () = { v1, v2 in
    v1.lastBaselineAnchor.constraint(equalTo: v2.lastBaselineAnchor).isActive = true
}

//  Extensions for adding and animating UIViews

public extension UIView {
    func addAndScrollUp(_ view: UIView, duration: TimeInterval = 0.2) {
        let viewHeight = self.bounds.height / 3.0
        view.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: viewHeight)
        view.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height + view.bounds.height / 2.0)
        self.addSubview(view)
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(translationX: 0, y: -viewHeight)
        }
    }
    
    func addAndAnimateZoomIn(_ view: UIView, duration: TimeInterval, location: CGPoint = .zero, size: CGSize = CGSize(width: 280, height: 280)){
        view.bounds = CGRect(origin: .zero, size: size)
        view.center = location
        view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.addSubview(view)
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform.identity
        }
    }
    
    func removeZoomOut(_ duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func removeScrollDown(_ duration: TimeInterval = 0.2){
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

public extension UIView {
    func autoLayout(_ width: CGFloat?, _ height: CGFloat?){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if let height = height {
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: height)
                ])
        }
    }
}


// Extensions/helpers for making UIColors
// From: https://github.com/nathangitter/fluid-interfaces/blob/master/FluidInterfaces/FluidInterfaces/UIColorExtensions.swift

public extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1){
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0xFF00) >> 8) / 255
        let b = CGFloat(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

//  View Subclasses
// From: https://github.com/nathangitter/fluid-interfaces/blob/master/FluidInterfaces/FluidInterfaces/GradientView.swift

public class GradientView: UIView {
    public var topColor: UIColor = .white {
        didSet {
            updateGradientColors()
        }
    }
    
    public var bottomColor: UIColor = .black {
        didSet {
            updateGradientColors()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayer
    }()
    
    public var cornerRadius: CGFloat? {
        didSet { layoutSubviews() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init(_ topColor: UIColor, _ bottomColor: UIColor, height: CGFloat? = nil, width: CGFloat? = nil) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.topColor = topColor
        self.bottomColor = bottomColor
        updateGradientColors()
        if let height = height {
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: height)])
        }
        if let width = width {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: width)
                ])
        }
    }
    
    private func setup(){
        layer.addSublayer(gradientLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? bounds.width * 0.2).cgPath
        layer.mask = maskLayer
    }
    
    private func updateGradientColors(){
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
}



public class StackScrollView: UIScrollView {
    let stackView = StackView(axis: .vertical)
    var scrollsToBottom = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        stackView |> self.addSubview
        (stackView, self) |> top(0) <> leading <> trailing <> bottom(0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addRow(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
        scrollToBottom()
    }
    
    private func scrollToBottom(){
        if scrollsToBottom {
            let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
            if bottomOffset.y > 0 {
                self.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
}


// UIGestureRecognizer helpers/Extensions/Subclasses
public class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == UIGestureRecognizer.State.began { return }
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}


// Utilites for programming
public func p(_ item: Any){
    print(item)
}

public func __(_ message: String) {
    print("\n----------")
    print(message + "\n")
    
}

public func loop(_ times: Int, closure: () -> ()) {
    for _ in 1...times {
        closure()
    }
}

// Get all fonts by family
//UIFont.familyNames.forEach { (name) in
//    __
//    p("\(name)'s Fonts:")
//    p("-------")
//    UIFont.fontNames(forFamilyName: name).forEach { p($0) }
//}

// Code for getting swift version number
//#if swift(>=4.2)
//print("Swift 4.2")
//#elseif swift(>=4.1)
//print("Swift 4.1")
//#endif


public enum FontFamily: String {
    case Copperplate = "Copperplate"
    case HeitiSC = "Heiti SC"
    case AppleSDGothicNeo = "Apple SD Gothic Neo"
    case Thonburi = "Thonburi"
    case GillSans = "Gill Sans"
    case MarkerFelt = "Marker Felt"
    case HiraginoMaruGothicProN = "Hiragino Maru Gothic ProN"
    case CourierNew = "Courier New"
    case KohinoorTelugu = "Kohinoor Telugu"
    case HeitiTC = "Heiti TC"
    case AvenirNextCondensed = "Avenir Next Condensed"
    case TamilSangamMN = "Tamil Sangam MN"
    case HelveticaNeue = "Helvetica Neue"
    case GurmukhiMN = "Gurmukhi MN"
    case Georgia = "Georgia"
    case TimesNewRoman = "Times New Roman"
    case SinhalaSangamMN = "Sinhala Sangam MN"
    case ArialRoundedMTBold = "Arial Rounded MT Bold"
    case Kailasa = "Kailasa"
    case KohinoorDevanagari = "Kohinoor Devanagari"
    case KohinoorBangla = "Kohinoor Bangla"
    case ChalkboardSE = "Chalkboard SE"
    case AppleColorEmoji = "Apple Color Emoji"
    case PingFangTC = "PingFang TC"
    case GujaratiSangamMN = "Gujarati Sangam MN"
    case GeezaPro = "Geeza Pro"
    case Damascus = "Damascus"
    case Noteworthy = "Noteworthy"
    case Avenir = "Avenir"
    case Mishafi = "Mishafi"
    case AcademyEngravedLET = "Academy Engraved LET"
    case Futura = "Futura"
    case PartyLET = "Party LET"
    case KannadaSangamMN = "Kannada Sangam MN"
    case ArialHebrew = "Arial Hebrew"
    case Farah = "Farah"
    case Arial = "Arial"
    case Chalkduster = "Chalkduster"
    case Kefa = "Kefa"
    case HoeflerText = "Hoefler Text"
    case Optima = "Optima"
    case Palatino = "Palatino"
    case MalayalamSangamMN = "Malayalam Sangam MN"
    case AlNile = "Al Nile"
    case LaoSangamMN = "Lao Sangam MN"
    case BradleyHand = "Bradley Hand"
    case HiraginoMinchoProN = "Hiragino Mincho ProN"
    case PingFangHK = "PingFang HK"
    case Helvetica = "Helvetica"
    case Courier = "Courier"
    case Cochin = "Cochin"
    case TrebuchetMS = "Trebuchet MS"
    case DevanagariSangamMN = "Devanagari Sangam MN"
    case OriyaSangamMN = "Oriya Sangam MN"
    case Rockwell = "Rockwell"
    case SnellRoundhand = "Snell Roundhand"
    case ZapfDingbats = "Zapf Dingbats"
    case Bodoni72 = "Bodoni 72"
    case Verdana = "Verdana"
    case AmericanTypewriter = "American Typewriter"
    case AvenirNext = "Avenir Next"
    case Baskerville = "Baskerville"
    case KhmerSangamMN = "Khmer Sangam MN"
    case Didot = "Didot"
    case SavoyeLET = "Savoye LET"
    case BodoniOrnaments = "Bodoni Ornaments"
    case Symbol = "Symbol"
    case Charter = "Charter"
    case Menlo = "Menlo"
    case NotoNastaliqUrdu = "Noto Nastaliq Urdu"
    case Bodoni72Smallcaps = "Bodoni 72 Smallcaps"
    case DINAlternate = "DIN Alternate"
    case Papyrus = "Papyrus"
    case HiraginoSans = "Hiragino Sans"
    case PingFangSC = "PingFang SC"
    case MyanmarSangamMN = "Myanmar Sangam MN"
    case NotoSansChakma = "Noto Sans Chakma"
    case Zapfino = "Zapfino"
    case TeluguSangamMN = "Telugu Sangam MN"
    case Bodoni72Oldstyle = "Bodoni 72 Oldstyle"
    case EuphemiaUCAS = "Euphemia UCAS"
    case BanglaSangamMN = "Bangla Sangam MN"
    case DINCondensed = "DIN Condensed"
}

// Code to gen the above enum:
//print("enum FontFamily: String {")
//UIFont.familyNames.forEach {
//    print("\tcase \($0.replacingOccurrences(of: " ", with: "")) = \"\($0)\"")
//}
//print("}")


// MARK: Functional Programming Operators

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

public func |> <A, B> (_ a: A, f: (A) -> B) -> B {
    return f(a)
}

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >=>: EffectfulComposition

public func >=><A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
    ) -> (A) -> (C, [String]) {
    return { a in
        let (b, logs) = f(a)
        let (c, moreLogs) = g(b)
        return (c, logs + moreLogs)
    }
}

precedencegroup ForwardComposition {
    associativity: right
    higherThan: EffectfulComposition
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { a in g(f(a)) }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardComposition
}

infix operator <>: SingleTypeComposition

public func <> <A: AnyObject>(_ f: @escaping (A) -> Void, _ g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}

public func <> <A: AnyObject, B: AnyObject> (_ f: @escaping (A, B) -> Void, _ g: @escaping (A, B) -> Void) -> (A, B) -> Void {
    return { a, b in
        f(a, b)
        g(a, b)
    }
}

precedencegroup BackwardsComposition {
    associativity: left
}

infix operator <<< : BackwardsComposition
public func <<< <A,B,C> (_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
    return { f(g($0)) }
}

// MARK: Funcs for making funcs

public func curry<A,B,C>(_ f: @escaping (A,B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a,b) } }
}

public func flip<A,B,C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b)}}
}

public func zurry<A>(_ f: () -> A) -> A {
    return f()
}

// MARK: Functional getters and setters

public func first<A,B,C>(_ f: @escaping (A) -> C) -> ((A, B)) -> (C, B) {
    return { pair in
        (f(pair.0), pair.1)
    }
}

public func second<A,B,C>(_ f: @escaping (B) -> C) -> ((A,B)) -> (A,C) {
    return { pair in
        (pair.0, f(pair.1))
    }
}

public func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
    -> (@escaping (Value) -> Value)
    -> (Root)
    -> Root {
        return { transform in
            { root in
                var copy = root
                copy[keyPath: kp] = transform(copy[keyPath: kp])
                return copy
            }
        }
}

public func map<A,B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { $0.map(f) }
}

public func map<A,B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
    return { $0.map(f) }
}

public func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in
        root[keyPath: kp]
    }
}

public func their<Root, Value>(_ f: @escaping (Root) -> Value, _ g: @escaping (Value, Value) -> Bool)
    -> (Root, Root) -> Bool {
        return { g(f($0), f($1)) }
}

public func their<Root, Value: Comparable>(_ f: @escaping (Root) -> Value)
    -> (Root, Root) -> Bool {
        return their(f, <)
}

public func combining<Root, Value> (_ f: @escaping (Root) -> Value, _ g: @escaping (Value, Value) -> Value) -> (Value, Root) -> Value {
    return { value, root in
        g(value, f(root))
    }
}


prefix operator ^
public prefix func ^<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return get(kp)
}

// MARK: Functional code for modifing built in classes
//
// Functional code for making/modifying NSAttributedStrings

public func titleString(_ string: String) -> NSAttributedString {
    return NSAttributedString(string: string, attributes: [
        .foregroundColor: UIColor.red,
        .font: UIFont.systemFont(ofSize: 28)
        ])
}

public func subtitleString(_ string: String) -> NSAttributedString {
    return NSAttributedString(string: string, attributes: [
        .foregroundColor: UIColor.lightGray,
        .font: UIFont.systemFont(ofSize: 22)
        ])
}

public func make(_ f: @escaping (String) -> NSAttributedString) -> (UILabel) -> (){
    return { l in
        guard let text = l.text else { return }
        l.attributedText = f(text)
    }
}

// Functional code for making/modifying UIViews

public func autolayoutStyle (_ v: UIView) -> () {
    v.translatesAutoresizingMaskIntoConstraints = false
}

public func backgroundColor(_ c: UIColor) -> (UIView) -> () {
    return { v in
        v.backgroundColor = c
    }
}

public func square(_ side: CGFloat) -> (UIView) -> () {
    return { v in
        NSLayoutConstraint.activate([
            v.widthAnchor.constraint(equalToConstant: side),
            v.heightAnchor.constraint(equalToConstant: side)
            ])
    }
}

public func rotate(_ degrees: CGFloat) -> (UIView) -> () {
    return { v in
        v.transform = v.transform.rotated(by: degreeToRad(degrees))
    }
}

public func degreeToRad(_ degree: CGFloat) -> CGFloat {
    return degree * (CGFloat.pi / 180)
}

// Functional code for modifying UIButtons

public func buttonTitle(_ text: String) -> (UIButton) -> () {
    return { b in
        b.setTitle(text, for: .normal)
    }
}

public func buttonColor(_ c: UIColor) -> (UIButton) -> () {
    return { b in
        b.setTitleColor(c, for: .normal)
    }
}


// Functional Code for modifying UIStackViews

public func spacing(_ distance: CGFloat) -> (UIStackView) -> () {
    return { sv in
        sv.spacing = distance
    }
}

public func stackDistribution(_ distribution: UIStackView.Distribution) -> (UIStackView) -> () {
    return { sv in
        sv.distribution = distribution
    }
}

public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]){
        views.forEach { self.addArrangedSubview($0) }
    }
}

public func addArrangedSubviews(_ views: [UIView]) -> (UIStackView) -> () {
    return { v in
        v.addArrangedSubviews(views)
    }
}


// Functional code for modifying UILabels

public func font(_ family: FontFamily) -> (UILabel) -> () {
    return { v in
        v.font = UIFont(name: family.rawValue, size: v.font.pointSize)
    }
}

public func fontSize(_ size: CGFloat) -> (UILabel) -> () {
    return { v in
        v.font = v.font.withSize(size)
    }
}

public func monoFont(_ size: CGFloat) -> (UILabel) -> () {
    return { v in
        v.font = UIFont.monospacedDigitSystemFont(ofSize: size, weight: .light)
    }
}

public let bold: (UILabel) -> () = { l in
    l.font = UIFont.systemFont(ofSize: l.font.pointSize, weight: .bold)
}

public func boldMono(_ size: CGFloat) -> (UILabel) -> () {
    return { v in
        v.font = UIFont.monospacedDigitSystemFont(ofSize: size, weight: .bold)
    }
}

public func boldFirst(_ labels: [UILabel]) -> () {
    guard let first = labels.first else { return }
    first |> boldMono(18)
}

public func numberOfLines(_ lines: Int) -> (UILabel) -> () {
    return { l in
        l.numberOfLines = lines
    }
}

public func alignment(_ alignment: NSTextAlignment) -> (UILabel) -> () {
    return { l in
        l.textAlignment = alignment
    }
}

