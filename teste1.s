.data
  

        # frase pra imprimir na tela
        string1:.asciiz "player 1"
        string2:.asciiz "player 2"
	#contadores do placar
	
	contador1: .word 0
	contador2: .word 0
	.eqv minhaeqv 351 
	
	#telas feitas do jogo
	menu: .asciiz "telainicial.bin"
	telafinal1: .asciiz "player.1.wins.1.bin"
	telafinal2: .asciiz "player.2.wins.1.bin"
	telafinal3: .asciiz "player.1.wins.2.bin"
	telafinal4: .asciiz "player.2.wins.2.bin"
	
	# cor do plano de fundo
	background: 	.word 0x00000000
			
	# cor do limite da tela
	cor.stblk: 	.word 0x90909090
	
	# cor dos blocos normais
	corblk: 	.word 0x28282828
	corblk2:        .word 0xCACACACA
	
	# cor das raquetes
	raqcor.p1: 	.word 0xCACACACA
	raqcor.p2: 	.word 0x37373737

	# omprimento das raquetes
	.eqv raq_vert 32
	.eqv raq_hor 8
	
	BALL:	.word 8, 8, 100, 100
	

.text

       li $t9, 0
inicio:
	#jal telainicial		# imprimi o menu do jogo
	jal paintscreen		# quando iniciar pinta a tela de preto
	

## imprimindo os blocos dos cantos
	
	li $a1, 0xFF000000	# imprime bloco superior esquerdo
	jal staticblocks
	li $a1, 0xFF0000C8	# imprime bloco superior direito
	jal staticblocks
	li $a1, 0xFF00F8C0	# imprime bloco inferior esquerdo
	jal staticblocks
	li $a1, 0xFF00F988	# imprime bloco inferior direito
	jal staticblocks
	
	jal lateralline		# imprime a linha divisoria de jogo e placar
	
	li $a1, 0xFF00002C	# imprime os blocos de cima
	jal print_blkhorizontal
	li $a1, 0xFF010428	# imprime os blocos de baixo
	jal print_blkhorizontal
	
	li $a1, 0xFF003480	# imprime os blocos da esquerda
	jal print.blocos.vertical
	li $a1, 0xFF003550	# imprime os blocos da direita
	jal print.blocos.vertical

#imprimindo as rauetes
	li $s4, 0xFF002D68
	move $a1, $s4
	
	lw $a2, raqcor.p1
	jal print.raquete.horizontal
	
	li $s5, 0xFF008224	                    
	move $a1, $s5
	lw $a2, raqcor.p2			
	jal print.raquete.vertical
	
	li $s6, 0xFF0082C8
	move $a1, $s6
	lw $a2, raqcor.p1
	jal print.raquete.vertical
	
	li $s7, 0xFF00F928
	move $a1, $s7
	lw $a2, raqcor.p2
	jal print.raquete.horizontal
	
	
	
	la $s1, BALL
	sw $zero, 0($s1)
	sw $zero, 4($s1)
	sw $zero, 8($s1)
	sw $zero, 12($s1)
	
		
	

MAIN:	

checkforkey:
	la $t6, 0xFF100000
	lw $t5, 0($t6)
	bnez $t5, verifykey
	j fim.move
verifykey:
        
	lw $t5, 4($t6)
	beq $t5, 119, goto_moveup.p1	#119: w
	beq $t5, 115, goto_movedown.p1	#115: s
	beq $t5, 97, goto_moveleft.p1	 #97: a
	beq $t5, 100, goto_moveright.p1 #100: d
	
	beq $t5, 105, goto_moveup.p2	#105: i
	beq $t5, 107, goto_movedown.p2  #107: k
	beq $t5, 106, goto_moveleft.p2	#106: j
	beq $t5, 108, goto_moveright.p2	#108: l
	
	beq $t5, 27, fim
	j sleep

	goto_moveup.p1:
		move $a1, $s6
		lw $a2, raqcor.p1
		jal moveup
		move $s6, $v1
		j fim.move

	goto_movedown.p1:
		move $a1, $s6
		lw $a2, raqcor.p1
		jal movedown
		move $s6, $v1
		j fim.move
	
	goto_moveleft.p1:
		move $a1, $s4
		lw $a2, raqcor.p1
		jal moveleft
		move $s4, $v1
		j fim.move
	
	goto_moveright.p1:
		move $a1, $s4
		lw $a2, raqcor.p1
		jal moveright
		move $s4, $v1
		j fim.move
		
	goto_moveup.p2:
		move $a1, $s5
		lw $a2, raqcor.p2
		jal moveup
		move $s5, $v1
		j fim.move
	
	goto_movedown.p2: 
		move $a1, $s5
		lw $a2, raqcor.p2
		jal movedown
		move $s5, $v1
		j fim.move
		
	goto_moveleft.p2:
		move $a1, $s7
		lw $a2, raqcor.p2
		jal moveleft
		move $s7, $v1
		j fim.move
		
	goto_moveright.p2:
		move $a1, $s7
		lw $a2, raqcor.p2
		jal moveright
		move $s7, $v1
		j fim.move
	

		
