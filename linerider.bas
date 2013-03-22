' -----[ Title ]-----------------------------------------------------------
'
' File...... pohja.bas
' Purpose... PIC16F876
' Author.... Seppo Vihavainen
' Started... 13.12.2012
' Updated... 


' -----[ Program Description ]---------------------------------------------
' 
'
'
'
'
'
' PIC16F876 kytketään seuraavasti:

' PortA.0		Pin2		
' PortA.1		Pin3		
' PortA.2		Pin4		
' PortA.3		Pin5
' PortA.4		Pin6		
' PortA.5		Pin7

' PortB.0		Pin21			
' PortB.1		Pin22		
' PortB.2		Pin23		
' PortB.3		Pin24		
' PortB.4		Pin25		
' PortB.5		Pin26		
' PortB.6		Pin27		
' PortB.7		Pin28		

' PortC.0		Pin11			
' PortC.1		Pin12		
' PortC.2		Pin13		
' PortC.3		Pin14		
' PortC.4		Pin15		
' PortC.5		Pin16		
' PortC.6		Pin17		
' PortC.7		Pin18		


' -----[ Includes ]--------------------------------------------------------
'
INCLUDE "modedefs.bas"

' -----[ Defines ]---------------------------------------------------------
'
DEFINE	OSC	10

DEFINE	DEBUG_REG	PORTB
DEFINE	DEBUG_BIT	5
DEFINE	DEBUG_BAUD	19200
DEFINE	DEBUG_MODE	1

'DEFINE	INTHAND	Intchk

' -----[ Constants ]-------------------------------------------------------
'
' -----[ Pins Variables ]--------------------------------------------------
'
vasen		VAR		PortB.1
oikea		VAR		PortB.2


'--- Paralax Infrared Line Follower ---
ir0			var 	PortC.0
ir1			var 	PortC.1
ir2			var 	PortC.2
ir3			var 	PortC.3
'--- käänteinen järkkä jotta johdot nätisti
ir4			var 	PortC.7
ir5			var 	PortC.6
ir6			var 	PortC.5
ir7			var 	PortC.4


' -----[ Variables ]-------------------------------------------------------
'
spinv	VAR	WORD
spino	var	word
X	VAR BYTE
pysahdys var word
veteenpain var word
oeteenpain var word
vkorjaus var word
okorjaus var word

' -----[ EEPROM Data ]-----------------------------------------------------
'
'     	      01234567890123456789
'	Data "ATE0cAT+CSCA=(+35850"		'  0 - 19
'	Data "8771011)cAT+CMGF=1cA"		'  20 - 39


' -----[ Interrupt ]--------------------------------------------------
'
GOTO Initl
'
'
' -----[ Initialization ]--------------------------------------------------
'
Initl:
'
' Yleiset alustukset
'
	TRISA = %11111111
	TRISC = %11111111
	TRISB = %11011001
	ADCON1 = %10001110		'Right Just, 1anal 0


' Muuttuja asetukset
'


	

' -----[ Main Code ]-------------------------------------------------------
'

'	DEBUG "R e s e t o i", cr, cr



'   ------------- Start -------------------
'
LOW vasen
LOW oikea
pysahdys = 376
oeteenpain = 500
veteenpain = 250

vkorjaus = 368
okorjaus = 383

spinv = pysahdys
spino = pysahdys
Start:

select case PortC
	'ei viivaa => pysähdy'
	case %11111111 
		spinv = pysahdys-1
		spino = pysahdys
	
	'eteenpäin'
	case %01110111, %11110111, %01111111, %00110111, %01110011, %00111111, %11110011,  %00110011
		spinv = veteenpain
		spino = oeteenpain

	case %10001111, %10011111, %11001111, %10111111, %11011111, %11101111
		spinv = veteenpain
		spino = okorjaus

	case %11111000, %11111100, %11111001, %11111011, %11111101, %11111110
		spinv = vkorjaus
		spino = oeteenpain
end select

'	FOR X = 1 TO 200
	PULSOUT oikea, spino
	PULSOUT vasen, spinv
	
		
		
	PAUSE 20
'	NEXT X
	GOTO Start	
END
'-------- Subrut------
        