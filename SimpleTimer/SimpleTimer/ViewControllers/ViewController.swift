//
//  ViewController.swift
//  SimpleTimer
//
//  Created by 김건우 on 7/25/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    private var timer: Timer?
    private var timerValue: Double = 0.0 {
        // 초가 바뀐 후
        didSet {
            // 레이블의 text에 값 대입하기
            if timerValue < 100.0 {
                timeLabel.text = String(format: "%.2f", timerValue)
            } else {
                timeLabel.text = String(format: "%.1f", timerValue)
            }
        }
    }
    private let timeInterval: Double = 0.01
    
    // NOTE: - 지연 저장을 해주지 않는다면 self가 존재하지 않는 초기화 단계에서
    //       - target이 제대로 설정되지 않기에 올바른 동작을 보장할 수 없음
    private lazy var resetLongPressGesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(resetLongPressGestureDid))
    
    private var timerActive: Bool = false {
        // 타이머의 작동 여부가 변경된 후
        didSet {
            // 타이머가 작동 중이지 않다면
            if !timerActive {
                startButton.backgroundColor = UIColor.systemMint
                startButton.setImage(UIImage(named: "play.pdf"), for: .normal)
            // 타이머가 작동 중이라면
            } else {
                startButton.backgroundColor = UIColor.red
                startButton.setImage(UIImage(named: "pause.pdf"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeUI()
    }
    
    func makeUI() {
        view.backgroundColor = UIColor.systemGray6
        
        timeLabel.text = "0.00"
        timeLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 120)
        timeLabel.textAlignment = .center
        timeLabel.isUserInteractionEnabled = true
        timeLabel.addGestureRecognizer(resetLongPressGesture)
        
        startButton.backgroundColor = UIColor.systemMint
        startButton.setImage(UIImage(named: "play.pdf"), for: .normal)
        startButton.layer.masksToBounds = false
        startButton.layer.cornerRadius = startButton.frame.size.width / 2
        startButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        startButton.layer.shadowRadius = 7.0
        startButton.layer.shadowOpacity = 1.0
        startButton.layer.shadowColor = UIColor.gray.cgColor
        
        resetButton.tintColor = UIColor.orange
        
        resetLongPressGesture.minimumPressDuration = 0.5
        resetLongPressGesture.delaysTouchesBegan = true
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if !timerActive {
            startTimer()
        } else {
            stopTimer(reset: false)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        stopTimer(reset: true)
    }
    
}

extension ViewController {
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
        timer?.tolerance = 0.01 // 타이머의 정확도(낮을수록 정확해짐)
        timerActive = true
        
        resetButton.isEnabled = false
        
        animateStartButtonPressed()
    }
    
    @objc func updateTimer() {
        timerValue += timeInterval
    }
    
    func stopTimer(reset: Bool) {
        timer?.invalidate()
        timerActive = false
        
        if reset {
            timerValue = 0.0
            timeLabel.text = "0.00"
        } else {
            animateStartButtonPressed()
        }
        
        resetButton.isEnabled = true
    }
    
    func animateStartButtonPressed() {
        // 버튼의 크기를 1.2배로 키우고
        startButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        // 스프링 애니메이션 효과를 적옹해
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 10.0,
            initialSpringVelocity: 4.0,
            options: .allowUserInteraction) {
                // 버튼의 크기를 원래대로 되돌리기
                self.startButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func resetLongPressGestureDid() {
        stopTimer(reset: true)
    }
}

