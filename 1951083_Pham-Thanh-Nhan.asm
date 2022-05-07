.ORIG x0500
;-----------------------------------------------------------
; CASE   Num1   Num2
; -2      -      -
; -1      +      +
; 0       -      +
; +1      +      -
;-----------------------------------------------------------
guide .stringz "THIS PROGRAM PERFORMS 6 OPERATIONS\nINPUT/OUTPUT RANGE: -32768..32767\n\n"
lea r0, guide
PUTS
txt1 .stringz "Input first number :  "
txt2 .stringz "Input second number:  "
;----------Init_case----------------------------------------
and r4, r4, #0
add r4, r4, #-1
st r4, CASE                     ;init CASE=-1, + +
;----------Input_n1-----------------------------------------
lea r0, txt1
PUTS
JSR INPUT_STRING_N1
JSR COPY_LEN
JSR RESET_R
ld r1, n1len
JSR STRING_TO_NUM
st r0, n1val
;----------Input_n2-----------------------------------------
lea r0, txt2
PUTS
JSR INPUT_STRING_N2
JSR COPY_LEN
JSR RESET_R
ld r1, n2len
JSR STRING_TO_NUM
st r0, n2val
;----------Update_case--------------------------------------
JSR COPY_CASE
ld r0, CASE
add r2, r0, #-2
BRnp SKIP_M_M                   ;skip minus r1 and minus r2
add r0, r0, #-4
st r0, CASE
SKIP_M_M
;----------ADD----------------------------------------------
JSR RESET_R
txt_add .stringz "\nR1 + R2  = "
lea r0, txt_add
PUTS
ld r1, n1val
ld r2, n2val
ld r0, CASE
	BRzp ADD_DIF_SIGN
add r3, r0, #2
	BRnp ADD_P_P
JSR PRINT_MINUS_SIGN

ADD_P_P
add r0, r1, r2
JSR NUM_TO_STRING
BR SUB

ADD_DIF_SIGN
not r2, r2
add r2, r2, #1
ld r0, CASE
BRp ADD_CASE_1

add r0, r1, r2                  ;R0 = R1 - R2
BRnz #1
JSR PRINT_MINUS_SIGN
add r0, r0, #0
BRp #2
not r0, r0
add r0, r0, #1
JSR NUM_TO_STRING
BR SUB

ADD_CASE_1
add r0, r1, r2
BRp #1
JSR PRINT_MINUS_SIGN
add r0, r0, #0
BRp #2
not r0, r0
add r0, r0, #1
JSR NUM_TO_STRING
BR SUB
;----------SUB-----------------------------------------------
n1len   .fill 0                 ;length of first number
n2len   .fill 0                 ;length of second number
SUB
JSR RESET_R
txt_sub .stringz "\nR1 - R2  = "
lea r0, txt_sub
PUTS
ld r1, n1val
ld r2, n2val
ld r0, CASE

BRzp ZP_CASE
not r2, r2
add r2, r2, #1
add r0, r0, #2
BRz M2_CASE
add r3, r1, r2
BRzp #3
not r3, r3
add r3, r3, #1
JSR PRINT_MINUS_SIGN
add r0, r3, #0
JSR NUM_TO_STRING
BR MUL

ZP_CASE
ld r0, CASE
BRp #1
JSR PRINT_MINUS_SIGN
add r0, r1, r2
JSR NUM_TO_STRING
BR MUL

