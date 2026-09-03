#All rights reserved
#Copyright belongs to Ernesto Rivera
#You can use this code freely in your project(s) as long as credit is given :)
#Proyecto 2 ISABEL Y STEVEN

# To run the project:
# 1) In the upper bar go to Run->Assemble (f3)
# 2) In the upper bar go to Tools->Bitmap Display
# 3) Configure the following settings in in the Bitmap Display:
	# a) Unit Width: 8
	# b) Unit Height: 8
	# c) Display Width: 512
	# d) Display Height: 512
	# e) Base Address: gp
	# f) Press connect to program 
# 4) In the upper bar go to Tools->Keyboard and Display MMIO Simulator and press connect to MIPS
# 5) In the upper bar go to Run->Go (f5)
# 6) Click on the lower window of the Keyboard and Display simulator to produce inputs

#Player movement is w and s for the left player and o and l for the right player.

#FOR THE STUDENTS: Internal labels of a function starts with a .

# Here I define the constants that will be used along the code
.eqv TOTAL_PIXELS, 22304 # The total ammount of pixels in the screen
.eqv FOUR_BYTES, 4 # The displacement in memory is done words which equals four bytes

.eqv TITLE_SCREEN_FIRST_LINE_ROW_Y, 2
.eqv TITLE_SCREEN_SECOND_LINE_ROW_Y, 15

.eqv DRAW_LIMITS_UP, 1
.eqv DRAW_LIMITS_DOWN,60
.eqv DRAW_LIMITS_LATERAL, 2

.eqv BLOCK_MAP_X, 10
.eqv BLOCK_MAP_Y, 7
.eqv BLOCK_MAP_H, 2

.eqv BATTLE_TEXT_X, 10
.eqv BATTLE_TEXT_Y, 6
.eqv BATTLE_TEXT_H, 6
	
.eqv PRESS_TEXT_X, 20
.eqv PRESS_TEXT_Y, 55
.eqv PRESS_TEXT_H, 4

.eqv NAME_TEXT_X 7
.eqv NAME_TEXT_Y 27
.eqv NAME_TEXT_H, 4

.eqv TEC_TEXT_X 6
.eqv TEC_TEXT_Y 40
.eqv TEC_TEXT_H, 6

.eqv LEVEL_TEXT_X 6
.eqv LEVEL_TEXT_Y 25
.eqv LEVEL_TEXT_H 6

.eqv KEY_INPUT_ADDRESS 0xFFFF0004
.eqv KEY_STATUS_ADDRESS 0xFFFF0000
# For reference of those addreses check https://urldefense.com/v3/__https://www.it.uu.se/education/course/homepage/os/vt18/module-1/memory-mapped-io/__;!!O7R4XxaP!bywcdkXgCeMZoYma0bPHo9-lK293uRBwULXM5vKYJ0GMyI480peiWNl-8CZq96VGNdwN9YA9pOfVUaGyB-h6UBsV2rg$ 

.eqv ASCII_1 0x00000031
.eqv ASCII_2 0x00000032
#MOVIMIENTOS
.eqv MOV_UP 1
.eqv MOV_DOWN 2
.eqv MOV_RIGHT 3
.eqv MOV_LEFT 4
.eqv MOV_STAY 0

.eqv SCORE_FIRST_ROW_POINTS 5
.eqv SCORE_SECOND_ROW_POINTS 6
.eqv ROW_1 1
.eqv ROW_3 3
.eqv P1_SCORE_COLUMN 1

.eqv GAME_WIN_POINTS 10

.eqv PADDLE_LENGTH 2

.eqv TOP_PADDLE_Y_ROW 0
.eqv BOTTOM_PADDLE_Y_ROW 64#  31 - 5 = 26 Thats the lowest point that paddle y can reach
.eqv TOP_PADDLE_X_ROW 0
.eqv BOTTOM_PADDLE_X_ROW 63

.eqv PLAYER_1_PADDLE_X_POS 5

.eqv FIRST_COLUMN 0
.eqv LAST_COLUMN 63

.eqv BALL_RIGHT_DIR 1
.eqv BALL_LEFT_DIR -1
.eqv BALL_UP_DIR -1
.eqv BALL_DOWN_DIR 1

.eqv LEFT_COLLISION_X_POS 14
.eqv RIGHT_COLLISION_X_POS 49

# The constants for the ball-pallet collision position
.eqv TOP_HIGH 0
.eqv TOP_MID 1
.eqv TOP_LOW 2
.eqv BOTTOM_HIGH 3
.eqv BOTTOM_MID 4
.eqv BOTTOM_LOW 5

# LIMITES PANTALLA
.eqv DOWN_Y_LIMIT 64
.eqv UP_Y_LIMIT 0

# ASSCII 

.eqv ASCII_W 119
.eqv ASCII_A 97
.eqv ASCII_S 115
.eqv ASCII_D 100
.eqv ASCII_p 0x70

#el espacio en codigo ASCII para tirar la bala del player
.eqv ASCII_SPACE 0x00000020

#COORDENADAS DEL LA PANTALLA

.eqv P_CHAR_WIN_X 26
.eqv P_CHAR_WIN_Y 5
.eqv P_CHAR_WIN_H 5

.eqv PLAYER_NUM_WIN_X 33
.eqv PLAYER_NUM_WIN_Y 5
.eqv PLAYER_NUM_WIN_H 5

.eqv WINS_TEXT_X, 21
.eqv WINS_TEXT_Y, 16
.eqv WINS_TEXT_H, 5

##COLISIONES
.eqv COLLISION 1
.eqv NO_COLLISION 0

##VIDAS
.eqv player_lives 3

.eqv SHOVEL_DURATION, 300     # duración del poder en tick

 # Begin of the data section
.data
	color_white:	.word 0x00ffffff
	color_black:	.word 0x00000000
	color_red:     .word 0x00ff0000
	color_cyan: 	.word 0x0000ffff
	color_orange:	.word 0x00ffa500
	color_green: .word 0x0000ff00    # verde puro RGB
    
       color_yellow: .word 0x00ffff00 # amarillo puro RGB
       color_blue: 	.word 0x000000ff
      color_purple: .word 0x00ff00ff # morado puro RGB
       color_brown: 	.word 0x00a52a2a # marrón puro RGB
      	color_gray:    .word 0x808080   # gris, para poder del casco
color_sky_blue: .word 0x00add8e6 # azul claro RGB


	player_mode:	.word 0
	p1_score:		.word 0
	computer_count:	.word 0
	computer_speed:	.word 0		#Used after first collision
	level:			.word 6		
	player_x:	.word 3
	player_y:	.word 3


        bullet_active: .word 0   # 0 = no hay bala en pantalla, 1 = bala activa
    	bullet_x:      .word 0   # coordenada X de la bala
    	bullet_y:      .word 0   # coordenada Y de la bala
    	bullet_DIR:  .word MOV_UP     # dirección actual del proyectil
    	last_DIR:        .word MOV_UP     # última dirección en que movió el jugador
	
	


	enemy_x:   .word 9     # posición inicial X
        enemy_y:   .word 10    # posición inicial Y
        enemy_DIR: .word MOV_LEFT   # dirección inicial
        enemy_active:   .word 1  # 1= vivo, 0=muerto
        p1_kills: .word 0 #contador para enemigos muertos
        last_erase_y:        .word 0 # para guardar las posicon de la barr
        
        enemy_bullet_active: .word 0       # 0 = no hay bala, 1 = bala activa
        enemy_bullet_x:      .word 0       # coordenada X de la bala del enemigo
        enemy_bullet_y:      .word 0       # coordenada Y de la bala del enemigo
        enemy_bullet_DIR:    .word MOV_DOWN  # dirección inicial (por ejemplo hacia abajo)
        enemy_fire_counter:  .word 0        # contador para que tire las balas cada ciclo
        enemy_move_counter:  .word 0        # contador para el movimiento del enemigo
        


        enemy1_respawn_active: .word 0  # 0 = no esperando, 1 = esperando respawn
        enemy1_respawn_counter: .word 0  # contador de ciclos de espera para reaparecer




        block_green_color: .word 0x0000ff00 # verde puro RGB

        # Variables para el segundo enemigo
        enemy2_x:   .word 15       # posición inicial X
        enemy2_y:   .word 20       # posición inicial Y
        enemy2_DIR: .word  MOV_LEFT # dirección inicialf
        enemy2_active: .word 0     # 1 = vivo, 0 = muerto

        enemy2_bullet_active: .word 0       # 0 = no hay bala, 1 = bala activa
        enemy2_bullet_x:      .word 0       # Coordenada X de la bala del enemigo 2
        enemy2_bullet_y:      .word 0       # Coordenada Y de la bala del enemigo 2
        enemy2_bullet_DIR:    .word MOV_DOWN  # Dirección inicial (por ejemplo, hacia abajo)
        enemy2_fire_counter:  .word 0       # Contador para disparos periódicos    
        enemy2_move_counter: .word 0       # Contador para el movimiento del enemigo 3


      enemy2_respawn_active: .word 1   # Flag de respawn para enemigo 2
      enemy2_respawn_counter: .word 0  # Contador de ciclos para enemigo 2



            
# En la sección .data
color_dark_pink: .word 0x00FF1493  # Rosado oscuro (Deep Pink)
        color_dark_blue: .word 0x0000008b # azul oscuro RGB

# Variables para el tercer enemigo
enemy3_x:   .word 40       # Posición inicial X
enemy3_y:   .word 15       # Posición inicial Y
enemy3_DIR: .word MOV_LEFT # Dirección inicial
enemy3_active: .word 1     # 1 = vivo, 0 = muerto

enemy3_bullet_active: .word 0       # 0 = no hay bala, 1 = bala activa
enemy3_bullet_x:      .word 0       # Coordenada X de la bala del enemigo 3
enemy3_bullet_y:      .word 0       # Coordenada Y de la bala del enemigo 3
enemy3_bullet_DIR:    .word MOV_DOWN  # Dirección inicial (por ejemplo, hacia abajo)
enemy3_fire_counter:  .word 0       # Contador para disparos periódicos

enemy3_move_counter: .word 0       # Contador para el movimiento del enemigo 3

enemy3_respawn_active: .word 0   # Flag de respawn para enemigo 3
enemy3_respawn_counter: .word 0  # Contador de ciclos para enemigo 3
game_time_counter: .word 0
# Variables para el segundo enemigo básico
# Segundo enemigo naranja (enemyA2)
color_orange2: .word 0x00FFA501  # Naranja puro RGB
enemyA2_x:       .word 20
enemyA2_y:       .word 5
enemyA2_DIR:     .word MOV_RIGHT
enemyA2_active:  .word 1
enemyA2_bullet_active: .word 0
enemyA2_bullet_x:      .word 0
enemyA2_bullet_y:      .word 0
enemyA2_bullet_DIR:    .word MOV_DOWN
enemyA2_fire_counter:  .word 0
enemyA2_move_counter:  .word 0


enemyA2_respawn_active: .word 0   # Flag de respawn para enemigo 2
enemyA2_respawn_counter: .word 0  # Contador de ciclos para enemigo 2


enemy_hit_counter: .word 0  # Contador de impactos al enemigo

enemy_hit_counter3: .word 0  # Contador de impactos al enemigo 3
reset_counter: .word 0

levelC:.word 1

player_shovel_active: .word 0    # 0 = pala inactiva, 1 = activa
shovel_timer:         .word 0    # cuenta regresiva del poder de pala

enemy_hit_counter2: .word 0  # Contador de impactos al enemigo 2

########################################################################
player_helmet_active:  .word 0  # 0 = no inmune, 1= inmune
helmet_timer:          .word 0 # temporizador para la duración del poder

loop_timer: .word 0

#########################################################################
##########################################################################
######################################################################
.data
    helmet_block_x: .word 15       # Coordenada X del bloque del casco
    helmet_block_y: .word 10       # Coordenada Y del bloque del casco
    helmet_block_active: .word 1   # 1 = activo, 0 = recogido
    blink_flag:   .word 0 
############################################################################
################################################################################
.text


.text

new_game:




reset_enemy_hit_counter:


    li t0, 0
    la t1, enemy_hit_counter
    sw t0, 0(t1)
    li t0, 0
    la t1, enemy_hit_counter2
    sw t0, 0(t1)





	# Reiniciar el contador global de reinicios
li t0, 0
la t1, reset_counter
sw t0, 0(t1)
li t0,0
la t1, enemy_hit_counter
sw t0, 0(t1)
    # Reiniciar el contador de tiempo de juego
    li t0, 0
    la t1, game_time_counter
    sw t0, 0(t1)
    


	jal clear_board
	jal draw_title_screen
	jal activate_helmet 
	
	  li t0, 0
    la t1, bullet_active       # Desactivar el proyectil
    sw t0, 0(t1)
    la t1, bullet_x            # Reiniciar coordenada X del proyectil
    sw t0, 0(t1)
    la t1, bullet_y            # Reiniciar coordenada Y del proyectil
    sw t0, 0(t1)
    la t1, bullet_DIR          # Reiniciar dirección del proyectil
    sw t0, 0(t1)


    # Reiniciar posición del enemigo
    li t0,  50                  # Posición inicial X del enemigo
    la t1, enemy_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del enemigo
    la t1, enemy_y
    sw t0, 0(t1)
    la t1, enemy_bullet_active # Desactivar la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_x      # Reiniciar coordenada X de la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_y      # Reiniciar coordenada Y de la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_DIR    # Reiniciar dirección de la bala del enemigo
    sw t0, 0(t1)
   
    # Reiniciar el contador de disparos del enemigo 1
        li t0, 0
        la t1, enemy_fire_counter
        sw t0, 0(t1)

    # Asegurarse de que el enemigo 1 esté activo
    li t0, 1
    la t1, enemy_active
    sw t0, 0(t1)

    # Si tienes una variable específica para el estado del bloque azul, reiníciala aquí
    # Por ejemplo:
    # la t1, block_blue_hit
    # sw t0, 0(t1)


            # Reiniciar posición del jugador
    li t0, 24                   # Posición inicial X del jugador
    la t1, player_x
    sw t0, 0(t1)
    li t0, 58                  # Posición inicial Y del jugador
    la t1, player_y
    sw t0, 0(t1)


    # Reiniciar posición del segundo enemigo
    li t0,  20                  # Posición inicial X del segundo enemigo
    la t1, enemy2_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del segundo enemigo
    la t1, enemy2_y
    sw t0, 0(t1)

    #descativar bullet enemigo 2
    li t0, 0   
    la t1, enemy2_bullet_active # Desactivar la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_x      # Reiniciar coordenada X de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_DIR    # Reiniciar dirección de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_fire_counter  # Reiniciar el contador de disparos del enemigo 2
    sw t0, 0(t1)
 


     # Reiniciar posición del tercer enemigo
    li t0,  40                  # Posición inicial X del tercer enemigo
    la t1, enemy3_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del tercer enemigo
    la t1, enemy3_y
    sw t0, 0(t1)
    


    #descativar bullet enemigo 3

    li t0, 0
    la t1, enemy3_bullet_active # Desactivar la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_x      # Reiniciar coordenada X de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_DIR    # Reiniciar dirección de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_fire_counter  # Reiniciar el contador de disparos del enemigo 3
    sw t0, 0(t1)




# ======== REINICIAR ENEMIGO 1 (normal) ========
li t0, 1
la t1, enemy_active
sw t0, 0(t1)

li t0, 0
la t1, enemy1_respawn_active
sw t0, 0(t1)
la t1, enemy1_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR ENEMIGO 2 (cyan) ========
li t0, 0
la t1, enemy2_active
sw t0, 0(t1)
 #Reiniciar posición del segundo enemigo (cyan)
li t0, 20                  # Posición inicial X del segundo enemigo
la t1, enemy2_x
sw t0, 0(t1)
li t0, 4                   # Posición inicial Y del segundo enemigo
la t1, enemy2_y
sw t0, 0(t1)

li t0, 0                   # Reiniciar contadores
la t1, enemy2_fire_counter
sw t0, 0(t1)
la t1, enemy2_respawn_active
sw t0, 0(t1)
la t1, enemy2_respawn_counter
sw t0, 0(t1)

li t0, 1
la t1, enemy2_respawn_active
sw t0, 0(t1)

li t0, 0
la t1, enemy2_respawn_counter
sw t0, 0(t1)

li t0, 0
la t1, enemy2_bullet_active
sw t0, 0(t1)
la t1, enemy2_bullet_x
sw t0, 0(t1)
la t1, enemy2_bullet_y
sw t0, 0(t1)
la t1, enemy2_bullet_DIR
sw t0, 0(t1)



# ======== REINICIAR ENEMIGO A2 (naranja claro) ========
li t0, 1
la t1, enemyA2_active
sw t0, 0(t1)
#reiniciar posición
li t0, 20
la t1, enemyA2_x
sw t0, 0(t1)
li t0, 5
la t1, enemyA2_y
sw t0, 0(t1)
li t0, 0                   # Reiniciar contadores
la t1, enemyA2_fire_counter
sw t0, 0(t1)
la t1, enemyA2_respawn_active
sw t0, 0(t1)
la t1, enemyA2_respawn_counter
sw t0, 0(t1)


li t0, 0
la t1, enemyA2_respawn_active
sw t0, 0(t1)
la t1, enemyA2_respawn_counter
sw t0, 0(t1)


li t0, 0
la t1, enemyA2_bullet_active
sw t0, 0(t1)
la t1, enemyA2_bullet_x
sw t0, 0(t1)
la t1, enemyA2_bullet_y
sw t0, 0(t1)
la t1, enemyA2_bullet_DIR




# ======== REINICIAR ENEMIGO 3 (rosado rápido) ========
li t0, 1
la t1, enemy3_active
sw t0, 0(t1)

li t0, 0
la t1, enemy3_respawn_active
sw t0, 0(t1)
la t1, enemy3_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR TIEMPO DE JUEGO ========
li t0, 0
la t1, game_time_counter
sw t0, 0(t1)




#reinicar enemy hit counter
li t0, 0
la t1, enemy_hit_counter
sw t0, 0(t1)

#reiniar levelC
li t0, 1
la t1, levelC
sw t0, 0(t1)
#reiniciar el contador de tiempo








jal press_1


	press_1:
    	lw t0, KEY_INPUT_ADDRESS # Sirve para verificar la tecla que ingresa el jugador, en este caso 1
    	
    	li t1, ASCII_1 
    	beq t0, t1, start_game
    	li a0, 250
    	li a7, 32
    	ecall
    	
    	j press_1 
    	
# ———————————————————————————————————————————————#
# INICIO

start_game:
    jal clear_board
    sw zero, KEY_STATUS_ADDRESS, t0 
    li   a7, 40        # syscall time()
    ecall              # a0 ← segundos  
    mv   a0, a0
    li   a7, 41        # syscall srand(a0)
    ecall
      # — Reiniciar el número de kills —
    li   t0, 0
    la   t1, p1_kills
    sw   t0, 0(t1)
    j    new_round


draw_level_1_blocks:
    addi sp, sp, -4
    sw ra, 0(sp)
    
 ###LADO IZQUIERFDA DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 8
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line


li a0, 9
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 10
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 11
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 16
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line


li a0, 17
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 18
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 19
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line


 ###LADO DERECHO DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 40
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 48
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 8
li a3, 28
lw a2, color_yellow
jal draw_vertical_line
###LADO ABAJO IZQUIERDO INFERIOR 
 ###LADO IZQUIERFDA DE LA PANTALLA SUPERIOR
 # === PAR 1 ===
li a0, 8
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


li a0, 9
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 10
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 11
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 16
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


li a0, 17
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 18
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 19
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


#lado inferior izquierdo de la pantalla 
 ###LADO DERECHO DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 40
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 48
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


# Dibujar las filas del bloque (horizontales) izquierda
li a0, 13        # Reiniciar X inicial
li a1, 34          # Coordenada Y inicial
li a3, 20          # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila


# Dibujar las filas del bloque (horizontales) derecha
li a0, 40        # Reiniciar X inicial
li a1, 34          # Coordenada Y inicial
li a3, 47         # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila



################H DE ARRIBA 
# === PAR 1===
li a0, 24
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


li a0, 25
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 26
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 27
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2 ===
li a0, 32
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


li a0, 33
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 34
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 35
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

####H de abajo
# === PAR 1===
li a0, 24
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line


li a0, 25
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line

li a0, 26
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line

li a0, 27
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2 ===
li a0, 32
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line


li a0, 33
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line

li a0, 34
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line

li a0, 35
li a1, 35
li a3, 46
lw a2, color_yellow
jal draw_vertical_line

#---------------------------------------------------#
#espacio para poner el aguila 
# Dibujar las filas del bloque (horizontales)
li a0, 27          # Reiniciar X inicial
li a1, 57          # Coordenada Y inicial
li a3, 28          # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales)
li a0, 33          # Reiniciar X inicial
li a1, 57        # Coordenada Y inicial
li a3, 34         # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales)
li a0, 27          # Reiniciar X inicial
li a1, 55   # Coordenada Y inicial
li a3, 34          # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila

#---------------------------------------------------#





# Dibujar un bloque morado más grande (4x4 píxeles)  de la H superior centro
li a0, 28      # Coordenada X inicial
li a1, 10       # Coordenada Y inicial
li a3, 15         # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna


# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 28      # Coordenada X inicial
li a1, 40     # Coordenada Y inicial
li a3, 43       # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna



####Bloques laterales 

#DERECHA 
# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 3      # Coordenada X inicial
li a1, 34   # Coordenada Y inicial
li a3, 37      # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna

#IZQUIERDA
####Bloques laterales 
# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 53     # Coordenada X inicial
li a1, 34   # Coordenada Y inicial
li a3, 37      # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna


#--------------------------------------------------#
 # Bloque azul esta es la aguila 
    li a0, 30         # Coordenada X
    li a1, 58      # Coordenada Y
    li a3, 60      # Coordenada Y final (altura del bloque)
    lw a2, color_blue   # Color azul

jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
#--------------------------------------------------#


#jal restore_green_blocks

    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra    





new_round:
    lw a0, p1_score
    li a1, P1_SCORE_COLUMN
    jal draw_score
    li a0, 3
    jal draw_lives
   # jal restore_green_blocks

    lw a0, player_x
    lw a1, player_y
    lw a2, color_red
    li a3, MOV_STAY
    jal draw_player

    # Llama a la función para dibujar los bloques del nivel 1
    jal draw_level_1_blocks

    li a0, 1000
    li a7, 32
    ecall  # 1 second delay

    j main_game_loop





new_game2:
    # Reiniciar el contador global de reinicios
    # Reiniciar el contador global de reinicios
 # Configurar el nivel actual a 2
    li      t0, 2
    la      t1, levelC
    sw      t0, 0(t1)
    
   li t0, 0
la t1, enemy_hit_counter2
sw t0, 0(t1)

   


#limpiar mapa 1
jal clear_board

