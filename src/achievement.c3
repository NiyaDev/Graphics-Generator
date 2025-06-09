
module graphics_gen::achievements;
import std::io;
import pleroma;


Texture background;
Font font;

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


<**>
fn Achievement TypedValue.to_achievement(&self, String name) {
  assert(self.type == ARRAY);

  Achievement output;

  String unobtained_path = string::tformat("resources/icons/%d_lock.png",self[0].v_int);
  output.icon_unobtained = texture::load(unobtained_path);
  String obtained_path = string::tformat("resources/icons/%s.png",self[0].v_string);
  output.icon_obtained = texture::load(obtained_path);

  //output.title = self[1].v_string.copy(allocator::heap());
  output.title = name;
  output.description = self[1].v_string.copy(allocator::heap());
  output.points = self[2].v_int;
  output.type = AchievementType.from_ordinal(self[4].v_int);

  return output;
}
<**>
fn void Achievement.print(&self) {
  io::printfn("%s (%d)\n%s\n%s", self.title, self.points, self.description, self.type);
}

