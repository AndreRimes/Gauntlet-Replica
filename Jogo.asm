.data
CHAR_POS:     .half 0,0          # x, y
OLD_CHAR_POS: .half 0,0          # x, y
CHAR_SENTIDO: .byte 3           #0= cima    1= dir      #2=baixo      #3 = esq 

ZUMB_POS:    .half 120,66
OLD_ZUMB_POS:   .half 120,66

VIDA: .byte 3,0
Quebra:  .string "\n"

TIRO_ZUMBI: .byte 200
#80
#220

NUM: .word 9
NOTAS:71,210,67,210,62,210,65,210,64,420,78,210,76,525,63,315,62,1050


.include "sprites/grama.data"
.include "sprites/map_grama.data"
.include "sprites/prota_dir.data"
.include "sprites/prota_esq.data"
.include "sprites/prota_baixo.data"
.include "sprites/prota_cima2.data"
.include "sprites/pedra.data"
.include "sprites/zumbi.data"
.include "sprites/map2_240.data"
.include "sprites/chave.data"
.include "sprites/exit.data"
.include "sprites/coracao.data"
.include "sprites/mapa1.data"
.include "sprites/score.data"
.include "sprites/um.data"
.include "sprites/dois.data"
.include "sprites/tres.data"
.include "sprites/grama16.data"
.include "sprites/gameover.data"
.include "sprites/zeroTeste.data"
.include "sprites/tile2.data"
.include "sprites/dez.data"
.include "sprites/vinte.data"
.include "sprites/trinta.data"
.include"sprites/quarenta.data"
.include "sprites/tiro_zumbi.data"
.include "sprites/map3(240).data"
.include "sprites/tile3.data"
.include "sprites/tile_3_16.data"
.include "sprites/fantasma.data"
.include "sprites/vitoria.data"
.include "sprites/gauntlet.data"

# REGISTRADORE QUE VC NAO PODE MEXER:
# s7: chave
#a5:zumbi
#s3
.text
MENU:	
	la a0,gauntlet
   li a1,0
   li a2,0
   li a3,0
   call PRINT
   li a3,1
   call PRINT
loop2:call KEY2
   j  loop2





SETUP:

    li a5,0 # a5 = zumbi indo para cima ou para baixo
    li s7,0
    
    la a0, mapa1      
    li a1, 0     #x          
    li a2, 0     #y       
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT 
    
    la a0, score     
    li a1, 0     #x          
    li a2, 0     #y       
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT 
    
   la a0, chave    
    li a1, 200   #x          
    li a2, 80    #y       
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT 
    
    la a0,exit #trocar para exit
    li a1,40
    li a2,180
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    la a0 ,zumbi
    li a1,120
    li a2,66
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    la a0,um
    li a1,280
    li a2,20
    li a3,0
    call PRINT
    li a3,1
    call PRINT 
    
     la a0,zeroTeste
    li a1,288
    li a2,55
    li a3,0
    call PRINT
    li a3,1
    call PRINT 
    
   la a0,tres
   li a1,280
   li a2,90
   li a3,0
   call PRINT
   li a3,1
   call PRINT

 	la a0,pedra
 	li a1,0
 	li a2,120
 	li s10,0
 	li s11,230
PAREDE: bge s10,s11 GAME_LOOP
	mv a1,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,16
	j PAREDE  
                
                                                                             
GAME_LOOP:
    	call KEY2
   	xori s0, s0, 1
   	
   	la s4, ZUMB_POS
   	la s2, OLD_ZUMB_POS
   	lh a7, 2(s4)  #a7 = posicao y do zumbi
   	mv a6,a7 # posicao antiga = a6
   	sh a7,2(s2)  #guardar a posicao antiga do zumbi
   	li s5, 98
   	li s6, 2
   	
   	beq a7,s5,comecar_a_subir
   	beq a7,s6,comecar_a_descer
  	j mov_zumb
   	
comecar_a_subir: li a5,1
		j mov_zumb
comecar_a_descer: li a5,0
	         j mov_zumb 
   	
mov_zumb:bnez a5,subir
   	addi a7,a7,16
   	la a0, zumbi
   	li a1,120
   	mv a2,a7
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   	j limpar_zumb
   	