li t0, 0
la t1, reset_counter
sw t0, 0(t1)
    jal clear_board
      li t0, 0
    la t1, bullet_active       # Desactivar el proyectil
    sw t0, 0(t1)
    la t1, bullet_x            # Reiniciar coordenada X del proyectil
    sw t0, 0(t1)
    la t1, bullet_y            # Reiniciar coordenada Y del proyectil
    sw t0, 0(t1)
    la t1, bullet_DIR          # Reiniciar dirección del proyectil
    sw t0, 0(t1)



    # Reiniciar posición del enemigo
    li t0,  50                  # Posición inicial X del enemigo
    la t1, enemy_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del enemigo
    la t1, enemy_y
    sw t0, 0(t1)
    la t1, enemy_bullet_active # Desactivar la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_x      # Reiniciar coordenada X de la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_y      # Reiniciar coordenada Y de la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_DIR    # Reiniciar dirección de la bala del enemigo
    sw t0, 0(t1)
    
    # Reiniciar el contador de disparos del enemigo 1
        li t0, 0
        la t1, enemy_fire_counter
        sw t0, 0(t1)

    # Asegurarse de que el enemigo 1 esté activo
    li t0, 1
    la t1, enemy_active
    sw t0, 0(t1)

    # Si tienes una variable específica para el estado del bloque azul, reiníciala aquí
    # Por ejemplo:
    # la t1, block_blue_hit
    # sw t0, 0(t1)


            # Reiniciar posición del jugador
    li t0, 24                   # Posición inicial X del jugador
    la t1, player_x
    sw t0, 0(t1)
    li t0, 58              # Posición inicial Y del jugador
    la t1, player_y
    sw t0, 0(t1)


    # Reiniciar posición del segundo enemigo
    li t0,  20                  # Posición inicial X del segundo enemigo
    la t1, enemy2_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del segundo enemigo
    la t1, enemy2_y
    sw t0, 0(t1)

    #descativar bullet enemigo 2
    li t0, 0   
    la t1, enemy2_bullet_active # Desactivar la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_x      # Reiniciar coordenada X de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_DIR    # Reiniciar dirección de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_fire_counter  # Reiniciar el contador de disparos del enemigo 2
    sw t0, 0(t1)
 


     # Reiniciar posición del tercer enemigo
    li t0,  40                  # Posición inicial X del tercer enemigo
    la t1, enemy3_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del tercer enemigo
    la t1, enemy3_y
    sw t0, 0(t1)
    


    #descativar bullet enemigo 3

    li t0, 0
    la t1, enemy3_bullet_active # Desactivar la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_x      # Reiniciar coordenada X de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_DIR    # Reiniciar dirección de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_fire_counter  # Reiniciar el contador de disparos del enemigo 3
    sw t0, 0(t1)




# ======== REINICIAR ENEMIGO 1 (normal) ========
li t0, 1
la t1, enemy_active
sw t0, 0(t1)

li t0, 0
la t1, enemy1_respawn_active
sw t0, 0(t1)
la t1, enemy1_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR ENEMIGO 2 (cyan) ========
li t0, 0
la t1, enemy2_active
sw t0, 0(t1)
 #Reiniciar posición del segundo enemigo (cyan)
li t0, 20                  # Posición inicial X del segundo enemigo
la t1, enemy2_x
sw t0, 0(t1)
li t0, 4                   # Posición inicial Y del segundo enemigo
la t1, enemy2_y
sw t0, 0(t1)

li t0, 0                   # Reiniciar contadores
la t1, enemy2_fire_counter
sw t0, 0(t1)
la t1, enemy2_respawn_active
sw t0, 0(t1)
la t1, enemy2_respawn_counter
sw t0, 0(t1)

li t0, 1
la t1, enemy2_respawn_active
sw t0, 0(t1)

li t0, 0
la t1, enemy2_respawn_counter
sw t0, 0(t1)




# ======== REINICIAR ENEMIGO A2 (naranja claro) ========
li t0, 1
la t1, enemyA2_active
sw t0, 0(t1)
#reiniciar posición
li t0, 20
la t1, enemyA2_x
sw t0, 0(t1)
li t0, 5
la t1, enemyA2_y
sw t0, 0(t1)
li t0, 0                   # Reiniciar contadores
la t1, enemyA2_fire_counter
sw t0, 0(t1)
la t1, enemyA2_respawn_active
sw t0, 0(t1)
la t1, enemyA2_respawn_counter
sw t0, 0(t1)


li t0, 0
la t1, enemyA2_respawn_active
sw t0, 0(t1)
la t1, enemyA2_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR ENEMIGO 3 (rosado rápido) ========
li t0, 1
la t1, enemy3_active
sw t0, 0(t1)

li t0, 0
la t1, enemy3_respawn_active
sw t0, 0(t1)
la t1, enemy3_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR TIEMPO DE JUEGO ========
li t0, 0
la t1, game_time_counter
sw t0, 0(t1)

#reinicar enemigo hit counter
li t0, 0
la t1, enemy_hit_counter
sw t0, 0(t1)





start_game2:
    jal clear_board
    sw zero, KEY_STATUS_ADDRESS, t0 
    li   a7, 40        # syscall time()
    ecall              # a0 ← segundos  
    mv   a0, a0
    li   a7, 41        # syscall srand(a0)
    ecall
        # — Reiniciar el número de kills —
    li   t0, 0
    la   t1, p1_kills
    sw   t0, 0(t1)
    j    new_round2





.draw_level_2_blocks:
    addi sp, sp, -4
    sw ra, 0(sp)    

 ###LADO IZQUIERFDA DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 8
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line


li a0, 9
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

li a0, 10
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

li a0, 11
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 16
li a1, 18
li a3, 26
lw a2, color_yellow
jal draw_vertical_line


li a0, 17
li a1, 18
li a3, 26
lw a2, color_yellow
jal draw_vertical_line

li a0, 18
li a1, 18
li a3, 26
lw a2, color_yellow
jal draw_vertical_line

li a0, 19
li a1, 18
li a3, 26
lw a2, color_yellow
jal draw_vertical_line

 ###LADO DERECHO DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 40
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 8
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

# === PAR 1.1 ===
li a0, 40
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 48
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2.1===
li a0, 48
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line
###LADO ABAJO IZQUIERDO INFERIOR 
 ###LADO IZQUIERFDA DE LA PANTALLA SUPERIOR
 # === PAR 1 ===
li a0, 8
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


li a0, 9
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 10
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 11
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 16
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


li a0, 17
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 18
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line

li a0, 19
li a1, 42
li a3, 55
lw a2, color_yellow
jal draw_vertical_line


#lado inferior izquierdo de la pantalla 
 ###LADO DERECHO DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 40
li a1, 45
li a3, 48
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 45
li a3, 48
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 45
li a3, 48
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 45
li a3, 48
lw a2, color_yellow
jal draw_vertical_line
# === PAR 1.1 ===
li a0, 40
li a1, 37
li a3, 40
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 37
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 37
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 37
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 48
li a1, 30
li a3, 48
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 30
li a3, 48
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 30
li a3, 48
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 30
li a3, 48
lw a2, color_yellow
jal draw_vertical_line



 ###LADO DERECHO DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 40
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 48
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 53
li a3, 56
lw a2, color_yellow
jal draw_vertical_line


    



##Centro de la pantalla
# Dibujar las filas del bloque (horizontales) izquierda
li a0, 24   # Reiniciar X inicial
li a1, 41       # Coordenada Y inicial
li a3, 35    # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales) izquierda
li a0, 24   # Reiniciar X inicial
li a1, 44       # Coordenada Y inicial
li a3, 35    # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila

# Dibujar las filas del bloque (horizontales) izquierda
li a0, 24    # Reiniciar X inicial
li a1, 47          # Coordenada Y inicial
li a3, 35    # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
##LISTO

# Dibujar las filas del bloque (horizontales) derecha
li a0, 40        # Reiniciar X inicial
li a1, 57        # Coordenada Y inicial
li a3, 51       # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila





################H DE ARRIBA 
# === PAR 1===
li a0, 24
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


li a0, 25
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 26
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 27
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2 ===
li a0, 32
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


li a0, 33
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 34
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 35
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

#### H de abajo
# === PAR 1===
li a0, 24
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line


li a0, 25
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 26
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 27
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2 ===
li a0, 32
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line


li a0, 33
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 34
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 35
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

#-------------------------------------AGUILA--------------------------------------#

#---------------------------------------------------#
#espacio para poner el aguila 
# Dibujar las filas del bloque (horizontales)
li a0, 27          # Reiniciar X inicial
li a1, 57          # Coordenada Y inicial
li a3, 28          # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales)
li a0, 33          # Reiniciar X inicial
li a1, 57        # Coordenada Y inicial
li a3, 34         # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales)
li a0, 27          # Reiniciar X inicial
li a1, 55   # Coordenada Y inicial
li a3, 34          # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila

#---------------------------------------------------#

#--------------------------------------------------#
 # Bloque azul esta es la aguila 
    li a0, 30         # Coordenada X
    li a1, 58      # Coordenada Y
    li a3, 60      # Coordenada Y final (altura del bloque)
    lw a2, color_blue   # Color azul

jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
#--------------------------------------------------#
#FIN DEL AGUILA
#----------------------------------------------------------------##



# Dibujar un bloque morado más grande (4x4 píxeles)  de la H superior centro
li a0, 28      # Coordenada X inicial
li a1, 10       # Coordenada Y inicial
li a3, 15         # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna


# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 28      # Coordenada X inicial
li a1, 40     # Coordenada Y inicial
li a3, 43       # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna



####Bloques laterales izquierda

#entre los dos amarillos
# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 3      # Coordenada X inicial
li a1, 34   # Coordenada Y inicial
li a3, 37      # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna

#entre ambas columas
####Bloques laterales 
# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 40    # Coordenada X inicial
li a1, 15  # Coordenada Y inicial
li a3, 18     # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna




####Bloques laterales 
# 
li a0, 44    # Coordenada X inicial
li a1, 11  # Coordenada Y inicial
li a3, 14    # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna



####Bloques laterales 
# 
li a0, 52 # Coordenada X inicial
li a1, 19  # Coordenada Y inicial
li a3, 22    # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna



####Bloques laterales 
# 
li a0, 44 # Coordenada X inicial
li a1, 45 # Coordenada Y inicial
li a3, 48   # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna


li a0, 12 # Coordenada X inicial
li a1, 45 # Coordenada Y inicial
li a3, 50  # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna

jal restore_green_blocks  #FUNCION QUE COLOREA LOS BLOQUES VERDES 




#---------------------------------------------------#
jal main_game_loop






# Function: new_round
#	The function does not have parameters, but due to speed internally uses the following convention
#		s0 stores the p1 dir
#		s1 stores the p2 dir
#		s2 stores thel ball x velocity
#		s3 stores the ball y velocity
#		s4 stores the player 1 paddle position
#		s5 stores the player 2 paddle position
#		s6 stores the ball x position
# 		s7 stores tghe ball y position
# This function is part of the main loop, so it does not require to save the state of the s registers
# but if it were an internal function, it should save each state.
new_round2:
        j .draw_level_2_blocks






new_game3:
    # Reiniciar el contador global de reinicios
#limpiar mapa 1
jal clear_board
li t0, 0
la t1, enemy_hit_counter2
sw t0, 0(t1)

li t0, 0
la t1, reset_counter
sw t0, 0(t1)
    jal clear_board
      li t0, 0
    la t1, bullet_active       # Desactivar el proyectil
    sw t0, 0(t1)
    la t1, bullet_x            # Reiniciar coordenada X del proyectil
    sw t0, 0(t1)
    la t1, bullet_y            # Reiniciar coordenada Y del proyectil
    sw t0, 0(t1)
    la t1, bullet_DIR          # Reiniciar dirección del proyectil
    sw t0, 0(t1)



    # Reiniciar posición del enemigo
    li t0,  50                  # Posición inicial X del enemigo
    la t1, enemy_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del enemigo
    la t1, enemy_y
    sw t0, 0(t1)
    la t1, enemy_bullet_active # Desactivar la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_x      # Reiniciar coordenada X de la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_y      # Reiniciar coordenada Y de la bala del enemigo
    sw t0, 0(t1)
    la t1, enemy_bullet_DIR    # Reiniciar dirección de la bala del enemigo
    sw t0, 0(t1)
    
    # Reiniciar el contador de disparos del enemigo 1
        li t0, 0
        la t1, enemy_fire_counter
        sw t0, 0(t1)

    # Asegurarse de que el enemigo 1 esté activo
    li t0, 1
    la t1, enemy_active
    sw t0, 0(t1)

    # Si tienes una variable específica para el estado del bloque azul, reiníciala aquí
    # Por ejemplo:
    # la t1, block_blue_hit
    # sw t0, 0(t1)


            # Reiniciar posición del jugador
    li t0, 24                   # Posición inicial X del jugador
    la t1, player_x
    sw t0, 0(t1)
    li t0, 58                   # Posición inicial Y del jugador
    la t1, player_y
    sw t0, 0(t1)


    # Reiniciar posición del segundo enemigo
    li t0,  20                  # Posición inicial X del segundo enemigo
    la t1, enemy2_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del segundo enemigo
    la t1, enemy2_y
    sw t0, 0(t1)

    #descativar bullet enemigo 2
    li t0, 0   
    la t1, enemy2_bullet_active # Desactivar la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_x      # Reiniciar coordenada X de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_bullet_DIR    # Reiniciar dirección de la bala del enemigo 2
    sw t0, 0(t1)
    la t1, enemy2_fire_counter  # Reiniciar el contador de disparos del enemigo 2
    sw t0, 0(t1)
 


     # Reiniciar posición del tercer enemigo
    li t0,  40                  # Posición inicial X del tercer enemigo
    la t1, enemy3_x
    sw t0, 0(t1)
    li t0, 4                  # Posición inicial Y del tercer enemigo
    la t1, enemy3_y
    sw t0, 0(t1)
    


    #descativar bullet enemigo 3

    li t0, 0
    la t1, enemy3_bullet_active # Desactivar la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_x      # Reiniciar coordenada X de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_bullet_DIR    # Reiniciar dirección de la bala del enemigo 3
    sw t0, 0(t1)
    la t1, enemy3_fire_counter  # Reiniciar el contador de disparos del enemigo 3
    sw t0, 0(t1)




# ======== REINICIAR ENEMIGO 1 (normal) ========
li t0, 1
la t1, enemy_active
sw t0, 0(t1)

li t0, 0
la t1, enemy1_respawn_active
sw t0, 0(t1)
la t1, enemy1_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR ENEMIGO 2 (cyan) ========
li t0, 0
la t1, enemy2_active
sw t0, 0(t1)
 #Reiniciar posición del segundo enemigo (cyan)
li t0, 20                  # Posición inicial X del segundo enemigo
la t1, enemy2_x
sw t0, 0(t1)
li t0, 4                   # Posición inicial Y del segundo enemigo
la t1, enemy2_y
sw t0, 0(t1)

li t0, 0                   # Reiniciar contadores
la t1, enemy2_fire_counter
sw t0, 0(t1)
la t1, enemy2_respawn_active
sw t0, 0(t1)
la t1, enemy2_respawn_counter
sw t0, 0(t1)

li t0, 1
la t1, enemy2_respawn_active
sw t0, 0(t1)

li t0, 0
la t1, enemy2_respawn_counter
sw t0, 0(t1)




# ======== REINICIAR ENEMIGO A2 (naranja claro) ========
li t0, 1
la t1, enemyA2_active
sw t0, 0(t1)
#reiniciar posición
li t0, 20
la t1, enemyA2_x
sw t0, 0(t1)
li t0, 5
la t1, enemyA2_y
sw t0, 0(t1)
li t0, 0                   # Reiniciar contadores
la t1, enemyA2_fire_counter
sw t0, 0(t1)
la t1, enemyA2_respawn_active
sw t0, 0(t1)
la t1, enemyA2_respawn_counter
sw t0, 0(t1)


li t0, 0
la t1, enemyA2_respawn_active
sw t0, 0(t1)
la t1, enemyA2_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR ENEMIGO 3 (rosado rápido) ========
li t0, 1
la t1, enemy3_active
sw t0, 0(t1)

li t0, 0
la t1, enemy3_respawn_active
sw t0, 0(t1)
la t1, enemy3_respawn_counter
sw t0, 0(t1)

# ======== REINICIAR TIEMPO DE JUEGO ========
li t0, 0
la t1, game_time_counter
sw t0, 0(t1)
#reinicar enemy_hit
li t0, 0
la t1, enemy_hit_counter
sw t0, 0(t1)





start_game3:
    jal clear_board
    sw zero, KEY_STATUS_ADDRESS, t0 
    li   a7, 40        # syscall time()
    ecall              # a0 ← segundos  
    mv   a0, a0
    li   a7, 41        # syscall srand(a0)
    ecall
        # — Reiniciar el número de kills —
    li   t0, 0
    la   t1, p1_kills
    sw   t0, 0(t1)
    j    new_round3



.draw_level_3_blocks:
###LADO IZQUIERFDA DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 8
li a1, 3
li a3, 13
lw a2, color_yellow
jal draw_vertical_line


li a0, 9
li a1, 3
li a3, 13
lw a2, color_yellow
jal draw_vertical_line

li a0, 10
li a1, 3
li a3, 13
lw a2, color_yellow
jal draw_vertical_line

li a0, 11
li a1, 3
li a3, 13
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 16
li a1, 3
li a3, 23
lw a2, color_yellow
jal draw_vertical_line


li a0, 17
li a1, 3
li a3, 23
lw a2, color_yellow
jal draw_vertical_line

li a0, 18
li a1, 3
li a3, 23
lw a2, color_yellow
jal draw_vertical_line

li a0, 19
li a1, 3
li a3, 23
lw a2, color_yellow
jal draw_vertical_line

# === centrro del castillo derecho abajo ===
li a0, 12
li a1, 57
li a3, 60
lw a2, color_yellow
jal draw_vertical_line


li a0, 13
li a1, 57
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

li a0, 14
li a1, 57
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

li a0, 15
li a1, 57
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

 ###LADO DERECHO DE LA PANTALLA SUPERIOR
# === PAR 1 ===
li a0, 40
li a1, 6
li a3, 16
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 6
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 6
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 6
li a3, 16
lw a2, color_yellow
jal draw_vertical_line

# === PAR 1.1 ===
li a0, 40
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line


li a0, 41
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 42
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 43
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 48
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 8
li a3, 14
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2.1===
li a0, 48
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line


li a0, 49
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 50
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

li a0, 51
li a1, 19
li a3, 22
lw a2, color_yellow
jal draw_vertical_line

 ###LADO IZQUIERFDA DE LA PANTALLA SUPERIOR
 # === PAR 1 ===
li a0, 8
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line


li a0, 9
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

li a0, 10
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

li a0, 11
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

# === PAR 2 ===
li a0, 16
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line


li a0, 17
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

li a0, 18
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line

li a0, 19
li a1, 53
li a3, 60
lw a2, color_yellow
jal draw_vertical_line




##Centro de la pantalla
# Dibujar las filas del bloque (horizontales) izquierda
li a0, 24   # Reiniciar X inicial
li a1, 41       # Coordenada Y inicial
li a3, 35    # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales) izquierda
li a0, 24   # Reiniciar X inicial
li a1, 44       # Coordenada Y inicial
li a3, 35    # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila

# Dibujar las filas del bloque (horizontales) izquierda
li a0, 24    # Reiniciar X inicial
li a1, 47          # Coordenada Y inicial
li a3, 35    # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
##LISTO

# Dibujar las filas del bloque (horizontales) derecha
li a0, 40        # Reiniciar X inicial
li a1, 57        # Coordenada Y inicial
li a3, 51       # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila





################H DE ARRIBA 
# === PAR 1===
li a0, 24
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


li a0, 25
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 26
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 27
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2 ===
li a0, 32
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line


li a0, 33
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 34
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

li a0, 35
li a1, 8
li a3, 20
lw a2, color_yellow
jal draw_vertical_line

#### H de abajo
# === PAR 1===
li a0, 24
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line


li a0, 25
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 26
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 27
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line


# === PAR 2 ===
li a0, 32
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line


li a0, 33
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 34
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line

li a0, 35
li a1, 35
li a3, 40
lw a2, color_yellow
jal draw_vertical_line








#-------------------------------------AGUILA--------------------------------------#

#---------------------------------------------------#
#espacio para poner el aguila 
# Dibujar las filas del bloque (horizontales)
li a0, 27          # Reiniciar X inicial
li a1, 57          # Coordenada Y inicial
li a3, 28          # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales)
li a0, 33          # Reiniciar X inicial
li a1, 57        # Coordenada Y inicial
li a3, 34         # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Primera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Segunda fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila
# Dibujar las filas del bloque (horizontales)
li a0, 27          # Reiniciar X inicial
li a1, 55   # Coordenada Y inicial
li a3, 34          # Coordenada X final (ancho del bloque)
jal draw_horizontal_line  # Tercera fila
addi a1, a1, 1          # Mover a la siguiente fila
jal draw_horizontal_line  # Cuarta fila

#---------------------------------------------------#

#--------------------------------------------------#
 # Bloque azul esta es la aguila 
    li a0, 30         # Coordenada X
    li a1, 58      # Coordenada Y
    li a3, 60      # Coordenada Y final (altura del bloque)
    lw a2, color_blue   # Color azul

jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
#--------------------------------------------------#
#FIN DEL AGUILA
#----------------------------------------------------------------##




# Dibujar un bloque morado más grande (4x4 píxeles)  de la H superior centro
li a0, 16   # Coordenada X inicial
li a1, 12       # Coordenada Y inicial
li a3, 15         # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna


# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 28      # Coordenada X inicial
li a1, 40     # Coordenada Y inicial
li a3, 43       # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna



####Bloques laterales izquierda

#entre los dos amarillos
# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 3      # Coordenada X inicial
li a1, 30   # Coordenada Y inicial
li a3, 40     # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna


li a0, 12 # Coordenada X inicial
li a1, 3 # Coordenada Y inicial
li a3, 10     # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna

#entre ambas columas
####Bloques laterales 
# Dibujar un bloque morado más grande (4x4 píxeles)  de la H  centro
li a0, 40    # Coordenada X inicial
li a1, 15  # Coordenada Y inicial
li a3, 18     # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna




####Bloques laterales 
# 
li a0, 44    # Coordenada X inicial
li a1, 11  # Coordenada Y inicial
li a3, 14    # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna



####Bloques laterales 
# 
li a0, 52 # Coordenada X inicial
li a1, 19  # Coordenada Y inicial
li a3, 22    # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna



####Bloques laterales 
# 
li a0, 44 # Coordenada X inicial
li a1, 45 # Coordenada Y inicial
li a3, 48   # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna


li a0, 12 # Coordenada X inicial
li a1, 45 # Coordenada Y inicial
li a3, 50  # Coordenada Y final (altura del bloque)
lw a2, color_purple  # Color morado

# Dibujar las columnas del bloque (verticales)

jal draw_vertical_line  # Segunda columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Tercera columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna
addi a0, a0, 1          # Mover a la siguiente columna
jal draw_vertical_line  # Cuarta columna

jal restore_green_blocks  #FUNCION QUE COLOREA LOS BLOQUES VERDES 

#---------------------------------------------------#

#---------------------------------------------------#


    jal main_game_loop



 new_round3:
        j .draw_level_3_blocks   











.reiniciar_enemigo_1:
    li t0, 1
    la t1, enemy_active
    sw t0, 0(t1) # Reiniciar el estado del enemigo a activo

    li t0, 0
    la t1, enemy1_respawn_counter
    sw t0, 0(t1) # Reiniciar el contador de respawn del enemigo 1

    li t0, 50
    la t1, enemy_x
    sw t0, 0(t1) # Reiniciar la posición X del enemigo 1

    li t0, 4
    la t1, enemy_y
    sw t0, 0(t1) # Reiniciar la posición Y del enemigo 1
#reiniciar proyectil enemigo 1
    li t0, 0
    la t1, enemy_bullet_active # Desactivar la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_bullet_x      # Reiniciar coordenada X de la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_bullet_DIR    # Reiniciar dirección de la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_fire_counter  # Reiniciar el contador de disparos del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_move_counter  # Reiniciar el contador de movimiento del enemigo 1
    sw t0, 0(t1)
#reiniciar respaw n enemigo 1\
    li t0, 0
    la t1, enemy1_respawn_active # Desactivar el respawn del enemigo 1
    sw t0, 0(t1)
    la t1, enemy1_respawn_counter # Reiniciar el contador de respawn del enemigo 1
    sw t0, 0(t1)
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
.reiniciar_enemigo_2:
    li t0, 1
    la t1, enemy_active
    sw t0, 0(t1) # Reiniciar el estado del enemigo a activo
    li t0, 0
    la t1, enemy1_respawn_counter
    sw t0, 0(t1) # Reiniciar el contador de respawn del enemigo 1
    li t0, 50
    la t1, enemy_x
    sw t0, 0(t1) # Reiniciar la posición X del enemigo 1
    li t0, 4
    la t1, enemy_y
    sw t0, 0(t1) # Reiniciar la posición Y del enemigo 1
