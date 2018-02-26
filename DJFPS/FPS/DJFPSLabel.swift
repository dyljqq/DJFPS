//
//  DJFPSLabel.swift
//  DJFPS
//
//  Created by 季勤强 on 2018/2/26.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

open class DJFPSLabel: UILabel {
  
  private var link: CADisplayLink!
  private var count: UInt = 0
  private var lastTime: TimeInterval = 0
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func displayLinkClick(_ displayLink: CADisplayLink) -> Void {
    guard lastTime > 0 else {
      lastTime = link.timestamp
      return
    }
    
    count += 1
    let delta = link.timestamp - lastTime
    guard delta > 1 else {
      return
    }
    
    lastTime = link.timestamp
    let fps = Double(count) / delta
    count = 0
    
    let progress = CGFloat(fps / 60.0)
    let color = UIColor(hue: 0.27 * (progress - 0.2), saturation: 1, brightness: 0.9, alpha: 1.0)
    
    let attr = NSMutableAttributedString(string: "\(round(fps)) FPS")
    attr.set(color: color, range: NSMakeRange(0, attr.length - 3))
    attr.set(color: .white, range: NSMakeRange(attr.length - 3, 3))
    attributedText = attr
  }
  
  private func setup() {
    link = CADisplayLink.init(target: self, selector: .tick)
    link.add(to: .main, forMode: .commonModes)
    
    layer.cornerRadius = 5
    clipsToBounds = true
    
    textAlignment = .center
    font = UIFont.systemFont(ofSize: 12)
    backgroundColor = UIColor.black.withAlphaComponent(0.7)
  }
  
  deinit {
    link.invalidate()
  }
  
}

fileprivate extension Selector {
  static let tick = #selector(DJFPSLabel.displayLinkClick(_:))
}

fileprivate extension NSMutableAttributedString {
  
  func set(color: UIColor, range: NSRange) {
    addAttribute(kCTForegroundColorAttributeName as String, value: color.cgColor, range: range)
    addAttribute(NSForegroundColorAttributeName, value: color, range: range)
  }
  
}
