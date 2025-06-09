
# Graphics Generator
---

### Script use
Before it can be used, change the value of game_id in "scripts/download_info.js" to the id of the game you want to use and create a file in the scripts directory called "key.js" that itself contains `export const username = <Your Username>;` and `export const api = <Your RA Api key>;`.
With your cli of choice in the main directory use `node scripts/download_info.js` to download all achievement icons in both locked and unlocked forms as well as creating a Yaml file containing all needed info for the generator.