subir: addi a7,a7,-16
   	la a0, zumbi
   	li a1,120
   	mv a2,a7
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   
   	
   
limpar_zumb:sh a7,2(s4) #atualizando a posicao do zumbi
	
   	la a0,grama
   	li a1,120
   	mv a2,a6
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   

   	la t0, CHAR_POS
	lh t1, 0(t0)  # x
    	li t2,40 # Posição x desejada
    	lh t3, 2(t0)  # y
    	li t4,180 # Posição y desejada
    	sub s8,t1,t2
    	call MODULO
    	li t0,16
    	bgt s8,t0,check_chave
    	sub s8,t3,t4
    	call MODULO
    	bgt s8,t0,check_chave
    	
   	li a0,60 #troca as notas por musica de mundanca de fase
    	li a1,1050
    	li a2,125
    	li a3,1000
   	li a7,31
   	ecall
	
	j SETUP2
    # Verificação de posição
 check_chave:  
    la t0, CHAR_POS
    lh t1, 0(t0)  # x
    li t2,200 # Posição x desejada
    lh t3, 2(t0)  # y
    li t4, 80  # Posição y desejada
   
   sub s8,t1,t2
   call MODULO
   li t0,16
   bgt s8,t0,CHAR
   sub s8,t3,t4
   call MODULO
   bgt s8,t0,CHAR
     
    # Se as posições forem iguais, execute a ação desejada
    la a0,grama
    li a1,200
    li a2,80
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    bnez s7,CHAR
    li a0,60
    li a1,1050
    li a2,125
    li a3,1000
    li a7,31
    ecall
    
    li s7,1
    
    la a0,dez
    li a1,288
    li a2,55
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    	la a0,grama16
 	li a1,0
 	li a2,120
 	li s10,0
 	li s11,230
limpa_parede: bge s10,s11 GAME_LOOP
	mv a1,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,16
	j limpa_parede
	
   
CHAR:    	     
        la t0, CHAR_POS
        lh t1, 0(t0)
        lh t2, 2(t0)

        la t0, OLD_CHAR_POS
        lh t3, 0(t0)
        lh t4, 2(t0)

        beq t1, t3, CHECK_VERTICAL
        blt t1, t3, CHAR_ESQ
        beq t1, t3, CHAR_DIR

CHECK_VERTICAL:
        blt t2, t4, CHAR_CIMA
        beq t2, t4, CHAR_BAIXO

CHAR_ESQ:
        la a0, prota_esq
        b CHAR_SPRITE_DONE

CHAR_DIR:
        la a0, prota_dir
        b CHAR_SPRITE_DONE

CHAR_CIMA:
        la a0, prota_cima2
        b CHAR_SPRITE_DONE

CHAR_BAIXO:
        la a0, prota_baixo

CHAR_SPRITE_DONE:
        mv a1, t1
        mv a2, t2
        li a3,0
        call PRINT
        li a3,1
        call PRINT

        j LABEL

LABEL:
    li t0, 0xFF200604
    sw s0, 0(t0)

    la t0, OLD_CHAR_POS
    la a0, grama
    lh a1, 0(t0)
    lh a2, 2(t0)
    mv a3, s0
   xori a3, a3, 1
   call PRINT
   
   
   
      la s1, CHAR_POS         # s1 = endereço de CHAR_POS
      la s2,ZUMB_POS          # s2 = endereco de Zumbi pos
      
      lh s3, 0(s1)            #s3 = posicao x do protagonista
      lh s4, 2(s1) 	      #s4 = posicao y do protagonista
      lh s5,2(s2)             #s5 = posicao y do zumbi
      lh s6,0(s2)             #s6 = posicao x do zumbi
      
     
     
      blt s6,s3,GAME_LOOP    #se Pzx<Pcharx pula para label 
      addi s3,s3,16
      bgt s6,s3,GAME_LOOP    #se Pzx>Pcharx+16 pula para label 
      
      sub s8,s4,s5
      call MODULO
      
      li t6,16
      bgt s8,t6,GAME_LOOP
      
    la s6,VIDA  
    lh s8,0(s6)#s8 = vida
  
    addi s8,s8,-1
    
    
    blez s8,GAMEOVER
    li a0,2
    beq s8,a0,PRINT2
    
    
    la a0,um
    li a1,280
    li a2,90
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    sb s8,0(s6)
   j GAME_LOOP
   		
PRINT2:
	 la a0,dois
   	li a1,280
   	li a2,90
   	li a3,0
  	 call PRINT
  	 li a3,1
   	call PRINT
       sb s8,0(s6)
 
     j GAME_LOOP 
