fs                = require 'fs'
_                 = require 'lodash'
complexGlyphChars = require './complex-glyph-chars.coffee'
scoperChars       = ['\t', '\n']
syntactChars      = require './syntacts.coffee'

ctFourFile    = process.argv[2]
ctFourProgram = fs.readFileSync ctFourFile, 'utf8'

eachBlock = []

stringSplice = (string, index, count, add) ->
  string.slice(0, index) + (add or "") + string.slice(index + count)

typeOfStringInPossessionOf = (char) ->
  isAComplexGlyph = char in complexGlyphChars
  isAScoper       = char in scoperChars

  if isAComplexGlyph
    return 'word'
  if isAScoper
    return 'scoper'
  if (not isAComplexGlyph) and (not isAScoper)
    return 'syntact'
    

thisString =
  content: ''
  type:    typeOfStringInPossessionOf ctFourProgram[0]


for character in ctFourProgram

  switch thisString.type 

    when 'word'

      if character in complexGlyphChars

        thisString.content += character

      else

        eachBlock.push _.clone thisString, true
        thisString =
          content: character
          type:    typeOfStringInPossessionOf character

    when 'scoper'

      if character in scoperChars

        thisString.content += character

      else

        eachBlock.push _.clone thisString, true
        thisString =
          content: character
          type:    typeOfStringInPossessionOf character

    when 'syntact'

      isAComplexGlyph = character in complexGlyphChars
      isAScoper       = character in scoperChars

      if (not isAComplexGlyph) and (not isAScoper)

        thisString.content += character

      else

        eachBlock.push _.clone thisString, true
        thisString =
          content: character
          type:    typeOfStringInPossessionOf character


lines = []
blockInLine = ''

for block in eachBlock

  if block.content[0] is '\n'

    lines.push blockInLine
    blockInLine = ''

  else

    blockInLine += block.content

lines.push blockInLine

console.log lines

lines = _.map lines, (line) ->
  numberOfSpaces = 0
  charIndex      = 0
  while line[ charIndex ] is ' '
    numberOfSpaces++
    charIndex++

  thisLine =
    content:           line.substring numberOfSpaces      
    indentationNumber: numberOfSpaces // 2

  thisLine


outputGoFile            = ''
outputLine              = ''
currentIdentationNumber = 0
keepLooking             = true

while keepLooking

  keepLooking = false

  for line in lines

    if (line.content.indexOf '->') isnt -1
      keepLooking = true

      outputLine += 'func '

      indexOfFirstParen     = line.content.indexOf '('
      indexOfSecondParen    = line.content.indexOf ')'
      indexOfFunctionArrow  = line.content.indexOf '->'

      outputLine += line.content.substring 0, indexOfFirstParen
      outputLine += line.content.substring indexOfFirstParen, indexOfSecondParen
      outputLine += ' '
      outputLine += line.content.substring indexOfSecondParen, indexOfFunctionArrow
      outputLine += '{'

      # outputGoFile += outputLine
      line.content = outputLine
      outputLine   = ''

    if ((line.content.indexOf ' is ') isnt -1)
      keepLooking = true

      line.content = stringSplice line.content, (line.content.indexOf ' is '), 4, ' == '
      outputLine  += line.content

    if ((line.content.indexOf ' isnt ') isnt -1)
      keepLooking = true

      line.content = stringSplice line.content, (line.content.indexOf ' isnt '), 6, ' != '
      outputLine  += line.content

    if ((line.content.indexOf ' not ') isnt -1 )
      keepLooking = true

      line.content = stringSplice line.content, (line.content.indexOf ' not '), 5, ' !'
      outputLine  += line.content

    if ((line.content.indexOf 'if ') isnt -1)
      if ((line.content.indexOf 'if (') is -1)
        indexOfIf = line.content.indexOf 'if'
        if (indexOfIf is 0) or (line.content[indexOfIf - 1] is ' ')

          keepLooking = true

          line.content = stringSplice line.content, (line.content.indexOf 'if '), 3, 'if ('
          line.content = line.content + ') {'

          outputLine  += line.content

    for charIndex in [1 .. (line.content.length - 2)] by 1


      character     = line.content[ charIndex ]

      doubleQuoteSwitchFirst = false
      singleQuoteSwitchFirst = false

      if character is '"' then doubleQuoteSwitchFirst = true
      if character is "'" then singleQuoteSwitchFirst = true

      if not (doubleQuoteSwitchFirst or singleQuoteSwitchFirst)

        if character is ' '

          leftNeighbor  = line.content[ charIndex - 1 ]
          RightNeighbor = line.content[ charIndex + 1 ]

          leftIsVariableChar  = not (leftNeighbor in syntactChars)
          rightIsVariableChar = not (RightNeighbor in syntactChars)

          if leftIsVariableChar and rightIsVariableChar
            line.content[ charIndex ] = '('

            keepHuntingForThatFunctionsEnd = true
            numberOfNewFunctionsFound      = 0
            doubleQuoteSwitch              = false
            singleQuoteSwitch              = false
            secondCharIndex                = 0
            while keepHuntingForThatFunctionsEnd

              nextCharacter = line.content[ charIndex + secondCharIndex ]

              if nextCharacter is '"' then doubleQuoteSwitch = not doubleQuoteSwitch
              if nextCharacter is "'" then singleQuoteSwitch = not singleQuoteSwitch

              if (not doubleQuoteSwitch) and (not singleQuoteSwitch)

                if nextCharacter is ' '

                  nextLeftNeighbor  = line.content[ charIndex + secondCharIndex - 1 ]
                  nextRightNeighbor = line.content[ charIndex + secondCharIndex + 1 ]

                  nextLeftIsVariableChar  = not (nextLeftNeighbor in syntactChars)
                  nextRightIsVariableChar = not (nextRightNeighbor in syntactChars)

                  if nextRightIsVariableChar and nextLeftIsVariableChar




previousIndentNumber = 0
for line in lines

  if line.indentationNumber < previousIndentNumber

    indents = ''
    for indent in [0.. (line.indentationNumber - 1)] by 1
      indents += '  '

    outputGoFile += '\n' + indents + '}'
  
  previousIndentNumber = line.indentationNumber

  indents = ''
  for indent in [0.. (line.indentationNumber - 1)] by 1
    indents += '  '

  outputGoFile += '\n' + indents + line.content


for indent in [0.. (previousIndentNumber - 1)] by 1
  indents = ''

  for anotherIndent in [0.. (indent - 1)] by 1
    indents += '  ' 

  outputGoFile += '\n' + indents + '}'


console.log outputGoFile