M2_CASE
add r0, r1, r2
BRn #2
JSR PRINT_MINUS_SIGN
BR #2
not r0, r0
add r0, r0, #1
JSR NUM_TO_STRING
BR MUL
;----------MUL-----------------------------------------------
MUL
JSR RESET_R
txt_mul .stringz "\nR1 * R2  = "
lea r0, txt_mul
PUTS
ld r1, n1val
ld r2, n2val
ld r0, CASE
BRn MUL_SAME_SIGN
JSR PRINT_MINUS_SIGN
MUL_SAME_SIGN
JSR MULT
JSR NUM_TO_STRING
;----------DIV-----------------------------------------------
JSR RESET_R
txt_quo .stringz "\nR1 / R2  = "
txt_rem .stringz ", remainder = "
lea r0, txt_quo
PUTS
ld r1, n1val
ld r2, n2val
ld r0, CASE
BRn DIV_SAME_SIGN
add r3, r3, #1
add r4, r4, #-1
JSR PRINT_MINUS_SIGN
DIV_SAME_SIGN
JSR DIVN
ld r0, res_quo
add r0, r0, r3
JSR NUM_TO_STRING
lea r0, txt_rem
PUTS
ld r0, res_rem
add r0, r0, r4
JSR NUM_TO_STRING
BR #1
CASE .fill 0                 ;3 cases for n1 and n2, <=>0
;----------DIV_REAL------------------------------------------
JSR RESET_R
lea r0, txt_quo
PUTS
ld r0, CASE
BRn #1
JSR PRINT_MINUS_SIGN
ld r0, res_quo
JSR NUM_TO_STRING
ld r0, PAS
add r0, r0, #-2
sti r0, DDR

ld r6, PAS
ld r1, res_rem
and r2, r2, #0
add r2, r2, #10
JSR MULT
add r1, r0, #0
ld r2, n2val
JSR DIVN
ld r0, res_quo
add r6, r6, r0
sti r6, DDR

ld r6, PAS
ld r1, res_rem
and r2, r2, #0
add r2, r2, #10
JSR MULT
add r1, r0, #0
ld r2, n2val
JSR DIVN
ld r0, res_quo
add r6, r6, r0
sti r6, DDR
;----------SQRT----------------------------------------------
lea r0, txt_sqrt1
PUTS
ld r0, n1val
JSR SQRT
lea r0, txt_sqrt2
PUTS
ld r0, n2val
JSR SQRT
BR DONE_PROJECT
;------------------------------------------------------------
pminus  .fill x2D
n1val   .fill 0
n2val   .fill 0
res_quo .fill 0                 ;store quotient value
res_rem .fill 0                 ;store remainder value
txt_sqrt1 .stringz "\nSQRT |R1|~ "
txt_sqrt2 .stringz "\nSQRT |R2|~ "
DONE_PROJECT
HALT
;-----COPY_CASE----------------------------------------------
COPY_CASE
st r7, saveR7
	ld r1, CASE
	ld r2, CASE_2
	add r1, r1, r2
	st r1, CASE
ld r7, saveR7
RET
;-----COPY_LEN_----------------------------------------------
COPY_LEN
st r7, saveR7
	ld r1, len1
	st r1, n1len
	ld r1, len2
	st r1, n2len
ld r7, saveR7
RET
;------------------------------------------------------------
STRING_TO_NUM                   ;input R1 for length
st r7, saveR7_strn              ;return value to R0
	add r6, r1, #0
	ld r4, string
	add r4, r4, r1
	add r4, r4, #-1
	lea r5, mult10
	CONVERT
	ldr r2, r4, #0    
        ldr r1, r5, #0          ;load r1 from mult10
	JSR MULT                ;R0 = R1 * R2
	add r3, r3, r0
	add r4, r4, #-1
	add r5, r5, #1          ;next 10 in mult10
	add r6, r6, #-1
	BRp CONVERT
add r0, r3, #0
ld r7, saveR7_strn
RET
;------------------------------------------------------------
PRINT_MINUS_SIGN
st r7, saveR7
st r0, saveR0
	ld r0, pminus
	sti r0, DDR
ld r0, saveR0
ld r7, saveR7
RET
;------------------------------------------------------------
NUM_TO_STRING                   ;return value to string                 
st r7, saveR7_nstr              ;input R0
st r4, saveR4

and r1, r1, #0
and r2, r2, #0
and r5, r5, #0
add r5, r5, #9
ld r6, numstr
CLEAR_STRING
str r1, r6, #0                  ;Set 0 to string location
add r6, r6, #1
add r5, r5, #-1
BRp CLEAR_STRING

and r5, r5, #0
add r5, r5, #5
ld r4, PAS
ld r6, numstr
add r6, r6, #4
CONVERT_TO_CHAR
JSR DIVI
add r2, r2, r4
str r2, r6, #0
add r0, r1, #0
add r6, r6, #-1
add r5, r5, #-1
BRp CONVERT_TO_CHAR