KEY2:    li t1,0xFF200000       
        lw t0,0(t1)         
        andi t0,t0,0x0001       
        beq t0,zero,FIM       
        lw t2,4(t1)         

        li t0,'w'
        beq t2,t0,CIMA      

        li t0,'a'
        beq t2,t0,ESQ       

        li t0,'s'
        beq t2,t0,BAIXO      

        li t0,'d'
        beq t2,t0,DIR
        
        li t0,'i'
        beq t2,t0,inicio
            

FIM:        ret  

inicio:
	j SETUP
	ret      
     
ESQ:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)  
    
    
    la t0, CHAR_POS
    lh t1, 0(t0)            # carrega o x atual do personagem
    li t2, 0              # define o limite direito (320 - 16)
    ble t1, t2,ESQ_FIM
    addi t1,t1,-20
    sh t1,0(t0)
    
    li t1,3
    la t0,CHAR_SENTIDO
    sb t1,0(t0)
    
    ret
    

DIR:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 0(t0)            # carrega o x atual do personagem
    li t2, 210             # define o limite direito (320 - 16)
    bge t1, t2, DIR_FIM    # se o x atual for maior ou igual ao limite direito, sai da função
    addi t1, t1, 20         # incrementa 16 pixels
    sh t1, 0(t0)            # salva a nova posição do personagem
    
    li t1,1
    la t0,CHAR_SENTIDO
    sb t1,0(t0) 
    
    ret

CIMA:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 2(t0)            # carrega o y atual do personagem
    li t2, 0                # define o limite superior (0)
    ble t1, t2,CIMA_FIM    # se o y atual for menor ou igual ao limite superior, sai da função
    addi t1, t1, -20       # decrementa 16 pixels
    sh t1, 2(t0)            # salva a nova posição do personagem
    
    li t1,0
    la t0,CHAR_SENTIDO
    sb t1,0(t0) 
    
    ret

BAIXO:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 2(t0)            # carrega o y atual do personagem
    li t2, 220              # define o limite inferior (240 - 16)
    bge t1, t2, BAIXO_FIM    # se o y atual for maior ou igual ao limite inferior, sai da função
    bnez s7,pula_parede
    li t2,100
    bge t1,t2,BAIXO_FIM
    
    
pula_parede:addi t1, t1, 20         # incrementa 16 pixels
    	sh t1, 2(t0)            # salva a nova posição do personagem
    	
    	li t1,2
   	la t0,CHAR_SENTIDO
   	sb t1,0(t0)
    	
    	
   	ret

ESQ_FIM:
    ret

DIR_FIM:
    ret

CIMA_FIM:
    ret

BAIXO_FIM:
    ret
        


PRINT:  li t0,0xFF0          # carrega 0xFF0 em t0
        add t0,t0,a3          # adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
        slli t0,t0,20          # shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
        
        add t0,t0,a1          # adiciona x ao t0
        
        li t1,320          # t1 = 320
        mul t1,t1,a2          # t1 = 320 * y
        add t0,t0,t1          # adiciona t1 ao t0
        
        addi t1,a0,8          # t1 = a0 + 8
        
        mv t2,zero          # zera t2
        mv t3,zero          # zera t3
        
        lw t4,0(a0)          # carrega a largura em t4
        lw t5,4(a0)          # carrega a altura em t5
        
PRINT_LINHA:    lw t6,0(t1)          # carrega em t6 uma word (4 pixeis) da imagem
        	sw t6,0(t0)                 # imprime no bitmap a word (4 pixeis) da imagem
        
        addi t0,t0,4          # incrementa endereco do bitmap
        addi t1,t1,4          # incrementa endereco da imagem
        
        addi t3,t3,4          # incrementa contador de coluna
        blt t3,t4,PRINT_LINHA      # se contador da coluna < largura, continue imprimindo

        addi t0,t0,320          # t0 += 320
        sub t0,t0,t4          # t0 -= largura da imagem
        # ^ isso serve pra "pular" de linha no bitmap
        
        mv t3,zero          # zera contador de coluna
        addi t2,t2,1          # incrementa contador de linha
        blt t2,t5,PRINT_LINHA      # se contador de linha < altura, continue imprimindo

        ret
       
#ARGUMENTOS:
#s8
#return S8 modulo         
MODULO:
	blt s8, zero, valor_negativo
	ret
	valor_negativo:
	sub s8,zero,s8
	ret
	
	
