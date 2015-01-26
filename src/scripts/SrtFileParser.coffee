###
 * @class SrtFileParser
###

newline = require 'newline'
SrtPacket = require './SrtPacket'
SrtFile = require './SrtFile'

module.exports =
	class SrtFileParser
		lineBreakFormats:
			CRLF: '\r\n'
			LF: '\n'


		###
		 * Parses and converts an SRT-style timestamp HH:MM:SS,sss into its equivalent in milliseconds
		 * @param  {String} timestamp  	The SRT-formatted timestamp
		 * @return {Number}      		Integer time in milliseconds
		###
		convertTimeToMs: (timestamp) ->
			# Format is HH:MM:SS,sss
			units = timestamp.split(':')

			# Seconds and milliseconds are separated by a comma (French)
			# Add the milliseconds as a separate entry on the end of the array
			secAndMs = units[2].split(',')
			units.splice(2)
			units.push(secAndMs[0])
			units.push(secAndMs[1])

			# Convert everything to integers
			units = (parseInt(unit) for unit in units)

			return ((units[0] * 60 * 60 * 1000) +
			(units[1] * 60 * 1000) +
			(units[2] * 1000) +
			units[3])


		###
		 * Parses a packet's duration into a start and end timestamp
		 * @param  {String} duration  The SRT-style duration
		 * @return {Object}           Start and end times
		###
		parseDuration: (duration) ->
			times = duration.split(' --> ')

			return {
				start: @convertTimeToMs(times[0])
				end: @convertTimeToMs(times[1])
			}


		###
		 * Parses an SRT file string into an SrtFile object
		 * @param  {String} source  The SRT file source text
		 * @return {SrtFile}
		###
		parsePackets: (source) ->
			lineBreakFormat = newline.detect(source)

			if lineBreakFormat of @lineBreakFormats
				lineEnd = @lineBreakFormats[lineBreakFormat]
			else
				console.log('Could not detect line break format.')
				return

			srtSource = source.split(lineEnd + lineEnd)
			srtPackets = []
			currentChapter = 1
			previousIdx = 0

			srtPackets =
				for packet in srtSource
					rawPacket = packet.split(lineEnd)

					# Don't parse this packet if it doesn't have the required pieces
					continue if rawPacket.length < 3

					# Sometimes, there are 4 or more line breaks between chapters and it will add an extra element
					rawPacket.splice(0, 1) unless rawPacket[0]

					# Increment the chapter counter if the current index is less than the last
					idx = parseInt(rawPacket[0])
					currentChapter++ if idx <= previousIdx
					previousIdx = idx

					# Add a line break if there are multiple lines
					srtText =
						if rawPacket.length is 3
							rawPacket[2]
						else
							rawPacket.splice(2).join('<br>')

					newPacket = new SrtPacket(currentChapter, idx, srtText)
					markers = @parseDuration(rawPacket[1])
					newPacket.setMarkers(markers.start, markers.end)

					newPacket

			return new SrtFile(srtPackets)


		###
		 * Reads an SRT file and returns an SrtFile object upon Promise resolution
		 * @async
		 * @param  {File} file The File object
		 * @return {Promise}
		###
		readFile: (file) ->
			fr = new FileReader
			fr.readAsText(file, 'UTF-8')

			return new Promise((resolve, reject) =>
				fr.onload = =>
					return reject(fr.error) unless fr.result
					resolve(@parsePackets(fr.result))
			)