and r5, r5, #0
add r5, r5, #5
ld r6, numstr
PRINT
ldr r1, r6, #0
sti r1, DDR
add r6, r6, #1
add r5, r5, #-1
BRp PRINT

ld r4, saveR4
ld r7, saveR7_nstr
RET
;-----------------------------------------------------------
CHECK_MINUS_SIGN                ;input R0
st r7, saveR7_sign              ;return R1=0 if number
st r3, saveR3
	and r1, r1, #0
	add r1, r1, #-16
	ld r3, minus
	add r3, r0, r3
	BRz MINUS_SIGN
	and r1, r1, #0
MINUS_SIGN
ld r3, saveR3
ld r7, saveR7_sign
RET
CASE_2  .fill 0
;-----------------------------------------------------------
MULT                             ;R0=R1*R2
st r7, saveR7_mult
st r1, saveR1
st r2, saveR2
and r0, r0, #0
add r1, r1, #0
BRz TER_BY_0
add r2, r2, #0
BRz TER_BY_0
	MULTIPLY
	add r0, r0, r1
	add r2, r2, #-1
	BRp MULTIPLY
TER_BY_0
ld r1, saveR1
ld r2, saveR2
ld r7, saveR7_mult
RET
;-----------------------------------------------------------
DIVI                              ;in R0, out Q-R1, R-R2
st r7, saveR7_divi
	and r1, r1, #0            ;reset R1, use as Q
	and r2, r2, #0            ;reset R2, use as R

	DIV_10
	add r1, r1, #1
	add r0, r0, #-10
	BRzp DIV_10
	add r1, r1, #-1
	add r2, r0, #10
st r1, saveR1
st r2, saveR2
ld r7, saveR7_divi
RET
;-----------------------------------------------------------
DIVN                              ;in R1/R2, out res_quo, res_rem
st r7, saveR7_divn
st r1, saveR1
st r2, saveR2
st r3, saveR3
st r4, saveR4
	and r3, r3, #0            ;reset R3, use as Q
	and r4, r4, #0            ;reset R4, use as R
	not r2, r2
	add r2, r2, #1
	DIV_N
	add r3, r3, #1
	add r1, r1, r2
	BRzp DIV_N
	add r3, r3, #-1
	not r2, r2
	add r2, r2, #1
	add r4, r1, r2
st r3, res_quo
st r4, res_rem
ld r1, saveR1
ld r2, saveR2
ld r3, saveR3
ld r4, saveR4
ld r7, saveR7_divn
RET
;-----------------------------------------------------------
hund .fill #100
sr0  .fill 0
sr1  .fill 0
SQRT
st r7, saveR7                    ;input R0
	st r0, sr0
	not r6, r0               ;copy input to -R6
	add r6, r6, #1

	and r1, r1, #0
	and r2, r2, #0
	FIND_LIM
	add r1, r1, #1
	add r2, r2, #1
	JSR MULT
	add r5, r0, r6          ;R5 = R0 - R6
	BRz TRUE_SQRT
	BRn FIND_LIM
st r1, sr1
add r0, r1, #-1
JSR NUM_TO_STRING

ld r0, PAS
add r0, r0, #-2                 ;print dot.
sti r0, DDR
ld r1, sr1
ld r2, sr1
ld r6, sr0

add r1, r1, #-1
add r2, r2, #-1
JSR MULT
not r0, r0
add r0, r0, #1
add r1, r6, r0
ld r2, hund
JSR MULT
add r1, r0, #10
add r1, r1, #10
ld r2, sr1
add r2, r2, r2
add r2, r2, #-1
JSR DIVN
ld r0, res_quo
JSR DIVI

ld r0, PAS
add r0, r0, r1
sti r0, DDR

ld r0, PAS
add r0, r0, r2
sti r0, DDR

BR END_SQRT