KEY3:    li t1,0xFF200000       
        lw t0,0(t1)         
        andi t0,t0,0x0001       
        beq t0,zero,FIM2       
        lw t2,4(t1)         

        li t0,'w'
        beq t2,t0,CIMA2      

        li t0,'a'
        beq t2,t0,ESQ2      

        li t0,'s'
        beq t2,t0,BAIXO2      

        li t0,'d'
        beq t2,t0,DIR2
            

FIM2:        ret     
     
ESQ2:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)  
    
    
    la t0, CHAR_POS
    lh t1, 0(t0)            # carrega o x atual do personagem
    li t2, 0              # define o limite direito (320 - 16)
    ble t1, t2,ESQ_FIM2
    addi t1,t1,-20
    sh t1,0(t0)
    
    li t1,3
    la t0,CHAR_SENTIDO
    sb t1,0(t0)
    
    ret
    

DIR2:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 0(t0)            # carrega o x atual do personagem
    li t2, 210             # define o limite direito (320 - 16)
    bge t1, t2, DIR_FIM2    # se o x atual for maior ou igual ao limite direito, sai da função
    bnez s7,pula_parede2
    li t2,100
    bge t1,t2,DIR_FIM2
    
pula_parede2:
    addi t1, t1, 20         # incrementa 16 pixels
    sh t1, 0(t0)            # salva a nova posição do personagem
    
    li t1,1
    la t0,CHAR_SENTIDO
    sb t1,0(t0) 
    
    ret

CIMA2:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 2(t0)            # carrega o y atual do personagem
    li t2, 0                # define o limite superior (0)
    ble t1, t2,CIMA_FIM2    # se o y atual for menor ou igual ao limite superior, sai da função
    addi t1, t1, -20       # decrementa 16 pixels
    sh t1, 2(t0)            # salva a nova posição do personagem
    
    li t1,0
    la t0,CHAR_SENTIDO
    sb t1,0(t0) 
    
    ret

BAIXO2:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 2(t0)            # carrega o y atual do personagem
    li t2, 220              # define o limite inferior (240 - 16)
    bge t1, t2, BAIXO_FIM2    # se o y atual for maior ou igual ao limite inferior, sai da função
    addi t1, t1, 20         # incrementa 16 pixels
    sh t1, 2(t0)            # salva a nova posição do personagem
    	
    li t1,2
    la t0,CHAR_SENTIDO
    sb t1,0(t0)
    ret

ESQ_FIM2:
    ret

DIR_FIM2:
    ret

CIMA_FIM2:
    ret

BAIXO_FIM2:
    ret	
	
	
	
	
SETUP2:
    la a0,CHAR_POS
    li a1,0
    sh a1,0(a0)
    sh a1,2(a0)
    
    la a0,OLD_CHAR_POS
    li a1,0
    sh a1,0(a0)
    sh a1,2(a0)
    
    li a5,200
    
    la a0, map2_240      
    li a1, 0     #x          
    li a2, 0     #y       
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT 
    
   
    la a0,prota_esq
    li a1,0
    li a2,0
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
pulo:
    la a0, chave    
    li a1, 100   #x          
    li a2, 200    #y       
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT 
    
    la a0,zumbi
    li a1,80
    li a2,220
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    la a0,exit #trocar para exit
    li a1,200
    li a2,20
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
     li s7,0
    
 	la a0,pedra
 	li a1,120
 	li a2,0
 	li s10,0
 	li s11,230
PAREDE2:bge s10,s11 GAME_LOOP2
	mv a2,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,16
	j PAREDE2   
	
	
GAME_LOOP2:
	call KEY3
   	xori s0, s0, 1
   	
ATAQUE_ZUMBI:
	la a0,zumbi
    	li a1,80
    	li a2,220
    	li a3,0
    	call PRINT
    	li a3,1
    	call PRINT
    	
    	li t0,0
    	ble a5,t0,FIM_TIRO2
    	mv a4,a5
    	addi a5,a5,-20 #trocar para 20
    	
    	la a0,tiro_zumbi #sprite da bala(20x20)
    	li a1,80
    	mv a2,a5
    	li a3,0
    	call PRINT
    	li a3,1
    	call PRINT
    	
    	la a0,tile2
   	li a1,80
   	mv a2,a4
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   	j CHECK_COLISAO_TIRO2
   	
