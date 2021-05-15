borrar_pantalla MACRO
   ;borra pantalla
    MOV ah,0
    MOV al, 03h
    INT 0x10     
    
    MOV AH,06H  
    MOV AL,0
    MOV CX,0000H
    MOV  DX,184FH
    MOV BH, 00011111B
    INT 10H 
ENDM
CopiarAlVector MACRO exponenteV,mantisaV
   LOCAL copiar_exponente  
   LOCAL copiar_mantisa
   LOCAL cop_mant
   LOCAL retorna
   
   XOR SI,SI
   XOR DI,DI       
   XOR AX,AX
   MOV AL,signo
   MOV formato[SI],AL
   INC SI
copiar_exponente:               
   CMP exponenteV[DI],'$'
   JE  copiar_mantisa
   MOV AL,exponenteV[DI]
   MOV formato[SI],AL  
   INC SI
   INC DI
   JMP copiar_exponente
   
copiar_mantisa: 
   XOR DI,DI
cop_mant:   
   CMP mantisaV[DI],'$'
   JE  retorna
   MOV AL,mantisaV[DI]
   MOV formato[SI],AL
   INC SI
   INC DI
   JMP cop_mant   
retorna:        
ENDM
toFormatoHexadecimal macro
    LOCAL copiar
    LOCAL seguir
    LOCAL toHexadecimal
    LOCAL fin
    imprimir_xy msj4,2,6                        
    XOR SI,SI
    XOR DI,DI
copiar:   
    CMP formato[SI],'$'
    JE  fin
    CMP numHex[DI],'$'
    JE  toHexadecimal
    MOV AL,formato[SI]
    MOV numHex[DI],AL
seguir:
    INC SI
    INC DI
    JMP copiar;estaba loop   
    
toHexadecimal:   
    MOV auxPuntero,SI
    
    toHex numHex
    imprimir  numeroH
    MOV SI, auxPuntero
    MOV DI,-1 
    DEC SI
    jmp seguir    
    JMP fin 
fin: 
    toHex numHex
    imprimir  numeroH  
    salto_linea
  
ENDM

tocadenaDecimal MACRO entero, decimal, unidades,decenas,centenas, decimas, centesimass, signoori,signocopia
    LOCAL negativo
    LOCAL seguir
    MOV Al,signoori   
    CMP AL,'0'
    JNE negativo
    MOV signocopia,'+'
    JMP seguir
negativo:    
    MOV signocopia,'-'
seguir:    
    XOR AX,AX
    XOR DX,DX
    XOR BX,BX
    
    MOV AX,entero
    MOV BX,000Ah
    DIV BX  
    ADD unidades,DL; recupero unidades
    DIV BL
    ADD decenas,AH
    XOR AH,AH ; BORRAMOS
    DIV BL
    add centenas,Ah
    
    XOR AX,AX
    
    MOV AX, decimal
    MOV Bl,000AH
    DIV Bl
    ADD centesimass,AH
    ADD decimas,AL
    
    
ENDM
suma MACRO  
   LOCAL suma0 
   LOCAL sumaa0
   LOCAL noes0
   LOCAL terminar 
   LOCAL sumar_enteros
   LOCAL ponernegativo
   LOCAL sigue
   LOCAL ponernegativo2
   LOCAL sigue2    
   LOCAL desbordenegativo
   LOCAL desbordepositivo
   LOCAL borrow
   LOCAL negativos2
   LOCAL aqui2     
   LOCAL desbordee
   LOCAL restarsuma
   LOCAL restaacero
   LOCAL restanegativos
   LOCAL aqui
   LOCAL obtenersigno_decimales
   LOCAL cambiarsigno        
   local signosdif
   MOV signodecimal,'0'
   MOV AX, entero2
   MOV BX, decimal2
   OR  BX,AX
   CMP BX,00d
   JE  suma0
    
   MOV AX,entero
   MOV bx,decimal
   OR  BX,AX
   CMP BX,00h
   JE  sumaa0
   CMP signo,'1'
   JE  ponernegativo
   MOV auxsigno,1d  
   jmp sigue
ponernegativo:
   MOV auxsigno,-1d
sigue:
   CMP signoB,'1'
   JE  ponernegativo2
   MOV auxsigno2,1d  
   jmp sigue2
