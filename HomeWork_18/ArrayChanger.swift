import Foundation

class ArrayChanger {
    var data: [Int]
    
    init(data: [Int]) {
        self.data = data
    }
    
    func sorter() -> ArrayChanger {
        data.sort()
        return self
    }
    
    func min() -> Int? {
        return data.min()
    }
    
    func max() -> Int? {
        return data.max()
    }
    
    func contain(_ a: Int) -> Int? {
        return data.contains(a) ? a : nil
    }
    
    func sum() -> Int {
        return data.reduce(0, +)
    }

}

func GCD_After(_ seconds: Double, perform: @escaping () -> ()) {
    let delayTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        perform()
    }
}