fim.move:

	

	jal print.bolinha
	lw $s3, 8($s1)			
	lw $s2, 12($s1)			
	sw $s3, 0($s1)			
	sw $s2, 4($s1)			
	addi $s3, $s3, 4
	addi $s2, $s2, 4
	sw $s3, 8($s1)
	sw $s2, 12($s1)
	
	
mostraplacar:
        jal mostraplacarp1
	jal mostraplacarp2
		
	
		
sleep:	li $v0, 32
	li $a0, 100
	syscall
	j MAIN

#################################################################################################
#printando a tela final do jogo e fechando o jogo################################################
################################################################################################# 
player1wins:
        li $t1,0xFF012C00
	li $s2,0xFF000000
	li $s1,0x88888888
loopfinal: 	beq $s2,$t1,FORA1
	sw $s1,0($s2)
	addi $s2,$s2,4
	j loopfinal
FORA1:
# Abre o arquivo
	la $a0,telafinal1
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

# Le o arquivos para a memoria VGA
	move $a0,$v0
	la $a1,0xFF000000
	li $a2,76800
	li $v0,14
	syscall
	

#Fecha o arquivo#
	#move $a0,$s1
	li $v0,16
	syscall
	j fim
	
player2wins:
        li $t1,0xFF012C00
	li $s2,0xFF000000
	li $s1,0x88888888
loopfinal2: 	beq $s2,$t1,FORA2
	sw $s1,0($s2)
	addi $s2,$s2,4
	j loopfinal2
FORA2:
# Abre o arquivo
	la $a0,telafinal2
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

# Le o arquivos para a memoria VGA
	move $a0,$v0
	la $a1,0xFF000000
	li $a2,76800
	li $v0,14
	syscall
	

#Fecha o arquivo#
	#move $a0,$s1
	li $v0,16
	syscall	
        j fim
        
fim:    li $v0, 10
	syscall

	
###########################################################################################################
	telainicial:	###################################################################################
# imrpimi a imagem do comeÁo do jogo#######################################################################


	li $t1,0xFF012C00
	li $s2,0xFF000000
	li $s1,0x88888888
LOOP: 	beq $s2,$t1,FORA
	sw $s1,0($s2)
	addi $s2,$s2,4
	j LOOP
FORA:
# Abre o arquivo
	la $a0,menu
	li $a1,0
	li $a2,0
	li $v0,13
	syscall

# Le o arquivos para a memoria VGA
	move $a0,$v0
	la $a1,0xFF000000
	li $a2,76800
	li $v0,14
	syscall
	

#Fecha o arquivo#
	#move $a0,$s1
	li $v0,16
	syscall						
													# fecha arquivo
			
telainicial.loop:
	la	$t4, 0xFF100000
	lw 	$t5, 0($t4)		# checha por uma tecla apertada
	bnez	$t5, fim.telainicial	# se ninguem apertou nada, repete
	j telainicial.loop
	
fim.telainicial: jr $ra


###########################################################################################################
	paintscreen:	###################################################################################
# pintando a tela de preto#################################################################################

	lw $t2, background
	li $t0, 0xFF000000
	li $t1, 0xFF012C00
	
paintscreen.loop:
	beq $t0, $t1, fim.paintscreen
	sw $t2, ($t0)
	addi $t0, $t0, 4
	j paintscreen.loop
	
