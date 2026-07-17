extends Node

var tamed_monster_index_dir: String
var inventory_path: String
var base_colors: ColorPalette
var monster_sprite_dir: String
var tamed_monster_color: Color
var wild_monster_color: Color

var developer_mode: bool = false
var card_index: Dictionary
var monster_index: Dictionary
var tamed_monster_index: Dictionary
var player_party: PlayerPartyData

func _ready():
	tamed_monster_index_dir = get_save_dir_root() + "tamed_monsters/"
	inventory_path = get_save_dir_root() + "inventory.tres"
	base_colors = ResourceLoader.load("res://resources/base_colors.tres")
	monster_sprite_dir = "res://assets/monster_sprites/"
	tamed_monster_color = base_colors.colors[0]
	wild_monster_color = base_colors.colors[1]
	
	card_index = _init_card_index()
	monster_index = _init_monster_index()
	tamed_monster_index = _init_tamed_monster_index()
	player_party = load_player_party()

func get_save_dir_root() -> String:
	if developer_mode:
		return "res://saves/"
	else:
		return "user://saves/"

func init_save_dir():
	if not DirAccess.dir_exists_absolute(get_save_dir_root()):
		DirAccess.make_dir_absolute(get_save_dir_root())
	if not DirAccess.dir_exists_absolute(tamed_monster_index_dir):
		DirAccess.make_dir_absolute(tamed_monster_index_dir)

func _init_card_index() -> Dictionary:
	var index_data: DeckData = ResourceLoader.load("res://resources/card_index_data.tres")
	var p_card_index: Dictionary = {}
	for card in index_data.cards:
		card = card as CardData
		p_card_index[card.card_id] = card
	return p_card_index

func get_card(card_id: int) -> CardData:
	var card: CardData = CardData.new()
	
	if card_id in card_index:
		card = card_index[card_id].duplicate()
	elif card_id < 0 and (card_id * -1) in card_index:
		card = card_index[card_id * -1].duplicate()
		card.card_id = card_id
	
	return card

func _init_monster_index() -> Dictionary:
	var monster_index_dir: String = "res://resources/monster_index/"
	var p_monster_index: Dictionary = {}
	for file_name in ResourceLoader.list_directory(monster_index_dir):
		var monster_data: MonsterData = ResourceLoader.load(monster_index_dir + file_name)
		p_monster_index[monster_data.monster_id] = monster_data
	return p_monster_index

func _init_tamed_monster_index() -> Dictionary:
	var p_tamed_monster_index: Dictionary = {}
	for file_name in ResourceLoader.list_directory(tamed_monster_index_dir):
		var tamed_monster_data: TamedMonsterData = ResourceLoader.load(tamed_monster_index_dir + file_name)
		p_tamed_monster_index[tamed_monster_data.uid] = tamed_monster_data
	return p_tamed_monster_index

func has_monster(monster_id: int) -> bool:
	return monster_index.keys().has(monster_id)

func get_monster(monster_id: int) -> WildMonsterData:
	if monster_id in monster_index.keys():
		return monster_index[monster_id]
	return WildMonsterData.new()

func get_tamed_monster(uid: String) -> TamedMonsterData:
	if uid in tamed_monster_index:
		return tamed_monster_index[uid]
	return null

func get_sprite_base_texture(monster_id: int) -> Texture2D:
	if not ResourceLoader.exists(get_sprite_base_path(monster_id)):
		return Texture2D.new()
	var texture: Texture2D = ResourceLoader.load(get_sprite_base_path(monster_id))
	return texture

func get_sprite_color_mask_texture(monster_id: int) -> Texture2D:
	if not ResourceLoader.exists(get_sprite_color_mask_path(monster_id)):
		return Texture2D.new()
	var texture: Texture2D = ResourceLoader.load(get_sprite_color_mask_path(monster_id))
	return texture

func get_sprite_base_path(monster_id: int):
	return monster_sprite_dir + "%03d_base.png" % monster_id

func get_sprite_color_mask_path(monster_id: int):
	return monster_sprite_dir + "%03d_color_mask.png" % monster_id

func add_tamed_monster(tamed_monster: TamedMonsterData):
	player_party.party_uids.append(tamed_monster.uid)
	save_player_party()
	tamed_monster_index[tamed_monster.uid] = tamed_monster

func create_tamed_id() -> String:
	var new_id: String = ""
	var created_new_id: bool = false
	var attempts: int = 0
	while not created_new_id:
		new_id = "%010d" % randi_range(0, 9999999999)
		created_new_id = new_id not in tamed_monster_index.keys()
		attempts += 1
		if attempts >= 100:
			new_id = "-1"
			created_new_id = true
	return new_id

func load_player_party() -> PlayerPartyData:
	var data_path: String = get_save_dir_root() + "player_party.tres"
	var data: PlayerPartyData = PlayerPartyData.new()
	if ResourceLoader.exists(data_path):
		data = ResourceLoader.load(data_path)
	var invalid_uids: Array = []
	for uid in data.party_uids:
		if not tamed_monster_index.keys().has(uid):
			invalid_uids.append(uid)
	for uid in invalid_uids:
		data.party_uids.erase(uid)
	return data

func update_player_party(p_player_party: PlayerPartyData):
	player_party = p_player_party
	save_player_party()

func load_starter():
	var starter_path: String = "res://resources/starter_monster/starter_monster.tres"
	var starter_monster: TamedMonsterData = ResourceLoader.load(starter_path)
	add_tamed_monster(starter_monster)
	save_tamed_monster(starter_monster)

func save_tamed_monster(tamed_monster_data: TamedMonsterData):
	var file_name: String = tamed_monster_data.uid + ".tres"
	ResourceSaver.save(tamed_monster_data, tamed_monster_index_dir + file_name)

func load_inventory() -> DeckData:
	if ResourceLoader.exists(inventory_path):
		return ResourceLoader.load(inventory_path)
	return DeckData.new()

func save_inventory(inventory: DeckData):
	ResourceSaver.save(inventory, inventory_path)

func save_player_party():
	ResourceSaver.save(player_party, get_save_dir_root() + "player_party.tres")
