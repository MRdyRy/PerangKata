# PerangKata
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/MRdyRy/PerangKata)

PerangKata (Word War) is a fast-paced typing game built with the Godot Engine. Defend your hero from waves of advancing monsters by typing the words that appear above their heads. Test and improve your typing speed and accuracy as the challenge intensifies over time.

## Gameplay
- **Defeat Enemies:** A horde of monsters will advance towards your hero from the right side of the screen.
- **Type to Attack:** Each monster is assigned a word. To defeat a monster, you must type its corresponding word correctly.
- **Target Lock:** The game automatically locks onto the nearest monster. All your typed characters will be directed at this target until it is defeated.
- **Combos & Ultimates:** String together successful kills to build your combo meter. A high combo allows you to unleash powerful attacks.
- **Increasing Difficulty:** The longer you survive, the faster the enemies move and the more complex the words become.

## How to Play
You can play the game directly in your browser.

**[Play PerangKata Online](https://mrdyry.github.io/PerangKata/)**

### Controls
- **Alphabetical Keys (A-Z):** Type the words to attack enemies.
- **Mouse:** Navigate the main menu.

## Running Locally
To run this project on your local machine, you will need the [Godot Engine](https://godotengine.org/) (version 4.6 or later).

1.  Clone the repository:
    ```sh
    git clone https://github.com/mrdyry/perangkata.git
    ```
2.  Navigate to the cloned directory:
    ```sh
    cd perangkata
    ```
3.  Open the project in the Godot Engine by importing the `project.godot` file.
4.  Run the main scene (`main.tscn`) from the editor.

## Project Structure
The project is organized into the following main directories:

-   `assets/`: Contains all game assets, including character sprites, backgrounds, and fonts.
-   `data/`: Holds game data, such as the `questions.json` file which contains the word bank for different difficulty levels.
-   `scenes/`: Includes all Godot scene files (`.tscn`), defining the game's objects and levels.
-   `scripts/`: Contains all the GDScript files that drive the game logic.
-   `docs/`: Contains the exported HTML5 build of the game, used for GitHub Pages deployment.

## Core Scripts
The game's logic is primarily handled by a few key scripts:

-   **`GameManager.gd`**: The central manager for game state, scoring, level progression, and difficulty scaling.
-   **`WordManager.gd`**: Loads words from `data/questions.json` and provides them to enemies based on the current difficulty level.
-   **`InputManager.gd`**: Captures keyboard input, routes it to the currently targeted enemy, and manages the target-locking logic.
-   **`Zombie.gd`**: Defines the behavior of an individual enemy, including its movement, associated word, and response to being typed at.
-   **`Hero.gd`**: Controls the player character's state and animations (idle, run, attack, hurt, death).