ponernegativo2:
   MOV auxsigno2,-1d
sigue2:          
   XOR DX,DX
   XOR AX,AX
   MOV AX,ENTERO
   IMUL auxsigno 
   MOV entero,AX
   XOR DX,DX
   XOR AX,AX 
   MOV AX,decimal
   IMUL auxsigno
   MOV  decimal,AX
   XOR AX,AX
   XOR DX,DX
   MOV AX,entero2
   IMUL auxsigno2
  
   MOV entero2,AX
   XOR AX,AX
   XOR DX,DX
   MOV AX,decimal2
   IMUL auxsigno2
   MOV decimal2,AX 
    
   MOV AX,DECIMAL2
   ADD decimal,AX; Suma decimales

   
   CMP decimal,-100D
   JLE desbordenegativo
   CMP decimal,-1
   JLE borrow
   CMP decimal,100D
   JAE desbordepositivo
   
   MOV AX,auxsigno2
   CMP auxsigno,AX
   JE  negativos2  
   CMP decimal,00h
   JE  sumar_enteros
   
   CMP ax,auxsigno
   JNE SIGNOSdif
  
   ;ES CERO
   jmp sumar_enteros        
signosdif:   
   CMP entero,00
   JE  restaacero  
   MOV AX,entero
   MOV BX,entero2 
   ADD AX,BX
   CMP AX,00H
   JGe  sumar_enteros
   INC entero        
   MOV signodecimal,'1'
   MOV AX,100d
   SUB AX,decimal
   MOV decimal,AX
   jmp sumar_enteros   
desbordenegativo: 
   DEC entero;****************** 
   NEG decimal;ya que sale negativo
   SUB decimal,100d    
   jmp sumar_enteros  
   MOV signo,31h            
desbordepositivo:
   SUB decimal,100d
   INC entero
   jmp sumar_enteros 
borrow:
  
   MOV AX,auxsigno2 
   CMP auxsigno,AX      ;INTERCAMBIEE
   JE restanegativos  
   CMP auxsigno,AX    ;AQUII
   JNE  negativos2    
aqui2:
   CMP entero,00
   JE  restaacero  
   CMP decimal,-100
   JLE desbordee   
   CMP decimal,00d
   jge sumar_enteros  ;AVER  
   MOV AX,entero2
   MOV BX,entero
   ADD BX,AX
   CMP BX, 00h
   JG desbordee
   MOV signodecimal,31h
   NEG decimal
   jmp sumar_enteros
desbordee:
   DEC entero
   MOV AX,100d
   ADD AX,decimal
   MOV decimal,AX
   jmp sumar_enteros
restaacero: 
   mov signo,'0'  
   CMP entero2,0
   JG restarsuma 
   CMP decimal,00
   JGE terminar
   NEG decimal
   MOV AX,entero2
   NEG AX
   MOV entero,AX
   MOV signo,'1'
   jmp terminar  
restarsuma: 
   MOV AX,entero2
   MOV signo,30h
   ADD entero,ax
   CMP decimal,00d
   JG  terminar
   DEC entero
   MOV AX,100d
   ADD AX,decimal
   MOV decimal,AX
   jmp terminar   
restanegativos:
   NEG decimal
   MOV signo,'1' 
   MOV signodecimal,'1'
sumar_enteros:
   MOV AX,entero2
   ADD entero,AX
   
   CMP entero,-1
   JLE cambiarsigno  
   CMP entero,00h
   JE  obtenersigno_decimales 
   MOV signo,30h
   jmp terminar   
negativos2:  
   CMP auxsigno,1
   JL  aqui
   JMP aqui2
aqui: 
   CMP decimal,00
   JL  aqui2
   CMP decimal,00h
   JE  sumar_enteros   
   CMP decimal,00
   JGE sumar_enteros
   INC entero
   MOV AX,100d
   SUB AX,decimal
   MOV decimal,AX
   jmp sumar_enteros
cambiarsigno:
   NEG entero
   MOV signo,31h
   JMP terminar
obtenersigno_decimales: 
    MOV Al,signodecimal 
    MOV signo,al
    JMP terminar
