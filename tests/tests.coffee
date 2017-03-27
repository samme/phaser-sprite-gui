"use strict"

{expect} = chai

DEFAULT_IMAGE = "__default"
IMAGE =
  key: "../example/assets/droid.png"
SPRITESHEET =
  key: "../example/assets/dude.png"
  width: 32
  height: 48

describe "hooks", ->

  game = null

  before "new game", (done) ->

    game = new Phaser.Game 100, 100, Phaser.HEADLESS
    game.state.add "boot",
      init:   -> game.raf.stop(); Phaser.Canvas.removeFromDOM game.canvas; done()
      create: -> console.log "boot.create"
    game.state.start "boot"

  after "destroy game", ->

    game.destroy()

  afterEach "clear state", ->

    game.state.clearCurrentState()

  describe "window", ->

    it "has dat", ->

      expect(window).to.have.property("dat").that.is.an.object

    it "has Phaser", ->

      expect(window).to.have.property("Phaser").that.is.an.object

    it "has SpriteGUI", ->

      expect(window).to.have.property("SpriteGUI").that.is.a.function

  describe "Phaser", ->

    it "is version 2.6.2", ->

      expect(Phaser).to.have.property("VERSION").that.equals "2.6.2"

  describe "a Sprite", ->

    it "s key is '__default'", ->

      sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
      expect(sprite).to.have.property("key").that.equals "__default"

    it "has a valid texture", ->

      sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
      expect(sprite.texture).to.have.property("valid").that.is.true

    it "has a frame", ->

      sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
      expect(sprite).to.have.property("frame").that.equals 0

    it "has no frameName", ->

      sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
      expect(sprite).to.have.property("frameName").that.is.null

    it "has an Animation Manager", ->

      sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
      expect(sprite).to.have.property("animations").that.is.an.instanceOf Phaser.AnimationManager

    describe "sprite.animations", ->

      it "is loaded", ->

        sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
        expect(sprite.animations).to.have.property("isLoaded").that.is.true

      it "has a frameTotal", ->

        sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
        expect(sprite.animations).to.have.property("frameTotal").that.equals 1

      it "has frame indexes", ->

        sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
        expect(sprite.animations.frameData.getFrameIndexes()).to.be.an("array").with.lengthOf 1

  describe "SpriteGUI", ->

    it "is a function", ->

      expect(SpriteGUI).to.be.a.function

    describe "new SpriteGUI", ->

      it "returns a SpriteGUI instance", ->

        sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
        gui = new SpriteGUI sprite
        expect(gui).to.be.an.instanceOf SpriteGUI
        gui.destroy()

      it "accepts a multi-frame Sprite"

      it "accepts a physics-enabled Sprite", ->

        sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
        game.physics.enable sprite
        expect(sprite.body).to.be.an.instanceOf Phaser.Physics.Arcade.Body
        gui = new SpriteGUI sprite
        expect(gui).to.be.an.instanceOf SpriteGUI
        gui.destroy()

      it "accepts an input-enabled Sprite", ->

        sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
        sprite.inputEnabled = yes
        expect(sprite.input).to.be.an.instanceOf Phaser.InputHandler
        gui = new SpriteGUI sprite
        expect(gui).to.be.an.instanceOf SpriteGUI
        gui.destroy()

      it "might accept an Image", ->

        img = game.add.image 0, 0, DEFAULT_IMAGE
        gui = new SpriteGUI img
        expect(gui).to.be.an.instanceOf SpriteGUI
        gui.destroy()

      it "might accept a TileSprite", ->

        tileSprite = game.add.tileSprite 0, 0, 100, 100, DEFAULT_IMAGE
        gui = new SpriteGUI tileSprite
        expect(gui).to.be.an.instanceOf SpriteGUI
        gui.destroy()

      describe "autoPlace", ->

        it "sets gui.autoPlace", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, {autoPlace: yes}
          expect(gui).to.have.property("autoPlace").that.is.true
          gui.destroy()

        it "sets gui.scrollable", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, {autoPlace: yes}
          expect(gui).to.have.property("scrollable").that.is.true
          gui.destroy()

      describe "autoPlace=false", ->

        it "sets gui.autoPlace", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, {autoPlace: no}
          expect(gui).to.have.property("autoPlace").that.is.false
          gui.destroy()

        it "doesn't set gui.scrollable", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, {autoPlace: no}
          expect(gui).to.have.property("scrollable").that.is.undefined
          gui.destroy()

      describe "closeOnTop", ->

        it "sets gui.closeOnTop", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, {closeOnTop: yes}
          expect(gui).to.have.property("closeOnTop").that.is.true
          gui.destroy()

      describe "width", ->

        it "sets gui.width", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, {width: 320}
          expect(gui).to.have.property("width").that.is.within 320, 321
          gui.destroy()

      describe "include", ->

        it "sets gui.include", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, null, {include: ["key"]}
          expect(gui).to.have.property("include").that.deep.equals {key: yes}
          gui.destroy()

        it "uses filterInclude", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, null, {include: ["key"]}
          expect(gui.filter).to.equal SpriteGUI::filterInclude
          gui.destroy()

      describe "exclude", ->

        it "sets gui.exclude", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, null, {exclude: ["key"]}
          expect(gui).to.have.property("exclude").that.deep.equals {key: yes}
          gui.destroy()

        it "uses filterExclude", ->

          sprite = game.add.sprite 0, 0, DEFAULT_IMAGE
          gui = new SpriteGUI sprite, null, {exclude: ["key"]}
          expect(gui.filter).to.equal SpriteGUI::filterExclude
          gui.destroy()
