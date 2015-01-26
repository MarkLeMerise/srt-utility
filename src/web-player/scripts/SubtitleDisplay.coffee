$ = require 'browserify-zepto'
SrtFileParser = require '../../scripts/SrtFileParser'
SrtPlayer = require '../../scripts/SrtPlayer'

module.exports =
	class SubtitleDisplay
		player: null

		constructor: ->
			@player = new SrtPlayer

			$('#start-playback').on('click', @player.start.bind(@player))
			$('#stop-playback').on('click', @player.stop.bind(@player))
			$('#srt-input').on('change', @setSource.bind(@))

			if @player
				@player.on('packet', @showSubtitle, @)
				@player.on('void', @clearDisplay, @)


		###
		 * [showSubtitle description]
		 * @param  {[type]} event [description]
		###
		showSubtitle: (event) ->
			packet = event.packet

			$('#srt-playback').html(packet.getText())
			console.log("Playing subtitle at chapter #{ packet.getChapter() }, index #{ packet.getIndex() }")


		###
		 * [clearDisplay description]
		 * @return {[type]} [description]
		###
		clearDisplay: -> $('#srt-playback').text('')


		###
		 * [setSource description]
		 * @param {[type]} event [description]
		###
		setSource: (event) ->
			srtFr = new SrtFileParser
			srtFile = event.target.files[0]

			return unless srtFile

			srtFr.readFile(srtFile).then((srtFile) => @player.setSource(srtFile))
