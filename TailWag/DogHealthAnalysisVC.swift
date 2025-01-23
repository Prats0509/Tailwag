//
//  DogHealthAnalysisVC.swift
//  TailWag
//


import UIKit

class DogHealthAnalysisVC: UIViewController {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var analyzeButton: UIButton!

    
    var dogName: String?
    var dogAge: Int?
    var dogWeight: Double?
    var breed: String?
    var healthIssues: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDogInfo()
    }
    
    
    private func displayDogInfo() {
        resultLabel.text = """
        Dog Name: \(dogName ?? "N/A")
        Age: \(dogAge ?? 0) years
        Weight: \(dogWeight ?? 0.0) kg
        Breed: \(breed ?? "N/A")
        Health Issues: \(healthIssues ?? "None")
        """
    }
    
    @IBAction func analyzeButtonTapped(_ sender: UIButton) {
        guard let age = dogAge, let weight = dogWeight else {
                adviceLabel.text = "Insufficient data for analysis."
                return
            }
            
            // Call GPT API for analysis
            callChatGPTAPI(age: age, weight: weight, breed: breed, healthIssues: healthIssues)
    }
    
    @IBAction func mainMenuTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMainMenuFromAnalysis", sender: self)
    }
    
    private func callChatGPTAPI(age: Int, weight: Double, breed: String?, healthIssues: String?) {
        let apiKey="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"
        let apiURL = "https://api.openai.com/v1/chat/completions"
        
        
        let prompt = """
        Analyze the health of a dog based on the following details:
        Dog Name: \(dogName ?? "N/A")
        Age: \(age) years
        Weight: \(weight) kg
        Breed: \(breed ?? "Unknown")
        Health Issues: \(healthIssues ?? "None")
        Provide insights and health advice in 500 tokens.
        """
        print("Prompt: \(prompt)")
        
        let parameters: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": "You are an expert in dog health analysis."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 500,
            "temperature": 0.3
        ]
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            adviceLabel.text = "Failed to prepare request."
            return
        }
        
        
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.adviceLabel.text = "Failed to get a response from the AI. Try again later."
                }
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status: \(httpResponse.statusCode)")
            }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(jsonString)")
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.adviceLabel.text = "No data received from the server."
                }

                print("Error: No data received.")
                return
            }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]] {
                print("Parsed Choices: \(choices)")
                
                if let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    DispatchQueue.main.async {
                        self?.adviceLabel.text = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.adviceLabel.text = "Unexpected response format."
                    }
                    print("Error: Unexpected response format in message.")
                }
            } else {
                DispatchQueue.main.async {
                    self?.adviceLabel.text = "Unexpected response format."
                }
                print("Error: Unexpected response format in choices.")
            }
        }
        
        task.resume()
    }
}
