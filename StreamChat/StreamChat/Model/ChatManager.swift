
import Foundation

class ChatManager: NSObject {
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    func connectSocket() {
        Stream.getStreamsToHost(withName: Host.address, port: Host.port, inputStream: &inputStream, outputStream: &outputStream)
        
        guard let inputStream = self.inputStream,
              let outputStream = self.outputStream else {
            return
        }
        
        let runLoop = RunLoop.current
        inputStream.schedule(in: runLoop, forMode: .default)
        outputStream.schedule(in: runLoop, forMode: .default)
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.open()
        outputStream.open()
    }
    
    func join(with client: Client) {
        let joinMessage = CommunicationMessage.join(client.nickname).description
        guard let data = joinMessage.data(using: .utf8) else {
            return
        }
        
        writeOnOutputStream(with: data)
    }
    
    func send(message: String) {
        let sendingMessage = CommunicationMessage.send(message).description
        guard let data = sendingMessage.data(using: .utf8) else {
            return
        }
        
        writeOnOutputStream(with: data)
    }
    
    func closeSocket() {
        guard let inputStream = self.inputStream,
              let outputStream = self.outputStream else {
            return
        }
        
        inputStream.close()
        outputStream.close()
    }
}
extension ChatManager: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            let iStream  =  aStream as! InputStream
            let bufferSize = 300
            var buffer = [UInt8](repeating: 0, count: bufferSize)
            iStream.read(&buffer, maxLength: bufferSize)
            let msg = String(bytes: buffer, encoding: .utf8)
            print(msg)
        case .endEncountered:
            closeSocket()
        default:
            print("some other event...")
        }
    }
}
extension ChatManager {
    private func writeOnOutputStream(with data: Data) {
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error")
                return
            }
            
            if let outputStream = self.outputStream {
                outputStream.write(pointer, maxLength: data.count)
            }
        }
    }
}

