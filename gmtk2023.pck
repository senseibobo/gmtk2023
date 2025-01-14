GDPC                 �                                                                         P   res://.godot/exported/133200997/export-03cf9c6a21c871d2ff97762570d6f706-Hero.scn�"      �      n����J��p|h�Mj�    P   res://.godot/exported/133200997/export-2c627f0aeee2256356f1e6ba540049dd-coin.scn       y      kj��ل���(F�    P   res://.godot/exported/133200997/export-609f762188a68253d349ec58c4f3a8d3-game.scnP            ��^Mx�9�^C��ާ    T   res://.godot/exported/133200997/export-a34f8db25240a16f5c3e891255cf5006-grass.scn   p      �      ڨV��5#T�`#eȇO�    T   res://.godot/exported/133200997/export-ad51a66c3829755016128bc6dbbf83bc-Platform.scnp:      �      ���"��c)$؜35w    \   res://.godot/exported/133200997/export-d24b7245cd71631fcefbcd725a26c65b-Jump Platform.scn   �5      �      ��5�,g ^�Py    ,   res://.godot/global_script_class_cache.cfg  �@             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�&      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  �D            G6�R�����̅��!       res://Game Over.gd  �      �      K�օ�����[���� �       res://Game.gd   �      �      �h��I_���߮�ۡ       res://Hero.gd           o      ��߶�u#���A�j�a�       res://Hero.tscn.remap   p?      a       $^��v@G:�u���`�       res://Jump Platform.gd  @4      :      �b6<��7���ܘ�j?�        res://Jump Platform.tscn.remap  �?      j       �}}Ƅ!�ۡ����p       res://Platform.tscn.remap   P@      e       �2E��p��亸��Y       res://coin.gd                 ��=�5���g�Hj       res://coin.tscn.remap    >      a       �d�b5M�{>����O*       res://game.tscn.remap   �>      a       �?��� �ު��y�       res://grass.tscn.remap   ?      b       q��"�XO��]�x�       res://icon.svg  �@      �      C��=U���^Qu��U3       res://icon.svg.import   p3      �       �.h
���l�	z�       res://project.binary�E      �      �	��;��>�����    extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_coin():
	pass # remove coin from screen

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.pick_up_coin()
		#Game.coins_spawned_counter -= 1
		queue_free()
	#if body.is_in_group("WorldBorder"):
		#body.coins_spawned_counter -= 1
		#queue_free()
		#print("coins destroyed")
RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    radius    script 	   _bundled       Script    res://coin.gd ��������      local://CircleShape2D_h3et6 O         local://PackedScene_np01s m         CircleShape2D             PackedScene          	         names "         coin 	   modulate    script    PickUps    Area2D 
   ColorRect    offset_left    offset_top    offset_right    offset_bottom    color    CollisionShape2D    scale    shape    _on_body_entered    body_entered    	   variants          ��G?��G?      �?               p�     pA     �?  �?      �?
     �?  �?                node_count             nodes     (   ��������       ����                                    ����                     	      
                        ����                         conn_count             conns                                       node_paths              editable_instances              version             RSRC�-��qs�extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("GAME OVER")
		# TODO GAME OVER - Show Game Over text, press any key to restart game
	#if body.is_in_group("PickUps"):
		#queue_free()
		#print("coin destroyed")
SKK�?�ȗextends Node2D

@export var speed: float = 100.0
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = 8
var water_width: int = 3
var current_platform_selected: int = 0 # 0 - regular platform | 1 - jumping platform
var max_coins: int = 3
var coins_spawned_counter: int = 0

func _ready():
	move_step = 1300
	#Engine.time_scale *= 5

func _process(delta):
	
	if Input.is_action_pressed("select_regular_platform"): #d
		current_platform_selected = 0
		$ColorRect.set_size(Vector2(300,100))
	else: if Input.is_action_pressed("select_jump_platform"): #s
		current_platform_selected = 1
		$ColorRect.set_size(Vector2(50,60)) # idk why this works
	
	if current_platform_selected == 0:
		var offset = fmod($Moving.global_position.x,100)
		$ColorRect.global_position.x = -150+get_global_mouse_position().x#int(get_global_mouse_position().x+50)/100*100+offset
		$ColorRect.global_position.y = int(get_global_mouse_position().y-25)/25*25
		#var platform = preload("res://Platform.tscn").instantiate()
		if Input.is_action_just_released("place_platform"):
			var platform = preload("res://Platform.tscn").instantiate()
			$Moving.add_child(platform)
			platform.global_position = $ColorRect.global_position
	else: if current_platform_selected == 1:
		var offset = fmod($Moving.global_position.x,100)
		$ColorRect.global_position.x = -25+get_global_mouse_position().x#int(get_global_mouse_position().x+50)/100*100+offset
		$ColorRect.global_position.y = int(get_global_mouse_position().y)/25*25
		#var platform = preload("res://Jump Platform.tscn").instantiate()
		if Input.is_action_just_released("place_platform"):
			var platform = preload("res://Jump Platform.tscn").instantiate()
			$Moving.add_child(platform)
			platform.global_position = $ColorRect.global_position
		
	$Moving.global_position.x -= delta*speed
	move_step += delta*speed
	while move_step >= 100:
		water_counter += 1
		move_step -= 100
		if water_counter > next_water:
			if water_counter == next_water + 1:
				water_width = 2+randi()%2
			var water = preload("res://grass.tscn").instantiate()
			$Moving.add_child(water)
			water.get_node("ColorRect").color = Color.BLUE
			water.get_node("CollisionShape2D").queue_free()
			water.global_position.x = 1300-move_step
			water.global_position.y = 500
			water_width -= 1
			if water_width == 0:
				water_counter = 0
				next_water = 7+randi()%3
				spawn_coin(get_coin_spawn_position())
		else:
			var grass = preload("res://grass.tscn").instantiate()
			$Moving.add_child(grass)
			grass.global_position.x = 1300-move_step
			grass.global_position.y = 500
		
	for child in $Moving.get_children():
		if child.global_position.x < -300:
			child.queue_free()
		
		
func spawn_coin(position_vector: Vector2):
	var coin = preload("res://coin.tscn").instantiate()
	$Moving.add_child(coin)
	coin.global_position.x = position_vector.x
	coin.global_position.y = position_vector.y
	coins_spawned_counter += 1
	print("Coin Spawned!")

func get_coin_spawn_position():
	randomize()
	var x = 1200
	var y_range = Vector2(10, 200)
	if (randi()%4) < 2:
		y_range = Vector2(10, 200)
	else:
		y_range = Vector2(200, 450)
	var random_y =  randi() % int(y_range[1]-y_range[0]) + 1 + y_range[0]
	var random_pos = Vector2(x, random_y)
	return random_pos
,��=�z9�uH���RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    a    b    script 	   _bundled       Script    res://Game.gd ��������   PackedScene    res://Hero.tscn ��[��ȿ   Script    res://Game Over.gd ��������      local://SegmentShape2D_rpryy �         local://PackedScene_bhjws �         SegmentShape2D       
      ?B�ľ   
     �ff�A         PackedScene          	         names "         Game    script    Node2D    Moving 
   ColorRect    offset_right    offset_bottom    scale    color    Hero 	   position    Game Over Collision    WorldBorder    Area2D    LeftCollisionLine    shape    CollisionShape2D    RightCollisionLine    BottomCollisionLine 	   rotation    SkyBox    StaticBody2D    TopCollisionLine    _on_body_entered    body_entered    	   variants                      �C     �B
     �?   ?     �?  �?  �?���>         
     $C  �C         
     H�    
     �?  �B          
     �D    
     �� �'D   �ɿ
      @  �B
     ��  ��      node_count    
         nodes     q   ��������       ����                            ����                      ����                                       ���	         
                        ����                            ����   
         	      
                    ����   
         	      
                    ����   
                     
                     ����                     ����   
                     
             conn_count             conns                                     node_paths              editable_instances              version             RSRC�������mRSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled           local://RectangleShape2D_mwvfh +         local://PackedScene_ailu4 \         RectangleShape2D       
     �B  �C         PackedScene          	         names "   	      Grass    StaticBody2D 
   ColorRect    offset_right    offset_bottom    color    CollisionShape2D 	   position    shape    	   variants            �B     �C       ���>      �?
     HB  C                node_count             nodes        ��������       ����                      ����                                        ����                         conn_count              conns               node_paths              editable_instances              version             RSRC�.����0extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var coin_counter: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY

func pick_up_coin():
	coin_counter += 1
	print("Player has: ", coin_counter, " coins!")
�RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://Hero.gd ��������      local://RectangleShape2D_cu73b P         local://PackedScene_10878 �         RectangleShape2D       
     HB  HB         PackedScene          	         names "         Hero    script    Player    CharacterBody2D 
   ColorRect    offset_left    offset_top    offset_right    CollisionShape2D 	   position    shape    	   variants                      ��     H�     �A
         ��                node_count             nodes     "   ��������       ����                              ����                                       ����   	      
                conn_count              conns               node_paths              editable_instances              version             RSRC#XPo�O���fGST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[ 4�����";���[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cvl372odw03hf"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 �o�6��kY� �{�extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.jump()
j{R2RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://Jump Platform.gd ��������      local://RectangleShape2D_51dhp �         local://RectangleShape2D_bbgsd �         local://PackedScene_e8dp1 �         RectangleShape2D       
     �A  �A         RectangleShape2D       
     HB  �A         PackedScene          	         names "         Jump Platform    script    Area2D 
   ColorRect    offset_right    offset_bottom    CollisionShape2D 	   position    shape    StaticBody2D    _on_body_entered    body_entered    	   variants                      HB     �A
     B  l�          
     �A  pA               node_count             nodes     1   ��������       ����                            ����                                 ����                           	   	   ����                     ����                         conn_count             conns                   
                    node_paths              editable_instances              version             RSRC��E��������v��RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled           local://RectangleShape2D_03avx +         local://PackedScene_5tn5d \         RectangleShape2D       
     �C  �B         PackedScene          	         names "   	   	   Platform    StaticBody2D 
   ColorRect    offset_right    offset_bottom    scale    CollisionShape2D 	   position    shape    	   variants            �C     �B
     �?   ?
     C  �A                node_count             nodes     !   ��������       ����                      ����                                        ����                               conn_count              conns               node_paths              editable_instances              version             RSRCյ�[remap]

path="res://.godot/exported/133200997/export-2c627f0aeee2256356f1e6ba540049dd-coin.scn"
��܏{�L�{Nk�\[remap]

path="res://.godot/exported/133200997/export-609f762188a68253d349ec58c4f3a8d3-game.scn"
^pH�F�Ř"N|�[remap]

path="res://.godot/exported/133200997/export-a34f8db25240a16f5c3e891255cf5006-grass.scn"
���.�Y�Z]�X[remap]

path="res://.godot/exported/133200997/export-03cf9c6a21c871d2ff97762570d6f706-Hero.scn"
j��G��ktF���:[remap]

path="res://.godot/exported/133200997/export-d24b7245cd71631fcefbcd725a26c65b-Jump Platform.scn"
"vA]�?[remap]

path="res://.godot/exported/133200997/export-ad51a66c3829755016128bc6dbbf83bc-Platform.scn"
�S\��u�D�glist=Array[Dictionary]([])
�d��<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
��r[����	   U�:��'F   res://coin.tscnoM�O�KT   res://game.tscn%��f��(   res://grass.tscn��[��ȿ   res://Hero.tscnk
��b
W   res://icon.svg�D���F   res://Jump Platform.tscn9E�.!�m   res://Platform.tscngy�Y�$?   res://UI_CoinCounter.tscn��z��2p   res://UI_CoinCounter.tscn�4[�'ECFG      application/config/name         gmtk2023   application/run/main_scene         res://game.tscn    application/config/features(   "         4.1    GL Compatibility       application/config/icon         res://icon.svg     autoload/GameManager          *res://GameManager.gd      input/place_platform�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script         input/select_regular_platform�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script         input/select_jump_platform�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility-   rendering/2d/snap/snap_2d_transforms_to_pixel         +   rendering/2d/snap/snap_2d_vertices_to_pixel         *��>��