fim.paintscreen: jr $ra


##############################################################################################################
		staticblocks:	##############################################################################
######imrpimindo os blocks estaticos dos cantos do jogo#######################################################
### $t1 = primeiro endere√ßo do bloco
### $t2 = comprimento
### $t4 = largura
### $t3 = cor: cinza

	move $t1, $a1
	li $t4, 40
	li $t2, 10
	lw $t3, cor.stblk
staticblk_linha:	
	beqz $t2, staticblk_col
	sw $t3, ($t1)
	addi $t1, $t1, 4
	subi $t2, $t2, 1
	j staticblk_linha

staticblk_col:
	beqz $t4, fim.staticblocks
	addi $t2, $t2, 10
	subi $t4, $t4, 1
	addi $t1, $t1, 280
	j staticblk_linha

fim.staticblocks:
	jr $ra

############################################################################################################
	lateralline:	####################################################################################
# imprimindo a linha lateral do jogo  ######################################################################

	li $t1, 0xFF0000F0	# endere√ßo inicial da linha
	li $t2, 240		# quantidade do contador (240 linhas)
	lw $t3, cor.stblk	# cor
	
loop_lateralline:			
	beqz $t2, fim.lateralline
	sw $t3, ($t1)		# imprime uma linha 
	addi $t1, $t1, 320	# pula pra proxima linha
	subi $t2, $t2, 1	
	j loop_lateralline	# repete 240 vezes

fim.lateralline: jr $ra


############################################################################################################
		print_blkhorizontal:	####################################################################
###imprimindo os blocos normais####################################################
#### t1 = endereco dos pixels
#### t2 = primeira cor
#### t9 = segunda cor
#### outros = contadores
############################################################################################################

			move $t1, $a1		# Recebe o primeiro endere√ßo pra come√ßar a impressao
			lw $t2, corblk
			lw $t9, corblk2		# a primeira cor a ser usada: amarelo
			
			
			li $t6, 2	# repete a linha de blocos mais 2 vezes, ou seja, sao 3 camadas de blocos
antes_hor_blk_larg:	li $t5, 7	# largura do bloco menos 1, ou seja, o bloco tem largura de 8 pixels
antes_hor_blk_lineqnt:	li $t4, 3	# repete o comprimento 3 vezes, ou seja, formara 4 blocos por linha
antes_hor_blk_compr:	li $t3, 9	# comprimento do bloco dividido por 4

#loops para imprimir os blocos
																				
hor_blk_line:				# imprime uma linha de 40 pixels
	beqz $t3, hor_blk_space
	sw $t9, ($t1)
	addi $t1, $t1, 4
	subi $t3, $t3, 1
	j hor_blk_line
	
hor_blk_space:				# pula espaco de 4 pixels entre essas linhas
	beqz $t4, hor_blk_verticalspace	# e volta pro loop anterior
	addi $t1, $t1, 4
	subi $t4, $t4, 1
	j antes_hor_blk_compr

hor_blk_verticalspace:			# vai pra proxima linha e repete os loops anteriores 4 vezes
	beqz $t5, hor_blk_proxlinha	# formando blocos com 5 pixels de largura 
	addi $t1, $t1, 164		
	subi $t5, $t5, 1
	j antes_hor_blk_lineqnt
	
hor_blk_proxlinha:			
	beqz $t6, fim.blocos_horizontal
	addi $t1, $t1, 1444		# repetiÁ„o para pular os espaÁos entre os blocos

	subi $t6, $t6, 1
	j antes_hor_blk_larg

fim.blocos_horizontal: jr $ra


############################################################################################################
		print.blocos.vertical:	####################################################################
###imprimindo os blocos normais da vertical           ######################################################
#### t1 = pixels
#### t2 = cor
#### outros = contadores
############################################################################################################

			move $t1, $a1	
			li $t4, 3
antes_vert_blocos:	li $t3, 36
	