sumaa0:
    MOV AX,entero2
    MOV bx,decimal2
    MOV entero,AX
    MOV decimal,BX
    MOV AL,signob
    MOV signo,AL   
suma0:
terminar:
   
endm
resta MACRO  
   LOCAL ponernegativo  
   LOCAL ponernegativo2
   LOCAL terminar
   LOCAL desbordenegativo 
   LOCAL desbordepositivo  
   LOCAL borrow       
   LOCAL aqui
   LOCAL aqui2      
    LOCAL aqui3
   LOCAL negativos2 
   local sigue2_2
   LOCAL resta0  
   LOCAL sigue3
   LOCAL noes0     
   LOCAL obtenersigno_decimales
   MOV AX,entero2
   MOV BX,decimal2  
   MOV signodecimal,'0'
   OR  BX,AX
   CMP BX,0
   JE  resta0
   JMP noes0
resta0:
   jmp terminar
noes0:      
   CMP signo,'1'
   JE  ponernegativo
   MOV auxsigno,1d  
   jmp sigue
ponernegativo:
   MOV auxsigno,-1d
sigue:
   CMP signoB,'1'
   JE  ponernegativo2
   MOV auxsigno2,1d  
   jmp sigue2
ponernegativo2:
   MOV auxsigno2,-1d
sigue2:          
   XOR DX,DX
   XOR AX,AX
   MOV AX,ENTERO
   IMUL auxsigno 
   MOV entero,AX
   XOR DX,DX
   XOR AX,AX 
   MOV AX,decimal
   IMUL auxsigno
   MOV  decimal,AX 
   
   XOR AX,AX
   XOR DX,DX
   MOV AX,entero2
   IMUL auxsigno2
  
   MOV entero2,AX
   XOR AX,AX
   XOR DX,DX
   MOV AX,decimal2
   IMUL auxsigno2
   MOV decimal2,AX
                    
  
                    
   MOV AX,entero2   
   CMP entero,AX
   JL  cambiar_orden
   jmp sigue3
cambiar_orden:
   MOV AX,entero2
   MOV BX,entero
   MOV entero,AX
   MOV entero2,BX
   
   MOV AX,decimal2
   MOV BX,decimal
   MOV decimal,AX
   MOV decimal2,BX
   
   MOV AL,signo
   MOV AH,signob
   MOV signob,al
   MOV signo,AH
   
   CMP signo,'1'
   JE  ponersignoPositivo;(por ley de signos)
   ;NEG entero
   ;NEG decimal
   MOV signo,'1'
   JMP sigue2_1
ponersignoPositivo:  
   MOV signo,'0'
   NEG entero 
   NEG decimal
sigue2_1:
   CMP signoB,'1'
   JNE sigue2_2
   NEG decimal2
   NEG entero2
sigue2_2:   
   suma 
   jmp terminar
  
   
   
sigue3:    
   MOV AX,DECIMAL2
   SUB decimal,AX
   CMP decimal,-100D
   JLE desbordenegativo
   CMP decimal,-1
   JLE borrow
   CMP decimal,100D
   JAE desbordepositivo
   
   MOV AX,auxsigno2
   CMP auxsigno,AX
   JE  negativos2
   ;ES CERO
   jmp restar_enteros
   
desbordenegativo:
   DEC entero;****************** 
   NEG decimal;ya que sale negativo
   SUB decimal,100d    
   jmp restar_enteros  
   MOV signo,31h
desbordepositivo:
   SUB decimal,100d
   INC entero
   jmp restar_enteros
borrow:    
   MOV AX,auxsigno2 
   CMP auxsigno,AX
   JNE restanegativos  
   CMP auxsigno,AX
   JE  negativos2
aqui2:
   CMP entero,00
   JE  restaacero  
   CMP decimal,-100
   JLE desbordee  
   MOV AX,entero2
   cmp ax,-1
   JG  siguee
   NEG AX
siguee:
   MOV BX,entero
   cmp BX,-1
   JG  siguee2
   neg BX
siguee2:   
   CMP ax,bx  
   JG  aqui   
   
   
aqui3:
   CMP decimal,00d
   jge restar_enteros  ;AVER  
   MOV AX,entero2
   MOV BX,entero
   SUB BX,AX
   CMP BX, 00h
   JG  desbordee
   MOV signodecimal,31h
   NEG decimal
   jmp restar_enteros
