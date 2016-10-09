_ = require 'lodash'

scale = [
  1       #0
  16/15   #1  16/15
  5/4     #2  
  4/3     #3
  3/2     #4
  5/3     #5
  16/9    #6
]

progression = []


note = (note, octave) ->

  chordItem =
    note: note
    octave: octave

  chordItem

initialChord = [
  note 0, 0
  note 4, 0
  note 2, 1
]


transpose = (chord, amount) ->

  if (typeof amount ) is 'number'
    _.map chord, (item) ->
      item.note += amount

      if item.note > (scale.length - 1)
        item.octave += item.note // 7
        item.note = item.note % 7
        item.note = Math.abs item.note

      item

  else
  
    for chordItem in amount
      chord[chordItem] += amount[chordItem]

    chord



# console.log initialChord

# initialChord = transpose initialChord, 1

# console.log initialChord


# initialChord = transpose initialChord, 2

# console.log initialChord

invert = (chord, center) ->

  _.map chord, (item) ->

    

#     numberOfItem    = item.note + (scale.length * item.octave)
#     numberOfCenter  = center + (scale.length * item.octave)


#     distanceFromCenter = numberOfItem - numberOfCenter
#     inversionBottom    = numberOfCenter - distanceFromCenter
#     inversionTop       = inversionBottom + scale.length

#     console.log distanceFromCenter, inversionBottom, inversionTop

#     distanceToInversionTop    = numberOfItem - inversionTop
#     distanceToInversionBottom = numberOfItem - inversionBottom


#     if (Math.abs distanceToInversionBottom) > (Math.abs distanceToInversionTop)
#       numberOfItem += distanceToInversionTop
#     else
#       numberOfItem += distanceToInversionBottom

#     item.note = numberOfItem % scale.length
#     item.octave = numberOfItem // scale.length

#     item
      
# console.log initialChord
# console.log 'INVERSION'
# console.log invert initialChord, 0