#reiniciar proyectil enemigo 1
    li t0, 0
    la t1, enemy_bullet_active # Desactivar la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_bullet_x      # Reiniciar coordenada X de la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_bullet_y      # Reiniciar coordenada Y de la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_bullet_DIR    # Reiniciar dirección de la bala del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_fire_counter  # Reiniciar el contador de disparos del enemigo 1
    sw t0, 0(t1)
    la t1, enemy_move_counter  # Reiniciar el contador de movimiento del enemigo 1
    sw t0, 0(t1)

#reiniciar respaw n enemigo 1

    li t0, 0
    la t1, enemy1_respawn_active # Desactivar el respawn del enemigo 1
    sw t0, 0(t1)
    la t1, enemy1_respawn_counter # Reiniciar el contador de respawn del enemigo 1
    sw t0, 0(t1)
    

    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra




# ======================
# restore_green_block
# Inputs:
#    a0 = x position
#    a1 = y position
# Outputs: None
# Efecto: Dibuja un pixel verde
# ======================
# ==========================
# restore_green_block
# Inputs:
#   a0 = X
#   a1 = Y
# Outputs:
#   Nada
# ==========================
restore_green_blocks:
    addi sp, sp, -4
    sw ra, 0(sp)


    # Línea verde en x=55 lado derecho
    li a0, 52
    li a1, 8
    li a3, 18
    lw a2, color_green
    jal draw_vertical_line


    li a0, 53
    li a1, 8
    li a3, 18
    lw a2, color_green
    jal draw_vertical_line

    li a0, 54
    li a1, 8
    li a3, 18
    lw a2, color_green
    jal draw_vertical_line

    li a0, 55
    li a1, 8
    li a3, 18
    lw a2, color_green
  jal draw_vertical_line
 
     # Línea verde en x=55 lado derecho
    li a0, 3
    li a1, 8
    li a3, 18
    lw a2, color_green
    jal draw_vertical_line


   li a0, 4
   li a1, 8
   li a3, 18
   lw a2, color_green
   jal draw_vertical_line

   li a0, 5
   li a1, 8
   li a3, 18
  lw a2, color_green
  jal draw_vertical_line

  li a0, 6
  li a1, 8
  li a3, 18
  lw a2, color_green
 jal draw_vertical_line
 
  li a0, 7
  li a1, 8
  li a3, 18
  lw a2, color_green
 jal draw_vertical_line


     # Línea verde en x=55 lado derecho
    li a0, 3
    li a1, 45
    li a3, 55
    lw a2, color_green
    jal draw_vertical_line


   li a0, 4
   li a1, 45
   li a3, 55
   lw a2, color_green
   jal draw_vertical_line

   li a0, 5
   li a1, 45
   li a3, 55
  lw a2, color_green
  jal draw_vertical_line

  li a0, 6
  li a1, 45
  li a3, 55
  lw a2, color_green
 jal draw_vertical_line
 
  li a0, 7
  li a1, 45
  li a3, 55
  lw a2, color_green
 jal draw_vertical_line



lw ra, 0(sp)
addi sp, sp, 4
jr ra




restaure_brown_blocks:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Leer el valor de enemy_hit_counter
  # Antes de llamar a restaure_brown_blocks
la t0, enemy_hit_counter2
lw t1, 0(t0)
li a7, 1
ecall  
    
    

    #caso 0: 
    li t2, 0
    beq t1, t2, .case_0

    # Caso 1: enemy_hit_counter == 1
    li t2, 2
    beq t1, t2, .case_1

    # Caso 2: enemy_hit_counter == 2
    li t2, 4
    beq t1, t2, .case_2

    # Caso 3: enemy_hit_counter == 3
    li t2, 8
    beq t1, t2, .case_3

    # Por defecto, no hacer nada
    j .done1


.case_0:
    # No hacer nada
     li a0, 25      # x
    li a1, 26      # y inicial
    li a3, 27      # y final
    lw a2, color_black
    jal draw_vertical_line

   li a0, 46      # x
    li a1, 20       # y inicial
    li a3, 22     # y final
    lw a2, color_black
    jal draw_vertical_line


    li a0, 14      # x
    li a1, 15      # y inicial
    li a3, 16      # y final
    lw a2, color_black
    jal draw_vertical_line

    j .done1

.case_1:

    
    li a0, 25      # x
    li a1, 26      # y inicial
    li a3, 27      # y final
    lw a2, color_black
    jal draw_vertical_line
 
     li a0, 46      # x
    li a1, 20       # y inicial
    li a3, 22      # y final
    lw a2, color_sky_blue
    jal draw_vertical_line
    j .done1
.case_2:

    li a0, 46      # x
    li a1, 20       # y inicial
    li a3, 22       # y final
    lw a2, color_black
    jal draw_vertical_line

    li a0, 14      # x
    li a1, 15      # y inicial
    li a3, 16      # y final
    lw a2, color_sky_blue
    jal draw_vertical_line
    
    j .done1

.case_3:

    li a0, 14      # x
    li a1, 15      # y inicial
    li a3, 16      # y final
    lw a2, color_black
    jal draw_vertical_line

    li a0, 25      # x
    li a1, 4      # y inicial
    li a3, 27      # y final
    lw a2, color_sky_blue
    jal draw_vertical_line
    #reiniciar el contador 
    j .done1

.done1:
      # Desactivar el enemigo
   
    # Borrar el sprite del enemigo
    la t0, enemy_x
    lw t1, 0(t0)       # Leer la posición X del enemigo
    la t0, enemy_y
    lw t2, 0(t0)       # Leer la posición Y del enemigo
    lw a2, color_black # Usar color negro para borrar
    li t3, PADDLE_LENGTH
    add t3, t2, t3     # Calcular la altura del sprite
    mv a0, t1
    mv a1, t2
    mv a3, t3
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # Limpiar el jugador 1
    la t0, player_x
    lw t1, 0(t0)       # Leer la posición X del jugador
    la t0, player_y
    lw t2, 0(t0)       # Leer la posición Y del jugador
    lw a2, color_black # Usar color negro para borrar
    li t3, PADDLE_LENGTH
    add t3, t2, t3     # Calcular la altura del sprite
    mv a0, t1
    mv a1, t2
    mv a3, t3
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
# Dibujar las filas del bloque (horizontales) izquierda
#li a0, 24 # Reiniciar X inicial
#li a1, 25    # Coordenada Y inicial
#li a3, 26   # Coordenada X final (ancho del bloque)
#jal draw_horizontal_line  # Primera fila
#addi a1, a1, 1          # Mover a la siguiente fila
#jal draw_horizontal_line  # Segunda fila
#addi a1, a1, 1          # Mover a la siguiente fila
#jal draw_horizontal_line  # Tercera fila

lw ra, 0(sp)
addi sp, sp, 4
jr ra

# Function: main_game_loop
# This function is the main game loop of the game when playing
#	The function does not have parameters, but due to speed internally uses the following conventions
#		s0 stores the p1 dir
#		s1 stores the p2 dir
#		s2 stores thel ball x velocity
#		s3 stores the ball y velocity
#		s4 stores the player y paddle position
#		s5 stores the player x paddle position
#		s6 stores the ball x position
# 		s7 stores the ball y position
# Return:
# 	void.
main_game_loop:

	jal draw_margen
	#jal draw_test_map		
	# — Dibuja el score en pantalla — Funciona los pixceles pero no se esta actualiznaod, hay que arreglarlo
       lw    a0, p1_kills           # a0 ← número de enemigos abatidos
       li    a1, P1_SCORE_COLUMN    # a1 ← columna donde poner el primer puntito
        jal   draw_score
        li a0,3
     
      jal draw_lives
       

	.draw_objects:
               # — Aumentar el contador de tiempo de juego —
        la t0, game_time_counter
        lw t1, 0(t0)
        addi t1, t1, 1
        li t2, 0x7FFFFFFF  # Maximum value for a 32-bit signed integer
        bgt t1, t2, .reset_counter
        sw t1, 0(t0)
        j .continue
    .reset_counter:
        li t1, 0
        sw t1, 0(t0)
    .continue:
       jal restore_green_blocks

     jal update_bullet   # lo mueve y lo pinta cada ciclo
     jal update_enemy_bullet
  jal handle_enemy_respawn
    jal handle_enemy2_respawn
    jal handle_enemyA2_respawn
    jal handle_enemy3_respawn
             ###################################PODERES#################
     jal update_helmet
 # ...código del loop principal...
    la t0, player_shovel_active
    lw t1, 0(t0)
    beqz t1, .no_shovel_power

    # Si el poder está activo, refresca los bloques morados y decrementa el timer
    jal update_shovel
    la t0, shovel_timer
    lw t1, 0(t0)
    addi t1, t1, -1
    sw t1, 0(t0)
    bnez t1, .no_shovel_power

    # Si el timer llegó a 0, restaurar bloques amarillos y desactivar el poder
    jal draw_yellow_blocks
    li t1, 0
    la t0, player_shovel_active
    sw t1, 0(t0)
    la t0, shovel_timer
    sw t1, 0(t0)

.no_shovel_power:
    # ...resto del loop principal...



    
        # Lógica de disparo para el enemigo A2
    la   t0, enemyA2_active
    lw   t1, 0(t0)
    beqz t1, .no_fire_enemyA2_check   # Si no está vivo, no dispares

    # Controlar el tiempo antes de disparar
    la t0, game_time_counter
    lw t1, 0(t0)
    li t2, 300
    blt t1, t2, .no_fire_enemyA2_check  # Si aún no pasan 300 ciclos, no dispares

    la    t0, enemyA2_fire_counter
    lw    t1, 0(t0)
    addi  t1, t1, 1
    sw    t1, 0(t0)

    li    t2, 4
    remu  t3, t1, t2 # Cada 4 ciclos dispara
    bnez  t3, .no_fire_enemyA2_check
    jal   fire_enemyA2_bullet

    .no_fire_enemyA2_check:
        # Actualizar la bala del enemigo A2
        jal update_enemyA2_bullet



    # —––– lógica de disparo periódico solo si enemy_active == 1 –––—
    la   t0, enemy_active
    lw   t1, 0(t0)
    beqz t1, .no_fire_enemy_check   # si no está vivo, no dispares en absoluto

    la    t0, enemy_fire_counter
    lw    t1, 0(t0)
    addi  t1, t1, 2
    sw    t1, 0(t0)

    li    t2, 2
    remu  t3, t1, t2 # coje el valor de t1 (el contador de ciclos) y calculando su resto al dividirlo por t2 (el número de ciclos entre disparos). Si el resto es cero (t3==0), significa “cada N iteraciones” y ahí disparas. Si quisieras el resto con signo usarías la instrucción rem en lugar de remu
    bnez  t3, .no_fire_enemy_check
    jal   fire_enemy_bullet
.no_fire_enemy_check:
 # Lógica de disparo para el enemigo 2
    la   t0, enemy2_active
    lw   t1, 0(t0)
    beqz t1, .no_fire_enemy2_check   # Si no está vivo, no dispares

  # --- NUEVO: no dispares antes de tiempo ---
    la t0, game_time_counter
    lw t1, 0(t0)
    li t2, 200
    blt t1, t2, .no_fire_enemy2_check  # Si aún no pasan 200 ciclos, no dispares

    

    la    t0, enemy2_fire_counter
    lw    t1, 0(t0)
    addi  t1, t1, 1
    sw    t1, 0(t0)

    li    t2, 3
    remu  t3, t1, t2 # Cada 3 ciclos dispara
    bnez  t3, .no_fire_enemy2_check
    jal   fire_enemy2_bullet

.no_fire_enemy2_check:
    # Actualizar la bala del enemigo 2
    jal update_enemy2_bullet
    jal update_enemy2_bullet
    jal update_enemy2_bullet


# Lógica de disparo para el enemigo 3
# Lógica de disparo para el enemigo 3
la   t0, enemy3_active
lw   t1, 0(t0)
beqz t1, .no_fire_enemy3_check   # Si no está vivo, no dispares


# no dispares antes de tiempo ---
la t0, game_time_counter
lw t1, 0(t0)
li t2, 400
blt t1, t2, .no_fire_enemy3_check  # Si aún no pasan 400 ciclos, no dispares

la    t0, enemy3_fire_counter
lw    t1, 0(t0)
addi  t1, t1, 1
sw    t1, 0(t0)

li    t2, 4
remu  t3, t1, t2 # Cada 4 ciclos dispara
bnez  t3, .no_fire_enemy3_check
jal   fire_enemy3_bullet



.no_fire_enemy3_check:
    # Actualizar la bala del enemigo 3
    jal update_enemy3_bullet
    jal update_enemy3_bullet







        lw a2, color_red
        mv a3, s0
        lw a0, player_x
        lw a1, player_y
        jal draw_player
        sw a0, player_x, t0
        sw a1, player_y, t0
        li s0, MOV_STAY
        lw a2, color_red
        jal draw_point
#_________ENEMIGO_____BASIC_______________#
    # — sólo si enemy_active == 1 —
       la   t0, enemy_active
       lw   t1, 0(t0)
       beqz t1, .skip_enemy


# Controlar la frecuencia de movimiento del enemigo 3
la    t0, enemy_move_counter
lw    t1, 0(t0)
addi  t1, t1, 1
sw    t1, 0(t0)

li    t2, 3  # Umbral actual (ajusta este valor para cambiar la velocidad)
remu  t3, t1, t2
bnez  t3, .skip_enemy_move


        
        #pinta y mueve el tanque naranja
            .draw_enemigo:
       lw    a2, color_orange
        lw    a3, enemy_DIR
        lw    a0, enemy_x
        lw    a1, enemy_y
        jal   draw_enemy         # retorna a0=newX, a1=newY, a2=newDIR

        la    t0, enemy_x
        sw    a0, 0(t0)
        la    t0, enemy_y
        sw    a1, 0(t0)
        la    t0, enemy_DIR
        sw    a2, 0(t0)

        mv    a0, a0
        mv    a1, a1
        lw    a2, color_orange
        jal   draw_point

.skip_enemy_move:


.skip_enemy:



# ——————– Lógica de movimiento del enemigo 2 basico (enemyA2)——————–#
# — sólo si enemy2_active == 1 —
    la   t0, enemyA2_active
    lw   t1, 0(t0)
    beqz t1, .skip_enemyA2

# Controlar la frecuencia de movimiento del enemigo 3
la    t0, enemyA2_move_counter
lw    t1, 0(t0)
addi  t1, t1, 1
sw    t1, 0(t0)
li    t2, 3  # Umbral actual (ajusta este valor para cambiar la velocidad)
remu  t3, t1, t2
bnez  t3, .skip_enemyA2_move

    # Activar enemy2 después de 200 ciclos
    la t0, game_time_counter
    lw t1, 0(t0)
    li t2, 200
    blt t1, t2, .skip_enemyA2  # Si aún no pasan 200, no se activa
.draw_enemgoA2:
    lw    a2, color_orange2
    lw    a3, enemyA2_DIR
    lw    a0, enemyA2_x
    lw    a1, enemyA2_y
    jal draw_enemigoA2
         # retorna a0=newX, a1=newY, a2=newDIR

    la    t0, enemyA2_x
    sw    a0, 0(t0)
    la    t0, enemyA2_y
    sw    a1, 0(t0)
    la    t0, enemyA2_DIR
    sw    a2, 0(t0)

    mv    a0, a0
    mv    a1, a1
    lw    a2, color_orange2
    jal   draw_point
.skip_enemyA2_move:
.skip_enemyA2:




# _________ENEMIGO_____CYAN_______________#
# — sólo si enemy2_active == 1 —
    la   t0, enemy2_active
    lw   t1, 0(t0)
    beqz t1, .skip_enemy2

# Controlar la frecuencia de movimiento del enemigo 3
la    t0, enemy2_move_counter
lw    t1, 0(t0)
addi  t1, t1, 1
sw    t1, 0(t0)

li    t2, 3  # Umbral actual (ajusta este valor para cambiar la velocidad)
remu  t3, t1, t2
bnez  t3, .skip_enemy2_move


    # Activar enemy2 después de 200 ciclos
    la t0, game_time_counter
    lw t1, 0(t0)
    li t2, 200
    blt t1, t2, .skip_enemy2  # Si aún no pasan 200, no se activa


.draw_enemy_cyan:
    


    lw    a2, color_cyan
    lw    a3, enemy2_DIR
    lw    a0, enemy2_x
    lw    a1, enemy2_y
    jal   draw_enemy         # retorna a0=newX, a1=newY, a2=newDIR

    la    t0, enemy2_x
    sw    a0, 0(t0)
    la    t0, enemy2_y
    sw    a1, 0(t0)
    la    t0, enemy2_DIR
    sw    a2, 0(t0)

    mv    a0, a0
    mv    a1, a1
    lw    a2, color_cyan
    jal   draw_point

.skip_enemy2_move:
.skip_enemy2:


    
# — sólo si enemy3_active == 1 —
la   t0, enemy3_active
lw   t1, 0(t0)
beqz t1, .skip_enemy3

# Controlar la frecuencia de movimiento del enemigo 3
la    t0, enemy3_move_counter
lw    t1, 0(t0)
addi  t1, t1, 1
sw    t1, 0(t0)

li    t2, 1  # Umbral actual (ajusta este valor para cambiar la velocidad)
remu  t3, t1, t2
bnez  t3, .skip_enemy3_move

    # Activar enemy3 después de 400 ciclos
    la t0, game_time_counter
    lw t1, 0(t0)
    li t2, 400
    blt t1, t2, .skip_enemy3  # Si aún no pasan 400, no se activa


.draw_enemy_dark_pink:
    lw    a2, color_dark_pink
    lw    a3, enemy3_DIR
    lw    a0, enemy3_x
    lw    a1, enemy3_y
    jal   draw_enemy3         # retorna a0=newX, a1=newY, a2=newDIR

    la    t0, enemy3_x
    sw    a0, 0(t0)
    la    t0, enemy3_y
    sw    a1, 0(t0)
    la    t0, enemy3_DIR
    sw    a2, 0(t0)

    mv    a0, a0
    mv    a1, a1
    lw    a2, color_dark_pink
    jal   draw_point

.skip_enemy3_move:
.skip_enemy3:


    j .begin_standby

	
handle_enemy_respawn:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t0, enemy1_respawn_active
    lw t1, 0(t0)
    beqz t1, .skip_respawn

    # Aumentar contador
    la t0, enemy1_respawn_counter
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    # Si alcanza el tiempo
    li t2, 100
    bne t1, t2, .skip_respawn

    jal .reiniciar_enemigo_1

    # Apagar el respawn flag
    li t0, 0
    la t1, enemy1_respawn_active
    sw t0, 0(t1)

.skip_respawn:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
handle_enemy2_respawn:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Verificar si enemyA2 está activo
    la t0, enemyA2_active
    lw t1, 0(t0)
    bnez t1, .skip_respawn2  # Si enemyA2 está activo, no reaparecer

    la t0, enemy2_respawn_active
    lw t1, 0(t0)
    beqz t1, .skip_respawn2

    la t0, enemy2_respawn_counter
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    li t2, 150
    bne t1, t2, .skip_respawn2

    # Reiniciar enemigo 2
    li t0, 1
    la t1, enemy2_active
    sw t0, 0(t1)

    # Resetear su posición
    li t0, 20
    la t1, enemy2_x
    sw t0, 0(t1)

    li t0, 4
    la t1, enemy2_y
    sw t0, 0(t1)

    # Resetear sus contadores
    li t0, 0
    la t1, enemy2_fire_counter
    sw t0, 0(t1)

    li t0, 0
    la t1, enemy2_bullet_active
    sw t0, 0(t1)

    li t0, 0
    la t1, enemy2_respawn_active
    sw t0, 0(t1)

.skip_respawn2:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra





handle_enemyA2_respawn:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Verificar si enemy2 está activo
    la t0, enemy2_active
    lw t1, 0(t0)
    bnez t1, .skip_respawnA2  # Si enemy2 está activo, no reaparecer

    la t0, enemyA2_respawn_active
    lw t1, 0(t0)
    beqz t1, .skip_respawnA2

    la t0, enemyA2_respawn_counter
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    li t2, 150
    bne t1, t2, .skip_respawnA2

    # Reiniciar enemigo A2
    li t0, 1
    la t1, enemyA2_active
    sw t0, 0(t1)

    # Resetear su posición
    li t0, 20
    la t1, enemyA2_x
    sw t0, 0(t1)

    li t0, 4
    la t1, enemyA2_y
    sw t0, 0(t1)

    # Resetear sus contadores
    li t0, 0
    la t1, enemyA2_fire_counter
    sw t0, 0(t1)

    li t0, 0
    la t1, enemyA2_bullet_active
    sw t0, 0(t1)

    li t0, 0
    la t1, enemyA2_respawn_active
    sw t0, 0(t1)

.skip_respawnA2:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra








handle_enemy3_respawn:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t0, enemy3_respawn_active
    lw t1, 0(t0)
    beqz t1, .skip_respawn3

    la t0, enemy3_respawn_counter
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    li t2, 200
    bne t1, t2, .skip_respawn3

    # Reiniciar enemigo 3
    li t0, 1
    la t1, enemy3_active
    sw t0, 0(t1)

    # Resetear su posición
    li t0, 40
    la t1, enemy3_x
    sw t0, 0(t1)

    li t0, 4
    la t1, enemy3_y
    sw t0, 0(t1)

    # Resetear sus contadores
    li t0, 0
    la t1, enemy3_fire_counter
    sw t0, 0(t1)

    li t0, 0
    la t1, enemy3_bullet_active
    sw t0, 0(t1)

    li t0, 0
    la t1, enemy3_respawn_active
    sw t0, 0(t1)

.skip_respawn3:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra





	
	# Wait and read inputs
	 .begin_standby:
        li   t0, 5           # contador ~50 ms

    .standby:
        blez t0, .end_standby
        li   a0, 10          # pausa 10 ms
        li   a7, 32
        ecall
        addi t0, t0, -1

        lw   t1, KEY_STATUS_ADDRESS
        blez t1, .standby    # sigo esperando si no hay tecla

        # — tecla pulsada, leo cuál es —
        lw   t0, KEY_INPUT_ADDRESS   # t0 = ASCII de la tecla
        li   t1, ASCII_SPACE
        beq  t0, t1, .do_fire        # si es 'P', disparo
        # si no es P, muevo jugador
        jal  adjust_dir
        j    .after_input

    .do_fire:
        jal  fire_bullet         # llama a tu rutina de disparo

    .after_input:
        sw   zero, KEY_STATUS_ADDRESS, t1  # limpio el estado de tecla

    .end_standby:
        j    .draw_objects

# Function: adjust_dir
# Parameters:
#	None.
# Return:
#	void.
adjust_dir:
	lw t0, KEY_INPUT_ADDRESS
	
	.adjust_dir_left_up:
    li   t1, ASCII_W
    bne  t0, t1, .adjust_dir_left_down
    li   s0, MOV_UP
    # — guardar última dir —
    la   t1, last_DIR
    sw   s0, 0(t1)
    j    .adjust_dir_done

.adjust_dir_left_down:
    li   t1, ASCII_S
    bne  t0, t1, .adjust_dir_right
    li   s0, MOV_DOWN
    la   t1, last_DIR
    sw   s0, 0(t1)
    j    .adjust_dir_done

.adjust_dir_right:
    li   t1, ASCII_D
    bne  t0, t1, .adjust_dir_left
    li   s0, MOV_RIGHT
    la   t1, last_DIR
    sw   s0, 0(t1)
    j    .adjust_dir_done

.adjust_dir_left:
    li   t1, ASCII_A
    bne  t0, t1, .adjust_dir_none
    li   s0, MOV_LEFT
    la   t1, last_DIR
    sw   s0, 0(t1)
    j    .adjust_dir_done

		
	.adjust_dir_none:
		# This section is kept as a case point if the player didn't press a valid option
	
	.adjust_dir_done:
		jr ra
		

		



