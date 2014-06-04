var i = 4

var numbers = [2, 4, 8]

var result = numbers.map({number in 2*number})

result
var list = [2, 5, 1, 12, 8]

list.sort({(number: Int, number2: Int) -> Bool in
    if number > number2 {
      return true
    }
    return false
    })
