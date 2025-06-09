
module graphics_gen::achievements;
import std::io;
import pleroma;


Texture background;
Font font;

int timer = 0;
bool currently_drawing = false;

struct Achievement {
	Texture icon_unobtained, icon_obtained;
	String title, description;
	int points;
	AchievementType type;
}

enum AchievementType {
	NORMAL,
	PROGRESSION,
	WIN_CONDITION,
	MISSABLE,
}


<* Converts a TypedValue from a Yaml file to an achievement *>
fn Achievement TypedValue.to_achievement(&self, String name) {
  Achievement output;

  String unobtained_path = string::tformat("resources/%s/%d_lock.png", graphics_gen::DIRECTORY, self.get_object("badgeName").v_int);
  
  output.icon_unobtained = texture::load(unobtained_path);
  String obtained_path = string::tformat("resources/%s/%d.png", graphics_gen::DIRECTORY, self.get_object("badgeName").v_int);
  output.icon_obtained = texture::load(obtained_path);

  output.title = name;
  output.description = self.get_object("description").v_string;
  output.points = self.get_object("points").v_int;

  return output;
}
<* Starts up animation for achievement *>
fn void Achievement.start(&self) {
  currently_drawing = true;
}
<* Draws achievement on screen *>
fn void Achievement.draw(&self) {
  if (currently_drawing) {
    timer++;
    if (timer > 300) {
      timer = 0;
      currently_drawing = false;
    }

    float y_position = 10;
    if (timer < 25) {
      y_position += ((float)timer - 25) * 10;
    }
    if (timer > 275) {
      y_position -= ((float)timer - 275) * 10;
    }

    

    background.draw_npatch(background.npatch(), {10,y_position,600,150}, {0,0}, 0.0, color::WHITE);
    if (timer < 50) {
      self.icon_unobtained.draw_pro({0,0,64,64}, {15,y_position+5,140,140}, {0,0}, 0, color::WHITE);
    } else {
      self.icon_obtained.draw_pro({0,0,64,64}, {15,y_position+5,140,140}, {0,0}, 0, color::WHITE);
    }
    font.draw_pro(self.title, {170,y_position+20}, {0,0}, 0, 30, 0, color::WHITE);
    font.draw_pro(self.description, {170,y_position+70}, {0,0}, 0, 20, 0, color::WHITE);
  }
}
<* Prints all achievement info *>
fn void Achievement.print(&self) {
  io::printfn("| %s (%d)\n| %s\n| %s", self.title, self.points, self.description, self.type.to_string());
}

<* Converts an AchievementType to a String *>
fn String AchievementType.to_string(&self) {
  switch (*self) {
    case NORMAL: return "";
    case PROGRESSION: return "Progression";
    case WIN_CONDITION: return "Win Condition";
    case MISSABLE: return "Missable";
  }
}