# Function: draw_player
# Parameters:
#	a0: paddle x position
#	a1: paddle top y position
#	a2: paddle color
#	a3: paddle direction
# Return:h
#	a0: new top y position
#	a1: direction of the paddle
#	a2: new top x position
draw_player:
	addi sp, sp -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)

	mv s0, a0 
	mv s1, a1
	mv s2, a2
	mv s3, a3
	# === Color dinámico según el estado del poder ===
   la t0, player_helmet_active
   lw t1, 0(t0)
   beqz t1, .set_red

   lw s2, color_gray
    
    j .draw_ready

.set_red:
    lw s2, color_red

.draw_ready:




##############################################################

	li t0, MOV_STAY
	beq t0, s3, .no_mov
	li t0, MOV_DOWN
	beq t0, s3, .down
	li t0, MOV_UP
	beq t0, s3, .up
	li t0, MOV_RIGHT
	beq t0, s3, .right
	li t0, MOV_LEFT
	beq t0, s3, .left
		
	#The default case is the up movement	
	


.up:
    # Verificar si el color actual es verde antes de borrar
    mv a0, s0
    mv a1, s1
    addi a3, a1, PADDLE_LENGTH 
    li t0, 2
    sll t0, a1, t0               # t0 = y * 64
    add t1, a0, t0               # t1 = x + y * 64
    li t0, 6
    sll t1, t1, t0               # t1 *= 4
    add t1, t1, gp
    lw t2, 0(t1)                 # Leer el color actual
    lw t3, color_green
    beq t2, t3, .skip_erase_up     # Si es verde, no borrar

    # Borrar el píxel si no es verde
    lw a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
.skip_erase_up:
    # Verificar si el paddle está en el límite superior
    li t0, TOP_PADDLE_Y_ROW
    beq s1, t0, .no_mov

    # Verificar colisiones en tres puntos arriba
    mv a0, s0
    mv a1, s1
    addi a1, a1, -1
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, 1
    mv a1, s1
    addi a1, a1, -1
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, 2
    mv a1, s1
    addi a1, a1, -1
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    # Mover hacia arriba si no hay colisión
    addi s1, s1, -1
    j .move






.down:
    # Verificar si el color actual es verde antes de borrar
    mv a0, s0
    mv a1, s1
    addi a3, a1, PADDLE_LENGTH
    li t0, 6
    sll t0, a1, t0               # t0 = y * 64
    add t1, a0, t0               # t1 = x + y * 64
    li t0, 2
    sll t1, t1, t0               # t1 *= 4
    add t1, t1, gp
    lw t2, 0(t1)                 # Leer el color actual
    lw t3, color_green
    beq t2, t3, .skip_erase_down      # Si es verde, no borrar

    # Borrar el píxel si no es verde
    lw a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
.skip_erase_down:
    # Verificar si el paddle está en el límite inferior
    li t0, BOTTOM_PADDLE_Y_ROW
    beq s1, t0, .no_mov

    # Verificar colisiones en tres puntos abajo
    mv a0, s0
    mv a1, s1
    addi a1, a1, 3
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, 1
    mv a1, s1
    addi a1, a1, 3
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, 2
    mv a1, s1
    addi a1, a1, 3
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    # Mover hacia abajo si no hay colisión
    addi s1, s1, 1
    j .move


    .left:
    # Verificar si el color actual es verde antes de borrar
    mv a0, s0
    mv a1, s1
    addi a3, a1, PADDLE_LENGTH
    li t0, 2
    sll t0, a1, t0               # t0 = y * 64
    add t1, a0, t0         # t1 = x + y * 64
    li t0, 6
    sll t1, t1, t0               # t1 *= 4
    add t1, t1, gp
    lw t2, 0(t1)                 # Leer el color actual
    lw t3, color_green
    beq t2, t3, .skip_erase_left      # Si es verde, no borrar

    # Borrar el píxel si no es verde
    lw a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
.skip_erase_left:
    # Verificar si el paddle está en el límite izquierdo
    li t0, TOP_PADDLE_X_ROW
    beq s0, t0, .no_mov

    # Verificar colisiones en tres puntos a la izquierda
    mv a0, s0
    addi a0, a0, -1
    mv a1, s1
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, -1
    mv a1, s1
    addi a1, a1, 1
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, -1
    mv a1, s1
    addi a1, a1, 2
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    # Mover hacia la izquierda si no hay colisión
    addi s0, s0, -1
    j .move
		
		.right:
    # Verificar si el color actual es verde antes de borrar
    mv a0, s0
    mv a1, s1
    addi a3, a1, PADDLE_LENGTH
    li t0, 6
    sll t0, a1, t0               # t0 = y * 64
    add t1, a0, t0               # t1 = x + y * 64
    li t0, 2
    sll t1, t1, t0               # t1 *= 4
    add t1, t1, gp
    lw t2, 0(t1)                 # Leer el color actual
    lw t3, color_green
    beq t2, t3, .skip_erase_right      # Si es verde, no borrar

    # Borrar el píxel si no es verde
    lw a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
.skip_erase_right:
    # Verificar si el paddle está en el límite derecho
    li t0, BOTTOM_PADDLE_X_ROW
    beq s0, t0, .no_mov

    # Verificar colisiones en tres puntos a la derecha
    mv a0, s0
    addi a0, a0, 3
    mv a1, s1
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, 3
    mv a1, s1
    addi a1, a1, 1
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    mv a0, s0
    addi a0, a0, 3
    mv a1, s1
    addi a1, a1, 2
    jal check_collision
    li t0, COLLISION
    beq t0, a0, .else

    # Mover hacia la derecha si no hay colisión
    addi s0, s0, 1
    j .move
		
	.no_mov:
		#set the return value to MOV_STAY
		li s3, MOV_STAY
	
	.else:
		j .move

	
	.move:
		mv a0, s0
		mv a1, s1
		mv a2, s2
		li t0, PADDLE_LENGTH
		add a3, a1, t0
		jal draw_vertical_line 
		addi a0, a0, 1
		jal draw_vertical_line 
		addi a0, a0, 1
		jal draw_vertical_line 
	# The return values of the new y-top position
	mv a0, s0
	mv a1, s1
	mv a2, s3	
	
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp 20
	
	jr ra
	
	#Function: check_collision
# Arguments:
#	a0: x
#	a1: y
#       s3:dirección de movimiento (MOV)
# Return:
#	COLLISION
#	NO_COLLISION

check_collision:
	addi sp, sp -4
	sw ra, 0(sp)
	#Calcular la direccion de memoria dl pixel (x,y)
	li t0, 6
	sll t0, a1, t0  # t0 = y * 64
	add t1, a0, t0 # t1 = x + y*64
	li t0, 2
	sll t1, t1, t0 
	add t1, t1, gp
	lw t1, (t1)
	
	    # Verificar colisión con el bloque del casco
    lw t0, color_gray
    beq t0, t1, .collision_helmet_block
	
#_________COMPARAR BLANCO CON COLISION DIRECTA	
	lw t0, color_white
	beq t0, t1, .collision
		#li a0, NO_COLLISION
		#j .check_collision_end

    lw t0, color_yellow  # Verificar colisión con color amarillo
    beq t0, t1, .collision

    lw t0, color_purple  # Verificar colisión con color morado
    beq t0, t1, .collision


     lw t0, color_orange     # color enemigo básico
    beq t0, t1, .collision

    lw t0, color_orange2    # color enemigo naranja claro
    beq t0, t1, .collision

    lw t0, color_cyan       # color enemigo cyan
    beq t0, t1, .collision


    lw t0, color_dark_pink  # color enemigo rápido rosado
    beq t0, t1, .collision
    
#-__________COMPARAR VERDE CON COLISION
 
 










    # Verificar color azul oscuro
    lw t0, color_dark_blue
    beq t0, t1, .desactivar_enemigo  # Si el jugador toca el bloque azul oscuro, desactiva el enemigo

    # Verificar color sky_blue
    lw t0, color_sky_blue
    beq t0, t1, .activar_pala

    # Verificar color café
    lw t0, color_brown
    beq t0, t1, .reset_enemy_hit_counter  # Si el jugador toca el bloque café, reinicia el contador

    # ... otras comparaciones si las tienes ...

    # Si no hubo colisión especial
    j .end

.activar_pala:
    li t0, 1
    la t1, player_shovel_active
    sw t0, 0(t1)
    li t0, 300
    la t1, shovel_timer
    sw t0, 0(t1)
    jal update_shovel
    j .end

 
.activate_shovel:
    # 1) Marcar pala como activa
    li      t0, 1
    la      t1, player_shovel_active
    sw      t0, 0(t1)

    # 2) Cargar duración del poder
    li      t0, 100
    la      t1, shovel_timer
    sw      t0, 0(t1)
         j .done1

    j       .end

.desactivar_enemigo:
    # Desactivar los enemigos y activar respawn
    li t0, 0
    la t1, enemy_hit_counter2
    sw t0, 0(t1)
    li t0, 0
    la t1, enemy_active
    sw t0, 0(t1)
    la t1, enemy2_active
    sw t0, 0(t1)
    la t1, enemy3_active
    sw t0, 0(t1)
    la t1, enemyA2_active
    sw t0, 0(t1)

    # Borrar sprite enemigo 1
    la t0, enemy_x
    lw t1, 0(t0)         # t1 = enemy_x
    la t0, enemy_y
    lw t2, 0(t0)         # t2 = enemy_y
    lw a2, color_black
    li t3, PADDLE_LENGTH
    add t3, t2, t3
    mv a0, t1
    mv a1, t2
    mv a3, t3
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # Borrar sprite enemigo 2
    la t0, enemy2_x
    lw t1, 0(t0)
    la t0, enemy2_y
    lw t2, 0(t0)
    lw a2, color_black
    li t3, PADDLE_LENGTH
    add t3, t2, t3
    mv a0, t1
    mv a1, t2
    mv a3, t3
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # Borrar sprite enemigo 3
    la t0, enemy3_x
    lw t1, 0(t0)
    la t0, enemy3_y
    lw t2, 0(t0)
    lw a2, color_black
    li t3, PADDLE_LENGTH
    add t3, t2, t3
    mv a0, t1
    mv a1, t2
    mv a3, t3
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # Borrar sprite enemigo A2
    la t0, enemyA2_x
    lw t1, 0(t0)
    la t0, enemyA2_y
    lw t2, 0(t0)
    lw a2, color_black
    li t3, PADDLE_LENGTH
    add t3, t2, t3
    mv a0, t1
    mv a1, t2
    mv a3, t3
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # Flags de respawn (deja esto después del borrado)
    li t0, 1
    la t1, enemy1_respawn_active
    sw t0, 0(t1)
    li t0, 0
    la t1, enemy1_respawn_counter
    sw t0, 0(t1)

    li t0, 1
    la t1, enemy2_respawn_active
    sw t0, 0(t1)
    li t0, 0
    la t1, enemy2_respawn_counter
    sw t0, 0(t1)

    li t0, 1
    la t1, enemy3_respawn_active
    sw t0, 0(t1)
    li t0, 0
    la t1, enemy3_respawn_counter
    sw t0, 0(t1)

    li t0, 1
    la t1, enemyA2_respawn_active
    sw t0, 0(t1)
    li t0, 0
    la t1, enemyA2_respawn_counter
    sw t0, 0(t1)

    j .end





.reset_enemy_hit_counter:
    # Reiniciar el contador enemy_hit_counter2
    li t2, 0
    la t0, enemy_hit_counter2
    sw t2, 0(t0)
    li a0, COLLISION
    j .activate_helmet


    
    .activate_helmet:
        # Logic to activate the helmet
        li t0, 1
        la t1, player_helmet_active
        sw t0, 0(t1)             # Set helmet active flag
        li t0, 100               # Set helmet timer duration
        la t1, helmet_timer
        sw t0, 0(t1)
          j .case_0
        j .end










    # Color verde: NO colisiona nunca
    lw t0, color_green
    beq t0, t1, .no_collision

    # Color negro: NO colisiona
    lw t0, color_black
    beq t0, t1, .no_collision







.collision_helmet_block:
    li a0, COLLISION
    j .end

    # Cualquier otro color: no colisiona
    j .no_collision


.check_direction:
    li t0, MOV_UP
    li t1, MOV_DOWN
    li t2, MOV_LEFT
    li t3, MOV_RIGHT
    beq s3, t1, .check_green_collision  # Si se mueve hacia abajo, no hay colisión
    beq s3, t2, .check_green_collision  # Si se mueve hacia la izquierda, no hay colisión
    beq s3, t3, .check_green_collision  # Si se mueve hacia la derecha, no hay colisión
    beq s3, t0, .check_green_collision  # Si se mueve hacia arriba, verifica colisión con verde

    # Si no es hacia arriba, no hay colisión
    li a0, NO_COLLISION
    j .end

.check_green_collision:
    # Si el color es verde, considera colisión solo si está bloqueado
    li a0, COLLISION
    j .end

	.collision:
		li a0, COLLISION
		j .end
.no_collision:
    li a0, NO_COLLISION

.end:	
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
	

draw_level_2_screen:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Limpiar la pantalla
    jal clear_board





# Letra L 
li a0, LEVEL_TEXT_X
addi a0, a0, 10
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 10
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

# Letra E 
li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line



######################### V
 # LETRA V
#  Brazo izquierdo (2 px)
li   a0, LEVEL_TEXT_X
addi a0, a0, 22
li   a1, LEVEL_TEXT_Y
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line

# Brazo izquierdo interior (2 px)
li   a0, LEVEL_TEXT_X
addi a0, a0, 23
li   a1, LEVEL_TEXT_Y
addi a1, a1, 2
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line

#Dos píxeles antes de la punta
li   a0, LEVEL_TEXT_X
addi a0, a0, 24
li   a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
addi a1, a1, -2        # H - 2
lw   a2, color_white
jal  draw_point

li   a0, LEVEL_TEXT_X
addi a0, a0, 24
li   a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
addi a1, a1, -1        # H - 1
lw   a2, color_white
jal  draw_point

#  Punta de la V
li   a0, LEVEL_TEXT_X
addi a0, a0, 24
li   a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H  # H
lw   a2, color_white
jal  draw_point

# Brazo derecho interior (2 px)
li   a0, LEVEL_TEXT_X
addi a0, a0, 25
li   a1, LEVEL_TEXT_Y
addi a1, a1, 2
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line

# Brazo derecho (2 px)
li   a0, LEVEL_TEXT_X
addi a0, a0, 26
li   a1, LEVEL_TEXT_Y
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line



###########################
# Letra E 
li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line


# Letra L 
li a0, LEVEL_TEXT_X
addi a0, a0, 35
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 35
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

########################### 1

    # mitad de la altura
    li   t0, LEVEL_TEXT_H
    srai t0, t0, 1          # t0 = H/2

    # Línea superior
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 43
    li   a1, LEVEL_TEXT_Y
    lw   a2, color_white
    addi a3, a0, 4
    jal  draw_horizontal_line

    #  Brazo derecho arriba
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 47
    li   a1, LEVEL_TEXT_Y
    lw   a2, color_white
    add  a3, a1, t0
    jal  draw_vertical_line

    # Línea media
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 43
    li   a1, LEVEL_TEXT_Y
    add  a1, a1, t0
    lw   a2, color_white
    addi a3, a0, 4
    jal  draw_horizontal_line

    # Brazo vertical inferior izquierdo (extendido)
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 43
    li   a1, LEVEL_TEXT_Y
    add  a1, a1, t0
    lw   a2, color_white
    add  a3, a1, t0
    addi a3, a3, 1
    jal  draw_vertical_line

    #  Línea inferior
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 43
    li   a1, LEVEL_TEXT_Y
    addi a1, a1, LEVEL_TEXT_H
    lw   a2, color_white
    addi a3, a0, 4
    jal  draw_horizontal_line


###################
       # Pausa para que el jugador vea el mensaje
    li a0, 3000         # Pausa de 3 segundos
    li a7, 32           # Syscall para delay
    ecall
jal new_game2

    # Finalizar
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra



draw_level_3_screen:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Limpiar la pantalla
    jal clear_board




# Letra L 
li a0, LEVEL_TEXT_X
addi a0, a0, 10
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 10
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

# Letra E 
li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 16
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line



######################### 
 # LETRA V
# Brazo izquierdo 
li   a0, LEVEL_TEXT_X
addi a0, a0, 22
li   a1, LEVEL_TEXT_Y
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line

# Brazo izquierdo interior 
li   a0, LEVEL_TEXT_X
addi a0, a0, 23
li   a1, LEVEL_TEXT_Y
addi a1, a1, 2
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line

#Dos píxeles antes de la punta
li   a0, LEVEL_TEXT_X
addi a0, a0, 24
li   a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
addi a1, a1, -2      
lw   a2, color_white
jal  draw_point

li   a0, LEVEL_TEXT_X
addi a0, a0, 24
li   a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
addi a1, a1, -1       
lw   a2, color_white
jal  draw_point

# Punta de la V
li   a0, LEVEL_TEXT_X
addi a0, a0, 24
li   a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H 
lw   a2, color_white
jal  draw_point

#  Brazo derecho interior
li   a0, LEVEL_TEXT_X
addi a0, a0, 25
li   a1, LEVEL_TEXT_Y
addi a1, a1, 2
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line

#Brazo derecho 
li   a0, LEVEL_TEXT_X
addi a0, a0, 26
li   a1, LEVEL_TEXT_Y
lw   a2, color_white
addi a3, a1, 1
jal  draw_vertical_line



###########################
# Letra E 
li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, LEVEL_TEXT_X
addi a0, a0, 29
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line


# Letra L 
li a0, LEVEL_TEXT_X
addi a0, a0, 35
li a1, LEVEL_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, LEVEL_TEXT_H
jal draw_vertical_line

li a0, LEVEL_TEXT_X
addi a0, a0, 35
li a1, LEVEL_TEXT_Y
addi a1, a1, LEVEL_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

########################### 
#NUMERO 3
     # Calcular mitad de altura t0
    li   t0, LEVEL_TEXT_H
    srai t0, t0, 1            

    # Línea superior 
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 49          
    li   a1, LEVEL_TEXT_Y    
    lw   a2, color_white
    addi a3, a0, 4           
    jal  draw_horizontal_line

    #  Rama vertical superior derecha
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 53       
    li   a1, LEVEL_TEXT_Y   
    lw   a2, color_white
    add  a3, a1, t0         
    jal  draw_vertical_line

    # Línea media
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 49          
    li   a1, LEVEL_TEXT_Y
    add  a1, a1, t0           
    lw   a2, color_white
    addi a3, a0, 4            
    jal  draw_horizontal_line

    #  Rama vertical inferior derecha
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 53          
    li   a1, LEVEL_TEXT_Y
    add  a1, a1, t0           
    lw   a2, color_white
    add  a3, a1, t0           
    addi a3, a3, 1           
    jal  draw_vertical_line

    #  Línea inferior 
    li   a0, LEVEL_TEXT_X
    addi a0, a0, 49          
    li   a1, LEVEL_TEXT_Y
    addi a1, a1, LEVEL_TEXT_H 
    lw   a2, color_white
    addi a3, a0, 4            
    jal  draw_horizontal_line


##############################
       # Pausa para que el jugador vea el mensaje
    li a0, 3000         # Pausa de 3 segundos
    li a7, 32           # Syscall para delay
    ecall
jal new_game3

    # Finalizar
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra







draw_p1_win: ##pantalla de perder
    addi sp, sp, -4
    sw   ra, 0(sp)

    # Limpiar la pantalla
    jal clear_board
      
       #———— LETRA E (offset 0) ————
        # Columna vertical
        li   a0, WINS_TEXT_X
        li   a1, WINS_TEXT_Y
        lw   a2, color_white
        addi a3, a1, WINS_TEXT_H
        jal  draw_vertical_line

        # Línea superior
        li   a0, WINS_TEXT_X
        li   a1, WINS_TEXT_Y
        lw   a2, color_white
        addi a3, a0, 4
        jal  draw_horizontal_line

        # Línea media
        li   a0, WINS_TEXT_X
        li   a1, WINS_TEXT_Y
        addi a1, a1, 2
        lw   a2, color_white
        addi a3, a0, 4
        jal  draw_horizontal_line

        # Línea inferior
        li   a0, WINS_TEXT_X
        li   a1, WINS_TEXT_Y
        addi a1, a1, WINS_TEXT_H
        lw   a2, color_white
        addi a3, a0, 4
        jal  draw_horizontal_line


        #———— LETRA N
        # Columna izquierda
        li   a0, WINS_TEXT_X
        addi a0, a0, 6
        li   a1, WINS_TEXT_Y
        lw   a2, color_white
        addi a3, a1, WINS_TEXT_H
        jal  draw_vertical_line

        # Diagonal (3 puntos)
        li   a0, WINS_TEXT_X
        addi a0, a0, 7
        li   a1, WINS_TEXT_Y
        addi a1, a1, 1
        lw   a2, color_white
        jal  draw_point

        li   a0, WINS_TEXT_X
        addi a0, a0, 8
        li   a1, WINS_TEXT_Y
        addi a1, a1, 2
        lw   a2, color_white
        jal  draw_point

        li   a0, WINS_TEXT_X
        addi a0, a0, 9
        li   a1, WINS_TEXT_Y
        addi a1, a1, 3
        lw   a2, color_white
        jal  draw_point

        # Columna derecha
        li   a0, WINS_TEXT_X
        addi a0, a0, 10
        li   a1, WINS_TEXT_Y
        lw   a2, color_white
        addi a3, a1, WINS_TEXT_H
        jal  draw_vertical_line


        # Columna vertical izquierda
        li   a0, WINS_TEXT_X
        addi a0, a0, 12        
        li   a1, WINS_TEXT_Y   
        lw   a2, color_white
        addi a3, a1, WINS_TEXT_H 
        jal  draw_vertical_line

        # Línea superior
        li   a0, WINS_TEXT_X
        addi a0, a0, 12
        li   a1, WINS_TEXT_Y
        lw   a2, color_white
        addi a3, a0, 4        
        jal  draw_horizontal_line

        # Línea inferior
        li   a0, WINS_TEXT_X
        addi a0, a0, 12
        li   a1, WINS_TEXT_Y
        addi a1, a1, WINS_TEXT_H
        lw   a2, color_white
        addi a3, a0, 4
        jal  draw_horizontal_line

        # Columna interior derecha
        li   a0, WINS_TEXT_X
        addi a0, a0, 16         # X0 + 16
        li   a1, WINS_TEXT_Y
        addi a1, a1, 1          # Y0+1
        lw   a2, color_white
        addi a3, a1, 3          
        jal  draw_vertical_line

        # Esquinas interiores simuladas con puntos

        # Esquina superior interior
        li   a0, WINS_TEXT_X
        addi a0, a0, 15         # X0 + 15
        li   a1, WINS_TEXT_Y
        addi a1, a1, 1          # Y0 + 1
        lw   a2, color_white
        jal  draw_point

        li   a0, WINS_TEXT_X
        addi a0, a0, 16
        li   a1, WINS_TEXT_Y
        addi a1, a1, 1
        lw   a2, color_white
        jal  draw_point

        # Esquina inferior interior
        li   a0, WINS_TEXT_X
        addi a0, a0, 15
        li   a1, WINS_TEXT_Y
        addi a1, a1, WINS_TEXT_H
        addi a1, a1, -1         # Y0 + H – 1
        lw   a2, color_white
        jal  draw_point

        li   a0, WINS_TEXT_X
        addi a0, a0, 16
        li   a1, WINS_TEXT_Y
        addi a1, a1, WINS_TEXT_H
        addi a1, a1, -1
        lw   a2, color_white
        jal  draw_point


    # Pausa para que el jugador vea el mensaje
    li a0, 3000         # Pausa de 3 segundos
    li a7, 32           # Syscall para delay
    ecall

    # Regresar al menú principal
    jal new_game

    # Finalizar
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra
# ———————————————————————————————————————————————
#  random_dir: devuelve en a0 uno de MOV_UP/DOWN/LEFT/RIGHT al azar
# ———————————————————————————————————————————————
random_dir:
    li   a7, 42        # syscall rand()
    ecall              # a0 ← rand()
    li   t1, 4
    remu a0, a0, t1    # a0 %= 4

    # mapear 0→UP, 1→DOWN, 2→LEFT, 3→RIGHT
    li   t0, 0
    beq  a0, t0, .dir_up
    li   t0, 1
    beq  a0, t0, .dir_down
    li   t0, 2
    beq  a0, t0, .dir_left
   
    li   a0, MOV_RIGHT
    jr   ra

