"use strict"

{Phaser} = this

@SpriteGUI = Object.freeze class SpriteGUI extends dat.GUI

  @addAnchor = addAnchor = (cn, anchor) ->
    addPoint cn, anchor, 0, 1
    cn

  @addBody = addBody = (cn, body) ->
    cn.add(body, "allowGravity")
    cn.add(body, "allowRotation")
    cn.add(body, "angularAcceleration", -3600, 3600).listen()
    cn.add(body, "angularDrag", 0, 3600).listen()
    cn.add(body, "angularVelocity", -body.maxAngular, body.maxAngular).listen()
    addPoint (cn.addFolder "bounce"), body.bounce, 0, 1
    cn.add(body, "collideWorldBounds").listen()
    addPoint (cn.addFolder "drag"), body.drag, 0, 1000
    cn.add(body, "enable").listen()
    addPoint (cn.addFolder "friction"), body.friction, 0, 1
    addPoint (cn.addFolder "gravity"), body.gravity, -1000, 1000
    cn.add(body, "immovable").listen()
    cn.add(body, "mass", 0, 100).listen()
    cn.add(body, "maxAngular", 0, 3600).listen()
    addPoint (cn.addFolder "maxVelocity"), body.maxVelocity, 0, 1000
    cn.add(body, "moves").listen()
    addPoint (cn.addFolder "offset"), body.offset
    cn.add(body, "rotation", -180, 180).step(5).listen()
    cn.add(body, "skipQuadTree").listen()
    cn.add(body, "syncBounds").listen()
    addPoint (cn.addFolder "velocity"), body.velocity, -1000, 1000
    cn

  @addInput = addInput = (cn, input) ->
    cn.add(input, "enabled").listen()
    # TODO …
    cn

  @addPoint = addPoint = (cn, point, min, max) ->
    cn.add(point, "x", min, max).listen()
    cn.add(point, "y", min, max).listen()
    cn

  @addRect = addRect = (cn, rect, min, max) ->
    cn.add(rect, "x", min, max).listen()
    cn.add(rect, "y", min, max).listen()
    cn.add(rect, "width", min, max).listen()
    cn.add(rect, "height", min, max).listen()
    cn

  @addScale = addScale = (cn, scale, min, max) ->
    addPoint cn, scale, min, max
    cn

  constructor: (@sprite, params = {}) ->
    super params
    @addAll()

  addAll: ->
    {sprite} = this
    {world} = sprite.game

    @add(sprite, "alive").listen()
    @add(sprite, "alpha", 0, 1).listen()
    @add(sprite, "autoCull").listen()
    @addAnchor()
    @add(sprite, "blendMode", Phaser.blendModes).listen()
    @add(sprite, "bringToTop")
    @addBody()
    @add(sprite, "cacheAsBitmap").listen()
    @add(sprite, "checkWorldBounds").listen()
    @add(sprite, "debug").listen()
    @add(sprite, "exists").listen()
    @add(sprite, "fixedToCamera").listen()
    @add(sprite, "frame", sprite.animations.frameData.getFrameIndexes()).listen()
    @add(sprite, "frameName").listen()
    @add(sprite, "health", 0, sprite.maxHealth).listen()
    @add(sprite, "key").listen()
    @add(sprite, "kill")
    @add(sprite, "lifespan", 0).listen()
    @add(sprite, "moveDown")
    @add(sprite, "moveUp")
    @add(sprite, "name").listen()
    @add(sprite, "outOfBoundsKill").listen()
    @add(sprite, "outOfCameraBoundsKill").listen()
    @add(sprite, "renderable").listen()
    @add(sprite, "reset")
    @add(sprite, "revive")
    @add(sprite, "rotation", -Math.PI, Math.PI).listen()
    @add(sprite, "sendToBack")
    @addScale()
    @add(sprite, "smoothed").listen()
    @add(sprite, "tint").listen()
    @add(sprite, "visible").listen()
    @add(sprite, "x", world.left, world.right).listen()
    @add(sprite, "y", world.top, world.bottom).listen()
    @add(sprite, "z").listen();
    return

  addAnchor: ->
    addAnchor (@addFolder "anchor"), @sprite.anchor

  addBody: ->
    addBody (@addFolder "body"), @sprite.body

  addInput: ->
    addInput (@addFolder "input"), @sprite.input

  addScale: ->
    addScale (@addFolder "scale"), @sprite.scale, (@sprite.scaleMin or -4), (@sprite.scaleMax or 4)
