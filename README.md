![Screenshot](https://samme.github.io/phaser-sprite-gui/screenshot.png)

Inspect and manipulate Phaser Sprites (via dat.gui). [Demo](https://samme.github.io/phaser-sprite-gui/)

Install
-------

### Bower

```sh
bower install -S samme/phaser-sprite-gui
```

### NPM

```sh
npm install -S phaser-sprite-gui
```

If [dat.gui/index.js](https://github.com/dataarts/dat.gui/blob/master/index.js) doesn't compile, use [dat.gui/build/dat.gui.js](https://github.com/dataarts/dat.gui/blob/master/build/dat.gui.js) instead.

### CommonJS / Webpack

It should work. The exported constructor is identical to `Phaser.SpriteGUI`.

### Drop-in install

Add [dat.gui.js](https://github.com/dataarts/dat.gui/tree/master/build/dat.gui.js) and [index.js](index.js) before your game scripts.

Use
---

```javascript
// In create():
var sprite = game.add.sprite();
// …
var gui = new Phaser.SpriteGUI(sprite);

// In shutdown():
gui.destroy();
```

### Options

#### Pass GUI params

```javascript
// Example: 320px wide panel
var gui = new SpriteGUI(sprite, {width: 320});
```

#### Filter sprite properties

```javascript
// Example: Show all properties *except* `body`
var gui = new SpriteGUI(sprite, null, {exclude: ['body']});

// Example: Show *only* `body.velocity.x`, `body.velocity.y`
var gui = new SpriteGUI(sprite, null, {include: ['body', 'velocity', 'x', 'y']});
```

For nested properties, `include` must contain **every** name in the property chain.