.dir_up:
    li   a0, MOV_UP
    jr   ra
.dir_down:
    li   a0, MOV_DOWN
    jr   ra
.dir_left:
    li   a0, MOV_LEFT
    jr   ra

#----------------------------------------------------------
# draw_test_map
#   Dibuja una barrera verde horizontal en y=10
#   y sitúa al jugador en (5, 12)        AUN NO FUNCIONA PORQUE L JUGADOR BORRA LA LINEA EN LUGAR DE PASAR POR DEBAJO 
#----------------------------------------------------------
draw_test_map:
    addi sp, sp, -4
    sw   ra, 0(sp)

    # barrera verde de x=0..63 en y=10
    li   a0, 0            # x inicial
    li   a1, 10           # y = 10
    lw   a2, color_green
    li   a3, LAST_COLUMN  # x final = 63
    jal  draw_horizontal_line

    # dibuja el jugador justo debajo, en (5,12)
    li   a0, 5            # player_x = 5
    li   a1, 12           # player_y = 12
    lw   a2, color_red
    li   a3, MOV_STAY     # sin moverse
    jal  draw_player

    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra
# Function: draw_enemy2
# Mueve y dibuja al segundo enemigo
# a0=input X, a1=input Y, a2=color, a3=dir previa
# Returns: a0=new X, a1=new Y, a2=new DIR
draw_enemy2:
    addi sp, sp, -20
    sw   ra, 0(sp)
    sw   s0,  4(sp)
    sw   s1,  8(sp)
    sw   s2, 12(sp)
    sw   s3, 16(sp)

    mv   s0, a0        # s0 = X
    mv   s1, a1        # s1 = Y
    mv   s2, a2        # s2 = color
    mv   s3, a3        # s3 = dir previa

    # Lógica de movimiento (igual que draw_enemy)
    li   t0, MOV_UP
    beq  s3, t0, .arriba2
    li   t0, MOV_DOWN
    beq  s3, t0, .abajo2
    li   t0, MOV_LEFT
    beq  s3, t0, .izquierda2
    j    .derecha2

.arriba2:
 mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # si estamos en y=0, tratar como choque
   # si el próximo y (s1–1) toca o supera la línea superior
   mv   t0, s1
   addi t0, t0, -1         # t0 = s1-1
   li   t1, DRAW_LIMITS_UP # 1
   ble  t0, t1, .collision_BasicTank

    #tests de colisión sobre tres puntos arriba
    mv   a0, s0
    mv   a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
    li   t0, COLLISION
     beq t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 1
    mv a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, -1
    mv a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
     li   t0, COLLISION
     beq t0, a0, .collision_BasicTank

    #sin choque → muevo Y hacia arriba
    addi s1, s1, -1
    j    .paint2

.abajo2:
     # Borra la parte superior del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

    # Si llega al límite inferior, choque
    li   t0, BOTTOM_PADDLE_Y_ROW
    beq  s1, t0, .collision_BasicTank

    #colisión en tres puntos ↓
    mv   a0, s0
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 1
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 2
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    #Si no chocó, mueve Y hacia abajo
    addi s1, s1, 1
    # ...
    j    .paint2

.izquierda2:
    # 1) Borra el lado derecho del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

 #Si llega al límite izquierdo, choque
    li   t0, TOP_PADDLE_X_ROW
    beq  s0, t0, .collision_BasicTank
 #Tests de colisión en tres puntos ←
    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    addi a1, a1, 1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    addi a1, a1, 2
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

 # Si no chocó, mueve X hacia la izquierda
    addi s0, s0, -1
    j    .paint

    j    .paint2

.derecha2:
  # Borra el lado izquierdo del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

# Si llega al límite derecho, choque
    li   t0, BOTTOM_PADDLE_X_ROW
    beq  s0, t0, .collision_BasicTank
 #Tests de colisión en tres puntos →
    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    addi a1, a1, 1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    addi a1, a1, 2
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

#Si no chocó, mueve X hacia la derecha
    addi s0, s0, 1
    j    .paint2

.paint2:
    # Pintar el sprite del segundo enemigo
    mv   a0, s0
    mv   a1, s1
    mv   a2, s2
    li   t0, PADDLE_LENGTH
    add  a3, a1, t0
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

    # Retorno
    mv   a0, s0
    mv   a1, s1
    mv   a2, s3
    lw   ra,  0(sp)
    lw   s0,  4(sp)
    lw   s1,  8(sp)
    lw   s2, 12(sp)
    lw   s3, 16(sp)
    addi sp, sp, 20
    jr   ra
# ———————————————————————————————————————————————------------------------------------------------------------------------------------
draw_enemy3:
    addi  sp, sp, -20
    sw    ra,  0(sp)
    sw    s0,  4(sp)
    sw    s1,  8(sp)
    sw    s2, 12(sp)
    sw    s3, 16(sp)

    # — Guardar parámetros en registros —
    mv    s0, a0        # X
    mv    s1, a1        # Y
    mv    s2, a2        # color original
    mv    s3, a3        # dir previa

    # — Blink periódico: toggle y seleccionar color —
    la    t0, blink_flag
    lw    t1, 0(t0)
    xori  t1, t1, 1
    sw    t1, 0(t0)
    beqz  t1, .use_normal3
    lw    s2, color_cyan
.use_normal3:

    # — Lógica de movimiento (igual que draw_enemy) —
    li    t0, MOV_UP
    beq   s3, t0, .arriba3
    li    t0, MOV_DOWN
    beq   s3, t0, .abajo3
    li    t0, MOV_LEFT
    beq   s3, t0, .izquierda3
    j     .derecha3

.arriba3:
    mv   a0, s0
    mv a1, s1
     addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    mv   t0, s1
    addi t0, t0, -1
    li t1, DRAW_LIMITS_UP
    ble  t0, t1, .collision_BasicTank
    mv   a0, s0
    mv a1, s1
     addi a1, a1, -1
     jal check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, 1
     mv a1, s1
    addi a1, a1, -1
     jal check_collision_enemy
    li   t0, COLLISION
     beq t0, a0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, -1
     mv a1, s1
     addi a1, a1, -1
    jal check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank
    addi s1, s1, -1
    j    .paint3

.abajo3:
    mv   a0, s0
    mv a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    li   t0, BOTTOM_PADDLE_Y_ROW
     beq s1, t0, .collision_BasicTank
    mv   a0, s0
    mv a1, s1
     addi a1, a1, 3
     jal check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, 1
     mv a1, s1 
     addi a1, a1, 3 
     jal check_collision_enemy
    li   t0, COLLISION 
     beq t0, a0, .collision_BasicTank
    mv   a0, s0
     addi a0, a0, 2
     mv a1, s1
     addi a1, a1, 3
     jal check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank
    addi s1, s1, 1
    j    .paint3

.izquierda3:
    mv   a0, s0
     mv a1, s1
     addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
     jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    li   t0, TOP_PADDLE_X_ROW
    beq s0, t0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, -1
     mv a1, s1
     jal check_collision_enemy
    li   t0, COLLISION
     beq t0, a0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, -1
    mv a1, s1
    addi a1, a1, 1
    jal check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, -1
    mv a1, s1
    addi a1, a1, 2
     jal check_collision_enemy
    li   t0, COLLISION
     beq t0, a0, .collision_BasicTank
    addi s0, s0, -1
    j    .paint3

.derecha3:
    mv   a0, s0
    mv a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    li   t0, BOTTOM_PADDLE_X_ROW
     beq s0, t0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, 3
    mv a1, s1
    jal check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank
    mv   a0, s0
    addi a0, a0, 3
    mv a1, s1
    addi a1, a1, 1
    jal check_collision_enemy
    li   t0, COLLISION
     beq t0, a0, .collision_BasicTank
    mv   a0, s0
     addi a0, a0, 3
      mv a1, s1
      addi a1, a1, 2
      jal check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank
    addi s0, s0, 1
    j    .paint3

.collision_BasicTank_1:
    jal  random_dir
    mv   s3, a0
    j    .paint3

.paint3:
    mv   a0, s0
    mv   a1, s1
    mv   a2, s2        # color alternado en rojo u original
    li   t0, PADDLE_LENGTH
    add  a3, a1, t0
    jal  draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
     jal draw_vertical_line

    # Retorno
    mv   a0, s0
    mv   a1, s1
    mv   a2, s3
    lw   ra,  0(sp)
    lw   s0,  4(sp)
    lw   s1,  8(sp)
    lw   s2, 12(sp)
    lw   s3, 16(sp)
    addi sp, sp, 20
    jr   ra










draw_enemigoA2:
    addi sp, sp, -20
    sw   ra, 0(sp)
    sw   s0,  4(sp)
    sw   s1,  8(sp)
    sw   s2, 12(sp)
    sw   s3, 16(sp)

    mv   s0, a0        # s0 = X
    mv   s1, a1        # s1 = Y
    mv   s2, a2        # s2 = color
    mv   s3, a3        # s3 = dir previa

    # Lógica de movimiento (igual que draw_enemy)
    li   t0, MOV_UP
    beq  s3, t0, .arribaA2
    li   t0, MOV_DOWN
    beq  s3, t0, .abajoA2
    li   t0, MOV_LEFT
    beq  s3, t0, .izquierdaA2
    j    .derechaA2
.arribaA2:

    # borrar parte inferior del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # si estamos en y=0, tratar como choque
   # si el próximo y (s1–1) toca o supera la línea superior
   mv   t0, s1
   addi t0, t0, -1         # t0 = s1-1
   li   t1, DRAW_LIMITS_UP # 1
   ble  t0, t1, .collision_BasicTank

    #tests de colisión sobre tres puntos arriba
    mv   a0, s0
    mv   a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
    li   t0, COLLISION
     beq t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 1
    mv a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, -1
    mv a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
     li   t0, COLLISION
     beq t0, a0, .collision_BasicTank
    #sin choque → muevo Y hacia arriba
    addi s1, s1, -1
    j    .paintA2
    # ——————————
    # ABAJO
    # ——————————
.abajoA2:
    # Borra la parte superior del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

    # Si llega al límite inferior, choque
    li   t0, BOTTOM_PADDLE_Y_ROW
    beq  s1, t0, .collision_BasicTankA2

    #colisión en tres puntos ↓
    mv   a0, s0
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

    mv   a0, s0
    addi a0, a0, 1
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

    mv   a0, s0
    addi a0, a0, 2
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2
    #Si no chocó, mueve Y hacia abajo
    addi s1, s1, 1
    j    .paintA2
    # ————————————
    # IZQIOERDA
    # ————————————
.izquierdaA2:
    # 1) Borra el lado derecho del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

 #Si llega al límite izquierdo, choque
    li   t0, TOP_PADDLE_X_ROW
    beq  s0, t0, .collision_BasicTankA2
 #Tests de colisión en tres puntos ←
    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    addi a1, a1, 1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    addi a1, a1, 2
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

 # Si no chocó, mueve X hacia la izquierda
    addi s0, s0, -1
    j    .paintA2
# ——————————
# DERECHA
# —————————
.derechaA2:
# —————————
 # Borra el lado izquierdo del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

# Si llega al límite derecho, choque
    li   t0, BOTTOM_PADDLE_X_ROW
    beq  s0, t0, .collision_BasicTankA2
 #Tests de colisión en tres puntos →
    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    addi a1, a1, 1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    addi a1, a1, 2
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTankA2

#Si no chocó, mueve X hacia la derecha
    addi s0, s0, 1
    j    .paint


# ———————————————————————————————
# Choque: elige nueva dirección
# ————————————————————————————————
.collision_BasicTankA2:
    jal  random_dir
    mv   s3, a0
    j    .paintA2
# ————————————————————————————————
# Pintar sprite en (s0,s1) con color s2
# ————————————————————————————————
.paintA2:
    # Pintar el sprite del segundo enemigo
    mv   a0, s0
    mv   a1, s1
    mv   a2, s2
    li   t0, PADDLE_LENGTH
    add  a3, a1, t0
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

    # Retorno
    mv   a0, s0
    mv   a1, s1
    mv   a2, s3
    lw   ra,  0(sp)
    lw   s0,  4(sp)
    lw   s1,  8(sp)
    lw   s2, 12(sp)
    lw   s3, 16(sp)
    addi sp, sp, 20
    jr   ra
# ———————————————————————————————————————————————------------------------------------------------------------------------------------











draw_enemy:
    addi sp, sp, -20
    sw   ra, 0(sp)
    sw   s0,  4(sp)
    sw   s1,  8(sp)
    sw   s2, 12(sp)
    sw   s3, 16(sp)

    mv   s0, a0        # s0 = X
    mv   s1, a1        # s1 = Y
    mv   s2, a2        # s2 = color
    mv   s3, a3        # s3 = dir previa

    #  elige hacia donde con s3 
    li   t0, MOV_UP
    beq  s3, t0, .arriba
    li   t0, MOV_DOWN
    beq  s3, t0, .abajo
    li   t0, MOV_LEFT
    beq  s3, t0, .izquierda
    j    .derecha

# —————————
# ARRIBA
# ————————
.arriba:
    # borrar parte inferior del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line
    addi a0, a0, 1
    jal draw_vertical_line

    # si estamos en y=0, tratar como choque
   # si el próximo y (s1–1) toca o supera la línea superior
   mv   t0, s1
   addi t0, t0, -1         # t0 = s1-1
   li   t1, DRAW_LIMITS_UP # 1
   ble  t0, t1, .collision_BasicTank

    #tests de colisión sobre tres puntos arriba
    mv   a0, s0
    mv   a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
    li   t0, COLLISION
     beq t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 1
    mv a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, -1
    mv a1, s1
    addi a1, a1, -1
    jal  check_collision_enemy
     li   t0, COLLISION
     beq t0, a0, .collision_BasicTank

    #sin choque → muevo Y hacia arriba
    addi s1, s1, -1
    j    .paint

 # ——————————
 # ABAJO
 # ——————————
.abajo:
    # Borra la parte superior del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

    # Si llega al límite inferior, choque
    li   t0, BOTTOM_PADDLE_Y_ROW
    beq  s1, t0, .collision_BasicTank

    #colisión en tres puntos ↓
    mv   a0, s0
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 1
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 2
    mv   a1, s1
    addi a1, a1, 3
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    #Si no chocó, mueve Y hacia abajo
    addi s1, s1, 1
    j    .paint


 # ————————————
 # IZQIOERDA
 # ————————————
.izquierda:
    # 1) Borra el lado derecho del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

 #Si llega al límite izquierdo, choque
    li   t0, TOP_PADDLE_X_ROW
    beq  s0, t0, .collision_BasicTank
 #Tests de colisión en tres puntos ←
    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    addi a1, a1, 1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, -1
    mv   a1, s1
    addi a1, a1, 2
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

 # Si no chocó, mueve X hacia la izquierda
    addi s0, s0, -1
    j    .paint

# ——————————
# DERECHA
# —————————
.derecha:
 # Borra el lado izquierdo del sprite
    mv   a0, s0
    mv   a1, s1
    addi a3, a1, PADDLE_LENGTH
    lw   a2, color_black
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

# Si llega al límite derecho, choque
    li   t0, BOTTOM_PADDLE_X_ROW
    beq  s0, t0, .collision_BasicTank
 #Tests de colisión en tres puntos →
    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    addi a1, a1, 1
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

    mv   a0, s0
    addi a0, a0, 3
    mv   a1, s1
    addi a1, a1, 2
    jal  check_collision_enemy
    li   t0, COLLISION
    beq  t0, a0, .collision_BasicTank

#Si no chocó, mueve X hacia la derecha
    addi s0, s0, 1
    j    .paint
 # ———————————————————————————————
 # Choque: elige nueva dirección
 # ————————————————————————————————
.collision_BasicTank:
    jal  random_dir
    mv   s3, a0
    j    .paint


# ————————————————————————————————
# Pintar sprite en (s0,s1) con color s2
# ————————————————————————————————
.paint:
    mv   a0, s0
    mv   a1, s1
    mv   a2, s2
    li   t0, PADDLE_LENGTH
    add  a3, a1, t0
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line
    addi a0, a0, 1
    jal  draw_vertical_line

    # Retorno
    mv   a0, s0
    mv   a1, s1
    mv   a2, s3
    lw   ra,  0(sp)
    lw   s0,  4(sp)
    lw   s1,  8(sp)
    lw   s2, 12(sp)
    lw   s3, 16(sp)
    addi sp, sp, 20
    jr   ra

#_____________________________________________________------------------------------------------------------------------
#Function: check_collision
# Arguments:
#	a0: x
#	a1: y
# Return:
#	COLLISION
#	NO_COLLISION
#___________________________________________________________--------------------------------------------------------------------------
check_collision_enemy:

	addi sp, sp -4
	sw ra, 0(sp)
	
	li t0, 6
	sll t0, a1, t0 
	add t1, a0, t0
	li t0, 2
	sll t1, t1, t0 
	add t1, t1, gp
	lw t1, (t1)
	
	lw t0, color_white
	beq t0, t1, .collision_enemy


   
    lw t0, color_yellow  # Verificar colisión con color amarillo
    beq t0, t1, .collision_enemy

    lw t0, color_purple  # Verificar colisión con color morado
    beq t0, t1, .collision_enemy
     lw t0, color_orange     # color del enemigo básico
    beq t0, t1, .collision_enemy

    lw t0, color_orange2    # color del enemigo A2
    beq t0, t1, .collision_enemy

    lw t0, color_cyan       # color del enemigo 2
    beq t0, t1, .collision_enemy

    lw t0, color_dark_pink  # color del enemigo 3
    beq t0, t1, .collision_enemy

    lw t0, color_gray      # color del jugador
    beq t0, t1, .collision_enemy
    #con el jugador
    lw t0, color_red
    beq t0, t1, .collision_enemy



  lw t0, color_dark_blue

    # Leer el valor de enemy_hit_counter
    la t0, enemy_hit_counter2
    lw t1, 0(t0)

    # Caso 1: enemy_hit_counter == 1
    li t2, 1
    beq t1, t2, .case_1B_granada

    # Caso 2: enemy_hit_counter == 2
    li t2, 2
    beq t1, t2, .case_2B_granada

    # Caso 3: enemy_hit_counter == 3
    li t2, 3
    beq t1, t2, .case_3B_granada

    # Por defecto, no hacer nada
    j .done_helmet




.case_1B_granada:
    
    
    li a0, 35      # x
    li a1, 30      # y inicial
    li a3, 32      # y final
    lw a2, color_black
    jal draw_vertical_line
    
    
    
    li a0, 40      # x
    li a3, 30     # y final
    lw a2, color_dark_blue
    jal draw_point

    j .done_helmet

.case_2B_granada:
    
   li a0, 40      # x
    li a1, 28      # y inicial
    li a3, 30     # y final
    lw a2, color_black
    jal draw_vertical_line
  
    li a0, 35      # x
    li a1, 30      # y inicial
    li a3, 32      # y final
    lw a2, color_brown
    jal draw_vertical_line
    j .done_helmet

.case_3B_granada:
    

   
    li a0, 35      # x
    li a1, 30      # y inicial
    li a3, 32      # y final
    lw a2, color_black
    jal draw_vertical_line


    li a0, 25      # x
    li a1, 26      # y inicial
    li a3, 27      # y final
    lw a2, color_brown
    jal draw_vertical_line

    #reiniciar el contador 

    li t1, 0               # Load 0 into t1
    la t0, enemy_hit_counter2
    sw t1, 0(t0)           # Store 0 into enemy_hit_counter2
    j .done_helmet












   lw t0, color_brown

    # Leer el valor de enemy_hit_counter
    la t0, enemy_hit_counter2
    lw t1, 0(t0)

    # Caso 1: enemy_hit_counter == 1
    li t2, 1
    beq t1, t2, .case_1_helmet

    # Caso 2: enemy_hit_counter == 2
    li t2, 2
    beq t1, t2, .case_2_helmet

    # Caso 3: enemy_hit_counter == 3
    li t2, 3
    beq t1, t2, .case_3_helmet

    # Por defecto, no hacer nada
    j .done_helmet

.case_1_helmet:
    
    
    li a0, 25      # x
    li a1, 26      # y inicial
    li a3, 27      # y final
    lw a2, color_black
    jal draw_vertical_line
    
    
    
    li a0, 46      # x
    li a1, 20       # y inicial
    li a3, 22      # y final
    lw a2, color_brown
    jal draw_vertical_line

    j .done_helmet

.case_2_helmet:
    
    li a0, 46      # x
    li a1, 20       # y inicial
    li a3, 22     # y final
    lw a2, color_black
    jal draw_vertical_line
    li a0, 14     # x
    li a1, 15      # y inicial
    li a3, 16      # y final
    lw a2, color_brown
    jal draw_vertical_line
    j .done_helmet

.case_3_helmet:
    

    li a0, 14      # x
    li a1, 15      # y inicial
    li a3, 16      # y final
    lw a2, color_black
    jal draw_vertical_line


    li a0, 25      # x
    li a1, 26      # y inicial
    li a3, 27      # y final
    lw a2, color_brown
    jal draw_vertical_line

    #reiniciar el contador 

    li t1, 0               # Load 0 into t1
    la t0, enemy_hit_counter2
    sw t1, 0(t0)           # Store 0 into enemy_hit_counter2
    j .done_helmet

.collision_enemy:
    li a0, COLLISION
    j .check_collision_enemy_end

.done_helmet:
    li a0, NO_COLLISION

.check_collision_enemy_end:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

#_________BALAAAAAAAAAAAAAAAAAAAAAAAAA_________________JUGADOR________________#

fire_bullet:
    addi sp, sp, -4
    sw   ra, 0(sp)

    # si ya hay bala activa, salgo
    lw   t0, bullet_active
    bne  t0, zero, .fp_done

    # activo la bala
    li   t0, 1
    la   t1, bullet_active
    sw   t0, 0(t1)

    # posición inicial X,Y
    lw   t0, player_x
    la   t1, bullet_x
    sw   t0, 0(t1)
    lw   t0, player_y
    la   t1, bullet_y
    sw   t0, 0(t1)

    # guardo la dirección de disparo ← last_DIR
    la   t1, last_DIR
    lw   t2, 0(t1)
    la   t1, bullet_DIR
    sw   t2, 0(t1)

.fp_done:
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra

#___________________________________________________________________________________________________________
   
# update_bullet: mueve la bala, mata al enemigo,
# y se desactiva al chocar contra muro blanco
# usa sólo T0–T6
#———————————————————————————————————————————————-------------------------------------------------------------
 
update_bullet:
    # — Prologue: salvar ra —
    addi    sp, sp, -4
    sw      ra, 0(sp)

    # ¿Bala activa?
    la      t0, bullet_active
    lw      t0, 0(t0)
    beqz    t0, .ub_end

    # Borrar el píxel viejo
    la      t1, bullet_x
    lw      t2, 0(t1)       # t2 = old_x
    la      t1, bullet_y
    lw      t3, 0(t1)       # t3 = old_y
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_black
    jal     draw_point

    # Calcular nueva posición (t2,t3)
    la      t4, bullet_DIR
    lw      t4, 0(t4)
    li      t5, MOV_UP
    beq     t4, t5, .mv_up
    li      t5, MOV_DOWN
    beq     t4, t5, .mv_down
    li      t5, MOV_LEFT
    beq     t4, t5, .mv_left
    # ⇒ mv_right por defecto
