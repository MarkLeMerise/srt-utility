###
 * Tests the SrtFileParser
###

SrtFileParser = require '../src/scripts/SrtFileParser'
SrtFile = require '../src/scripts/SrtFile'
fs = require 'fs'

describe 'SrtFileParser', ->
	this.timeout(0)

	reader = null

	beforeEach -> reader = new SrtFileParser

	afterEach -> reader = null


	it 'should exist', -> expect(reader).to.exist


	it 'should read a file', ->
		srtSrc = fs.readFileSync(__dirname + '/fixtures/nixLf.srt')
		srtPromise = reader.readFile(new File([srtSrc], 'nixLf.srt'))

		expect(srtPromise).to.be.an.instanceof(Promise)

		srtPromise.then((srtFile) ->
			expect(srtFile).to.be.an.instanceof(SrtFile)
			expect(srtFile.getPackets()).to.have.length 818
			expect(srtFile.getLastTimestamp()).to.be.equal 2520978
		)
