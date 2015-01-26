###
 * Tests the SrtPacket model
###

_ = require 'underscore'
SrtPacket = require '../src/scripts/SrtPacket'

describe 'SrtPacket model', ->
	packet = null

	beforeEach ->
		packet = new SrtPacket(1, 1, 'subtitle')
		packet.setMarkers(10, 15)

	afterEach -> packet = null

	it 'should exist', ->
		expect(packet).to.exist

	it 'should set object properties upon instantiation', ->
		expect(packet.getChapter()).to.equal 1
		expect(packet.getIndex()).to.equal 1
		expect(packet.getStart()).to.equal 10
		expect(packet.getEnd()).to.equal 15
		expect(packet.getText()).to.equal 'subtitle'

	it 'should throw an Error if the start marker exceeds the end marker', ->
		badCall = _.bind(packet.setMarkers, packet, 15, 10)
		expect(badCall).to.throw(Error)