.mv_right:
    addi    t2, t2,  1
    j       .after_mv
.mv_left:
    addi    t2, t2, -1
    j       .after_mv
.mv_up:
    addi    t3, t3, -1
    j       .after_mv
.mv_down:
    addi    t3, t3,  1

.after_mv:
    # Leer color de pantalla en (t2,t3)
    li      t0, 6
    sll     t0, t3, t0       # t0 = y*64
    add     t0, t0, t2       # t0 = x + y*64
    li      t1, 2
    sll     t0, t0, t1       # t0 <<= 2
    add     t0, t0, gp
    lw      t5, 0(t0)        # t5 = color en pantalla

    #¿Choque contra enemigo (naranja_basic tank)?
    lw      t6, color_orange
    beq     t5, t6, .hit_enemy
    
    lw     t6, color_orange2
    beq     t5, t6, .hit_enemyA2

    #¿Choque contra enemigo2 (cyan_power tank)?
    lw      t6, color_cyan
    beq    t5, t6, .hit_enemy2

    #¿Choque contra enemigo3 (pink_fast tank)?
    lw      t6, color_dark_pink
    beq    t5, t6, .hit_enemy3

    #¿Choque contra muro blanco????????????????
    lw      t6, color_white
    beq     t5, t6, .disable


    # ¿Choque contra bloque amarillo?
    lw      t6, color_yellow
    beq     t5, t6, .remove_block
     beq     t5, t6, .disable

      # ¿Choque contra bloque amarillo?
    lw      t6, color_purple
     beq     t5, t6, .disable


    # ¿Choque contra bloque azul?
    lw      t6, color_blue
    beq     t5, t6, .p1_win   # Si es azul, mostrar pantalla de victoria



    # Límites de pantalla
    blt     t2, zero,      .disable
    li      t6, LAST_COLUMN
    bgt     t2, t6,        .disable
    blt     t3, zero,      .disable
    li      t6, DOWN_Y_LIMIT
    bgt     t3, t6,        .disable

    # Ningún choque: guardar y dibujar la bala
    la      t1, bullet_x
    sw      t2, 0(t1)
    la      t1, bullet_y
    sw      t3, 0(t1)
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_cyan
    jal     draw_point
    j       .ub_end


.p1_win:
    # Llamar a la función para mostrar la pantalla de victoria
    jal     draw_p1_win
    j       end              # Detener el juego


.p1_new_game:
 jal    draw_level_2_screen
    j       end              # Detener el juego


.p2_new_game:
    # Configurar el nivel actual a 3
    li      t0, 3
    la      t1, levelC
    sw      t0, 0(t1)

    # Llamar a la rutina para iniciar el nivel 3
    jal     draw_level_3_screen
    j       end


.remove_block:
    # Cambiar el bloque actual a negro
    mv      a0, t2          # Coordenada X del bloque
    mv      a1, t3          # Coordenada Y del bloque
    lw      a2, color_black # Cambiar a color negro
    jal     draw_point

    # Destruir el segundo bloque según la dirección
    la      t0, bullet_DIR
    lw      t0, 0(t0)       # Dirección del proyectil
    li      t1, MOV_LEFT
    beq     t0, t1, .destroy_second_vertical
    li      t1, MOV_RIGHT
    beq     t0, t1, .destroy_second_vertical
    li      t1, MOV_UP
    beq     t0, t1, .destroy_second_horizontal
    li      t1, MOV_DOWN
    beq     t0, t1, .destroy_second_horizontal
    j       .end_remove_block

.destroy_second_vertical:
    addi    a1, a1, -1      # Bloque arriba o abajo
    jal     draw_point
    j       .end_remove_block

.destroy_second_horizontal:
    addi    a0, a0, -1      # Bloque a la izquierda o derecha
    jal     draw_point

.end_remove_block:
    # Desactivar la bala
    j       .disable


.disable:
    # Desactivar bala
    la      t0, bullet_active
    sw      zero, 0(t0)
    j       .ub_end

.hit_enemy:
  # Incrementar el contador de impactos
    la      t0, enemy_hit_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)


#este contador se agrega por separedo al de enemy_hit_counter para no intereferir de ningunamanera en el original 
    la      t0, enemy_hit_counter2
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)



   # Verificar si el contador alcanza el límite (5)
    li      t2, 1
    beq     t1, t2, .check_level

    # 1) Borrar sprite enemigo (3 columnas × altura PADDLE_LENGTH+1)
    la    t0, enemy_x
    lw    t2, 0(t0)
    la    t0, enemy_y
    lw    t3, 0(t0)
    li    t4, PADDLE_LENGTH
    add   t4, t4, t3        # t4 = y + altura
    li    t5, 0             # offset = 0

# Desactivar enemigo
la    t0, enemy_active
sw    zero, 0(t0)

# Activar el respawn
li    t0, 1
la    t1, enemy1_respawn_active
sw    t0, 0(t1)

# Resetear contador de respawn
li    t0, 0
la    t1, enemy1_respawn_counter
sw    t0, 0(t1)


            jal restaure_brown_blocks



.clear_loop:
    add   t6, t2, t5        # t6 = x + offset
    mv    a0, t6
    mv    a1, t3
    mv    a3, t4
    lw    a2, color_black
    jal   draw_vertical_line
    addi  t5, t5, 1
    li    t0, 3
    blt   t5, t0, .clear_loop

    #Desactivar bala del jugador y enemigo
    la    t0, bullet_active
    sw    zero, 0(t0)
    la    t0, enemy_active
    sw    zero, 0(t0)

    #Desactivar bala enemiga
    la    t0, enemy_bullet_active
    sw    zero, 0(t0)

    #Borrar el píxel de la bala enemiga en pantalla (opcional)
    la    t0, enemy_bullet_x
    lw    t2, 0(t0)
    la    t0, enemy_bullet_y
    lw    t3, 0(t0)
    mv    a0, t2
    mv    a1, t3
    lw    a2, color_black
    jal   draw_point

    #Incrementar contador de kills
    la    t0, p1_kills
    lw    t1, 0(t0)
    addi  t1, t1, 1
    sw    t1, 0(t0)

   jal erase_score_pixel
    # — Borrar el último píxel del marcador —
  #  addi t1, t1, -1           # t1 = índice (kills-1)
   # slli  t1, t1, 1            # t1 = 2*(kills-1)  (separación de 2px entre puntos)
   # li   a0, P1_SCORE_COLUMN  # columna base del marcador
   # add  a0, a0, t1           # a0 = columna donde estaba el último punto
   # li   a1, ROW_1            # fila del marcador
    #lw   a2, color_black      # color negro = borrar
   # jal  draw_point

    # Redibujar marcador
  #  mv    a0, t1
   # li    a1, P1_SCORE_COLUMN
    #jal   draw_score

    j     .ub_end

.ub_end:
    lw    ra, 0(sp)
    addi  sp, sp, 4
    jr    ra


       .hit_enemy2:
         # Incrementar el contador de impactos
    la      t0, enemy_hit_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

   # Verificar si el contador alcanza el límite (5)
    li      t2, 1
    beq     t1, t2, .check_level

    # 1) Borrar sprite enemigo (3 columnas × altura PADDLE_LENGTH+1)
    la    t0, enemy2_x
    lw    t2, 0(t0)
    la    t0, enemy2_y
    lw    t3, 0(t0)
    li    t4, PADDLE_LENGTH
    add   t4, t4, t3        # t4 = y + altura
    li    t5, 0             # offset = 0



# Desactivar enemigo
la    t0, enemy2_active
sw    zero, 0(t0)
# Activar respawn enemigo 2
li t0, 1
la t1, enemy2_respawn_active
sw t0, 0(t1)

# Resetear su contador
li t0, 0
la t1, enemy2_respawn_counter
sw t0, 0(t1)


.clear_enemy2_loop:
    add   t6, t2, t5        # t6 = x + offset
    mv    a0, t6
    mv    a1, t3
    mv    a3, t4
    lw    a2, color_black
    jal   draw_vertical_line
    addi  t5, t5, 1
    li    t0, 3
    blt   t5, t0, .clear_enemy2_loop

    # Desactivar enemigo 2
    la    t0, enemy2_active
    sw    zero, 0(t0)

    # Incrementar contador de kills
    la    t0, p1_kills
    lw    t1, 0(t0)
    addi  t1, t1, 1
    sw    t1, 0(t0)
  jal erase_score_pixel
    # Redibujar marcador
   # mv    a0, t1
   # li    a1, P1_SCORE_COLUMN
   # jal   draw_score

    # Desactivar bala del jugador
    j     .disable



.hit_enemy3:
  # Incrementar el contador de impactos
    la      t0, enemy_hit_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

     # Verificar si el contador alcanza el límite (5)
    li      t2, 1
    beq     t1, t2, .check_level

    # Borrar sprite enemigo (3 columnas × altura PADDLE_LENGTH+1)
    la    t0, enemy3_x
    lw    t2, 0(t0)
    la    t0, enemy3_y
    lw    t3, 0(t0)
    li    t4, PADDLE_LENGTH
    add   t4, t4, t3        # t4 = y + altura
    li    t5, 0             # offset = 0
    # Desactivar enemigo
    la    t0, enemy3_active
    sw    zero, 0(t0)
    # Activar respawn enemigo 3
    li t0, 1
    la t1, enemy3_respawn_active
    sw t0, 0(t1)

    # Resetear su contador
    li t0, 0
    la t1, enemy3_respawn_counter
    sw t0, 0(t1)





.clear_enemy3_loop:
    add   t6, t2, t5        # t6 = x + offset
    mv    a0, t6
    mv    a1, t3
    mv    a3, t4
    lw    a2, color_black
    jal   draw_vertical_line
    addi  t5, t5, 1
    li    t0, 3
    blt   t5, t0, .clear_enemy3_loop

    # Desactivar enemigo 3
    la    t0, enemy3_active
    sw    zero, 0(t0)

    # Incrementar contador de kills
    la    t0, p1_kills
    lw    t1, 0(t0)
    addi  t1, t1, 1
    sw    t1, 0(t0)
  jal erase_score_pixel
    # Redibujar marcador
   # mv    a0, t1
   # li    a1, P1_SCORE_COLUMN
    #jal   draw_score
    # Desactivar bala del jugador
    j     .disable
    # Desactivar bala del enemigo
    la    t0, enemy_bullet_active
    sw    zero, 0(t0)
    # Borrar el píxel de la bala enemiga en pantalla (opcional)
    la    t0, enemy_bullet_x
    lw    t2, 0(t0)
    la    t0, enemy_bullet_y
    lw    t3, 0(t0)
    mv    a0, t2
    mv    a1, t3
    lw    a2, color_black
    jal   draw_point
    j     .ub_end
    # Desactivar bala del jugador




.hit_enemyA2:
  # Incrementar el contador de impactos
    la      t0, enemy_hit_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    # Verificar si el contador alcanza el límite (5)
    li      t2, 1
    beq     t1, t2, .check_level

    # 1) Borrar sprite enemigo (3 columnas × altura PADDLE_LENGTH+1)
    la    t0, enemyA2_x
    lw    t2, 0(t0)
    la    t0, enemyA2_y
    lw    t3, 0(t0)
    li    t4, PADDLE_LENGTH
    add   t4, t4, t3        # t4 = y + altura
    li    t5, 0             # offset = 0
    # Desactivar enemigo
    la    t0, enemyA2_active
    sw    zero, 0(t0)
    # Activar respawn enemigo A2
    li t0, 1
    la t1, enemyA2_respawn_active
    sw t0, 0(t1)
    # Resetear su contador
    li t0, 0
    la t1, enemyA2_respawn_counter
    sw t0, 0(t1)
    # Borrar el sprite enemigo A2
.clear_enemyA2_loop:
    add   t6, t2, t5        # t6 = x + offset
    mv    a0, t6
    mv    a1, t3
    mv    a3, t4
    lw    a2, color_black
    jal   draw_vertical_line
    addi  t5, t5, 1
    li    t0, 3
    blt   t5, t0, .clear_enemyA2_loop

    # Desactivar enemigo A2
    la    t0, enemyA2_active
    sw    zero, 0(t0)

    # Incrementar contador de kills
    la    t0, p1_kills
    lw    t1, 0(t0)
    addi  t1, t1, 1
    sw    t1, 0(t0)
    jal erase_score_pixel

    # Redibujar marcador
   # mv    a0, t1
   # li    a1, P1_SCORE_COLUMN
   # jal   draw_score
    # Desactivar bala del jugador
    j     .disable
    # Desactivar bala del enemigo
    la    t0, enemy_bullet_active
    sw    zero, 0(t0)
    # Borrar el píxel de la bala enemiga en pantalla (opcional)
    la    t0, enemy_bullet_x
    lw    t2, 0(t0)
    la    t0, enemy_bullet_y
    lw    t3, 0(t0)
    mv    a0, t2
    mv    a1, t3
    lw    a2, color_black
    jal   draw_point
    j     .ub_end



.check_level:
    # Verificar el nivel actual
    la      t0, levelC
    lw      t0, 0(t0)
    li      t1, 1
    beq     t0, t1, .p1_new_game  # Si está en nivel 1, ir a nivel 2
    li      t1, 2
    beq     t0, t1, .p2_new_game  # Si está en nivel 2, ir a nivel 3
    li      t1, 3
    beq     t0, t1, .p1_win       # Si está en nivel 3, mostrar victoria
    j       .ub_end



# Function: draw_score
# Parameters:
#	a0: score of the player
#	a1: column of the leftmost scoring dot  ###NO SE ACTUALIZA cuando se mata el enemigo y aumenta el contador que esta en el .data
draw_score:
    addi sp, sp, -16
    sw   ra, 0(sp)
    sw   s0, 4(sp)
    sw   s1, 8(sp)
    sw   a0,12(sp)

    # s0 = score, s1 = columna base para los puntos
    mv   s0, a0
    mv   s1, a1

    # —Dibuja los puntos de score en ROW_1 —
    li   t0, SCORE_FIRST_ROW_POINTS
    ble  s0, t0, .score_loop

.score_loop:
    beq  s0, zero, .draw_sidebar
    addi t0, s0, -1
    li   t1, 1
    sll  t0, t0, t1          # t0 = 2*(s0-1)
    add  a0, t0, s1          # a0 = columna donde dibujar
    li   a1, ROW_1
    lw   a2, color_white
    jal  draw_point
    addi s0, s0, -1
    j    .score_loop

.draw_sidebar:
    li   t2, LAST_COLUMN
    addi t2, t2, -1        # t2 = LAST_COLUMN - 1  (columna fija)

    # — Arranca en y=2, 18 puntos separados 1px (2 en 2) —
    li   t6, 2             # y inicial
    li   t5, 18            # filas = 18

.dot_loop:
    mv   a0, t2            # X fijo
    mv   a1, t6            # Y variable
    lw   a2, color_red     # color rojo
    jal  draw_point

    addi t6, t6, 2         # subir 2px (1px de gap)
    addi t5, t5, -1        # decrementa filas
    bgtz t5, .dot_loop

    j    .score_end


.score_end:
    lw   ra, 0(sp)
    lw   s0, 4(sp)
    lw   s1, 8(sp)
    lw   a0,12(sp)
    addi sp, sp, 16
    jr   ra


# -------------------------------------------------------------------
# erase_score_pixel
# Borra un único píxel del marcador en el sidebar,
# en función de cuántas muertes lleve el jugador (p1_kills).
# Entrada: (ninguna explícita)
#   lee p1_kills desde memoria
# Efecto:
#   calcula Y = 2 + (kills-1),
#   X = LAST_COLUMN - 1,
#   y llama a draw_point(X, Y, color_black)
# Destruye: t0–t3, a0–a2, ra
# -------------------------------------------------------------------

erase_score_pixel:

addi    sp, sp, -20
    sw      ra, 0(sp)
    sw      t0, 4(sp)
    sw      t1, 8(sp)
    sw      t2, 12(sp)
    sw      t3, 16(sp)

    #Leer kills
    la      t0, p1_kills
    lw      t1, 0(t0)         # t1 = kills

    # Índice 0-based = kills - 1
    addi    t1, t1, -1

    # 3) Calcular Y = 2 + 2*(kills-1)
    slli    t2, t1, 1         # t2 = 2*(kills - 1)
    addi    t2, t2, 2         # t2 = 2 + 2*(kills - 1)

    # 4) Calcular X = LAST_COLUMN - 1
    li      t3, LAST_COLUMN
    addi    t3, t3, -1        # t3 = LAST_COLUMN - 1

    # 5) Borrar ese único píxel
    mv      a0, t3            # X
    mv      a1, t2            # Y
    lw      a2, color_black  # color = negro
    jal     draw_point

    # epílogo
    lw      ra, 0(sp)
    lw      t0, 4(sp)
    lw      t1, 8(sp)
    lw      t2, 12(sp)
    lw      t3, 16(sp)
    addi    sp, sp, 20
    jr      ra


    # — draw_lives: a0 = número de vidas —
draw_lives:
    addi    sp, sp, -12
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)

    mv      s0, a0       # s0 = vidas
    li      s1, 1       # s1 = columna inicial X = 2

.draw_loop:
    beq     s0, zero, .draw_end
    mv      a0, s1       # X actual
    li      a1, 1        # Y fija en fila 1
    lw      a2, color_dark_pink
    jal     draw_point

    addi    s1, s1, 2    # siguiente X += 2
    addi    s0, s0, -1   # vidas--
    j       .draw_loop

.draw_end:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12
    jr      ra


     # — erase_life: borra el pixel correspondiente a la vida perdida —
erase_life:
    addi    sp, sp, -16
    sw      ra,   0(sp)
    sw      t0,   4(sp)
    sw      t1,   8(sp)
    sw      t2,  12(sp)

    # 1) Leer cuántas veces se ha reiniciado (vidas perdidas)
    la      t0, reset_counter
    lw      t1, 0(t0)        # t1 = reset_counter
    addi    t1, t1, -1       # t1 = índice 0-based

    bltz    t1, .done        # si t1<0, aún no perdió ninguna vida

    # 2) Calcular X = 1 + 2 * t1
    slli    t2, t1, 1        # t2 = 2 * índice
    addi    t2, t2, 1        # t2 = 1 + 2 * índice
    mv      a0, t2           # a0 = columna dinámica

    # 3) Fijar Y = 1 (misma fila que draw_lives)
    li      a1, 1

    # 4) Borrar ese píxel
    lw      a2, color_black
    jal     draw_point

.done:
    # epílogo
    lw      ra,   0(sp)
    lw      t0,   4(sp)
    lw      t1,   8(sp)
    lw      t2,  12(sp)
    addi    sp, sp, 16
    jr      ra
#__________________________



#__________bala enemigo a2____________________________________
# fire_enemyA2_bullet

fire_enemyA2_bullet:
    addi  sp, sp, -4
    sw    ra, 0(sp)

    # Si ya hay bala activa, salir
    la    t0, enemyA2_bullet_active
    lw    t0, 0(t0)
    bne   t0, zero, .fe_doneA2

    # Activar bala
    li    t0, 1
    la    t1, enemyA2_bullet_active
    sw    t0, 0(t1)

    # Posición inicial X,Y = posición del enemigo A2
    la    t1, enemyA2_x
    lw    t0, 0(t1)
    la    t2, enemyA2_bullet_x
    sw    t0, 0(t2)

    la    t1, enemyA2_y
    lw    t0, 0(t1)
    la    t2, enemyA2_bullet_y
    sw    t0, 0(t2)

    # Dirección de disparo: usa enemyA2_DIR o fija MOV_DOWN
    la    t1, enemyA2_DIR
    lw    t0, 0(t1)
    la    t2, enemyA2_bullet_DIR
    sw    t0, 0(t2)

.fe_doneA2:
    lw    ra, 0(sp)
    addi  sp, sp, 4
    jr    ra


#:__________________________________BALA ENEMIGO___________________________#
# fire_enemy_bullet
# activa la bala del tanque enemigo en (enemy_x,enemy_y)
# y le da una dirección (a3 = su última dir o MOV_DOWN)
fire_enemy_bullet:
    addi  sp, sp, -4
    sw    ra, 0(sp)

    # si ya hay bala activa, salir
    la    t0, enemy_bullet_active
    lw    t0, 0(t0)
    bne   t0, zero, .fe_done

    # activar bala
    li    t0, 1
    la    t1, enemy_bullet_active
    sw    t0, 0(t1)

    # posición inicial X,Y = posición del enemigo
    la    t1, enemy_x
    lw    t0, 0(t1)
    la    t2, enemy_bullet_x
    sw    t0, 0(t2)

    la    t1, enemy_y
    lw    t0, 0(t1)
    la    t2, enemy_bullet_y
    sw    t0, 0(t2)

    # dirección de disparo: usa enemy_DIR o fija MOV_DOWN
    la    t1, enemy_DIR
    lw    t0, 0(t1)
    la    t2, enemy_bullet_DIR
    sw    t0, 0(t2)

.fe_done:
    lw    ra, 0(sp)
    addi  sp, sp, 4
    jr    ra



#para el enimgo 2
fire_enemy2_bullet:
    addi  sp, sp, -4
    sw    ra, 0(sp)

    # Si ya hay bala activa, salir
    la    t0, enemy2_bullet_active
    lw    t0, 0(t0)
    bne   t0, zero, .fe_done2

    # Activar bala
    li    t0, 1
    la    t1, enemy2_bullet_active
    sw    t0, 0(t1)

    # Posición inicial X,Y = posición del enemigo 2
    la    t1, enemy2_x
    lw    t0, 0(t1)
    la    t2, enemy2_bullet_x
    sw    t0, 0(t2)

    la    t1, enemy2_y
    lw    t0, 0(t1)
    la    t2, enemy2_bullet_y
    sw    t0, 0(t2)

    # Dirección de disparo: usa enemy2_DIR o fija MOV_DOWN
    la    t1, enemy2_DIR
    lw    t0, 0(t1)
    la    t2, enemy2_bullet_DIR
    sw    t0, 0(t2)

.fe_done2:
    lw    ra, 0(sp)
    addi  sp, sp, 4
    jr    ra




fire_enemy3_bullet:
    addi sp, sp, -4
    sw ra, 0(sp)
    # Si ya hay bala activa, salir
    la t0, enemy3_bullet_active
    lw t0, 0(t0)
    bne t0, zero, .fe_done3
    # Activar bala
    li t0, 1
    la t1, enemy3_bullet_active
    sw t0, 0(t1)
    # Posición inicial X,Y = posición del enemigo 3
    la t1, enemy3_x
    lw t0, 0(t1)
    la t2, enemy3_bullet_x
    sw t0, 0(t2)
    la t1, enemy3_y
    lw t0, 0(t1)
    la t2, enemy3_bullet_y
    sw t0, 0(t2)
    # Dirección de disparo: usa enemy3_DIR o fija MOV_DOWN
    la t1, enemy3_DIR
    lw t0, 0(t1)
    la t2, enemy3_bullet_DIR
    sw t0, 0(t2)
.fe_done3:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra












update_enemyA2_bullet:
    addi    sp, sp, -4
    sw      ra, 0(sp)

    # ¿Bala activa?
    la      t0, enemyA2_bullet_active
    lw      t0, 0(t0)
    beqz    t0, .uebA2_end

    # Borrar el píxel viejo
    la      t1, enemyA2_bullet_x
    lw      t2, 0(t1)        # t2 = old_x
    la      t1, enemyA2_bullet_y
    lw      t3, 0(t1)        # t3 = old_y
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_black
    jal     draw_point

    # Calcular nueva posición según enemyA2_bullet_DIR
    la      t4, enemyA2_bullet_DIR
    lw      t4, 0(t4)
    li      t5, MOV_UP
    beq     t4, t5, .uebA2_mv_up
    li      t5, MOV_DOWN
    beq     t4, t5, .uebA2_mv_down
    li      t5, MOV_LEFT
    beq     t4, t5, .uebA2_mv_left
    # → por defecto: derecha
