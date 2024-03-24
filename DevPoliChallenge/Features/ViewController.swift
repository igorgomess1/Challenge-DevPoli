import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let label: UILabel = {
            let label = UILabel()
            label.text = "MARINA EU TE AMOOOOO❤️"
            label.backgroundColor = .white
            return label
        }()
        
        view.addSubview(label)
    }

}

