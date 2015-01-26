###
 * @class SrtPacket
###

module.exports =
	class SrtPacket
		chapter: null
		index: null
		endMarker: -1
		startMarker: -1
		text: ''

		constructor: (@chapter, @index, @text) ->

		getEnd: -> @endMarker

		getStart: -> @startMarker

		setMarkers: (@startMarker, @endMarker) ->
			throw new Error('Start marker cannot exceed end marker') if @startMarker > @endMarker

		getChapter: -> @chapter

		getIndex: -> @index

		getText: -> @text