FIM_TIRO2:
	la a0,tile2
   	li a1,80
   	mv a2,a5
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   	
   	li a5,200

CHECK_COLISAO_TIRO2:
	la s0,CHAR_POS
	lh s1,0(s0)#s1 = x
	lh s2,2(s0)#s2 = y
	
	li t0,80
	bne s1,t0,CHECK_EXIT2
	
	sub s8,s2,a5
	call MODULO
	li t0,40
	bgt s8,t0,CHECK_EXIT2
	
	la a0,tile2
	li a1,80
	mv a2,a5
	li a3,0
	call PRINT
	li a3,1
	call PRINT
			
	li a5,200
	
	la s1,VIDA
	lb s2,0(s1)
	addi s2,s2,-1
	beqz s2,GAMEOVER
	sb s2,0(s1)
	li s1,1
	beq s2,s1,PRINT1_2
	
	la a0,dois
    	li a1,280
    	li a2,90
    	li a3,0
   	 call PRINT
    	li a3,1
    	call PRINT
    	j CHECK_EXIT2
PRINT1_2:
	la a0,um
   	li a1,280
    	li a2,90
   	li a3,0
    	call PRINT
    	li a3,1
    	call PRINT	
   	   	
CHECK_EXIT2:   	
   	la t0, CHAR_POS
	lh t1, 0(t0)  # x
    	li t2,200 # Posição x desejada
    	lh t3, 2(t0)  # y
    	li t4,20 # Posição y desejada
    	sub s8,t1,t2
    	call MODULO
    	li t0,16
    	bgt s8,t0,CHECK_CHAVE2
    	sub s8,t3,t4
    	call MODULO
    	bgt s8,t0,CHECK_CHAVE2
    	
 
   	li a0,60 #troca as notas por musica de mundanca de fase
    	li a1,1050
    	li a2,125
    	li a3,1000
   	li a7,31
   	ecall
	
	j SETUP3	
   			
   									
CHECK_CHAVE2:
    la t0, CHAR_POS
    lh t1, 0(t0)  # x
    li t2,100 # Posição x desejada
    lh t3, 2(t0)  # y
    li t4, 200  # Posição y desejada
   
   sub s8,t1,t2
   call MODULO
   li t0,16
   bgt s8,t0,CHAR2
   sub s8,t3,t4
   call MODULO
   bgt s8,t0,CHAR2
   bnez s7,CHAR2  

    li a0,60
    li a1,1050
    li a2,125
    li a3,1000
    li a7,31
    ecall
    
    li s7,1
    
    la a0,vinte
    li a1,288
    li a2,55
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    	la a0,tile2
 	li a1,120
 	li a2,0
 	li s10,0
 	li s11,230
LIMPA_PAREDE2:bge s10,s11 GAME_LOOP2
	mv a2,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,16
	j LIMPA_PAREDE2
	
   	
   	CHAR2:    	     
        la t0, CHAR_POS
        lh t1, 0(t0)
        lh t2, 2(t0)

        la t0, OLD_CHAR_POS
        lh t3, 0(t0)
        lh t4, 2(t0)

        beq t1, t3, CHECK_VERTICAL2
        blt t1, t3, CHAR_ESQ2
        beq t1, t3, CHAR_DIR2

CHECK_VERTICAL2:
        blt t2, t4, CHAR_CIMA2
        beq t2, t4, CHAR_BAIXO2

CHAR_ESQ2:
        la a0, prota_esq
        b CHAR_SPRITE_DONE2

CHAR_DIR2:
        la a0, prota_dir
        b CHAR_SPRITE_DONE2

CHAR_CIMA2:
        la a0, prota_cima2
        b CHAR_SPRITE_DONE2

CHAR_BAIXO2:
        la a0, prota_baixo

CHAR_SPRITE_DONE2:
        mv a1, t1
        mv a2, t2
        li a3,0
        call PRINT
        li a3,1
        call PRINT

        j LABEL2

LABEL2:
    li t0, 0xFF200604
    sw s0, 0(t0)

    la t0, OLD_CHAR_POS
    la a0, tile2
    lh a1, 0(t0)
    lh a2, 2(t0)
    mv a3, s0
   xori a3, a3, 1
   call PRINT

 j GAME_LOOP2