.uebA2_mv_right:
    addi    t2, t2,  1
    j       .uebA2_after_mv
.uebA2_mv_up:
    addi    t3, t3, -1
    j       .uebA2_after_mv
.uebA2_mv_down:
    addi    t3, t3,  1
    j       .uebA2_after_mv
.uebA2_mv_left:
    addi    t2, t2, -1

.uebA2_after_mv:
    # Leer color de pantalla en (t2, t3)
    li      t0, 6
    sll     t0, t3, t0        # t0 = y*64
    add     t0, t0, t2        # t0 = x + y*64
    li      t1, 2
    sll     t0, t0, t1        # t0 <<= 2
    add     t0, t0, gp
    lw      t5, 0(t0)         # t5 = color en pantalla

    # ¿Choque contra bloque amarillo?
    lw      t6, color_yellow
    beq     t5, t6, .uebA2_remove_block

    # ¿Choque contra muro blanco?
    lw      t6, color_white
    beq     t5, t6, .uebA2_disable
    # ¿Choque contra bloque azul?
    lw      t6, color_blue
    beq     t5, t6, .p1_win   # Si es azul, mostrar pantalla de victoria
    # ¿Choque contra bloque morado?
    lw      t6, color_purple
    beq     t5, t6, .uebA2_disable
    # ¿Choque contra jugador?
    # ¿Choque contra jugador?
    lw      t6, color_red
    beq     t5, t6, .reset_player_positionA2
 

    # Límites de pantalla
    blt     t2, zero,      .uebA2_disable
    li      t6, LAST_COLUMN
    bgt     t2, t6,        .uebA2_disable
    blt     t3, zero,      .uebA2_disable
    li      t6, DOWN_Y_LIMIT
    bgt     t3, t6,        .uebA2_disable

    # Guardar y dibujar bala enemiga en su nueva posición
    la      t1, enemyA2_bullet_x
    sw      t2, 0(t1)
    la      t1, enemyA2_bullet_y
    sw      t3, 0(t1)
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_orange2
    jal     draw_point
    j       .uebA2_done


.uebA2_remove_block:
    # Cambiar el bloque actual a negro
    mv      a0, t2          # Coordenada X del bloque
    mv      a1, t3          # Coordenada Y del bloque
    lw      a2, color_black # Cambiar a color negro
    jal     draw_point

    # Destruir el segundo bloque según la dirección
    la      t0, enemyA2_bullet_DIR
    lw      t0, 0(t0)       # Dirección del proyectil
    li      t1, MOV_LEFT
    beq     t0, t1, .destroy_second_vertical_A2
    li      t1, MOV_RIGHT
    beq     t0, t1, .destroy_second_vertical_A2
    li      t1, MOV_UP
    beq     t0, t1, .destroy_second_horizontal_A2
    li      t1, MOV_DOWN
    beq     t0, t1, .destroy_second_horizontal_A2
    j       .end_remove_block_A2

.destroy_second_vertical_A2:
    addi    a1, a1, -1      # Bloque arriba o abajo
    jal     draw_point
    j       .end_remove_block_A2

.destroy_second_horizontal_A2:
    addi    a0, a0, -1      # Bloque a la izquierda o derecha
    jal     draw_point

.end_remove_block_A2:
    # Desactivar la bala enemiga
    j       .uebA2_disable

.uebA2_disable:
    # Desactivar bala enemiga
    la      t1, enemyA2_bullet_active
    sw      zero, 0(t1)

.uebA2_done:
.uebA2_end:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra









#———————————————————————————————————————————————
# update_enemy_bullet: mueve la bala del enemigo y la desactiva si choca
# usa T0–T6
#———————————————————————————————————————————————



update_enemy_bullet:
    addi    sp, sp, -4
    sw      ra, 0(sp)

    # Bala enemiga activa?
    la      t0, enemy_bullet_active
    lw      t0, 0(t0)
    beqz    t0, .ueb_end

    # Borrar el píxel viejo
    la      t1, enemy_bullet_x
    lw      t2, 0(t1)        # t2 = old_x
    la      t1, enemy_bullet_y
    lw      t3, 0(t1)        # t3 = old_y
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_black
    jal     draw_point

    # Calcular nueva posición según enemy_bullet_DIR
    la      t4, enemy_bullet_DIR
    lw      t4, 0(t4)
    li      t5, MOV_UP
    beq     t4, t5, .ueb_mv_up
    li      t5, MOV_DOWN
    beq     t4, t5, .ueb_mv_down
    li      t5, MOV_LEFT
    beq     t4, t5, .ueb_mv_left
    # → por defecto: derecha
.ueb_mv_right:
    addi    t2, t2,  1
    j       .ueb_after_mv
.ueb_mv_up:
    addi    t3, t3, -1
    j       .ueb_after_mv
.ueb_mv_down:
    addi    t3, t3,  1
    j       .ueb_after_mv
.ueb_mv_left:
    addi    t2, t2, -1

.ueb_after_mv:
    # Leer color de pantalla en (t2, t3)
    li      t0, 6
    sll     t0, t3, t0        # t0 = y*64
    add     t0, t0, t2        # t0 = x + y*64
    li      t1, 2
    sll     t0, t0, t1        # t0 <<= 2
    add     t0, t0, gp
    lw      t5, 0(t0)         # t5 = color en pantalla
    # Verificar si el casco está activo
    la      t6, player_helmet_active
    lw      t6, 0(t6)
    bnez    t6, .ignore_player_collision  # Si el casco está activo, ignorar al jugador
        # ¿Choque contra jugador?
    lw      t6, color_red
    beq     t5, t6, .reset_player_position
    beq     t5, t6, .ueb_disable
    .ignore_player_collision:

    # ¿Choque contra bloque amarillo?
    lw      t6, color_yellow
    beq     t5, t6, .ueb_remove_block

    # ¿Choque contra muro blanco?
    lw      t6, color_white
    beq     t5, t6, .ueb_disable


    # ¿Choque contra bloque azul?
    lw      t6, color_blue
    beq     t5, t6, .p1_win   # Si es azul, mostrar pantalla de victoria

    # ¿Choque contra bloque morado?
    lw      t6, color_purple
    beq     t5, t6, .ueb_disable


    # Límites de pantalla
    blt     t2, zero,      .ueb_disable
    li      t6, LAST_COLUMN
    bgt     t2, t6,        .ueb_disable
    blt     t3, zero,      .ueb_disable
    li      t6, DOWN_Y_LIMIT
    bgt     t3, t6,        .ueb_disable

    # Guardar y dibujar bala enemiga en su nueva posición
    la      t1, enemy_bullet_x
    sw      t2, 0(t1)
    la      t1, enemy_bullet_y
    sw      t3, 0(t1)
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_cyan
    jal     draw_point
    j       .ueb_done


.ueb_remove_block:
    # Cambiar el bloque actual a negro
    mv      a0, t2          # Coordenada X del bloque
    mv      a1, t3          # Coordenada Y del bloque
    lw      a2, color_black # Cambiar a color negro
    jal     draw_point

    # Destruir el segundo bloque según la dirección
    la      t0, enemy_bullet_DIR
    lw      t0, 0(t0)       # Dirección del proyectil
    li      t1, MOV_LEFT
    beq     t0, t1, .destroy_second_vertical1
    li      t1, MOV_RIGHT
    beq     t0, t1, .destroy_second_vertical1
    li      t1, MOV_UP
    beq     t0, t1, .destroy_second_horizontal1
    li      t1, MOV_DOWN
    beq     t0, t1, .destroy_second_horizontal1
    j       .end_remove_block11


.destroy_second_horizontal1:
    addi    a0, a0, -1      # Bloque a la izquierda o derecha
    lw      a2, color_black # Cambiar a color negro
    jal     draw_point
    j       .end_remove_block11

.destroy_second_vertical1:
    addi    a1, a1, -1      # Bloque arriba o abajo
    lw      a2, color_black # Cambiar a color negro
    jal     draw_point
    j       .end_remove_block11


.end_remove_block11:
    # Desactivar la bala enemiga
    j      .ueb_disable

.ueb_disable:
    # Desactivar bala enemiga
    la      t1, enemy_bullet_active
    sw      zero, 0(t1)

.ueb_done:
.ueb_end:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra

update_enemy2_bullet:
    addi    sp, sp, -4
    sw      ra, 0(sp)

    # ¿Bala activa?
    la      t0, enemy2_bullet_active
    lw      t0, 0(t0)
    beqz    t0, .ueb2_end

    # Borrar el píxel viejo
    la      t1, enemy2_bullet_x
    lw      t2, 0(t1)        # t2 = old_x
    la      t1, enemy2_bullet_y
    lw      t3, 0(t1)        # t3 = old_y
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_black
    jal     draw_point

    # Calcular nueva posición según enemy2_bullet_DIR
    la      t4, enemy2_bullet_DIR
    lw      t4, 0(t4)
    li      t5, MOV_UP
    beq     t4, t5, .ueb2_mv_up
    li      t5, MOV_DOWN
    beq     t4, t5, .ueb2_mv_down
    li      t5, MOV_LEFT
    beq     t4, t5, .ueb2_mv_left
    # → por defecto: derecha
.ueb2_mv_right:
    addi    t2, t2,  1
    j       .ueb2_after_mv
.ueb2_mv_up:
    addi    t3, t3, -1
    j       .ueb2_after_mv
.ueb2_mv_down:
    addi    t3, t3,  1
    j       .ueb2_after_mv
.ueb2_mv_left:
    addi    t2, t2, -1

.ueb2_after_mv:
    # Leer color de pantalla en (t2, t3)
    li      t0, 6
    sll     t0, t3, t0        # t0 = y*64
    add     t0, t0, t2        # t0 = x + y*64
    li      t1, 2
    sll     t0, t0, t1        # t0 <<= 2
    add     t0, t0, gp
    lw      t5, 0(t0)         # t5 = color en pantalla
   # Verificar si el casco está activo
    la      t6, player_helmet_active
    lw      t6, 0(t6)
    bnez    t6, .ignore_player_collision2  # Si el casco está activo, ignorar al jugador  
    
       # ¿Choque contra jugador?
    lw      t6, color_red
    beq     t5, t6, .reset_player_position2

.ignore_player_collision2:
    # ¿Choque contra bloque amarillo?
    lw      t6, color_yellow
    beq     t5, t6, .ueb2_remove_block
    beq    t5, t6, .ueb2_disable

    # ¿Choque contra muro blanco?
    lw      t6, color_white
    beq     t5, t6, .ueb2_disable

    # ¿Choque contra bloque azul?
    lw      t6, color_blue
    beq     t5, t6, .p1_win   # Si es azul, mostrar pantalla de victoria
    # ¿Choque contra bloque morado?
    lw      t6, color_purple
    beq     t5, t6, .ueb2_disable
    


    # Límites de pantalla
    blt     t2, zero,      .ueb2_disable
    li      t6, LAST_COLUMN
    bgt     t2, t6,        .ueb2_disable
    blt     t3, zero,      .ueb2_disable
    li      t6, DOWN_Y_LIMIT
    bgt     t3, t6,        .ueb2_disable

    # Guardar y dibujar bala enemiga en su nueva posición
    la      t1, enemy2_bullet_x
    sw      t2, 0(t1)
    la      t1, enemy2_bullet_y
    sw      t3, 0(t1)
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_cyan
    jal     draw_point
    j       .ueb2_done







.ueb2_remove_block:
    # Cambiar el bloque amarillo a negro
    mv      a0, t2          # Coordenada X del bloque
    mv      a1, t3          # Coordenada Y del bloque
    lw      a2, color_black # Cambiar a color negro
    jal     draw_point


la     t0, enemy2_bullet_DIR
    lw      t0, 0(t0)       # Dirección del proyectil
    li      t1, MOV_LEFT
    beq     t0, t1, .destroy_second_vertical2
    li      t1, MOV_RIGHT
    beq     t0, t1, .destroy_second_vertical2
    li      t1, MOV_UP
    beq     t0, t1, .destroy_second_horizontal2
    li      t1, MOV_DOWN
    beq     t0, t1, .destroy_second_horizontal2
    j       .end_remove_block2
.destroy_second_vertical2:

    addi    a1, a1, -1      # Bloque arriba o abajo
    jal     draw_point
    j       .end_remove_block2
.destroy_second_horizontal2:

    addi    a0, a0, -1      # Bloque a la izquierda o derecha
    jal     draw_point
.end_remove_block2:


    # Desactivar la bala enemiga
    j       .ueb2_disable

.ueb2_disable:
    # Desactivar bala enemiga
    la      t1, enemy2_bullet_active
    sw      zero, 0(t1)

.ueb2_done:
.ueb2_end:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra


##ENEMIGO ######

update_enemy3_bullet:
     addi    sp, sp, -4
    sw      ra, 0(sp)

    # ¿Bala activa?
    la      t0, enemy3_bullet_active
    lw      t0, 0(t0)
    beqz    t0, .ueb3_end
      # Borrar el píxel viejo
    la      t1, enemy3_bullet_x
    lw      t2, 0(t1)        # t2 = old_x
    la      t1, enemy3_bullet_y
    lw      t3, 0(t1)        # t3 = old_y
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_black
    jal     draw_point

   # Calcular nueva posición según enemy3_bullet_DIR
    la      t4, enemy3_bullet_DIR
    lw      t4, 0(t4)
    li      t5, MOV_UP
    beq     t4, t5, .ueb3_mv_up
    li      t5, MOV_DOWN
    beq     t4, t5, .ueb3_mv_down
    li      t5, MOV_LEFT
    beq     t4, t5, .ueb3_mv_left
    # → por defecto: derecha
.ueb3_mv_right:
    addi    t2, t2,  1
    j       .ueb3_after_mv
.ueb3_mv_up:
    addi    t3, t3, -1
    j       .ueb3_after_mv
.ueb3_mv_down:
    addi    t3, t3,  1
    j       .ueb3_after_mv
.ueb3_mv_left:
    addi    t2, t2, -1

.ueb3_after_mv:
    # Leer color de pantalla en (t2, t3)
    li      t0, 6
    sll     t0, t3, t0        # t0 = y*64
    add     t0, t0, t2        # t0 = x + y*64
    li      t1, 2
    sll     t0, t0, t1        # t0 <<= 2
    add     t0, t0, gp
    lw      t5, 0(t0)         # t5 = color en pantalla
    
    # Verificar si el casco está activo
    la      t6, player_helmet_active
    lw      t6, 0(t6)
    bnez    t6, .ignore_player_collision3  # Si el casco está activo, ignorar al jugador
         # ¿Choque contra jugador?
    lw      t6, color_red
    beq     t5, t6, .reset_player_position3
.ignore_player_collision3:
    # ¿Choque contra bloque amarillo?
    lw      t6, color_yellow
    beq     t5, t6, .ueb3_remove_block
    # ¿Choque contra muro blanco?
    lw      t6, color_white
    beq     t5, t6, .ueb3_disable
    # ¿Choque contra bloque azul?
    lw      t6, color_blue
    beq     t5, t6, .p1_win   # Si es azul, mostrar pantalla de victoria
    # ¿Choque contra bloque morado?
    lw      t6, color_purple
    beq     t5, t6, .ueb3_disable



    # Límites de pantalla
    blt     t2, zero,      .ueb3_disable
    li      t6, LAST_COLUMN
    bgt     t2, t6,        .ueb3_disable
    blt     t3, zero,      .ueb3_disable
    li      t6, DOWN_Y_LIMIT
    bgt     t3, t6,        .ueb3_disable
    # Guardar y dibujar bala enemiga en su nueva posición
    la      t1, enemy3_bullet_x
    sw      t2, 0(t1)
    la      t1, enemy3_bullet_y
    sw      t3, 0(t1)
    mv      a0, t2
    mv      a1, t3
    lw      a2, color_dark_pink
    jal     draw_point
    j       .ueb3_done
.ueb3_remove_block:
    # Cambiar el bloque amarillo a  
      mv      a0, t2          # Coordenada X del bloque
    mv      a1, t3          # Coordenada Y del bloque
    lw      a2, color_black # Cambiar a color negro
    jal     draw_point



la t0, enemy3_bullet_DIR
    lw t0, 0(t0)       # Dirección del proyectil
    li t1, MOV_LEFT
    beq t0, t1, .destroy_second_vertical3
    li t1, MOV_RIGHT
    beq t0, t1, .destroy_second_vertical3
    li t1, MOV_UP
    beq t0, t1, .destroy_second_horizontal3
    li t1, MOV_DOWN
    beq t0, t1, .destroy_second_horizontal3
    j .end_remove_block3
.destroy_second_vertical3:

    addi a1, a1, -1      # Bloque arriba o abajo
    jal draw_point
    j .end_remove_block3
.destroy_second_horizontal3:

    addi a0, a0, -1      # Bloque a la izquierda o derecha
    jal draw_point
.end_remove_block3:

    j      .ueb3_disable



.ueb3_disable:
    # Desactivar bala enemiga
    la      t1, enemy3_bullet_active
    sw      zero, 0(t1)

.ueb3_done:
.ueb3_end:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra




.reset_player_positionA2:
        # Incrementar el contador global de reinicios
    la      t0, reset_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    # Verificar si el contador alcanza el límite (3)
    li      t2, 3
    beq     t1, t2, .p1_win

         #borarr el icono de vida 
 jal erase_life
    # Borrar al jugador actual (paddle rojo)

    lw      t2, player_x
    lw      t3, player_y
    lw      a2, color_black
    
    mv      a0, t2
    mv      a1, t3
    li      t0, PADDLE_LENGTH
    add     a3, a1, t0
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line

    # Reiniciar posición del jugador rojo
    li      t0, 24           # Posición inicial X del jugador
    la      t1, player_x
    sw      t0, 0(t1)
    li      t0, 58         # Posición inicial Y del jugador
    la      t1, player_y
    sw      t0, 0(t1)
    jal     .activate_helmet

    # Borrar la bala enemiga
    j  .uebA2_disable  
   
    
.reset_player_position:
    # Incrementar el contador global de reinicios
    la      t0, reset_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    # Verificar si el contador alcanza el límite (3)
    li      t2, 3
    beq     t1, t2, .p1_win
    
 #borarr el icono de vida 
 jal erase_life

    # Borrar al jugador actual (paddle rojo)
    lw      t2, player_x
    lw      t3, player_y
    lw      a2, color_black
    
    mv      a0, t2
    mv      a1, t3
    li      t0, PADDLE_LENGTH
    add     a3, a1, t0
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line

    # Reiniciar posición del jugador rojo
    li      t0, 24           # Posición inicial X del jugador
    la      t1, player_x
    sw      t0, 0(t1)
    li      t0, 58          # Posición inicial Y del jugador
    la      t1, player_y
    sw      t0, 0(t1)

    # Activar el helmet (protección)
    jal     .activate_helmet


    # Borrar la bala enemiga
    j  .ueb_disable
#___________________________________________________________________________________________________#
.reset_player_position2:
    # Incrementar el contador global de reinicios
    la      t0, reset_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    # Verificar si el contador alcanza el límite (3)
    li      t2, 3
    beq     t1, t2, .p1_win
     #borarr el icono de vida 
 jal erase_life

    # Borrar al jugador actual (paddle rojo)
    lw      t2, player_x
    lw      t3, player_y
    lw      a2, color_black
    
    mv      a0, t2
    mv      a1, t3
    li      t0, PADDLE_LENGTH
    add     a3, a1, t0
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line

    # Reiniciar posición del jugador rojo
    li      t0, 24           # Posición inicial X del jugador
    la      t1, player_x
    sw      t0, 0(t1)
    li      t0, 58           # Posición inicial Y del jugador
    la      t1, player_y
    sw      t0, 0(t1)
    jal     .activate_helmet

    # Borrar la bala enemiga
    j  .ueb2_disable  
   
     
    .reset_player_position3:
        # Incrementar el contador global de reinicios
    la      t0, reset_counter
    lw      t1, 0(t0)
    addi    t1, t1, 1
    sw      t1, 0(t0)

    # Verificar si el contador alcanza el límite (3)
    li      t2, 3
    bne     t1, t2,skip_p1_win
     #borarr el icono de vida 
    j .p1_win
skip_p1_win:
     #borarr el icono de vida 
 jal erase_life

    # Borrar al jugador actual (paddle rojo)
    lw      t2, player_x
    lw      t3, player_y
    lw      a2, color_black
    
    mv      a0, t2
    mv      a1, t3
    li      t0, PADDLE_LENGTH
    add     a3, a1, t0
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line
    addi    a0, a0, 1
    jal     draw_vertical_line

    # Reiniciar posición del jugador rojo
    li      t0, 24           # Posición inicial X del jugador
    la      t1, player_x
    sw      t0, 0(t1)
    li      t0, 58           # Posición inicial Y del jugador
    la      t1, player_y
    sw      t0, 0(t1)
    jal     .activate_helmet

    # Borrar la bala enemiga
    j  .ueb3_disable  
   
    
###################
###################################################################################################################
###################################################################################################################   
####################################--------------------------------NUEVO PODER CASCO__________________############    
activate_helmet:
    li t0, 1                       # Activar inmunidad
    la t1, player_helmet_active
    sw t0, 0(t1)

    li t0, 300                     # Duración de la inmunidad (ajusta según sea necesario)
    la t1, helmet_timer
    sw t0, 0(t1)

    jr ra

##################################################################
update_helmet:
    la t0, player_helmet_active
    lw t1, 0(t0)
    beqz t1, .end_update_helmet  # Si no está activo, salir

    # Reducir el temporizador
    la t0, helmet_timer
    lw t1, 0(t0)
    addi t1, t1, -1
    sw t1, 0(t0)

    # Si el temporizador llega a 0, desactivar el poder
    bnez t1, .end_update_helmet
    li t1, 0
    la t0, player_helmet_active
    sw t1, 0(t0)

.end_update_helmet:
    jr ra
#______________
#______MARGENES_____________________________________________________________________##
##################.eqv DOWN_Y_LIMIT 63
##################.eqv UP_Y_LIMIT 0	




li   t0, 300           # 5 segundos si tu loop es 60Hz (ajusta según tu frecuencia)
la   t1, loop_timer
sw   t0, 0(t1)

loop_x:
    la   t0, loop_timer
    lw   t1, 0(t0)
    beqz t1, end_loop_x     # Si timer == 0, salir del ciclo

    # ... aquí va el código que quieres repetir ...
    jal update_shovel       # Llamar a la función update_shovel

    # Decrementar el temporizador
    la   t0, loop_timer
    lw   t1, 0(t0)
    addi t1, t1, -1
    sw   t1, 0(t0)

    j loop_x                # Volver al inicio del ciclo

end_loop_x:
    jal draw_yellow_blocks



 update_shovel:
     # — Prolog: guardar registros —
     addi    sp, sp, -12
     sw      ra, 0(sp)
     sw      s0, 4(sp)
     sw      s1, 8(sp)


     lw      a2, color_purple

     # bloque izquierdo (4 filas)
     li      a0, 27
     li      a1, 57
     li      a3, 28
     jal     draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
      jal draw_horizontal_line

     # bloque derecho (4 filas)
     li      a0, 33
     li      a1, 57
     li      a3, 34
     jal     draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line

     # bloque inferior (2 filas)
     li      a0, 27
     li      a1, 55
     li      a3, 34
     jal     draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line

    

    
.fin_update_shovel:
    # Restaurar registros y regresar
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12
    jr      ra


 draw_yellow_blocks:
     # — Prolog: guardar registros —
     addi    sp, sp, -12
     sw      ra, 0(sp)
     sw      s0, 4(sp)
     sw      s1, 8(sp)


     lw      a2, color_yellow

     # bloque izquierdo (4 filas)
     li      a0, 27
     li      a1, 57
     li      a3, 28
     jal     draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
      jal draw_horizontal_line

     # bloque derecho (4 filas)
     li      a0, 33
     li      a1, 57
     li      a3, 34
     jal     draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line

     # bloque inferior (2 filas)
     li      a0, 27
     li      a1, 55
     li      a3, 34
     jal     draw_horizontal_line
     addi    a1, a1, 1
     jal draw_horizontal_line




