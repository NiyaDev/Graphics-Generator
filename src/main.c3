
module graphics_gen;
import std::io;
import pleroma;




Keybindings keybinds;

fn int main(String[] args) {
	
	raylib::init_window(1920, 1080, "Graphics gen");

	keybinds.set("start_next", {.type=KEYBOARD,.kb=raylib::KEY_SPACE});

	Yaml yml = yaml::parse_file("resources/test.yml");
	yml.@each(; String key, TypedValue val) {
		Achievement a = val.to_achievement(key);
		a.print();
	};
	//Achievement test = yml

	while (!raylib::window_should_close()) {
		if (keybinds.is_pressed("start_next")) { io::printfn("fug"); }


		raylib::begin_drawing();
		raylib::clear_background(color::GREEN);

		raylib::end_drawing();
	}

	return 0;
}
