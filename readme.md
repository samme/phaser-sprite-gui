# Phaser Sprite GUI

Inspect and manipulate Phaser Sprites (via [dat.gui](https://github.com/dataarts/dat.gui)).

## Use

Add [dat.GUI](https://github.com/dataarts/dat.gui) and [index.js](index.js).

```javascript
// Create
var sprite = game.add.sprite();
// …
var gui = new SpriteGUI(sprite);

// Shutdown
gui.destroy();
```
