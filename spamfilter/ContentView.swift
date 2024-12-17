import SwiftUI
import CoreML

struct ContentView: View {
    @State private var message: String = ""
    @State private var result: String = ""
    @State private var resultColor: Color = .black

    // CoreML 모델 인스턴스 생성
    let model = try! SpamClassifier(configuration: MLModelConfiguration())
    
    var body: some View {
        VStack(spacing: 20) {
            Text("스팸 분류기 (CoreML)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            TextField("메시지를 입력하세요", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: analyzeMessage) {
                Text("분석하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Text(result)
                .font(.title2)
                .foregroundColor(resultColor)
                .padding()
            
            Spacer()
        }
    }
    
    func analyzeMessage() {
        guard !message.isEmpty else {
            result = "메시지를 입력해주세요."
            resultColor = .gray
            return
        }
        
        do {
            // CoreML 모델을 사용해 예측
            let prediction = try model.prediction(text: message)
            if prediction.label == "spam" {
                result = "🚨 스팸입니다!"
                resultColor = .red
            } else {
                result = "✅ 정상 메시지입니다."
                resultColor = .green
            }
        } catch {
            result = "⚠️ 예측 실패: \(error.localizedDescription)"
            resultColor = .orange
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
