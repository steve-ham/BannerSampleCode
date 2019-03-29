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
        bannerViewHeight = UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.size.height + 150
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
    
    var animationState: AnimationState = .isHiding
    
    enum AnimationState {
        case isHiding
        case isShowing
    }
    var fractionComplete: CGFloat!
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch animationState {
        case .isHiding:
            switch recognizer.state {
            case .began:
                timer?.invalidate()
                animator.pauseAnimation()
                fractionComplete = animator.fractionComplete
            case .changed:
                let translation = recognizer.translation(in: bannerView)
                let fraction = (translation.y / -bannerViewHeight) + fractionComplete
                animator.fractionComplete = fraction
            case .ended:
                let velocity = recognizer.velocity(in: bannerView)
                if animator.fractionComplete > 0.3  || velocity.y <= -100 {
                    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                } else {
                    animator.stopAnimation(true)
                    showBanner(duration: TimeInterval(2 * animator.fractionComplete))
                }
            default:
                break
            }
        case .isShowing:
            switch recognizer.state {
            case .began:
                timer?.invalidate()
                animator.pauseAnimation()
                fractionComplete = animator.fractionComplete
            case .changed:
                let translation = recognizer.translation(in: bannerView)
                let fraction = (translation.y / bannerViewHeight) + fractionComplete
                animator.fractionComplete = fraction
            case .ended:
                let velocity = recognizer.velocity(in: bannerView)
                if animator.fractionComplete > 0.3  || velocity.y <= -100 {
                    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                } else {
                    animator.stopAnimation(true)
                    hideBanner(duration: TimeInterval(2 * animator.fractionComplete))
                }
            default:
                break
            }
        }
    }
    
    @IBAction func clickSwitch(_ sender: UISwitch) {
        timer?.invalidate()
        if sender.isOn {
            showBanner(duration: 2)
        } else {
            hideBanner(duration: 2)
        }
    }
    
    private func showBanner(duration: TimeInterval) {
        guard let navigationController = navigationController else {
            return
        }
        animationState = .isShowing
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            self.bannerViewTopAnchorConstraint.constant = 0
            navigationController.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            guard let self = self else { return }
            self.hideBanner(afterDelay: 2, duration: 2)
        }
        animator.startAnimation()
    }
    
    
    private func hideBanner(afterDelay delay: TimeInterval = 0.0, duration: TimeInterval) {
        if delay == 0.0  {
            startHideBannerAnimation(duration: duration)
        } else {
            startHideBannerAnimation(duration: duration)
            animator.pauseAnimation()
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] timer in
                guard let self = self else { return }
                self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        }
    }
    
    private func startHideBannerAnimation(duration: TimeInterval) {
        guard let navigationController = navigationController else {
            return
        }
        animationState = .isHiding
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            self.bannerViewTopAnchorConstraint.constant = -self.bannerViewHeight
            navigationController.view.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            print("startHideBannerAnimation completion")
        }
        animator.startAnimation()
    }
}

