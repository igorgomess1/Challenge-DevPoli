import AVFoundation
import UIKit
import SnapKit

final class VoiceRecordingViewController: ViewController<VoiceRecordingInteracting, UIView> {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var isRecording = false
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var startRecordingAudio: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Gravar", for: .normal)
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
                button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()

        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Permissão concedida")
            } else {
                print("Permissão negada")
            }
        }
    }

    
    override func buildViewHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(startRecordingAudio)
        stackView.addArrangedSubview(playButton)
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func configureViews() {
        view.backgroundColor = .white
    }
}

private extension VoiceRecordingViewController {
    @objc
    func recordButtonTapped() {
        if isRecording {
            stopRecording()
            startRecordingAudio.setTitle("Gravar", for: .normal)
            playButton.isEnabled = true
        } else {
            startRecording()
            startRecordingAudio.setTitle("Parar", for: .normal)
            playButton.isEnabled = false
        }
        
        isRecording.toggle()
    }
    
    @objc func playButtonTapped() {
        playAudio()
    }
    
    func playAudio() {
        let audioFileURL = getAudioFileURL()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.play()
        } catch {
            print("Erro ao reproduzir áudio: \(error)")
        }
    }
    
    func startRecording() {
        setupAudioRecorder()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            audioRecorder?.record()
        } catch {
            print("Erro ao iniciar gravação: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print("Erro ao parar a gravação \(error)")
        }
    }
    
    func setupAudioRecorder() {
        let settings: [String: Any] = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 12000,
            AVNumberOfChannelsKey : 1,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: getAudioFileURL(), settings: settings)
            audioRecorder?.delegate = self
        } catch {
            print("Erro ao configurar gravador: \(error)")
        }
    }
    
    func getAudioFileURL() -> URL {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return filePath.appendingPathComponent("recording.m4a")
    }
}

extension VoiceRecordingViewController: AVAudioRecorderDelegate {
    
}
