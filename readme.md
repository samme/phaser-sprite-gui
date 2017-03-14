![Screenshot](https://samme.github.io/phaser-sprite-gui/screenshot.png)

[Demo](https://samme.github.io/phaser-sprite-gui/)

Install
-------

If not using `npm` or `bower`, add [dat.gui](https://github.com/dataarts/dat.gui) and [index.js](index.js) before your game scripts.

Use
---

```javascript
// @create:
var sprite = game.add.sprite();
// …
var gui = new SpriteGUI(sprite);

// @shutdown:
gui.destroy();
```

### Options

#### Pass GUI params

```javascript
// Example: 320px wide panel
var gui = new SpriteGUI(sprite, {width: 320});
```

### Filter sprite properties

```javascript
// Example: Show all properties *except* `body`
var gui = new SpriteGUI(sprite, null, {exclude: ['body']});

// Example: Show *only* `body`
var gui = new SpriteGUI(sprite, null, {include: ['body']});
```
