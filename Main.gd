extends Control
# Paṭṭhāna Quest 24: offline native Android learning game.
const SAVE = "user://quest24_save.json"
var lessons: Array = []
var finished: Array = []
var xp: int = 0
var current: int = 0
var step: int = 0
var quiz_mistakes: int = 0
var content: VBoxContainer
var scroller: ScrollContainer
var status: Label
var tint_bg = Color("#092f39")
var tint_panel = Color("#174650")
var tint_gold = Color("#f1c976")
var tint_white = Color("#fff3df")
var mini_order: Array = [2, 0, 3, 1]
var mini_position: int = 0

func _ready() -> void:
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/lessons.json"))
	if raw is Array:
		lessons = raw
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE)) if FileAccess.file_exists(SAVE) else {}
	if data is Dictionary:
		if data.get("completed", []) is Array:
			finished = data.get("completed", [])
		xp = int(data.get("xp", 0))
	var fonts = SystemFont.new()
	fonts.font_names = PackedStringArray(["Noto Sans Myanmar", "Myanmar Text", "Pyidaungsu", "sans-serif"])
	var ui_theme = Theme.new()
	ui_theme.default_font = fonts
	ui_theme.default_font_size = 23
	theme = ui_theme
	_ui()
	if lessons.size() == 24:
		_map()
	else:
		_clear()
		_label("Error: ပစ္စည်း ၂၄ ပါး Data မတွေ့ပါ။", 29)

func _ui() -> void:
	var bg = ColorRect.new()
	bg.color = tint_bg
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	var margins = MarginContainer.new()
	margins.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left","right"]:
		margins.add_theme_constant_override("margin_" + side, 18)
	margins.add_theme_constant_override("margin_top", 26)
	margins.add_theme_constant_override("margin_bottom", 24)
	add_child(margins)
	var col = VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	margins.add_child(col)
	var heading = HBoxContainer.new()
	col.add_child(heading)
	var title = Label.new()
	title.text = "✦ ပဋ္ဌာန်းအလင်း"
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", tint_gold)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.add_child(title)
	status = Label.new()
	status.add_theme_color_override("font_color", tint_white)
	heading.add_child(status)
	scroller = ScrollContainer.new()
	scroller.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroller.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(scroller)
	content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 12)
	scroller.add_child(content)
	var footer = HBoxContainer.new()
	col.add_child(footer)
	_button(footer, "⌂ World Map", Callable(self, "_map"), true)
	_button(footer, "၂၄ ပစ္စည်းစာရင်း", Callable(self, "_catalog"), true)

func _clear() -> void:
	for c in content.get_children():
		content.remove_child(c)
		c.queue_free()
	scroller.scroll_vertical = 0
	status.text = "★ %d XP" % xp

func _label(value: String, size: int = 23, gold: bool = false) -> Label:
	var l = Label.new()
	l.text = value
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", tint_gold if gold else tint_white)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(l)
	return l

func _button(parent: Node, caption: String, action: Callable, expand: bool = false) -> Button:
	var b = Button.new()
	b.text = caption
	b.custom_minimum_size = Vector2(0, 68)
	b.add_theme_font_size_override("font_size", 21)
	b.add_theme_color_override("font_color", tint_white)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL if expand else Control.SIZE_FILL
	var sty = StyleBoxFlat.new()
	sty.bg_color = tint_panel
	sty.set_corner_radius_all(15)
	sty.content_margin_left = 12
	sty.content_margin_right = 12
	sty.content_margin_top = 14
	sty.content_margin_bottom = 14
	b.add_theme_stylebox_override("normal", sty)
	parent.add_child(b)
	b.pressed.connect(action)
	return b

func _panel(value: String) -> void:
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = tint_panel
	style.set_corner_radius_all(16)
	style.content_margin_left = 18
	style.content_margin_top = 15
	style.content_margin_right = 18
	style.content_margin_bottom = 15
	panel.add_theme_stylebox_override("panel", style)
	var label = Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", tint_white)
	panel.add_child(label)
	content.add_child(panel)

func _is_done(id: int) -> bool:
	return finished.has(id)
func _is_open(id: int) -> bool:
	return id == 1 or _is_done(id-1) or _is_done(id)
func _save() -> void:
	var f = FileAccess.open(SAVE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"xp":xp,"completed":finished}))
		f.close()

