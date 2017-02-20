"use strict"

{Phaser} = this

@SpriteGUI = Object.freeze class SpriteGUI extends dat.GUI

  @addAnchor = addAnchor = (cn, anchor) ->
    addPoint cn, anchor, 0, 1, 0.1
    cn

  @addAnim = addAnim = (cn, anim) ->
    cn.add(anim, "paused").listen()
    cn.add(anim, "updateIfVisible").listen()
    cn

  @addBody = addBody = (cn, body) ->
    cn.add(body, "allowGravity")
    cn.add(body, "allowRotation")
    cn.add(body, "angularAcceleration", -body.maxAngular, body.maxAngular).listen()
    cn.add(body, "angularDrag", 0, 2 * body.maxAngular).listen()
    cn.add(body, "angularVelocity", -body.maxAngular, body.maxAngular).listen()
    addPoint (cn.addFolder "bounce"), body.bounce, 0, 1, 0.1
    cn.add(body, "collideWorldBounds").listen()
    addPoint (cn.addFolder "drag"), body.drag, 0, 1000, 10
    cn.add(body, "enable").listen()
    addPoint (cn.addFolder "friction"), body.friction, 0, 1, 0.1
    addPoint (cn.addFolder "gravity"), body.gravity, -1000, 1000, 100
    cn.add(body, "immovable").listen()
    cn.add(body, "mass", 0, 10, 1).listen()
    cn.add(body, "maxAngular", 0, 1000, 10).listen()
    addPoint (cn.addFolder "maxVelocity"), body.maxVelocity, 0, 1000, 10
    cn.add(body, "moves").listen()
    addPoint (cn.addFolder "offset"), body.offset
    cn.add(body, "rotation", -180, 180, 5).listen()
    cn.add(body, "skipQuadTree").listen()
    cn.add(body, "syncBounds").listen()
    addPoint (cn.addFolder "velocity"), body.velocity, -1000, 1000, 10
    cn

  @addInput = addInput = (cn, input) ->
    cn.add(input, "allowHorizontalDrag").listen()
    cn.add(input, "allowVerticalDrag").listen()
    addRect (cn.addFolder "boundsRect"), input.boundsRect if input.boundsRect
    cn.add(input, "dragDistanceThreshold", 0, 10, 1).listen()
    cn.add(input, "draggable").listen()
    addPoint (cn.addFolder "dragOffset"), input.dragOffset, 0, 100
    cn.add(input, "dragStopBlocksInputUp").listen()
    cn.add(input, "dragTimeThreshold", 0, 100, 10).listen()
    cn.add(input, "bringToTop").listen()
    cn.add(input, "enabled").listen()
    cn.add(input, "pixelPerfectAlpha", 0, 255, 5).listen()
    cn.add(input, "pixelPerfectClick").listen()
    cn.add(input, "pixelPerfectOver").listen()
    cn.add(input, "priorityID", 0, 10, 1).listen()
    cn.add input, "reset"
    cn.add(input, "snapOffsetX", -100, 100, 10).listen()
    cn.add(input, "snapOffsetY", -100, 100, 10).listen()
    cn.add(input, "snapOnDrag").listen()
    cn.add(input, "snapOnRelease").listen()
    cn.add(input, "snapX", 0, 100, 5).listen()
    cn.add(input, "snapY", 0, 100, 5).listen()
    cn.add input, "stop"
    cn.add(input, "useHandCursor").listen()
    cn

  @addPoint = addPoint = (cn, point, min, max, step) ->
    cn.add(point, "x", min, max, step).listen()
    cn.add(point, "y", min, max, step).listen()
    cn

  @addRect = addRect = (cn, rect, min = 0, max = 1000, step = 10) ->
    cn.add(rect, "x", min, max, step).listen()
    cn.add(rect, "y", min, max, step).listen()
    cn.add(rect, "width", min, max, step).listen()
    cn.add(rect, "height", min, max, step).listen()
    cn

  @addScale = addScale = (cn, scale, min, max) ->
    addPoint cn, scale, min, max
    cn

  constructor: (@sprite, params = {}) ->
    super params
    @addAll()

  add: (obj, prop) ->
    if obj[prop] is null
      console.warn "Property '#{prop}' is null"
      return
    else
      super

  addAll: ->
    {sprite} = this
    {world} = sprite.game
    {animations} = sprite

    @add(sprite, "alive").listen()
    @add(sprite, "alpha", 0, 1).listen()
    @add(sprite, "autoCull").listen()
    @addAnim() if animations?.frameTotal > 1
    @addAnchor()
    @add(sprite, "blendMode", Phaser.blendModes).listen()
    @add(sprite, "bringToTop")
    @addBody() if sprite.body.type is Phaser.Physics.ARCADE
    @add(sprite, "cacheAsBitmap").listen()
    @addPoint "cameraOffset", sprite.cameraOffset # TODO
    @add(sprite, "checkWorldBounds").listen()
    @add(sprite, "debug").listen()
    @add(sprite, "exists").listen()
    @add(sprite, "fixedToCamera").listen()
    @add(sprite, "frame", animations.frameData.getFrameIndexes()).listen()
    @add(sprite, "frameName").listen()
    @add(sprite, "health", 0, sprite.maxHealth).listen()
    @addInput() if sprite.input
    @add(sprite, "key").listen()
    @add(sprite, "kill")
    @add(sprite, "lifespan", 0, 10000, 100).listen()
    @add(sprite, "moveDown")
    @add(sprite, "moveUp")
    @add(sprite, "name").listen()
    @add(sprite, "outOfBoundsKill").listen()
    @add(sprite, "outOfCameraBoundsKill").listen()
    @add(sprite, "renderable").listen()
    @add(sprite, "reset")
    @add(sprite, "revive")
    @add(sprite, "rotation", -Math.PI, Math.PI, Math.PI / 30).listen()
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

  addAnim: ->
    addAnim (@addFolder "animations"), @sprite.animations

  addBody: ->
    addBody (@addFolder "body"), @sprite.body

  addInput: ->
    addInput (@addFolder "input"), @sprite.input

  addPoint: (name, point, min, max, step) ->
    addPoint (@addFolder name), point, min, max, step

  addScale: ->
    addScale (@addFolder "scale"), @sprite.scale, (@sprite.scaleMin or -5), (@sprite.scaleMax or 5)
