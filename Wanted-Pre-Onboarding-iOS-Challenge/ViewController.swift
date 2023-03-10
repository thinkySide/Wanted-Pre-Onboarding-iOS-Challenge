//
//  ViewController.swift
//  Wanted-Pre-Onboarding-iOS-Challenge
//
//  Created by 김민준 on 2023/02/23.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Variable
    
    // 현재 클릭한 UIStackview의 Index
    var currentIndex = 0
    
    // 구글드라이브 (구글 드라이브에 업로드한 이미지 다운로드)
    let googleImageURL = [
        "https://drive.google.com/uc?export=download&id=1F8orTckEM8vRhrqDQZu3Ycsde9H5BA7A",
        "https://drive.google.com/uc?export=download&id=15GktXfKtJuJl-nJeKPExcf11QlIlHCXA",
        "https://drive.google.com/uc?export=download&id=1FstKka8HKQQuM_YgOv5LCVVWMANCVsTm",
        "https://drive.google.com/uc?export=download&id=10DaqhTjlC9bW7VMgQQXBDGRJ-giGsvPf",
        "https://drive.google.com/uc?export=download&id=1YCxh8tYfYAwrRJbILzTotxHotEOO3pHh"
    ]
    
    // github에 올린 이미지 (일반 이미지 URL)
    let imageURL = [
        "https://user-images.githubusercontent.com/113565086/221188226-8f43302e-7efc-42d4-b503-17586fc33fd1.png",
        "https://user-images.githubusercontent.com/113565086/221188316-1ddb92e1-d09d-4dc7-b764-f582fb78d7de.png",
        "https://user-images.githubusercontent.com/113565086/221188430-42d0dcb1-a5cb-4e6d-8699-8589f33fab0f.png",
        "https://user-images.githubusercontent.com/113565086/221188366-e1f0a91b-258d-412f-a105-1e0969fe06c8.png",
        "https://user-images.githubusercontent.com/113565086/221188490-88702dcc-4be2-496a-8f0d-a702b39efa62.png"
    ]
    
    // MARK: - IBOutlet
    @IBOutlet weak var superStackView: UIStackView!
    
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - IBAction
    @IBAction func loadButtonTapped(_ sender: UIButton) {
        
        // 컴포넌트 잡기
        guard
            let stackView = sender.superview as? UIStackView,
            let imageView = stackView.arrangedSubviews[0] as? UIImageView
        else { return }
        
        // 이미지 초기화
        imageView.image = UIImage(systemName: "photo.fill")
        
        // 내가 클릭한 StackView의 Index 구하기
        for (index, stackView) in superStackView.arrangedSubviews.enumerated() {
            if let clickedStackView = stackView as? UIStackView, clickedStackView.arrangedSubviews[2] == sender {
                currentIndex = index
                break
            }
        }
        imageUpdate(imageView: imageView)
    }
    
    @IBAction func loadAllImageButtonTapped(_ sender: UIButton) {
        
        for (index, stackView) in superStackView.arrangedSubviews.enumerated() {
            if let subStackView = stackView as? UIStackView, let imageView = subStackView.arrangedSubviews[0] as? UIImageView {
                
                // 이미지 초기화
                imageView.image = UIImage(systemName: "photo.fill")
                currentIndex = index
                
                // 모든 이미지 다운로드 대기열에 올리기
                DispatchQueue.global().sync { [weak self] in
                    guard let self = self else { return }
                    self.imageUpdate(imageView: imageView)
                }
            }
        }
    }
    
    
    // MARK: - Function
    func imageUpdate(imageView: UIImageView) {
        
        // 현재 선택된 index의 이미지 URL
        guard let url = URL(string: imageURL[currentIndex]) else { return }
        
        // URLSession
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // 에러 확인
            guard error == nil else {
                print("에러가 발생했습니다.: \(error!.localizedDescription)")
                return
            }
            
            // 데이터 확인
            guard let data = data else {
                print("데이터를 전달 받지 못했습니다.")
                return
            }
            
            // 이미지 데이터 생성
            let image = UIImage(data: data)
            
            // 이미지 업데이트
            DispatchQueue.main.async { // ⭐️ UI업데이트는 main queue에서 진행
                print("이미지 업데이트 진행")
                imageView.image = image
            }
            
        }.resume()
        
    }
}