vert_blocos:
	beqz $t3, vert_space
	
	lw $t2, corblk
	
	sw $t2, ($t1)
	addi $t1, $t1, 4
	sw $t2, ($t1)
	addi $t1, $t1, 8
	
	sw $t2, ($t1)
	addi $t1, $t1, 4
	sw $t2, ($t1)
	addi $t1, $t1, 8
	
	sw $t2, ($t1)
	addi $t1, $t1, 4
	sw $t2, ($t1)
	addi $t1, $t1, 292
	
	subi $t3, $t3, 1
	j vert_blocos
	
vert_space:
	beqz $t4, fim.blocos_vertical
	addi $t1, $t1, 1280
	subi $t4, $t4, 1
	j antes_vert_blocos
	
fim.blocos_vertical: jr $ra

###############################################################################################################
	print.raquete.vertical: 	##############################################################################
# imprimindo as raquetes verticais ################################################################
#### a1 = endere√ßo inicial a ser impresso ###################################################################
#### t1 = cor
#### t3 = contador (no caso, o comprimento vertical da raquete)
######################################################################################################
	
	move $t2, $a1
	move $t1, $a2
	li $t3, raq_vert

raq.vert_loop:
	beqz $t3, fim.print.raquete.vertical
	sw $t1, ($t2)
	addi $t2, $t2, 320
	subi $t3, $t3, 1
	j raq.vert_loop
	
fim.print.raquete.vertical: jr $ra


###############################################################################################################
	print.raquete.horizontal: 	##############################################################################
# imprimindo as raquetes horizontais ################################################################
#### a1 = endere√ßo inicial a ser impresso ###################################################################
#### t1 = cor
#### t3 = contador (comprimento da raquete = 32)
#### t4 = contador (largura da raquete = 4)
######################################################################################################
	
	move $t2, $a1
	move $t1, $a2
	li $t4, 3

antes.raq.hor_innerloop:
	li $t3, raq_hor
raq.hor_innerloop:
	beqz $t3, raq.hor_outerloop
	sw $t1, ($t2)
	addi $t2, $t2, 4
	subi $t3, $t3, 1
	j raq.hor_innerloop

raq.hor_outerloop:
	beqz $t4, fim.print.raquete.horizontal
	addi $t2, $t2, 288
	subi $t4, $t4, 1
	j antes.raq.hor_innerloop
li $t3, 0
fim.print.raquete.horizontal: jr $ra

############################################################################################################
#	imprimindo o placar na tela	####################################################################
############################################################################################################
#### a0 = valor a ser mostrado
#### a1 = coordenada x
#### a2 = coordenada y
#### a3 = cor
#### t3 = reg da contagem dos pontos player 2
#### t7 = reg da contagem dos pontos player 1
############################################################################################################

mostraplacarp1:

printplayer1:
       la $a0, string1
       li $a1, 250
       li $a2, 60
       li $a3, 0x00FF
       li $v0, 104
       syscall
       
printplayer2:
        li $a0, 0
        la $a0, string2
	li $a1, 250
	li $a2, 140
	li $a3, 0x00FF
	li $v0, 104
	syscall
	
loop123:
	lw $a0, contador1
	li $a1, 270
	li $a2, 80
	li $a3, 0x00FF
	li $v0, 101
	syscall
	addi $t7,$t7, 4
	
	sw $t7, contador1
sleep2:	li $v0, 32
	li $a0, 50
	syscall


	
	beq $t7, minhaeqv, player1wins 
		
	jr $ra
mostraplacarp2:



        
	lw $a0, contador2
	li $a1, 270
	li $a2, 170
	li $a3, 0x00FF
	li $v0, 101
	syscall
	addi $t3,$t3, 1
	
	sw $t3, contador2
	
sleep3:	li $v0, 32
	li $a0, 50
	syscall
	beq $t3, minhaeqv, player2wins 

	jr $ra

#############################################################################################################
moveup:
	
	lw $t4, background
	addi $t2, $a1, -320
	move $t1, $a2
	li $t8, 4
	li $t9, 4
up.raq.cria:
	beqz $t9, antes.up.raq.apaga
	sw $t1, ($t2)
	addi $t2, $t2, -320
	subi $t9, $t9, 1
	j up.raq.cria
	
antes.up.raq.apaga:
	addi $t2, $a1, 10240
	addi $v1, $a1, -1280
