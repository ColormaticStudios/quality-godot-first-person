# quality-godot-first-person
Actually good first person controller for Godot 4.1
MIT License (credit Colormatic Studios)

This is a first person controller that was made because there aren't many first person controllers for Godot, and the ones that do exist are pretty bad.

# Directions
Move with WASD, space to jump, shift to sprint, control to crouch.

**FEATURES:**
 - In-air momentum
 - Motion smoothing
 - FOV smoothing
 - Head bobbing
 - Crouching
 - Sprinting
 
 ![editor screenshot](https://i.ibb.co/X5P34h0/fpc-screenshot.png)

More features incoming

Possibly a version of this that is an addon?

**If you want to add this to an existing project**, just steal the `data/player` folder.

You will also want to remove the code for pausing, it's the first two lines of `_ready()` and the `_on_pause()` and `_on_unpause()` functions. **Note, you will need to bring your own mouse capturing code.**

The player scene also has a little dot sprite in the middle of the screen, you can either delete that or provide your own cursor image.

If you make a cool game with this program, I would love to hear about it!
