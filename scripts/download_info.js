
import {buildAuthorization, getAchievementCount, getGameExtended, getAchievementUnlocks} from "@retroachievements/api";
import {username, api} from './key.js';
import {get} from 'https';
import {createWriteStream} from 'fs';


const game_id = 14817;
const icon_base_url = "https://media.retroachievements.org/Badge/";
const save_loc = "resources/" + game_id + "/";

// Create authorization and then request achievement list
const authorization = buildAuthorization({username: username, webApiKey: api});
const game = await getGameExtended(authorization, {gameId: game_id});

// Start making yaml
const yaml_save = save_loc + "achievements.yml";
const yaml = createWriteStream(yaml_save);
yaml.write("%YAML 1.2\n---\n\n");

for(var key in game['achievements']) {
  const a = game['achievements'][key];

  const url_unlocked = icon_base_url + a['badgeName'] + ".png";
  const url_locked   = icon_base_url + a['badgeName'] + "_lock.png";

  const save_unlocked = save_loc + a['badgeName'] + ".png";
  const save_locked = save_loc + a['badgeName'] + "_lock.png";

  // Download unlocked icon
  const unlocked_file = createWriteStream(save_unlocked);
  get(url_unlocked, response => {
    response.pipe(unlocked_file);

    unlocked_file.on('finish', () => {
      unlocked_file.close();
      console.log("Image downloaded " + save_unlocked);
    })
  }).on('error', err => {
    fs.unlink(save_unlocked);
    console.error("Error downloading image: " + save_unlocked);
  });

  // Download locked icon
  const locked_file = createWriteStream(save_locked);
  get(url_locked, response => {
    response.pipe(locked_file);

    locked_file.on('finish', () => {
      locked_file.close();
      console.log("Image downloaded " + save_locked);
    })
  }).on('error', err => {
    fs.unlink(save_locked);
    console.error("Error downloading image: " + save_locked);
  });

  // Save achievement info to yaml
  yaml.write(a['title'] + ":\n");
  yaml.write("\tbadgeName: " + a['badgeName'] + "\n");
  yaml.write("\tdescription: " + a['description'] + "\n");
  yaml.write("\tpoints: " + a['points'] + "\n");
  yaml.write("\n");
}
yaml.close();