desbordee:
   DEC entero
   MOV AX,100d
   ADD AX,decimal
   MOV decimal,AX
   jmp restar_enteros
restaacero:     ;chequeo
    mov signo,'0'  
   CMP entero2,-1
   JLE restarsuma  ;umm
   CMP decimal,00
   JGE terminar
   NEG decimal
   MOV AX,entero2
   MOV entero,AX
   MOV signo,'1'
   jmp terminar  

restarsuma: 
   MOV AX,entero2
   MOV signo,30h
   sub entero,ax
   DEC entero
   MOV AX,100d
   ADD AX,decimal
   MOV decimal,AX
   jmp terminar   
restanegativos:
   NEG decimal
   MOV signo,'1'
   MOV signodecimal,'1'
restar_enteros:
   MOV AX,entero2
   SUB entero,AX
   
   CMP entero,-1
   JLE cambiarsigno  
   CMP entero,00h
   JE  obtenersigno_decimales 
   MOV signo,30h
   jmp terminar   
negativos2:  
   CMP auxsigno,1
   JL  aqui
   JMP aqui2
aqui:  
   CMP auxsigno,1
   JGE  aqui3
   CMP decimal,00
   JL  aqui2
   CMP decimal,00h
   JE  restar_enteros   
   ;CMP decimal,00
   ;JGE  restar_enteros
   MOV AX,entero
   MOV BX,entero2
   CMP ax,bx
   JGE  restar_enteros    ;le movi aqui jaja DIOS
   MOV signodecimal,'1'
   INC entero
   MOV AX,100d
   SUB AX,decimal
   MOV decimal,AX
   jmp restar_enteros
cambiarsigno:
   NEG entero
   MOV signo,31h
   JMP terminar
obtenersigno_decimales: 
    MOV Al,signodecimal 
    MOV signo,al
terminar:
    
ENDM    
separar MACRO   numeroCompleto
    LOCAL copiarEntero    
    LOCAL copiarDecimales
    MOV SI,03d        
    XOR DI,DI
    ;pasamos la parte entera al vector numEnt
    copiarEntero:
        MOV AL,numeroCompleto[SI]
        MOV numEnt[DI],AL
        INC SI           
        INC DI
        CMP numeroCompleto[SI],'.'
        JNE copiarEntero
    ;pasamos la parte decimal al vector numDec
        INC SI; se quedaria en la posicion del punto, asi que se le suma 1    
        XOR DI,DI
    copiarDecimales:                                                          
        MOV AL,numeroCompleto[SI]
        MOV numDec[DI],AL
        INC SI
        INC DI
        CMP numeroCompleto[SI],13d; retorno de carro
        JNE copiarDecimales  
        
ENDM
comprobar_formato MACRO cadena, signo
    LOCAL flag  
    LOCAL regresar
    XOR SI,SI
    MOV flagFormato,00H
    
    CMP cadena[SI+1],07d
    JNE flag
    CMP cadena[SI+6],'.'
    JNE flag 
    ;paso prueba, formato correcto
    CMP cadena[SI+2],'+'
    JE  regresar
    ADD signo,01d         
    jmp regresar
    
flag:
   MOV flagFormato,01h    
   
regresar:
      
ENDM
comprobar_operador MACRO operador
    LOCAL termonar
    MOV flagFormato,00h
    CMP operador,'+'
    JE  terminar
    CMP operador,'-'
    JE  terminar
    MOV flagFormato,01h
terminar:
ENDM     
obtener_numero MACRO lugar
            
    MOV AH, 0AH
    MOV DX, OFFSET lugar
    INT 21H  
             
ENDM
pedirChar MACRO lugar
    MOV AH,01H
    INT 21H
    MOV lugar,AL
ENDM     
toHex   MACRO numeroHex  
    LOCAL conver  
    LOCAL   esmayor10
    LOCAL   final
    xor si,si
    mov cx,0004H                   ;VALEN
    MOV numeroH,00H                ;8|4|2|1
    MOV multi,08d   ;POR POSICIONES 1|1|1|1