up.raq.apaga:
	beqz $t8, fim.moveup
	sw $t4, ($t2)
	addi $t2, $t2, -320
	subi $t8, $t8, 1
	j up.raq.apaga
	
fim.moveup: jr $ra


#############################################################################################################

movedown:
        #
	addi $t6,$t6, 1
	
	sw $t6, contador2
	#li $s4, 0
	addi $t6,$t6, 1
	
	lw $t4, background
	addi $t2, $a1, 10240
	move $t1, $a2
	li $t8, 4
	li $t9, 4
down.raq.cria:
	beqz $t9, antes.down.raq.apaga
	sw $t1, ($t2)
	addi $t2, $t2, 320
	subi $t9, $t9, 1
	j down.raq.cria
	
antes.down.raq.apaga:
	move $t2, $a1
	addi $v1, $a1, 1280
down.raq.apaga:
	beqz $t8, fim.movedown
	sw $t4, ($t2)
	addi $t2, $t2, 320
	subi $t8, $t8, 1
	j down.raq.apaga
	
fim.movedown: jr $ra

#############################################################################################################
moveleft:

	lw $t4, background
	addi $t2, $a1, -4
	move $t1, $a2
	li $t8, 4
	li $t9, 4
	
left.raq.cria:
	beqz $t8, antes.left.raq.apaga
	sw $t1, ($t2)
	addi $t2, $t2, 320
	subi $t8, $t8, 1
	j left.raq.cria
	
antes.left.raq.apaga:
	addi $t2, $a1, 28
	addi $v1, $a1, -4
left.raq.apaga:
	beqz $t9, fim.moveleft
	sw $t4, ($t2)
	addi $t2, $t2, 320
	subi $t9, $t9, 1
	j left.raq.apaga
	
fim.moveleft: jr $ra

#############################################################################################################
moveright:

	lw $t4, background
	addi $t2, $a1, 32
	move $t1, $a2
	li $t8, 4
	li $t9, 4
	
right.raq.cria:
	beqz $t8, antes.right.raq.apaga
	sw $t1, ($t2)
	addi $t2, $t2, 320
	subi $t8, $t8, 1
	j right.raq.cria
	
antes.right.raq.apaga:
	move $t2, $a1
	addi $v1, $a1, 4
right.raq.apaga:
	beqz $t9, fim.moveright
	sw $t4, ($t2)
	addi $t2, $t2, 320
	subi $t9, $t9, 1
	j right.raq.apaga
	
fim.moveright: jr $ra
	
################################################################################################################
print.bolinha:
	
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
#	sw $s3, 12($sp)

	li $s0, 0xFFFFFFFF	# s0 = branco
	lw $s1, background	# s1 = preto
	li $s2, 0xFF009678
	
	# APAGAR
	
	la $t0, BALL
	lw $t1, 0($t0)
	lw $t2, 4($t0)
	
	mul $t2, $t2, 320			#ACHA O EIXO Y INICIAL PARA PRINTAR
	add $t1, $s2, $t1			#ACHA O EIXO X INICIAL PARA PRINTAR
	add $t1, $t1, $t2			#SOMA $t1 e $t2 PARA ACHAR O EIXO XY (LINHA E COLUNA)
	
	sw $s1, 0($t1)				
	sw $s1, 320($t1)
	sw $s1, 640($t1)
	sw $s1, 960($t1)			#APAGA A BOLINHA (PRINTA DE BRANCO)
	
	# CRIAR
	
	la $t0, BALL				#carrega $t0 com o valor de BALL que e uma array aleatoria 
	lw $t1, 8($t0)				#load word $t1 com o 3 elemento de BALL ( coordenada X final )
	lw $t2, 12($t0)				#load word $t2 com o 4 elemento de BALL ( coordenada Y final )
	
	mul $t2, $t2, 320			#acha a linha do y
	add $t1, $s2, $t1			#acha a linha do x  
	add $t1, $t1, $t2			#soma os dois dados pra acha  endereÁo xy que vai printa a bolinha
	
	sw $s0, 0($t1)					
	sw $s0, 320($t1)
	sw $s0, 640($t1)
	sw $s0, 960($t1)			#print na bolinha 4x4

	

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
#	lw $s3, 12($sp)
	addi $sp, $sp, 12
	
	jr $ra
