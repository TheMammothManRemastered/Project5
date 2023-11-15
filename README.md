# Game Name

* **Originality:** What is original about your game?
* **Technical Merit:** What is interesting about your game technology?
* **Prototype Postmortem:** What did you learn from this prototype? What was the easiest or hardest part of making it?
* **Prototype Assets:** Did you make your prototype assets from scratch? Did you borrow them? Cite your sources here.
* **Prototype Closest Other Game:** Which other game most closely resembles your game? If you are borrowing code from a Phaser Example, you must say so here. If you borrow code from elsewhere, you must say so here.
* **High Concept:** A one-sentence summary of your game.
* **Theme:** State which of the themes or challenges you used.
* **Mandated Variety:** State which input, randomness, genre, and play style you used in this prototype.
* **Prototype Goal:** What game mechanic is this prototype evaluating?
* **Player Experience Goals:** What experience do you want players to have when playing your game?
* **Gameplay:** A paragraph describing the actions the player can perform, the system dynamics, and the core mechanic. Include a concise explanation of the prototype’s inputs and their expected effects (how to play). You can also describe game play that is not in the prototype. You may include mock-up images for parts of the game not in the prototype.
* **Strategies:** What player strategies do you expect will be effective at playing this game?
* **Story/Setting/Premise:** A paragraph about the world your game is set in and who the characters are. What makes the game world and its occupants unique and interesting? Do the tokens represent something? If the game has a backstory, mention it here. If the game is abstract, then say so. How will the dramatic tension interact with the gameplay tension?
* **Target Audience:** A single sentence that describes the demographic you're trying to reach.
* **Play Time:** How long does your game take to play?

---
### dev stuff

#### TODO (and/or what's already done):
##### Visuals:
	- [ ] Tile Atlas
	- [ ] Player sprite(s)
	- [ ] Player animation(s)
	- [ ] Enemy sprite(s)
	- [ ] Enemy animation(s)
##### Code/implementation:
	- [\] Full Level Framework (still need to do spawners, but the main hard bit is working)
	- [X] Functioning doors
	- [X] Functioning enemy spawners
	- [X] Functioning pickup spawners
	- [X] Functioning ranged enemy
	- [ ] Functioning melee enemy
	- [\] Fully functioning player (no weapons or parry yet)
	- [X] Parrying
	- [ ] Sword
	- [ ] AWP
	- [ ] Levels outside the template level
	- [ ] Real title screen
	- [ ] Level select screen (optional)
 	- [ ] Have bullets talk directly to the player. This way, when their spawner dies, they still can inflict their damage.
  	- [ ] Despawn all bullets on room transition.
   	- [ ] Cache room changes (the registry calls your name)
##### Other:
	- [ ] Audio

#### design

Note for Tyler:
	hook the animations for the player up to the AnimatedSprite2D in scenes/objects/player.tscn
	scale the AnimatedSprite2D and change the CollisionShape2D if the sizes are bad, but try to keep the height roughly the same
	one of us can do a proper animation tree or whatever later if we want to have hitboxes change and shit, idk how to do that lol
	-Will

metroid-style level layouts (platforming with doors)
there are some enemies about the levels (turrets, melee guys)
there are also gauntlet-style rooms where a bunch of enemies show up and you have to kill them all at once
the object of each level is to reach an end room, clear a hard gauntlet and then exit the level

the player is equipped with a melee weapon upon entering the first level
they have the ability to parry enemy projectiles and attacks
doing so successfully grants the player a number of points (just gonna call them energy for now)
the more energy the player has, the faster they move and the harder they hit.
higher energy melee attacks deal greater damage and knockback (can send enemies flying through other enemies and knock them back too)
energy slowly decays over time

other tools can be found thoughout the levels, usually after gauntlet rooms
these may be weapons (ie. a ranged weapon), other combat tools (ie. a shield or some other defensive option) or upgrades to base abilities (ie. double jump)
the combat tools cost energy to use

#### Levels, Rooms and Doors
Levels are a collection of packed room scenes and information about each room in the level, as well as information about the player going through the level
Rooms are the actual scenes with geometry and enemy spawnpoints and doors and the like
Rooms have something called a registry, which contains information about all of their objects and themselves
a room's registry contains:
	a room's name
	an ordered list of all of its doors (sorted by door ID. this allows for array access when switching levels, which is faster)
	a list of all of its enemy spawnpoints
	a list of all other spawnpoints
Room registries are echoed in the Level they belong to, which is loaded in Autoload
The level has a list of these registries sorted by room ID
Doors are scenes that are instanciated in rooms
They have IDs, a target room ID and a target door ID for that room

how are levels loaded?
there is a thing in Autoload, the LevelManager
this thing holds the current Level