func _map() -> void:
	_clear()
	_label("Paṭṭhāna Quest 24", 39, true)
	_panel("6 Worlds • 24 Levels • Offline / XP %d / Completed %d" % [xp,finished.size()])
	var titles = ["ဗောဓိပင်ဥယျာဉ်","ကြာကန်","ပညာကျောင်း","မြန်မာကျေးရွာ","တရားဓမ္မဥယျာဉ်","ဓမ္မမဏ္ဍပ်"]
	for w in range(6):
		_label("WORLD %d — %s" % [w+1, titles[w]],25,true)
		var grid = GridContainer.new()
		grid.columns = 2
		content.add_child(grid)
		for j in range(4):
			var idx = w*4+j
			var d: Dictionary = lessons[idx]
			var id = int(d["id"])
			var caption = ("✓" if _is_done(id) else ("▶" if _is_open(id) else "🔒"))
			var b = _button(grid,"%s %02d %s" % [caption,id,str(d["name_mm"])],Callable(self,"_lesson").bind(idx,false),true)
			b.disabled = not _is_open(id)
			b.custom_minimum_size = Vector2(0,105)
	_label("လေ့လာပါ → Mini Game → Quiz → XP → နောက် Level",20)

func _catalog() -> void:
	_clear()
	_label("ပဋ္ဌာန်း ၂၄ ပစ္စည်း စာရင်း",30,true)
	for i in range(lessons.size()):
		var d: Dictionary = lessons[i]
		_button(content,"%02d • %s\n%s" % [int(d["id"]),str(d["name_mm"]),str(d["pali"])],Callable(self,"_lesson").bind(i,true),true)

func _lesson(idx: int, preview: bool = false) -> void:
	_clear()
	current = idx
	step = 0
	var d: Dictionary = lessons[idx]
	_label("LEVEL %02d — %s" % [int(d["id"]),str(d["name_mm"])],29,true)
	_label(str(d["pali"]),24)
	_panel(str(d["meaning_mm"]))
	var texture = load(str(d["image"]))
	if texture is Texture2D:
		var pic = TextureRect.new()
		pic.texture = texture
		pic.custom_minimum_size = Vector2(0,495)
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		content.add_child(pic)
	_label("သင်ကြားရေးရုပ်ပုံ ဥပမာ — " + str(d["mnemonic_en"]), 19)
	_label("ဤပုံသည် မှတ်မိလွယ်စေရန် ဥပမာသာဖြစ်ပြီး အဘိဓမ္မာအနက်ဖွင့်အပြည့်အစုံ မဟုတ်ပါ။",18)
	if _is_open(int(d["id"])) and not preview:
		_button(content,"🎮 Mini Game စတင်ရန်",Callable(self,"_challenge"),true)
	else:
		_panel("Preview Only — Level ကို World Map မှ ဖွင့်ပါ။")

func _challenge() -> void:
	_clear()
	step = 0
	_label("MINI GAME — အစဉ်လိုက် နှိပ်ပါ",28,true)
	_panel("သဘောတရားတစ်ခု၏ အစဉ်လိုက် လေ့လာမှုကို ၁ → ၂ → ၃ → ၄ စီစဉ်ပါ။")
	_challenge_buttons()

func _challenge_buttons() -> void:
	var row = GridContainer.new()
	row.columns = 2
	content.add_child(row)
	for n in mini_order:
		var b = _button(row,"%d" % (n+1),Callable(self,"_choose_step").bind(n),true)
		b.custom_minimum_size = Vector2(0,95)

func _choose_step(number: int) -> void:
	if number == step:
		step += 1
	if step >= 4:
		_quiz()
	else:
		_clear()
		_label("MINI GAME",29,true)
		_panel("%d / 4 အဆင့်မှန်ပါတယ်။ နောက်နံပါတ်ကို ရွေးပါ။" % step)
		_challenge_buttons()

func _quiz() -> void:
	_clear()
	_label("QUIZ — အဓိပ္ပာယ်မှန် ရွေးပါ",29,true)
	var d: Dictionary = lessons[current]
	_panel(str(d["name_mm"]) + "\n" + str(d["pali"]))
	var choices: Array = d["quiz_options"]
	for i in range(choices.size()):
		_button(content,str(choices[i]),Callable(self,"_answer").bind(i),true)

func _answer(answer: int) -> void:
	var d: Dictionary = lessons[current]
	if answer != int(d["quiz_correct"]):
		_clear()
		_label("ပြန်ဖြေပါ",28,true)
		_panel("အဖြေမမှန်သေးပါ။ မြန်မာအဓိပ္ပာယ်ကို သေချာဖတ်ပြီး ပြန်ရွေးပါ။")
		_button(content,"Quiz ပြန်ဖြေမယ်",Callable(self,"_quiz"),true)
		return
	var id = int(d["id"])
	if not _is_done(id):
		finished.append(id)
		xp += 40
		_save()
	_clear()
	_label("✓ LEVEL COMPLETE",33,true)
	_panel(str(d["name_mm"]) + "\n" + str(d["meaning_mm"]))
	_label("★ 40 XP • Total %d XP" % xp,28,true)
	if current+1 < lessons.size():
		_button(content,"Next Level ▶",Callable(self,"_lesson").bind(current+1,false),true)
	_button(content,"World Map",Callable(self,"_map"),true)