conver:
    MOV AL,numeroHex[SI]
    SUB AL,30H
    MUL multi
    ADD AL,numeroH   
    MOV numeroH,AL
    XOR AX,AX
    MOV AL,multi
    DIV dos
    MOV multi,al
    XOR AX,AX
    INC SI
    LOOP conver
    
    CMP numeroH,10d
    JAE esmayor10
    ADD numeroH,30H
    JMP final
    
esmayor10:
   ADD numeroH,55d
   
final:
    
ENDM    
    
salto_linea MACRO
    MOV AH,09H
    MOV DX, OFFSET salto
    INT 21H 
ENDM  
imprimir_xy MACRO cadena, x,y
    MOV AH,02H
    MOV BH,00H
    MOV DH,Y
    MOV DL,X   
    INT 10H
    imprimir cadena  
ENDM
imprimir MACRO cadena
    MOV AH,09H
    MOV DX, OFFSET cadena
    INT 21H 
ENDM       
;RECUPERA DE CADENA A DECIMAL | 
recuperar MACRO num,tam 
    LOCAL ciclo
    MOV AUX,00H
    XOR SI, SI
    MOV DI, 00H  
    XOR BX,BX
 ciclo:        
    INC AUX
    MOV AL,num[SI]
    SUB AL,30H      
    MUL var
    MOV vectAux[DI],AX
    ADD BX,vectAux[DI]
    XOR AH,AH;limpiamos AH
    INC DI
    INC DI
    MOV AL, var
    DIV var1
    MOV var,AL 
    INC SI
    CMP aux,tam;FIN
    JNE ciclo       
    
    MOV AX,BX
    XOR DX,DX    
    MOV var,100d
    MOV var1,10d

ENDM  
;PASA A BINARIO LA PARTE DECIMAL 
tobinDec macro num 
    MOV AUX,02d 
    XOR DX,DX
    MOV SI,00h
    MOV AX,num
transformar:
    MUL AUX
    CMP AX,100d
    JAE  Poner1
    MOV binDec[SI],'0'
cont:
    INC SI
    CMP AL,00d
    JE  regresa
    CMP SI,33d 
    JNE transformar
    JMP regresa     

    
poner1:
    MOV binDec[SI],'1'  
    sub AX,100d
    jmp cont
       
    regresa:
ENDM 

;OBTIENE LA MANTISA Y EL EXPONENTE         
obtener_mantisa MACRO 
       
    LOCAL for 
    LOCAL continuar_decimales 
    MOV expd,136d  
    XOR SI,SI
    XOR DI,DI         
    MOV AL,signo
    MOV todo[DI],AL  ;EN TODO SE COPIA EL SIGNO,ENTERO Y DECIMALES
    INC DI
    XOR AL,AL
copyEnteros:      
    MOV AL,binario[SI]
    MOV todo[DI],AL
    INC SI
    INC DI
    CMP binario[SI],'$'
    JE  copyDecimales 
    JMP copyEnteros  
    
copyDecimales:
    
    XOR SI,SI
copyDec:
    
    MOV AL,binDec[SI]
    MOV todo[DI],AL
    INC SI
    INC DI
    CMP todo[DI],'$'
    JE  obtener_exponente 
    JMP copyDec
                         
obtener_exponente:
    XOR DI,DI 
    INC DI 
    ;BUSCA EL UNO MAS SIGNIFICATIVO
obt_exp:    
    CMP expd,103d
    JB  escero
    CMP todo[DI],'1'
    JE  encontrado
    DEC expd
    INC DI
    JMP obt_exp                         
encontrado: 
    toBinary expd,  exponente, 7  
    
    XOR SI,SI
    INC DI     ;UNA VEZ ENCONTRADO EL 1 MAS SIGNIFATIVO
Omantisa:      ;SE PARTE DE LA SIGUIENTE POSICION Y SE TOMAN 23 TERMINOS COMO MANTISA
    MOV AL,todo[DI]
    MOV mantisa[SI],AL
    CMP DI,42d
    JE  terminado
    CMP mantisa[SI+1],'$'
    JE  terminado
    INC SI
    INC DI
    JMP Omantisa 
           
escero:  

terminado:
   
ENDM
            ;numero a transformar | lugar | tamanio