SETUP3:
	li s9,1
	li s7,0
	la a0,CHAR_POS
    	li a1,0
    	sh a1,0(a0)
    	sh a1,2(a0)
    
   la a0,OLD_CHAR_POS
    li a1,0
    sh a1,0(a0)
    sh a1,2(a0)



	la a0,map3
	li a1,0
	li a2,0
	li a3,0
	call PRINT
	li a3,1
	call PRINT

    la a0,prota_esq
    li a1,0
    li a2,0
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    la a0,tres
    li a1,280
    li a2,20
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
     la a0,chave
     li a1,80
     li a2,100
     li a3,0
     call PRINT 
     li a3,1
     call PRINT
     
    la a0, chave    
    li a1, 200   #x          
    li a2, 100    #y       
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT
    
    la s0,ZUMB_POS
    li t0,0
    sh t0,0(s0)
    li t0,0
    sh t0,2(s0)
    
    
    la a0, exit    
    li a1, 0   #x          
    li a2, 220    #y       
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT
    
	la a0,pedra
 	li a1,120
 	li a2,0
 	li s10,0
 	li s11,230
PAREDE3:bge s10,s11 teste
	mv a2,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,13
	j PAREDE3    
	    
teste:	la a0,pedra
 	li a1,0
 	li a2,120
 	li s10,0
 	li s11,230
PAREDE4: bge s10,s11 GAME_LOOP3
	mv a1,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,16
	j PAREDE4   
	                        

GAME_LOOP3:
	call KEY4

	li t1,1
	bne s7,t1,ATAQUE_ZUMBI3
MOV_ZUMBI3:
	la s0,ZUMB_POS
	la s1,CHAR_POS
	
	lh s2,0(s0)#s2 = x zumbi
	lh s3,2(s0)#s3 = y zumbi
	
	lh s4,0(s1)#s4 = x char
	lh s5,2(s1)#s5 = y char
	
	mv s10,s2
	mv s8,s3
	
horizontal3:
	beq s2,s4,vertical3	
	blt s2,s4,direita3
	esquerda3:
		addi s2,s2,-4
		j vertical3
	direita3:
		addi s2,s2,4
vertical3:
	beq s5,s3,print_zumbi3
	bgt s5,s3,descer3 #char>zumbi
	subir3:
	      addi s3,s3,-4
	      j print_zumbi3
	descer3:
	      addi s3,s3,4
print_zumbi3:
	sh s2,0(s0)
	sh s3,2(s0)
	
limpafantasma:       
       la a0,tile3
       mv a1,s10
       mv a2,s8
       li a3,1
       call PRINT 
       li a3,0
       call PRINT
       

	la a0,fantasma
	mv a1,s2
	mv a2,s3,
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	
COLISION_FANTASMA:
	la s0,ZUMB_POS
	la s1,CHAR_POS
	
	lh s2,0(s0)
	lh s3,2(s0)
	
	lh s4,0(s1)
	lh s5,2(s1)
	
	sub s8,s2,s4
	call MODULO
	li t2,16
	bgt s8,t2,ATAQUE_ZUMBI3
	sub s8,s3,s5
	bgt s8,t2,ATAQUE_ZUMBI3
	
	j DECREMENTO_VIDA
	
   
ATAQUE_ZUMBI3:
	li t2,2
	bne s7,t2,CHECK_CHAVE4
	
	la a0,zumbi
    	li a1,220
    	li a2,140
    	li a3,0
    	call PRINT
    	li a3,1
    	call PRINT
    	
    	li t0,0
    	ble a5,t0,FIM_TIRO3
    	mv a4,a5
    	addi a5,a5,-20 #trocar para 20
    	
    	la a0,tiro_zumbi #sprite da bala(20x20)
    	mv a1,a5
    	li a2,140
    	li a3,0
    	call PRINT
    	li a3,1
    	call PRINT
    	
    	la a0,tile3
   	mv a1,a4
   	li a2,140
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   	j CHECK_COLISION3
   	
FIM_TIRO3:
	la a0,tile3
   	mv a1,a5
   	li a2,140
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   	
   	li a5,220
   	
CHECK_COLISION3:
   	la s0,CHAR_POS
   	lh s1,0(s0)
   	lh s2,2(s0)
   	
   	#y bala = 140
   	#x bala = a5
   	li t1,140
   	bne s2,t1,CHECK_CHAVE4
   	
   	sub s8,s1,a5
   	call MODULO
   	li t1,16
   	bgt s8,t1,CHECK_CHAVE4
   	

