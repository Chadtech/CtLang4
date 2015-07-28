fs = require 'fs'
_  = require 'lodash'


beginningOfWordCharacters = require './beginning-of-word-characters.coffee'
operatorCharacters        = require './operator-characters.coffee'

ctLangFourFile    = process.argv[2]
ctLangFourProgram = fs.readFileSync ctLangFourFile, 'utf8'


stringSplice = (string, index, count, add) ->
  string.slice(0, index) + (add or "") + string.slice(index + count)


line  = ''
lines = []
for character in ctLangFourProgram

  if character isnt '\n'
    line += character

  else
    lines.push line
    line = ''


lines = _.map lines, (line) ->
  thisLine =
    content: line

  numberOfSpaces = 0
  characterIndex = 0
  while line[ characterIndex ] is ' '
    numberOfSpaces++
    characterIndex++

  thisLine.indentationNumber: numberOfSpaces // 2


outputGoFile            = ''
outputLine              = ''
currentIndetationNumber = 0
keepLooking             = true
while keepLooking
  keepLooking = false

  for line in lines
    indentationNumber = line.indentationNumber
    line = line.content

    if (line.indexOf '->') isnt -1
      keepLooking = true

      outputLine += 'func '

      indexOfFirstParen     = line.indexOf '('
      indexOfSecondParen    = line.indexOf ')'
      indexOfFunctionArrow  = line.indexOf '->'

      outputLine += line.substring 0, indexOfFirstParen
      outputLine += line.substring indexOfFirstParen, indexOfSecondParen
      outputLine += ' '
      outputLine += line.substring indexOfSecondParen, indexOfFunctionArrow
      outputLine += '{'

      line       = outputLine
      outputLine = ''

    if (line.indexOf ' is ') isnt -1
      keepLooking = true
      line = stringSplice line, (line.indexOf ' is '), 4, ' == '

    if (line.indexOf ' isnt ') isnt -1
      keepLooking = true
      line = stringSplice line, (line.indexOf ' isnt '), 6, ' != '

    if (line.indexOf ' not ') isnt -1
      keepLooking = true
      line = stringSplice line, (line.indexOf ' not '), 5, ' !'

    if (line.indexOf 'if ') isnt -1
      if (line.indexOf 'if (') is -1
        indexOfIf = line.indexOf 'if'
        if (indexOfIf is 0) or (line[indexOfIf - 1] is ' ')
          keepLooking = true

          line = stringSplice line, line.indexOf 'if ', 3, 'if ('
          line = line + ') {'

# LLVM
# Tokenizing

    searchForFunction = true
    functionFound     = false
    characterIndex    = 1
    while searchForFunction 
      character     = line[ characterIndex ]
      leftNeighbor  = line[ characterIndex - 1 ]
      rightNeighbor = line[ characterIndex + 1 ]

      if character is ' '
        leftNeighborIsFunction  = not (leftNeighbor in operatorCharacters)
        rigtNeighorIsArgument   = rightNeighbor in beginningOfWordCharacters

        if leftNeighborIsFunction and rigtNeighorIsArgument

          functionFound = true
          searchForFunction = false

      characterIndex++

      if characterIndex is (line.length - 2)
        searchForFunction = false



    if functionFound
      collectArguments         = true
      argumentsForThisFunction = []
      thisArgument             = ''
      outputLine               = ''
      outputLine               += line.substring 0, (characterIndex - 1)
      outputLine               += '('
      nextCharacterIndex       = 1

      while collectArguments
        thisCharacter = line[ characterIndex + nextCharacterIndex ]

        if thisCharacter is ','




    # for characterIndex in [1 .. (line.length - 2)] by 1
    #   character = line[ characterIndex ]
      
    #   if 


      # doubleQuoteSwitchFirst = false
      # singleQuoteSwitchFirst = false

      # if character is '"' then doubleQuoteSwitchFirst = true
      # if character is "'" then singleQuoteSwitchFirst = true


      # if not (doubleQuoteSwitchFirst or singleQuoteSwitchFirst)
      #   if character is ' '
      #     leftNeighbor  = line[ characterIndex - 1]
      #     rightNeighbor = line[ characterIndex + 1]

      #     rightCharacterIsArgument = rightNeighbor in beginningOfWordCharacters
      #     leftCharacterIsFunction  = not (leftNeighbor in operatorCharacters)

      #     if rightCharacterIsArgument and leftCharacterIsFunction
      #       line[ characterIndex ] = '('





            # keepHuntingForThatFunctionsEnd  = true
            # numberOfNewFunctionsFound       = 0
            # doubleQuoteSwitchSecond         = false
            # singleQuoteSwitchSecond         = false
            # secondCharacterIndex            = 0
            # while keepHuntingForThatFunctionsEnd
            #   nextCharacter = line[ characterIndex + secondCharacterIndex ]

            #   if nextCharacter is '"' then doubleQuoteSwitchSecond = not doubleQuoteSwitchSecond
            #   if nextCharacter is "'" then singleQuoteSwitchSecond = not singleQuoteSwitchSecond

            #   if (not doubleQuoteSwitchSecond) and (not singleQuoteSwitchSecond)

            #     if nextCharacter is ' '

            #       nextLeftNeighbor = line[ characterIndex + secondCharacterIndex - 1 ]
            #       nextRightNeighbor = line[ characterIndex + secondCharacterIndex + 1 ]

            #       if not (nextLeftNeighbor is ',')



      #             nextRightNeighborIsArgument = nextRightNeighbor in beginningOfWordCharacters
      #             nextLeftNeighborIsFunction  = not (nextLeftNeighbor) in operatorCharacters 

      #             if nextRightNeighborIsArgument and nextLeftNeighborIsFunction

      #               numberOfNewFunctionsFound++