toBinary macro num, lugar, tam 
    LOCAL transforma 
    XOR DX,DX
    MOV SI,tam
    MOV AX,num
transforma:
    DIV var2
    ADD DL,30H
    MOV lugar[SI],DL
    XOR DX,DX
    DEC SI
    CMP SI,00H 
    JNE transforma
    ADD AL,30H
    MOV lugar[SI],AL     
   
ENDM  
.MODEL SMALL
   
.STACK
;Segmento de pila

.DATA
;Segmento de datos
        salto       DB  '',0DH,0AH,'$'   
        msj         DB  '********** CALCULADORA FORMATO IEEE 754 **********','$' 
        msj1        DB  'Ingresa el operando #1 (',241d,'000.00/',241d,'999.99): ','$'
        numCom      DB  8,?,8 DUP (?);'$' 
        numCom2     DB  8,?,8 DUP (?)
        numEnt      DB  3 DUP('0');aqui copiaremos parte entera
        numDec      DB  2 DUP('0');aqui copiaremos parte decimal      
        signo       Db  '0','$'    
        signoB      Db  '0','$'            
        vectAux     DW  3 DUP('0');aqui pondre los resultados de convertir a cen dec uni
        aux         DB  ?    ; para ciclo en recuperar
        var         DB  100d    
        var1        DB  10d
        entero      DW  00h; aqui guardaremos la parte entera
        decimal     DW  00h;aqui guardaremos la parte decimal  
        entero2      DW  00h; aqui guardaremos la parte entera
        decimal2     DW  00h;aqui guardaremos la parte decimal                           
        var2        DW  02h; para dividir entre 2                             
        binario     DB  10 DUP("0"),'$' 
        binDec      DB  33 DUP("0"),'$'  
        mantisa     DB  23 DUP("0"),'$'
        exponente   DB  8 DUP("0"),'$'      
        expd        DW  ? 
        tamdecimal  DW  22d     
        todo        DB  43 DUP("0"),'$'  
        msj2        DB  'El numero ingresado es el 000.00','$' 
        msj3        DB  'S        Exponente                    Mantisa','$'
        multi       DB  8d
        numeroH     DB  0d,'$'  ;AQUI ESTARA EL NUMERO EN HEX
        numHex      DB  4 DUP('0'),'$'  
        dos         DB  2d  
        formato     DB  32 DUP('0'),'$'
        msj4        DB  "Formato Hexadecimal: ",'$'  
        
        msj6        DB  "Operacion (+ o -): ",'$'     
        msj7        DB  'Ingresa el operando #2 (',241d,'000.00/',241d,'999.99): ','$'    
        
        msj8        DB  "************ MENU FORMATO ************",'$'
        msj9        DB  "*     [1]Formato IEEE 754 SP BIN     *",'$'
        msjA        DB  "*     [2]Formato IEEE 754 SP HEX     *",'$'
        msjB        DB  "*     [3]Formato decimal             *",'$'
        msjC        DB  "**************************************",'$'
        msjD        DB  "Seleccione el formato a mostrar: [ ]",08h,08h,'$'
  
        resultadoEn DW  ?
        resultadoDe DW  ?
        flagFormato DB  00H 
        
        auxPuntero  dw  00H
        auxsigno    DW  01H
        auxsigno2   DW  01H  
        signodecimal DB 01h  
        
        mensaje     DB  "El resultado de: "
                
        signoUno    DB  30h    
        cent        DB  30h
        dece        DB  30h
        uni         DB  30h,'.'  
        decimas     DB  30h
        centesimas  DB  30h,' '
        operador    DB  ?,' '
        signoDos    DB  ?           
        centb       DB  30h
        deceb       DB  30h
        unib        DB  30h,'.'
        
        decimasb    DB  30h
        centesimasb DB  30h
        
        mensaje2    DB  " es: ",
        signoR      DB   ?,'$'   
                            
       
        centR       DB  30h
        deceR       DB  30h
        uniR        DB  30h,'.'
        decimasR    DB  30h
        centesimasR DB  30h,'$' 
        
        infinitoMen    DB "infinito",'$' 
        infinitoEx  DB "11111111",'$'            
.CODE
;Segmento de codigo

