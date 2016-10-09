package main

import (
    // "bufio"
    "fmt"
    // "io"
    // "io/ioutil"
    // "strconv"
    "os"
    // "math"
)

func check(e error){
  if e != nil {
    panic(e)
  }
}

func isALetter( character string ) bool {
  isALetter := false

  switch character {
    case "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z":
      isALetter = true
  }

  return isALetter
}

func main() {
  
  functionDenoter := " ->"
  whatsHappening := "nothing"


  ctFourFileName := os.Args[1]

  ctFourFile, err := os.Open(ctFourFileName)
  check(err)

  stat, err := ctFourFile.Stat()
  check(err)
  fileLength := int(stat.Size())

  ctFourProgram := ""

  for charIndex := 0; charIndex < fileLength; charIndex++ {
    thisCharAsByte := make([]byte, 1)
    ctFourFile.Read(thisCharAsByte)

    thisChar := string(thisCharAsByte)

    ctFourProgram += thisChar 
  }


  currentWord := ""
  words := make([]string, 10)
  var wordIndex int = 0

  for charIndex := 0; charIndex < fileLength; charIndex++ {

    thisChar := string(ctFourProgram[charIndex])

    fmt.Println(thisChar)

    if isALetter(thisChar){
      currentWord += thisChar
    } else {

      switch thisChar {
        
        case " ":
          words[wordIndex] = currentWord
          wordIndex++
          currentWord = ""

        case "(":
          
          afterParenIndex := 0
          keepLooking := true

          for keepLooking {

            if (ctFourProgram[ charIndex + afterParenIndex ] != ")") {
              afterParenIndex++
            } else { 

              whatsActuallyThere := ""

              whatsActuallyThere += ctFourProgram[ charIndex + afterParenIndex + 1 ]
              whatsActuallyThere += ctFourProgram[ charIndex + afterParenIndex + 2 ]
              whatsActuallyThere += ctFourProgram[ charIndex + afterParenIndex + 3 ]

              if (whatsActuallyThere == functionDenoter) {
                whatsHappening = "func getting delcared"
              }

              keepLooking = false
            }
          }
      }
    }
  }

  // firstByte := make([]byte, 1)
  // ctFourFile.Read(firstByte)


  // currentWord := ""

  // currentWord += "Ye"

  // fmt.Println(currentWord)

}