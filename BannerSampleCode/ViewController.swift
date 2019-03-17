//
//  ViewController.swift
//  BannerSampleCode
//
//  Created by steve on 17/03/2019.
//  Copyright © 2019 BrainTools. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var bannerView: UIView!
    private var bannerViewHeight: CGFloat!
    private var bannerViewTopAnchorConstraint: NSLayoutConstraint!
    private var animator: UIViewPropertyAnimator!
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBannerView()
    }
    
    private func configureBannerView() {
        guard let navigationController = navigationController else {
            return
        }
        bannerViewHeight = UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.size.height// + 100
        let bannerViewFrame = CGRect(x: 0.0, y: 0, width: navigationController.navigationBar.frame.size.width, height: bannerViewHeight)
        bannerView = BannerView(frame: bannerViewFrame)
        navigationController.view.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.widthAnchor.constraint(equalToConstant: bannerViewFrame.size.width).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: bannerViewHeight).isActive = true
        bannerViewTopAnchorConstraint = bannerView.topAnchor.constraint(equalTo: navigationController.view.topAnchor, constant: -bannerViewHeight)
        bannerViewTopAnchorConstraint.isActive = true
        bannerView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor).isActive = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        bannerView.addGestureRecognizer(pan)
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let navigationController = navigationController else {
            return
        }
        
        switch recognizer.state {
        case .began:
            timer?.invalidate()
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
                self.bannerViewTopAnchorConstraint.constant = -self.bannerViewHeight
                navigationController.view.layoutIfNeeded()
            }
            animator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: bannerView)
            let fraction = translation.y / -bannerViewHeight
            animator.fractionComplete = fraction
        case .ended:
            let velocity = recognizer.velocity(in: bannerView)
            if animator.fractionComplete > 0.3  || velocity.y <= -100 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                animator.stopAnimation(true)
                showBanner()
                hideBanner(afterDelay: 3)
            }
        default:
            break
        }
    }

    @IBAction func clickSwitch(_ sender: UISwitch) {
        timer?.invalidate()
        if sender.isOn {
            showBanner()
            hideBanner(afterDelay: 3)
        } else {
            hideBanner()
        }
    }
    
    private func showBanner() {
        guard let navigationController = navigationController else {
            return
        }
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.bannerViewTopAnchorConstraint.constant = 0
            navigationController.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    
    private func hideBanner(afterDelay delay: Double = 0.0) {
        if delay == 0.0  {
            self.startHideBannerAnimation()
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] timer in
                guard let self = self else {
                    return
                }
                self.startHideBannerAnimation()
            }
        }
    }
    
    private func startHideBannerAnimation() {
        guard let navigationController = navigationController else {
            return
        }
        self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            self.bannerViewTopAnchorConstraint.constant = -self.bannerViewHeight
            navigationController.view.layoutIfNeeded()
        }
        self.animator.startAnimation()
    }
}