TRUE_SQRT
add r0, r1, #0
JSR NUM_TO_STRING
END_SQRT
ld r7, saveR7
RET
;-----------------------------------------------------------
PAS     .fill x30
NAS     .fill x-30
KBSR    .fill xFE00
KBDR    .fill xFE02
DSR     .fill xFE04
DDR     .fill xFE06
enter   .fill x26               ;enter key
minus   .fill x-2D              ;#-45, minus sign
mult10  .fill #1
        .fill #10
        .fill #100
        .fill #1000
        .fill #10000
saveR0  .fill 0
saveR1  .fill 0
saveR2  .fill 0
saveR3  .fill 0
saveR4  .fill 0
saveR5  .fill 0
saveR6  .fill 0
saveR7  .fill 0
saveR7_resr   .fill 0
saveR7_sign   .fill 0
saveR7_mult   .fill 0
saveR7_divi   .fill 0
saveR7_divn   .fill 0
saveR7_strn   .fill 0
saveR7_nstr   .fill 0
string  .fill x3501             ;start string location
strend  .fill x-3501
numstr  .fill x4001             ;store char->num value
numend  .fill x-4001
len1    .fill 0
len2    .fill 0
;-----------------------------------------------------------
INPUT_STRING_N1                 ;input string from KB
st r7, saveR7                   ;return R0 for string length

and r0, r0, #0
and r5, r5, #0
add r5, r5, #9
ld r6, string
CLEAR_STRING_1
str r0, r6, #0                  ;Set 0 to string location
add r6, r6, #1
add r5, r5, #-1
BRp CLEAR_STRING_1

ld r5, enter
ld r6, string
INPUT_1
and r0, r0, #0
ld r4, NAS
	chkKB_1
	ldi r1, KBSR
	BRzp chkKB_1
	ldi r0, KBDR
	
	chkD_1
	ldi r1, DSR
	BRzp chkD_1
	sti r0, DDR
	JSR CHECK_MINUS_SIGN
	add r1, r1, #0
	BRn IS_A_MINUS_SIGN_1
	add r0, r0, r4
	str r0, r6, #0          ;store char to string 1
	add r6, r6, #1          ;increase pointer
	add r2, r0, r5
	BRz DONE_ENTER_1
BR INPUT_1

IS_A_MINUS_SIGN_1
ld r4, CASE_2
add r4, r4, #1
st r4, CASE_2                   ;CASE=0, - +
BR INPUT_1

DONE_ENTER_1
ld r5, strend
add r5, r6, r5
add r5, r5, #-1
st r5, len1 
ld r7, saveR7
RET
;-----------------------------------------------------------
INPUT_STRING_N2                 ;input string from KB
st r7, saveR7                   ;return R0 for string length

and r0, r0, #0
and r5, r5, #0
add r5, r5, #9
ld r6, string
CLEAR_STRING_2
str r0, r6, #0                  ;Set 0 to string location
add r6, r6, #1
add r5, r5, #-1
BRp CLEAR_STRING_2

ld r5, enter
ld r6, string
INPUT_2
and r0, r0, #0
ld r4, NAS
	chkKB_2
	ldi r1, KBSR
	BRzp chkKB_2
	ldi r0, KBDR
	
	chkD_2
	ldi r1, DSR
	BRzp chkD_2
	sti r0, DDR
	JSR CHECK_MINUS_SIGN
	add r1, r1, #0
	BRn IS_A_MINUS_SIGN_2
	add r0, r0, r4
	str r0, r6, #0          ;store char to string 1
	add r6, r6, #1          ;increase pointer
	add r2, r0, r5
	BRz DONE_ENTER_2
BR INPUT_2

IS_A_MINUS_SIGN_2
ld r4, CASE_2
add r4, r4, #2
st r4, CASE_2                   ;CASE=2, + -
BR INPUT_2

DONE_ENTER_2
ld r5, strend
add r5, r6, r5
add r5, r5, #-1
st r5, len2
ld r7, saveR7
RET
;-----------------------------------------------------------
RESET_R
st r7, saveR7_resr
and r0, r0, #0
and r1, r1, #0
and r2, r2, #0
and r3, r3, #0
and r4, r4, #0
and r5, r5, #0
and r6, r6, #0
ld r7, saveR7_resr
RET
;-----------------------------------------------------------
.END