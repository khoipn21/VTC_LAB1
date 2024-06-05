;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Mon Apr 22 2024
; Processor: AT89C51
; Compiler:  ASEM-51 (Proteus)
;====================================================================

$NOMOD51
$INCLUDE (8051.MCU)

;====================================================================
; DEFINITIONS
;====================================================================

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      org   0000h
      ;Gán giá trị của MALED vào thanh ghi data pointer
            MOV DPTR, #MALED     

      LJmp   Start
      
            ;XỬ LÝ INTERRUPT NÚT TĂNG 1 GIÂY
      ORG 0003H
   CALL INCREASE
   RETI

      
;Xử lý interrupt của timer để khi cờ tràn TF0 lên mức high thì sẽ nhảy đến địa chỉ 000BH để xử lý(ngắt trong của 8051)
      ORG 000BH
   CALL CLEARTIMER
   RETI
   
        ;XỬ LÝ INTERRUPT NÚT GIẢM 1 GIÂY
      ORG 0013H
      DEC R6
      RETI

         ;DEC R6;GIẢM GIÁ TRỊ GIÂY  1 ĐƠN VỊ

ORG   0050H


 
      org   0100h
Start:	


   MOV TMOD,  #1B ;Chỉnh giá trị TMOD để sử dụng timer0
    SETB EA ;Bật global interrupt
   SETB ET0 ;Bật interrupt của timer0 để xử lý khi bộ đếm tràn
   SETB  EX0 ;Bật external interrupt0
   SETB  EX1;bật external interrupt1
   SETB IT0
   SETB IT1
   
   ;Set giá trị ban đầu của đồng hồ

    MOV R6, #0 ; Giá trị giây
   MOV R0, #0 ; GIá trị 1% giây
  
  
   CHECKTIME:
      ;Gán giá trị để đếm 10000 * 10 ^ -6 = 0.01 giây để đếm
   MOV TH0, #0DEH
   MOV TL0, #04FH
   SETB TR0 ;bắt đầu đếm

   CLOCK:
      ;Gán giá trị vào hàng chục của 1% giây
       MOV A, R0
       MOV B, #10
       DIV AB
       MOV P2, #11000100B
       MOVC  A, @A + DPTR
      MOV  P0,  A
      CALL DELAYSCAN
      
      ;Gán giá trị vào hàng đơn vị của 1% giây
      MOV P2, #11001000B
      MOV A, B
       MOVC  A, @A + DPTR
       ADD A, #10000000B
      MOV  P0,  A
      CALL DELAYSCAN
      
         ;Gán giá trị vào hàng chục của giây
       MOV A, R6
       MOV B, #10
       DIV AB
       MOV P2, #11000001B
       MOVC  A, @A + DPTR
      MOV  P0,  A
      CALL DELAYSCAN
      
;	Gán giá trị vào hàng đơn vị của  giây
      MOV P2, #11000010B
      MOV A, B
       MOVC  A, @A + DPTR
      ADD A, #10000000B
      MOV  P0,  A
      CALL DELAYSCAN
      
      ;kiểm tra xem nút pause/resume đã được nhấn chưa, 
      ;nếu đã nhấn thì đảo bit interrupt của timer0 để pause lại hoặc tiếp tục đếm
      MOV R5, P1
      CJNE R5, #00000000B, CONTINUE
      CPL ET0
      
      CONTINUE:
      

      
      

      CJNE R0, #100, CHECKTIME   ;Kiểm tra nếu mili giây = 1000 thì reset thành 0
      MOV R0, #0
      INC R6
      CJNE R6, #100, CHECKTIME   ;Kiểm tra nếu giây = 99 thì set giá trị thành 99.99 và tiếp tục quét led
      MOV R0, #99
      MOV R6, #99
      
      CPL ET0
      CLOCK2:
            ;Gán giá trị vào hàng chục của 1% giây
       MOV A, R0
       MOV B, #10
       DIV AB
       MOV P2, #11000100B
       MOVC  A, @A + DPTR
      MOV  P0,  A
      CALL DELAYSCAN
      
      ;Gán giá trị vào hàng đơn vị của 1% giây
      MOV P2, #11001000B
      MOV A, B
       MOVC  A, @A + DPTR
       ADD A, #10000000B
      MOV  P0,  A
      CALL DELAYSCAN
      
         ;Gán giá trị vào hàng chục của giây
       MOV A, R6
       MOV B, #10
       DIV AB
       MOV P2, #11000001B
       MOVC  A, @A + DPTR
      MOV  P0,  A
      CALL DELAYSCAN
      
;	Gán giá trị vào hàng đơn vị của  giây
      MOV P2, #11000010B
      MOV A, B
       MOVC  A, @A + DPTR
      ADD A, #10000000B
      MOV  P0,  A
      CALL DELAYSCAN
      
   JMP CLOCK2

      

   org 0300h
   
   ;Mã led của 7 segment display để hiển thị từ số 0-9
         MALED:
   DB 0C0H, 0F9H, 0A4H, 0B0H, 99H, 92H, 82H, 0F8H, 80H, 90H
   
   ;Hàm  delay ngắn để quét led
DELAYSCAN:
   MOV R2, #20
AGAINSCAN:
   MOV R1, #250
NEXTSCAN:
   DJNZ R1, NEXTSCAN
   DJNZ R2, AGAINSCAN
   
   RET
   

         CLEARTIMER:

   CLR TR0 ;Clear cờ đếm của timer0
   CLR TF0 ;Clear cờ tràn của timer0
   INC R0 ;  Tăng lên 0.01 giây
   CJNE R0, #100, CONTINUETIMER
   RETI
   ;Gán giá trị để đếm 10000 * 10 ^ -6 = 0.01 giây để đếm
   CONTINUETIMER:
   MOV TH0, #0DEH
   MOV TL0, #04FH
   SETB TR0 
   RETI ; Trả lại ctrinh cho program


   INCREASE:
         INC R6;TĂNG GIÁ TRỊ GIÂY LÊN 1
      RET    
      
   

     
      END