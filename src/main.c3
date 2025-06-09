
module graphics_gen;
import std::io;
import std::collections;
import pleroma;



const String DIRECTORY = "14817";

Keybindings keybinds;
List{Achievement} achievos;
usz current_achievement = 0;

fn int main(String[] args) {
	//raylib::set_trace_log_level(NONE);
	raylib::init_window(1920, 1080, "Graphics gen");
	raylib::set_target_fps(60);

	keybinds.set("start_next", {.type=KEYBOARD,.kb=raylib::KEY_SPACE});

	String directory_path = string::tformat("resources/%s", DIRECTORY);

	achievements::background = texture::load("resources/background.png");
	achievements::font = font::load_ex("resources/fredoka.ttf", 240, {});

	// Load yaml containing achievements
	String yaml_path = string::tformat("%s/achievements.yml", directory_path);
	Yaml yml = yaml::parse_file(yaml_path);
	yml.@each(; String key, TypedValue val) {
		Achievement a = val.to_achievement(key);
		achievos.push(a);
	};

	while (!raylib::window_should_close()) {
		if (keybinds.is_pressed("start_next") && !achievements::currently_drawing) {
			achievos[current_achievement].start();
			current_achievement++;
			if (current_achievement > achievos.len()) current_achievement = 0;
		}


		raylib::begin_drawing();
		raylib::clear_background(color::GREEN);
		achievos[current_achievement].draw();

		raylib::end_drawing();
	}

	return 0;
}