DECREMENTO_VIDA:   	
	la s1,VIDA
	lb s2,0(s1)
	addi s2,s2,-1
	beqz s2,GAMEOVER
	sb s2,0(s1)
	li s1,1
	beq s2,s1,PRINT1_3
	
	la a0,dois
    	li a1,280
    	li a2,90
    	li a3,0
   	 call PRINT
    	li a3,1
    	call PRINT
    	j CHECK_CHAVE4
PRINT1_3:
	la a0,um
   	li a1,280
    	li a2,90
   	li a3,0
    	call PRINT
    	li a3,1
    	call PRINT
	
CHECK_CHAVE4:
	la s0,CHAR_POS
	lh s1,0(s0)
	lh s2,2(s0)
	
	li t2,200
	bne s1,t2,CHECK_CHAVE3
	li t2,100
	bne s2,t2,CHECK_CHAVE3
	li t2,2
	beq s7,t2,CHECK_EXIT3
	li s7,2
	
	 la a0,quarenta
    	 li a1,288
    	 li a2,55
    	li a3,0
    call PRINT
    li a3,1
    call PRINT
	
	li a0,60 #troca as notas por musica de mundanca de fase
    	li a1,1050
    	li a2,125
    	li a3,1000
   	li a7,31
   	ecall
   	
   	la s0,ZUMB_POS
   	li t0,200
   	lh t0,0(s0)
   	li t0,100
   	lh t0,2(s0)
   	
   	
   	
	la a0,tile_3_16
 	li a1,0
 	li a2,120
 	li s10,0
 	li s11,230
LIMPA_PAREDE4: bge s10,s11 CHECK_CHAVE3
	mv a1,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,16
	j LIMPA_PAREDE4 					
	

CHECK_CHAVE3:
	la s0,CHAR_POS
	lh s1,0(s0)
	lh s2,2(s0)
	
	li t2,80
	bne s1,t2,CHECK_EXIT3
	li t2,100
	bne s2,t2,CHECK_EXIT3
	bnez s7,CHECK_EXIT3
	

	
    li s7,1
    la a0,trinta
    li a1,288
    li a2,55
    li a3,0
    call PRINT
    li a3,1
    call PRINT
    
    	
	li a0,60 
    	li a1,1050
    	li a2,125
    	li a3,1000
   	li a7,31
   	ecall
	
	la a0,tile3
 	li a1,120
 	li a2,0
 	li s10,0
 	li s11,230
LIMPA_PAREDE3:bge s10,s11 print_meio
	mv a2,s10
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	addi s10,s10,16
	j LIMPA_PAREDE3	
	
print_meio:la a0,pedra
	li a1,120
	li a2,120
	li a3,0
	call PRINT
	li a3,1
	call PRINT
	la a0,pedra
	li a1,124
	li a2,120
	li a3,0
	call PRINT
	li a3,1
	call PRINT			

CHECK_EXIT3:
	la s0,CHAR_POS
	lh s1,0(s0)
	lh s2,2(s0)
	
	bnez s1,CHAR3
	li t2,220
	bne s2,t2,CHAR3
	
	li a0,60 #troca as notas por musica de mundanca de fase
    	li a1,1050
    	li a2,125
    	li a3,1000
   	li a7,31
   	ecall
   	
   	
   	la a0,vitoria
   	li a1,0
   	li a2,0
   	li a3,0
   	call PRINT
   	li a3,1
   	call PRINT
   	loop:call KEY4
   	j loop
   	
   fim3:li a7,10
   	ecall
CHAR3:   	  
    la t0, CHAR_POS
    lh t1, 0(t0)
    lh t2, 2(t0)

    la t0, OLD_CHAR_POS
    lh t3, 0(t0)
    lh t4, 2(t0)

    beq t1, t3, CHECK_VERTICAL3
    blt t1, t3, CHAR_ESQ3
    beq t1, t3, CHAR_DIR3

CHECK_VERTICAL3:
    blt t2, t4, CHAR_CIMA3
    beq t2, t4, CHAR_BAIXO3

CHAR_ESQ3:
    la a0, prota_esq
    b CHAR_SPRITE_DONE3

CHAR_DIR3:
    la a0, prota_dir
    b CHAR_SPRITE_DONE3

CHAR_CIMA3:
    la a0, prota_cima2
    b CHAR_SPRITE_DONE3

CHAR_BAIXO3:
    la a0, prota_baixo