inicio:
    MOV AX,@DATA
    MOV DS,AX  
    ;Mi codigo
    
pedir:    
    
    borrar_pantalla
    
    ;mostramos mensaje 
    imprimir msj
           
    salto_linea     
    salto_linea     
    

pedir1ro:
    ;mostramos mensaje para obtener 1er numero
    imprimir msj1
    
    obtener_numero  numCom  ;obtener 1er operando
    salto_linea
    comprobar_formato numCom,signo                                                   
    CMP flagFormato,01h
    JE  pedir1ro
    
pedirOperador:                                                      
    imprimir msj6 ;mensaje operador    
    pedirChar operador ;pedir y almacenar operador
    comprobar_operador operador
    salto_linea      
    CMP flagFormato,01h
    JE  pedirOperador  
pedir2do:
    
    imprimir msj7    ;mensaje 2do perador
    
    obtener_numero  numCom2 ;obtener 2do operando
     salto_linea
    comprobar_formato numCom2,signoB
    CMP flagFormato,01h
    JE  pedir2do
    
    
    ;separa parte entera y decimal de lo obtenido DEL NUMERO1    
    separar numCom    
   
          
    recuperar numEnt, 3 ;obtiene valor base 10 decimal DEL 1ER numero
    MOV entero,BX 
    MOV VAR,10d   
    
    recuperar numDec, 2 ;obtiene valor del decimal en base 10 DEL 1ER numero
    MOV decimal,BX  
    
    ;separa parte entera y decimal de lo obtenido DEL NUMERO2  
    separar numCom2    
       
    recuperar numEnt, 3 ;obtiene valor base 10 decimal DEL 2DO numero
    MOV entero2,BX 
    MOV VAR,10d   
    
    recuperar numDec, 2 ;obtiene valor del decimal en base 10 DEL 2DO numero
    MOV decimal2,BX         
    
    tocadenaDecimal entero,decimal, uni,dece,cent,decimas,centesimas,signo, signoUno 
    tocadenaDecimal entero2,decimal2, uniB,deceb,centb,decimasb,centesimasb,signoB,signoDos
                    
    
    CMP operador,'-'
    JNE hacer_suma   
    resta; 
    JMP aa    
hacer_suma:
    suma;    
aa:

pedirForm:    
    borrar_pantalla
    
    imprimir msj8  
    salto_linea
    imprimir msj9
    salto_linea
    imprimir msjA
    salto_linea
    imprimir msjB
    salto_linea
    imprimir msjC
    salto_linea
    imprimir msjD
    pedirChar flagformato
    CMP flagFormato,'3'
    JA  pedirForm  
    CMP flagFormato,'1'
    JB  pedirForm
    
    CMP entero, 1000d
    JAE infinito 
    
    tobinary entero, binario,9d    
    tobinDec decimal          
    obtener_mantisa ;tambien se obtiene el exponente   
    CopiarAlVector exponente,mantisa 
     
    jmp imprimirformato
infinito:
    CopiarAlVector infinitoEx,mantisa
imprimirformato:
   
    borrar_pantalla
    tocadenaDecimal entero,decimal, uniR,deceR,centR,decimasR,centesimasR,signo,signoR   
    imprimir_xy mensaje,0,2  
    CMP entero,1000d
    JA  imprimirMensInfinitoo
    imprimir centR   
    JMP comparaFormato
imprimirMensInfinitoo:
    imprimir infinitoMen    
comparaFormato:
    salto_linea 

    CMP flagformato,'1'
    JNE formatoHexadecimal
   
    imprimir_xy msj3,2,5
  
    imprimir_xy signo,2,7
    CMP entero,1000d
    JAE imprimirExponenteInfi
    imprimir_xy exponente,11d,7
    jmp imprimirMantisa
ImprimirExponenteInfi:
    imprimir_xy infinitoEx,11d,7
imprimirMantisa:
    imprimir_xy mantisa,40d,7       
    JMP fin2  
                        
formatoHexadecimal:

    CMP flagFormato,'2'
    JNE formatoDecimal 
    toFormatoHexadecimal
    JMP fin2
          
formatoDecimal:   
fin2:
    salto_linea
    salto_linea
    MOV AH,4Ch            
    INT 21h
END inicio
END

