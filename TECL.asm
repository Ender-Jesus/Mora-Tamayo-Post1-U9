[BITS 16]
[ORG 0x100]

start:
 CLI                ; <-- NUEVO: Deshabilita interrupciones de la BIOS
 
.poll:
 IN AL, 64h         ; leer registro de estado del 8042 [cite: 214]
 TEST AL, 01h       ; comprobar bit OBF [cite: 214]
 JZ .poll           ; si OBF=0, no hay dato listo — repetir [cite: 215]
 
 IN AL, 60h         ; leer scancode del Data Port [cite: 217]
 MOV BL, AL         ; guardar scancode en BL [cite: 218]
 
 STI                ; <-- NUEVO: Vuelve a habilitar interrupciones antes de usar DOS
 
 ; Mostrar scancode en pantalla (conversión hex manual)
 MOV AH, 02h        ; función DOS: imprimir carácter [cite: 221]
 ; ... (resto de tu código exactamente igual)
 MOV DL, BL
 SHR DL, 4 ; nibble alto
 ADD DL, 30h
 CMP DL, 3Ah
 JL .printH
 ADD DL, 07h ; ajuste A–F
.printH:
 INT 21h
 MOV DL, BL
 AND DL, 0Fh ; nibble bajo
 ADD DL, 30h
 CMP DL, 3Ah
 JL .printL
 ADD DL, 07h
.printL:
 INT 21h
 MOV AH, 02h
 MOV DL, 0Dh ; CR
 INT 21h
 MOV DL, 0Ah ; LF
 INT 21h
 MOV AH, 4Ch
 INT 21h ; terminar programa