CHAR_SPRITE_DONE3:
    mv a1, t1
    mv a2, t2
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT


    la t0, OLD_CHAR_POS
    la a0, tile3
    lh a1, 0(t0)
    lh a2, 2(t0)
    xori a3,a3,1
    call PRINT

LABEL3:
    li t0, 0xFF200604
    sw s0, 0(t0)

    la t0, OLD_CHAR_POS
    lh a1, 0(t0)
    lh a2, 2(t0)
    mv a3, s0
    xori a3, a3, 1
    call PRINT

j GAME_LOOP3



GAMEOVER:
    la a0, gameover     
    li a1, 0              
    li a2, 0            
    li a3, 0              
    call PRINT            
    li a3, 1               
    call PRINT  
   
   	la s0,NUM		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,NOTAS		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,1		# define o instrumento
	li a3,127		# define o volume

LOOP_MUSICA:beq t0,s1, FIM_MUSICA		# contador chegou no final? então  vá para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP_MUSICA			# volta ao loop
	
FIM_MUSICA:li a7,10
	ecall
	
	
KEY4:    li t1,0xFF200000       
        lw t0,0(t1)         
        andi t0,t0,0x0001       
        beq t0,zero,FIM3       
        lw t2,4(t1)         

        li t0,'w'
        beq t2,t0,CIMA3      

        li t0,'a'
        beq t2,t0,ESQ3      

        li t0,'s'
        beq t2,t0,BAIXO3      

        li t0,'d'
        beq t2,t0,DIR3
        
        li t0,'x'
        beq t2,t0,comeco
        
        li t0,'m'
        beq t2,t0,fim2
            

FIM3:        ret     
     
comeco:
	j SETUP
	ret     
     
fim2:
	j fim3     
     	ret
ESQ3:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)  
    
    
    la t0, CHAR_POS
    lh t1, 0(t0)            # carrega o x atual do personagem
    li t2, 0              # define o limite direito (320 - 16)
    ble t1, t2,ESQ_FIM3
    addi t1,t1,-20
    sh t1,0(t0)
    
    li t1,3
    la t0,CHAR_SENTIDO
    sb t1,0(t0)
    
    ret
    

DIR3:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 0(t0)            # carrega o x atual do personagem
    li t2, 210             # define o limite direito (320 - 16)
    bge t1, t2, DIR_FIM3    # se o x atual for maior ou igual ao limite direito, sai da função
    bnez s7,pula_parede3
    li t2,100
    bge t1,t2,DIR_FIM3
    
pula_parede3:
    addi t1, t1, 20         # incrementa 16 pixels
    sh t1, 0(t0)            # salva a nova posição do personagem
    
    li t1,1
    la t0,CHAR_SENTIDO
    sb t1,0(t0) 
    
    ret

CIMA3:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 2(t0)            # carrega o y atual do personagem
    li t2, 0                # define o limite superior (0)
    ble t1, t2,CIMA_FIM3    # se o y atual for menor ou igual ao limite superior, sai da função
    addi t1, t1, -20       # decrementa 16 pixels
    sh t1, 2(t0)            # salva a nova posição do personagem
    
    li t1,0
    la t0,CHAR_SENTIDO
    sb t1,0(t0) 
    
    ret

BAIXO3:
    la t0, CHAR_POS         # carrega em t0 o endereço de CHAR_POS
    la t1, OLD_CHAR_POS     # carrega em t1 o endereço de OLD_CHAR_POS
    lw t2, 0(t0)
    sw t2, 0(t1)            # salva a posição atual do personagem em OLD_CHAR_POS

    la t0, CHAR_POS
    lh t1, 2(t0)            # carrega o y atual do personagem
    li t2, 220              # define o limite inferior (240 - 16)
    bge t1, t2, BAIXO_FIM3    # se o y atual for maior ou igual ao limite inferior, sai da função
    li t2,2
    beq s7,t2,pula_parede4
    li t2,100
    bge t1,t2,BAIXO_FIM3
pula_parede4:addi t1, t1, 20         # incrementa 16 pixels
    sh t1, 2(t0)            # salva a nova posição do personagem
    	
    li t1,2
    la t0,CHAR_SENTIDO
    sb t1,0(t0)
    ret

ESQ_FIM3:
    ret

DIR_FIM3:
    ret

CIMA_FIM3:
    ret

BAIXO_FIM3:
    ret
    
  
