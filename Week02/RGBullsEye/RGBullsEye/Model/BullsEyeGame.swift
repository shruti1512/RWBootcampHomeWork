struct BullsEyeGame {
    
    private static func randomRGBGenerator(in range: CountableClosedRange<Int>) -> RGB {
      return RGB(r: Int.random(in: range), g: Int.random(in: range), b: Int.random(in: range))
    }

    //only the setter is private!
    private(set) var targetValue = RGB()
    private(set) var round = 0
    private(set) var gameScore = 0
    private(set) var roundScore = 0

    mutating func startNewRound() {
        round += 1
        targetValue = BullsEyeGame.randomRGBGenerator(in: 0...255)
    }
     
    mutating func startNewGame() {
        roundScore = 0
        gameScore = 0
        round = 0
        startNewRound()
    }
    
    mutating func calculateRoundScore(for guessValue: RGB) {
        let difference = abs(guessValue.difference(target: targetValue))
        roundScore = 100 - difference
    }
    
    mutating func addBonus(points: Int) {
        roundScore += points
    }
    
    mutating func calculateGameScore() {
        gameScore +=  roundScore
    }
}