.fin_yellow_shovel:
    # Restaurar registros y regresar
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12
    jr      ra
 








#___________________________________________________________________________________________________#
draw_margen:
    addi sp, sp, -4
    sw   ra, 0(sp)

    # — Top border: TRES líneas (y=0,1,2), de x=0 a x=LAST_COLUMN
    li   a0, 0              # x start = 0
    li   a3, LAST_COLUMN    # x end   = 63
    lw   a2, color_white

    li   a1, 0              # y = 0
    jal  draw_horizontal_line
    addi a1, a1, 1          # y = 1
    jal  draw_horizontal_line
    addi a1, a1, 1          # y = 2
    jal  draw_horizontal_line

    # — Bottom border: TRES líneas (y = 31, 30 y 29)
    li   a1, DOWN_Y_LIMIT    # y = 31
    li   a0, 0
    li   a3, LAST_COLUMN
    lw   a2, color_white

    jal  draw_horizontal_line   # y = 31
    addi a1, a1, -1             # y = 30
    jal  draw_horizontal_line
    addi a1, a1, -1             # y = 29
    jal  draw_horizontal_line
    addi a1, a1, -1             # y = 29
    jal  draw_horizontal_line
    # — Left border: dos columnas (x=0 y x=1), de y=0 a y=31
    li   a0, 0            # x = 0
    li   a1, 0            # y start = 0
    li   a3, DOWN_Y_LIMIT # y end = 31
    lw   a2, color_white
    jal  draw_vertical_line
    addi a0, a0, 1        # x = 1
    jal  draw_vertical_line
    addi a0, a0, 1        # x = 1
    jal  draw_vertical_line
    # — Right border: CINCO columnas (x=63,62,61,60,59), de y=0 a y=31
    li   a0, LAST_COLUMN        # x = 63
    li   a1, 0                  # y start = 0
    li   a3, DOWN_Y_LIMIT       # y end = 31
    lw   a2, color_white
    jal  draw_vertical_line
    addi a0, a0, -1             # x = 62
    jal  draw_vertical_line
    addi a0, a0, -1             # x = 61
    jal  draw_vertical_line
    addi a0, a0, -1             # x = 60
    jal  draw_vertical_line
    addi a0, a0, -1             # x = 59
    jal  draw_vertical_line
    addi a0, a0, -1             # x = 59
    jal  draw_vertical_line
    addi a0, a0, -1             # x = 59
    jal  draw_vertical_line
        addi a0, a0, -1             # x = 59
    jal  draw_vertical_line
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra

# Function: draw_point
# Parameters:
#	a0: x coordinate
#	a1: y coordinate
#	a2: color of the point
# Return
#	void
draw_point:
	li t0, 6
	sll t0, a1, t0 #Due to the size of the screen, multiply y coodinate by 64 (length of the field)
	add t1, a0, t0
	li t0, 2
	sll t1, t1, t0 # Multiply the resulting coodinate by 4
	add t1, t1, gp
	sw a2, (t1)
	jr ra
	

# Function: draw_horizontal_line
# Parameters:
#	a0: starting x coordinate
#	a1: y coordinate
#	a2: color of the line
#	a3: ending x coordinate
# Return
#	void
draw_horizontal_line:
	
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	
	sub s0, a3, a0
	mv s1, a0
	li s2, 0
	
	.horizontal_loop:
		add a0, s1, s0
		jal draw_point
		addi s0, s0, -1
		
		bge s0, s2, .horizontal_loop
	
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16	
	
	jr ra

# Function: draw_vertical_line
# Parameters:
#	a0: x coordinate
#	a1: starting y coordinate
#	a2: color of the line
#	a3: ending y coordinate
# Return
#	void
draw_vertical_line:
	
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	
	sub s0, a3, a1
	mv s1, a1
	li s2, 0
	
	.vertical_loop:
		add a1, s1, s0
		jal draw_point
		addi s0, s0, -1
		
		bge s0, s2, .vertical_loop
	
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	
	addi sp, sp, 16	
	
	jr ra
	
# Function: clear_board
# Parameters:
#	none
# Return
#	void
clear_board:
	lw t0, color_black
	li t1, TOTAL_PIXELS
	li t2, FOUR_BYTES
	
	.start_clear_loop:
		sub t1, t1, t2
		add t3, t1, gp
		sw t0, (t3)
		beqz t1, .end_clear_loop
		j .start_clear_loop
		
	.end_clear_loop:
	
	jr ra
	
# Function: draw_title_screen
# Parameters:
#	none
# Return
#	void
draw_title_screen:

	addi sp, sp, -4
	sw ra, 0(sp)


	addi sp, sp, -4
	sw ra, 0(sp)

# The upper lines
	li a0, 2
	li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
	lw a2, color_dark_pink
	li a3, 61
	jal draw_horizontal_line
	
	li a0, 2
	li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
	addi a1, a1, 1
	lw a2, color_white
	li a3, 61
	jal draw_horizontal_line
	
	li a0, 2
	li a1, TITLE_SCREEN_FIRST_LINE_ROW_Y
	addi a1, a1, 2
	lw a2, color_dark_pink
	li a3, 61
	jal draw_horizontal_line
	
	# The below lines
	li a0, 2
	li a1, TITLE_SCREEN_SECOND_LINE_ROW_Y
	lw a2, color_dark_pink
	li a3, 61
	jal draw_horizontal_line
	
	li a0, 2
	li a1, TITLE_SCREEN_SECOND_LINE_ROW_Y
	addi a1, a1, 1
	lw a2, color_white
	li a3, 61
	jal draw_horizontal_line
	
	li a0, 2
	li a1, TITLE_SCREEN_SECOND_LINE_ROW_Y
	addi a1, a1, 2
	lw a2, color_dark_pink
	li a3, 61
	jal draw_horizontal_line

#############################TITULO

# Letra B (offset 0)
	li a0, BATTLE_TEXT_X
	addi a0, a0, -7
	li a1, BATTLE_TEXT_Y
	lw a2, color_white
	mv a3, a1
	addi a3, a3, BATTLE_TEXT_H
	jal draw_vertical_line

	li a0, BATTLE_TEXT_X	
	addi a0, a0, -6
	li a1, BATTLE_TEXT_Y
	lw a2, color_white
	addi a3, a0, 2
	jal draw_horizontal_line

	li a0, BATTLE_TEXT_X	
	addi a0, a0, -6
	li a1, BATTLE_TEXT_Y
	addi a1, a1, 2
	lw a2, color_white
	addi a3, a0, 2
	jal draw_horizontal_line

	li a0, BATTLE_TEXT_X	
	addi a0, a0, -6
	li a1, BATTLE_TEXT_Y
	addi a1, a1, 6
	lw a2, color_white
	addi a3, a0, 2
	jal draw_horizontal_line

	li a0, BATTLE_TEXT_X	
	addi a0, a0, -3
	li a1, BATTLE_TEXT_Y
	addi a1, a1, 1
	lw a2, color_white
	mv a3, a1
	jal draw_vertical_line

	li a0, BATTLE_TEXT_X
	addi a0, a0, -3
	li a1, BATTLE_TEXT_Y
	addi a1, a1, 3
	lw a2, color_white
	li a3, BATTLE_TEXT_Y
	addi a3, a3, 6
	jal draw_vertical_line

######################################
# Letra A
li a0, BATTLE_TEXT_X
addi a0, a0, -1
li a1, BATTLE_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, 6
jal draw_vertical_line

li a0, BATTLE_TEXT_X
addi a0, a0, 3
li a1, BATTLE_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, 6
jal draw_vertical_line

li a0, BATTLE_TEXT_X
addi a0, a0, 0
li a1, BATTLE_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, BATTLE_TEXT_X
addi a0, a0, 0
li a1, BATTLE_TEXT_Y
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line




##########t

# Letra T 
li a0, BATTLE_TEXT_X
addi a0, a0, 5
li a1, BATTLE_TEXT_Y
lw a2, color_white
addi a3, a0, 4
jal draw_horizontal_line

li a0, BATTLE_TEXT_X
addi a0, a0, 7
li a1, BATTLE_TEXT_Y
addi a1, a1, 1
lw a2, color_white
li t0, BATTLE_TEXT_H
addi t0, t0, -1
add a3, a1, t0
jal draw_vertical_line

# Letra T 
li a0, BATTLE_TEXT_X
addi a0, a0, 11
li a1, BATTLE_TEXT_Y
lw a2, color_white
addi a3, a0, 4
jal draw_horizontal_line

li a0, BATTLE_TEXT_X
addi a0, a0, 13
li a1, BATTLE_TEXT_Y
addi a1, a1, 1
lw a2, color_white
li t0, BATTLE_TEXT_H
addi t0, t0, -1
add a3, a1, t0
jal draw_vertical_line


# Letra L 
li a0, BATTLE_TEXT_X
addi a0, a0, 17
li a1, BATTLE_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, BATTLE_TEXT_H
jal draw_vertical_line

li a0, BATTLE_TEXT_X
addi a0, a0, 17
li a1, BATTLE_TEXT_Y
addi a1, a1, BATTLE_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

# Letra E 
li a0, BATTLE_TEXT_X
addi a0, a0, 23
li a1, BATTLE_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, BATTLE_TEXT_H
jal draw_vertical_line

li a0, BATTLE_TEXT_X
addi a0, a0, 23
li a1, BATTLE_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, BATTLE_TEXT_X
addi a0, a0, 23
li a1, BATTLE_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, BATTLE_TEXT_X
addi a0, a0, 23
li a1, BATTLE_TEXT_Y
addi a1, a1, BATTLE_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line
###################

# Letra C
li a0, BATTLE_TEXT_X
addi a0, a0, 32
li a1, BATTLE_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, BATTLE_TEXT_H
jal draw_vertical_line

li a0, BATTLE_TEXT_X
addi a0, a0, 32
li a1, BATTLE_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, BATTLE_TEXT_X
addi a0, a0, 32
li a1, BATTLE_TEXT_Y
addi a1, a1, BATTLE_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

#LETRA I

# Letra L 
li a0, BATTLE_TEXT_X
addi a0, a0, 38
li a1, BATTLE_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, BATTLE_TEXT_H
jal draw_vertical_line


# Letra T 
li a0, BATTLE_TEXT_X
addi a0, a0, 40
li a1, BATTLE_TEXT_Y
lw a2, color_white
addi a3, a0, 4
jal draw_horizontal_line

li a0, BATTLE_TEXT_X
addi a0, a0, 42
li a1, BATTLE_TEXT_Y
addi a1, a1, 1
lw a2, color_white
li t0, BATTLE_TEXT_H
addi t0, t0, -1
add a3, a1, t0
jal draw_vertical_line


#LETRA Y

    # — 0) Cálculo de la mitad de la altura
    li   t0, BATTLE_TEXT_H
    srai t0, t0, 1           # t0 = H / 2

    # — 1) Brazo izquierdo (vertical de Y0 a Y0 + H/2)
    li   a0, BATTLE_TEXT_X
    addi a0, a0, 46          # X = X0
    li   a1, BATTLE_TEXT_Y   # Y_inicio = Y0
    lw   a2, color_white
    addi  a3, a1, 2        # Y_fin = Y0 + H/2
    jal  draw_vertical_line

    # — 2) Brazo derecho (vertical de Y0 a Y0 + H/2)
    li   a0, BATTLE_TEXT_X
    addi a0, a0, 50          # X = X0 + 4
    li   a1, BATTLE_TEXT_Y
    lw   a2, color_white
    add  a3, a1, t0
    jal  draw_vertical_line

    # — 3) Barra horizontal central (de X0 a X0+4 en Y0 + H/2)
    li   a0, BATTLE_TEXT_X
    addi a0, a0, 46          # X_inicio = X0
    li   a1, BATTLE_TEXT_Y
    add  a1, a1, t0          # Y = Y0 + H/2
    lw   a2, color_white
    addi a3, a0, 4          # X_fin = X0 + 4
    jal  draw_horizontal_line

    # — 4) Tallo (vertical de Y0 + H/2 + 1 hasta Y0 + H)
    li   a0, BATTLE_TEXT_X
    addi a0, a0, 48          # X = X0 + 2 (centro)
    li   a1, BATTLE_TEXT_Y
    addi  a1, a1, 3      # Y_inicio = Y0 + H/2
          # +1 para no sobreescribir la barra horizontal
    lw   a2, color_white
    add  a3, a1, t0          # Y_fin = Y0 + H/2 + H/2 = Y0 + H
    jal  draw_vertical_line
    addi  a3, a1, 3         # Y_fin = Y0 + H/2 + H/2 = Y0 + H
    jal  draw_vertical_line

#############################################################################
#############################################################################
#############################################################################

# The P
	li a0, PRESS_TEXT_X
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 3
	li a1, PRESS_TEXT_Y
	addi a1, a1, 1
	lw a2, color_white
	addi a3, a1, 1
	jal draw_vertical_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 1
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a0, 2
	jal draw_horizontal_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 1
	li a1, PRESS_TEXT_Y
	addi a1, a1, 2
	lw a2, color_white
	addi a3, a0, 2
	jal draw_horizontal_line
	
	# The R
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 5
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 7
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 7
	li a1, PRESS_TEXT_Y
	addi a1, a1, 2
	lw a2, color_black
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 6
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	jal draw_point

	li a0, PRESS_TEXT_X
	addi a0, a0, 6
	li a1, PRESS_TEXT_Y
	addi a1, a1, 2
	lw a2, color_white
	jal draw_point
			
	#The E
	li a0, PRESS_TEXT_X
	addi a0, a0, 9
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 10
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 10
	li a1, PRESS_TEXT_Y
	addi a1, a1, 2
	lw a2, color_white
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 10
	li a1, PRESS_TEXT_Y
	addi a1, a1, 4
	lw a2, color_white
	jal draw_point
	
	# The first S
	li a0, PRESS_TEXT_X
	addi a0, a0, 12
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 12
	li a1, PRESS_TEXT_Y
	addi a1, a1, 3
	lw a2, color_black
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 13
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 13
	li a1, PRESS_TEXT_Y
	addi a1,  a1, 2
	lw a2, color_white
	jal draw_point

	li a0, PRESS_TEXT_X
	addi a0, a0, 13
	li a1, PRESS_TEXT_Y
	addi a1,  a1, 4
	lw a2, color_white
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 14
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line

	li a0, PRESS_TEXT_X
	addi a0, a0, 14
	li a1, PRESS_TEXT_Y
	addi a1,  a1, 1
	lw a2, color_black
	jal draw_point

	# The other S
		
	li a0, PRESS_TEXT_X
	addi a0, a0, 16
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 16
	li a1, PRESS_TEXT_Y
	addi a1, a1, 3
	lw a2, color_black
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 17
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 17
	li a1, PRESS_TEXT_Y
	addi a1,  a1, 2
	lw a2, color_white
	jal draw_point

	li a0, PRESS_TEXT_X
	addi a0, a0, 17
	li a1, PRESS_TEXT_Y
	addi a1,  a1, 4
	lw a2, color_white
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 18
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line

	li a0, PRESS_TEXT_X
	addi a0, a0, 18
	li a1, PRESS_TEXT_Y
	addi a1,  a1, 1
	lw a2, color_black
	jal draw_point
	
	# The 1 

	li a0, PRESS_TEXT_X
	addi a0, a0, 23
	li a1, PRESS_TEXT_Y
	lw a2, color_white
	addi a3, a1, PRESS_TEXT_H
	jal draw_vertical_line
			
	li a0, PRESS_TEXT_X
	addi a0, a0, 22
	li a1, PRESS_TEXT_Y
	addi a1,  a1, 1
	lw a2, color_white
	jal draw_point
	
	li a0, PRESS_TEXT_X
	addi a0, a0, 22
	li a1, PRESS_TEXT_Y
	addi a1, a1, PRESS_TEXT_H
	lw a2, color_white
	addi a3, a0, 2
	jal draw_horizontal_line
	
	
	
#############################################
# ------NOMBRES ISABEL Y STEVEN ------------#
					
	# The name																																																																
# ==============================
# LETRA I
# ==============================

li a0, NAME_TEXT_X          # Cargar la posición X inicial de la letra I
addi a0, a0, 0             # Ajustar la posición X (en este caso, no cambia)
li a1, NAME_TEXT_Y          # Cargar la posición Y inicial de la letra I
lw a2, color_white          # Cargar el color blanco
addi a3, a1, NAME_TEXT_H    # Calcular la posición Y final (altura de la letra I)
jal draw_vertical_line      # Llamar a la función para dibujar una línea vertical

# Punto superior izquierdo de la letra I
li a0, NAME_TEXT_X          # Cargar la posición X inicial
addi a0, a0, -1             # Mover la posición X hacia la izquierda
li a1, NAME_TEXT_Y          # Cargar la posición Y inicial
lw a2, color_white          # Cargar el color blanco
jal draw_point              # Llamar a la función para dibujar un punto

# Punto superior derecho de la letra I
li a0, NAME_TEXT_X          # Cargar la posición X inicial
addi a0, a0, 1              # Mover la posición X hacia la derecha
li a1, NAME_TEXT_Y          # Cargar la posición Y inicial
lw a2, color_white          # Cargar el color blanco
jal draw_point              # Llamar a la función para dibujar un punto

# Punto inferior izquierdo de la letra I
li a0, NAME_TEXT_X          # Cargar la posición X inicial
addi a0, a0, -1             # Mover la posición X hacia la izquierda
li a1, NAME_TEXT_Y          # Cargar la posición Y inicial
addi a1, a1, NAME_TEXT_H    # Mover la posición Y hacia abajo (altura de la letra)
lw a2, color_white          # Cargar el color blanco
jal draw_point              # Llamar a la función para dibujar un punto

# Punto inferior derecho de la letra I
li a0, NAME_TEXT_X          # Cargar la posición X inicial
addi a0, a0, 1              # Mover la posición X hacia la derecha
li a1, NAME_TEXT_Y          # Cargar la posición Y inicial
addi a1, a1, NAME_TEXT_H    # Mover la posición Y hacia abajo (altura de la letra)
lw a2, color_white          # Cargar el color blanco
jal draw_point              # Llamar a la función para dibujar un punto

# ==============================
# LETRA S
li a0, NAME_TEXT_X
addi a0, a0, 3
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 3
li a1, NAME_TEXT_Y
addi a1, a1, 3
lw a2, color_black
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 4
li a1, NAME_TEXT_Y
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 4
li a1, NAME_TEXT_Y
addi a1, a1, 2
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 4
li a1, NAME_TEXT_Y
addi a1, a1, 4
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 5
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 5
li a1, NAME_TEXT_Y
addi a1, a1, 1
lw a2, color_black
jal draw_point

# ==============================
# LETRA A
li a0, NAME_TEXT_X
addi a0, a0, 7
li a1, NAME_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 8
li a1, NAME_TEXT_Y
addi a1, a1, 1
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 10
li a1, NAME_TEXT_Y
addi a1, a1, 1
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 11
li a1, NAME_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 9
li a1, NAME_TEXT_Y
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 8
li a1, NAME_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

# ==============================



# ==============================
# LETRA 
li a0, NAME_TEXT_X
addi a0, a0, 17
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 17
li a1, NAME_TEXT_Y
addi a1, a1, NAME_TEXT_H
lw a2, color_white
jal draw_point




# ==============================
# The S in "STEVEN"

li a0, NAME_TEXT_X
addi a0, a0, 24
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 24
li a1, NAME_TEXT_Y
addi a1, a1, 3
lw a2, color_black
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 25
li a1, NAME_TEXT_Y
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 25
li a1, NAME_TEXT_Y
addi a1, a1, 2
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 25
li a1, NAME_TEXT_Y
addi a1, a1, 4
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 26
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 26
li a1, NAME_TEXT_Y
addi a1, a1, 1
lw a2, color_black
jal draw_point


# ==============================
# LETRA T
li a0, NAME_TEXT_X
addi a0, a0, 28
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, NAME_TEXT_X
addi a0, a0, 29
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

# ==============================
# LETRA E

li a0, NAME_TEXT_X
addi a0, a0, 32
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 33
li a1, NAME_TEXT_Y
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 33
li a1, NAME_TEXT_Y
addi a1, a1, 2
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 33
li a1, NAME_TEXT_Y
addi a1, a1, 4
lw a2, color_white
jal draw_point


# ==============================
# LETRA V
li a0, NAME_TEXT_X
addi a0, a0, 35
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 36
li a1, NAME_TEXT_Y
addi a1, a1, 2
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 37
li a1, NAME_TEXT_Y
addi a1, a1, NAME_TEXT_H
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 38
li a1, NAME_TEXT_Y
addi a1, a1, 2
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 39
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, 1
jal draw_vertical_line

# ==============================
# LETRA E (repetí una vez más el bloque de la E con offset nuevo)
li a0, NAME_TEXT_X
addi a0, a0, 41
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 42
li a1, NAME_TEXT_Y
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 42
li a1, NAME_TEXT_Y
addi a1, a1, 2
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 42
li a1, NAME_TEXT_Y
addi a1, a1, 4
lw a2, color_white
jal draw_point

# ==============================
# LETRA N
li a0, NAME_TEXT_X
addi a0, a0, 44
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line

li a0, NAME_TEXT_X
addi a0, a0, 45
li a1, NAME_TEXT_Y
addi a1, a1, 1
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 46
li a1, NAME_TEXT_Y
addi a1, a1, 2
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 47
li a1, NAME_TEXT_Y
addi a1, a1, 3
lw a2, color_white
jal draw_point

li a0, NAME_TEXT_X
addi a0, a0, 48
li a1, NAME_TEXT_Y
lw a2, color_white
addi a3, a1, NAME_TEXT_H
jal draw_vertical_line





###################################
##TEC TEXT########################

li a0, TEC_TEXT_X
addi a0, a0, 15
li a1, TEC_TEXT_Y
lw a2, color_white
addi a3, a0, 4
jal draw_horizontal_line

li a0, TEC_TEXT_X
addi a0, a0, 17
li a1, TEC_TEXT_Y
addi a1, a1, 1
lw a2, color_white
li t0, TEC_TEXT_H
addi t0, t0, -1
add a3, a1, t0
jal draw_vertical_line





# Letra E 
li a0, TEC_TEXT_X
addi a0, a0, 23
li a1, TEC_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, TEC_TEXT_H
jal draw_vertical_line

li a0, TEC_TEXT_X
addi a0, a0, 23
li a1, TEC_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, TEC_TEXT_X
addi a0, a0, 23
li a1, TEC_TEXT_Y
addi a1, a1, 3
lw a2, color_white
addi a3, a0, 2
jal draw_horizontal_line

li a0, TEC_TEXT_X
addi a0, a0, 23
li a1, TEC_TEXT_Y
addi a1, a1, TEC_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line
###################

# Letra C
li a0, TEC_TEXT_X
addi a0, a0, 30
li a1, TEC_TEXT_Y
lw a2, color_white
mv a3, a1
addi a3, a3, TEC_TEXT_H
jal draw_vertical_line

li a0, TEC_TEXT_X
addi a0, a0, 30
li a1, TEC_TEXT_Y
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line

li a0, TEC_TEXT_X
addi a0, a0, 30
li a1, TEC_TEXT_Y
addi a1, a1, TEC_TEXT_H
lw a2, color_white
addi a3, a0, 3
jal draw_horizontal_line


# ==============================



	
lw ra, 0(sp)
addi sp, sp, 4
	
jr ra 


# Function: clear_key_press
# Parameters:
# 	none.
# Return:firefox
#	void.
clear_key_press:
	sw zero, KEY_INPUT_ADDRESS, t0
	jr ra
	
# Function: clear_key_status
# Parameters:
# 	none.
# Return:
#	void.
clear_key_status:
	sw zero, KEY_STATUS_ADDRESS, t0
	jr ra
end:

j end
