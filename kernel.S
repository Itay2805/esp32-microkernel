
kernel/out/build/kernel.elf:     file format elf32-xtensa-le


Disassembly of section .text:

400a0000 <get_cpu_index-0x20>:
400a0000:	524b      	addi.n	a5, a2, 4
400a0002:	4e          	.byte 0x4e
400a0003:	f84c      	movi.n	a8, 79
400a0005:	000022        	l8ui	a2, a0, 0
400a0008:	003130        	lsi	f3, a1, 0
400a000b:	039400        	lsi	f0, a4, 12
400a000e:	d00000        	subx2	a0, a0, a0
400a0011:	400a22        	l8ui	a2, a10, 64
	...

400a0020 <get_cpu_index>:
400a0020:	004136        	entry	a1, 32
400a0023:	03eb20        	rsr.prid	a2
400a0026:	042d20        	extui	a2, a2, 13, 1
400a0029:	f01d      	retw.n
	...

400a002c <_out_buffer>:
400a002c:	004136        	entry	a1, 32
400a002f:	742020        	extui	a2, a2, 0, 8
400a0032:	04b457        	bgeu	a4, a5, 400a003a <_out_buffer+0xe>
400a0035:	334a      	add.n	a3, a3, a4
400a0037:	004322        	s8i	a2, a3, 0
400a003a:	f01d      	retw.n

400a003c <_out_null>:
400a003c:	004136        	entry	a1, 32
400a003f:	f01d      	retw.n
400a0041:	00          	.byte 00
400a0042:	00          	.byte 00
400a0043:	00          	.byte 00
400a0044:	1c 00 f4 3f 	
400a0048:	00 00 f4 3f 	

400a004c <_out_char>:
400a004c:	004136        	entry	a1, 32
400a004f:	742020        	extui	a2, a2, 0, 8
400a0052:	012216        	beqz	a2, 400a0068 <_out_char+0x1c>
400a0055:	fffb91        	l32r	a9, 400a0044 <_out_null+0x8>
400a0058:	0020c0        	memw
400a005b:	0988      	l32i.n	a8, a9, 0
400a005d:	f7f877        	bbsi	a8, 23, 400a0058 <_out_char+0xc>
400a0060:	fffa81        	l32r	a8, 400a0048 <_out_null+0xc>
400a0063:	0020c0        	memw
400a0066:	0829      	s32i.n	a2, a8, 0
400a0068:	f01d      	retw.n
	...

400a006c <_ntoa_format>:
400a006c:	006136        	entry	a1, 48
400a006f:	102182        	l32i	a8, a1, 64
400a0072:	2a0c      	movi.n	a10, 2
400a0074:	10a8a0        	and	a10, a8, a10
400a0077:	0129      	s32i.n	a2, a1, 0
400a0079:	11a9      	s32i.n	a10, a1, 4
400a007b:	032d      	mov.n	a2, a3
400a007d:	d198      	l32i.n	a9, a1, 52
400a007f:	e1e8      	l32i.n	a14, a1, 56
400a0081:	f138      	l32i.n	a3, a1, 60
400a0083:	3001b2        	l8ui	a11, a1, 48
400a0086:	eafc      	bnez.n	a10, 400a00c8 <_ntoa_format+0x5c>
400a0088:	04a080        	extui	a10, a8, 0, 1
400a008b:	639c      	beqz.n	a3, 400a00a5 <_ntoa_format+0x39>
400a008d:	4a9c      	beqz.n	a10, 400a00a5 <_ntoa_format+0x39>
400a008f:	3bcc      	bnez.n	a11, 400a0096 <_ntoa_format+0x2a>
400a0091:	cc0c      	movi.n	a12, 12
400a0093:	0e08c7        	bnone	a8, a12, 400a00a5 <_ntoa_format+0x39>
400a0096:	330b      	addi.n	a3, a3, -1
400a0098:	000246        	j	400a00a5 <_ntoa_format+0x39>
400a009b:	f67a      	add.n	a15, a6, a7
400a009d:	004fd2        	s8i	a13, a15, 0
400a00a0:	771b      	addi.n	a7, a7, 1
400a00a2:	000106        	j	400a00aa <_ntoa_format+0x3e>
400a00a5:	0c4c      	movi.n	a12, 64
400a00a7:	30a0d2        	movi	a13, 48
400a00aa:	02b7e7        	bgeu	a7, a14, 400a00b0 <_ntoa_format+0x44>
400a00ad:	eabc77        	bgeu	a12, a7, 400a009b <_ntoa_format+0x2f>
400a00b0:	0c4c      	movi.n	a12, 64
400a00b2:	0d3c      	movi.n	a13, 48
400a00b4:	0001c6        	j	400a00bf <_ntoa_format+0x53>
400a00b7:	f67a      	add.n	a15, a6, a7
400a00b9:	004fd2        	s8i	a13, a15, 0
400a00bc:	01c772        	addi	a7, a7, 1
400a00bf:	005a16        	beqz	a10, 400a00c8 <_ntoa_format+0x5c>
400a00c2:	02b737        	bgeu	a7, a3, 400a00c8 <_ntoa_format+0x5c>
400a00c5:	eebc77        	bgeu	a12, a7, 400a00b7 <_ntoa_format+0x4b>
400a00c8:	02e847        	bbsi	a8, 4, 400a00ce <_ntoa_format+0x62>
400a00cb:	002146        	j	400a0154 <_ntoa_format+0xe8>
400a00ce:	00a4a2        	movi	a10, 0x400
400a00d1:	10a8a0        	and	a10, a8, a10
400a00d4:	0afc      	bnez.n	a10, 400a0108 <_ntoa_format+0x9c>
400a00d6:	e7ac      	beqz.n	a7, 400a0108 <_ntoa_format+0x9c>
400a00d8:	c0d7e0        	sub	a13, a7, a14
400a00db:	1c0c      	movi.n	a12, 1
400a00dd:	83acd0        	moveqz	a10, a12, a13
400a00e0:	74a0a0        	extui	a10, a10, 0, 8
400a00e3:	7acc      	bnez.n	a10, 400a00ee <_ntoa_format+0x82>
400a00e5:	c0d730        	sub	a13, a7, a3
400a00e8:	93cad0        	movnez	a12, a10, a13
400a00eb:	019c16        	beqz	a12, 400a0108 <_ntoa_format+0x9c>
400a00ee:	c70b      	addi.n	a12, a7, -1
400a00f0:	121726        	beqi	a7, 1, 400a0106 <_ntoa_format+0x9a>
400a00f3:	f0c9f2        	addi	a15, a9, -16
400a00f6:	1a0c      	movi.n	a10, 1
400a00f8:	0d0c      	movi.n	a13, 0
400a00fa:	93adf0        	movnez	a10, a13, a15
400a00fd:	74a0a0        	extui	a10, a10, 0, 8
400a0100:	fec772        	addi	a7, a7, -2
400a0103:	049ad7        	bne	a10, a13, 400a010b <_ntoa_format+0x9f>
400a0106:	0c7d      	mov.n	a7, a12
400a0108:	27b966        	bnei	a9, 16, 400a0133 <_ntoa_format+0xc7>
400a010b:	0c2c      	movi.n	a12, 32
400a010d:	0d4c      	movi.n	a13, 64
400a010f:	10c8c0        	and	a12, a8, a12
400a0112:	1a0c      	movi.n	a10, 1
400a0114:	01bd77        	bgeu	a13, a7, 400a0119 <_ntoa_format+0xad>
400a0117:	0a0c      	movi.n	a10, 0
400a0119:	74a0a0        	extui	a10, a10, 0, 8
400a011c:	accc      	bnez.n	a12, 400a012a <_ntoa_format+0xbe>
400a011e:	6a8c      	beqz.n	a10, 400a0128 <_ntoa_format+0xbc>
400a0120:	a67a      	add.n	a10, a6, a7
400a0122:	78a0c2        	movi	a12, 120
400a0125:	0005c6        	j	400a0140 <_ntoa_format+0xd4>
400a0128:	ac9c      	beqz.n	a12, 400a0146 <_ntoa_format+0xda>
400a012a:	8a9c      	beqz.n	a10, 400a0146 <_ntoa_format+0xda>
400a012c:	a67a      	add.n	a10, a6, a7
400a012e:	8c5c      	movi.n	a12, 88
400a0130:	000306        	j	400a0140 <_ntoa_format+0xd4>
400a0133:	0f2966        	bnei	a9, 2, 400a0146 <_ntoa_format+0xda>
400a0136:	0a4c      	movi.n	a10, 64
400a0138:	0a3a77        	bltu	a10, a7, 400a0146 <_ntoa_format+0xda>
400a013b:	a67a      	add.n	a10, a6, a7
400a013d:	62a0c2        	movi	a12, 98
400a0140:	004ac2        	s8i	a12, a10, 0
400a0143:	01c772        	addi	a7, a7, 1
400a0146:	1a4c      	movi.n	a10, 65
400a0148:	2917a7        	beq	a7, a10, 400a0175 <_ntoa_format+0x109>
400a014b:	a67a      	add.n	a10, a6, a7
400a014d:	0c3c      	movi.n	a12, 48
400a014f:	004ac2        	s8i	a12, a10, 0
400a0152:	771b      	addi.n	a7, a7, 1
400a0154:	1a4c      	movi.n	a10, 65
400a0156:	1b17a7        	beq	a7, a10, 400a0175 <_ntoa_format+0x109>
400a0159:	5b8c      	beqz.n	a11, 400a0162 <_ntoa_format+0xf6>
400a015b:	a67a      	add.n	a10, a6, a7
400a015d:	db2c      	movi.n	a11, 45
400a015f:	000346        	j	400a0170 <_ntoa_format+0x104>
400a0162:	a67a      	add.n	a10, a6, a7
400a0164:	bb2c      	movi.n	a11, 43
400a0166:	06e827        	bbsi	a8, 2, 400a0170 <_ntoa_format+0x104>
400a0169:	086837        	bbci	a8, 3, 400a0175 <_ntoa_format+0x109>
400a016c:	a67a      	add.n	a10, a6, a7
400a016e:	0b2c      	movi.n	a11, 32
400a0170:	004ab2        	s8i	a11, a10, 0
400a0173:	771b      	addi.n	a7, a7, 1
400a0175:	148080        	extui	a8, a8, 0, 2
400a0178:	f89c      	beqz.n	a8, 400a019b <_ntoa_format+0x12f>
400a017a:	048d      	mov.n	a8, a4
400a017c:	07fd      	mov.n	a15, a7
400a017e:	778a      	add.n	a7, a7, a8
400a0180:	001086        	j	400a01c6 <_ntoa_format+0x15a>
400a0183:	0198      	l32i.n	a9, a1, 0
400a0185:	2189      	s32i.n	a8, a1, 8
400a0187:	31f9      	s32i.n	a15, a1, 12
400a0189:	05dd      	mov.n	a13, a5
400a018b:	02bd      	mov.n	a11, a2
400a018d:	0a2c      	movi.n	a10, 32
400a018f:	0009e0        	callx8	a9
400a0192:	2188      	l32i.n	a8, a1, 8
400a0194:	31f8      	l32i.n	a15, a1, 12
400a0196:	881b      	addi.n	a8, a8, 1
400a0198:	000106        	j	400a01a0 <_ntoa_format+0x134>
400a019b:	078d      	mov.n	a8, a7
400a019d:	c0f470        	sub	a15, a4, a7
400a01a0:	cf8a      	add.n	a12, a15, a8
400a01a2:	dd3837        	bltu	a8, a3, 400a0183 <_ntoa_format+0x117>
400a01a5:	080c      	movi.n	a8, 0
400a01a7:	023377        	bltu	a3, a7, 400a01ad <_ntoa_format+0x141>
400a01aa:	c08370        	sub	a8, a3, a7
400a01ad:	884a      	add.n	a8, a8, a4
400a01af:	fff246        	j	400a017c <_ntoa_format+0x110>
400a01b2:	ff0b      	addi.n	a15, a15, -1
400a01b4:	86fa      	add.n	a8, a6, a15
400a01b6:	0008a2        	l8ui	a10, a8, 0
400a01b9:	0188      	l32i.n	a8, a1, 0
400a01bb:	31f9      	s32i.n	a15, a1, 12
400a01bd:	05dd      	mov.n	a13, a5
400a01bf:	02bd      	mov.n	a11, a2
400a01c1:	0008e0        	callx8	a8
400a01c4:	31f8      	l32i.n	a15, a1, 12
400a01c6:	078d      	mov.n	a8, a7
400a01c8:	c0c7f0        	sub	a12, a7, a15
400a01cb:	fe3f56        	bnez	a15, 400a01b2 <_ntoa_format+0x146>
400a01ce:	1198      	l32i.n	a9, a1, 4
400a01d0:	c99c      	beqz.n	a9, 400a01f0 <_ntoa_format+0x184>
400a01d2:	c07740        	sub	a7, a7, a4
400a01d5:	062c      	movi.n	a6, 32
400a01d7:	000406        	j	400a01eb <_ntoa_format+0x17f>
400a01da:	08cd      	mov.n	a12, a8
400a01dc:	0188      	l32i.n	a8, a1, 0
400a01de:	05dd      	mov.n	a13, a5
400a01e0:	20b220        	or	a11, a2, a2
400a01e3:	20a660        	or	a10, a6, a6
400a01e6:	0008e0        	callx8	a8
400a01e9:	771b      	addi.n	a7, a7, 1
400a01eb:	874a      	add.n	a8, a7, a4
400a01ed:	e93737        	bltu	a7, a3, 400a01da <_ntoa_format+0x16e>
400a01f0:	082d      	mov.n	a2, a8
400a01f2:	f01d      	retw.n

400a01f4 <_ntoa_long>:
400a01f4:	014136        	entry	a1, 160
400a01f7:	02ad      	mov.n	a10, a2
400a01f9:	2821e2        	l32i	a14, a1, 160
400a01fc:	2b2122        	l32i	a2, a1, 172
400a01ff:	03bd      	mov.n	a11, a3
400a0201:	04cd      	mov.n	a12, a4
400a0203:	05dd      	mov.n	a13, a5
400a0205:	06fd      	mov.n	a15, a6
400a0207:	747070        	extui	a7, a7, 0, 8
400a020a:	96cc      	bnez.n	a6, 400a0217 <_ntoa_long+0x23>
400a020c:	f86c      	movi.n	a8, -17
400a020e:	108280        	and	a8, a2, a8
400a0211:	4fe2a7        	bbsi	a2, 10, 400a0264 <_ntoa_long+0x70>
400a0214:	000046        	j	400a0219 <_ntoa_long+0x25>
400a0217:	028d      	mov.n	a8, a2
400a0219:	042580        	extui	a2, a8, 5, 1
400a021c:	194c      	movi.n	a9, 65
400a021e:	61a032        	movi	a3, 97
400a0221:	839320        	moveqz	a9, a3, a2
400a0224:	f6c992        	addi	a9, a9, -10
400a0227:	0f2d      	mov.n	a2, a15
400a0229:	20c152        	addi	a5, a1, 32
400a022c:	0f0c      	movi.n	a15, 0
400a022e:	1c6192        	s32i	a9, a1, 112
400a0231:	000046        	j	400a0236 <_ntoa_long+0x42>
400a0234:	032d      	mov.n	a2, a3
400a0236:	1c2192        	l32i	a9, a1, 112
400a0239:	e262e0        	remu	a6, a2, a14
400a023c:	744060        	extui	a4, a6, 0, 8
400a023f:	803490        	add	a3, a4, a9
400a0242:	990c      	movi.n	a9, 9
400a0244:	743030        	extui	a3, a3, 0, 8
400a0247:	053967        	bltu	a9, a6, 400a0250 <_ntoa_long+0x5c>
400a024a:	30c442        	addi	a4, a4, 48
400a024d:	743040        	extui	a3, a4, 0, 8
400a0250:	004532        	s8i	a3, a5, 0
400a0253:	ff1b      	addi.n	a15, a15, 1
400a0255:	c232e0        	quou	a3, a2, a14
400a0258:	01c552        	addi	a5, a5, 1
400a025b:	0532e7        	bltu	a2, a14, 400a0264 <_ntoa_long+0x70>
400a025e:	40a022        	movi	a2, 64
400a0261:	cfb2f7        	bgeu	a2, a15, 400a0234 <_ntoa_long+0x40>
400a0264:	2a2122        	l32i	a2, a1, 168
400a0267:	11e9      	s32i.n	a14, a1, 4
400a0269:	3129      	s32i.n	a2, a1, 12
400a026b:	292122        	l32i	a2, a1, 164
400a026e:	4189      	s32i.n	a8, a1, 16
400a0270:	2129      	s32i.n	a2, a1, 8
400a0272:	0179      	s32i.n	a7, a1, 0
400a0274:	20c1e2        	addi	a14, a1, 32
400a0277:	ffdf65        	call8	400a006c <_ntoa_format>
400a027a:	0a2d      	mov.n	a2, a10
400a027c:	f01d      	retw.n
	...

400a0280 <_ntoa_long_long>:
400a0280:	016136        	entry	a1, 176
400a0283:	b00182        	l8ui	a8, a1, 176
400a0286:	069d      	mov.n	a9, a6
400a0288:	1d6182        	s32i	a8, a1, 116
400a028b:	076d      	mov.n	a6, a7
400a028d:	207970        	or	a7, a9, a7
400a0290:	2e21e2        	l32i	a14, a1, 184
400a0293:	2f21f2        	l32i	a15, a1, 188
400a0296:	3221a2        	l32i	a10, a1, 200
400a0299:	c7cc      	bnez.n	a7, 400a02a9 <_ntoa_long_long+0x29>
400a029b:	f86c      	movi.n	a8, -17
400a029d:	108a80        	and	a8, a10, a8
400a02a0:	026aa7        	bbci	a10, 10, 400a02a6 <_ntoa_long_long+0x26>
400a02a3:	002d86        	j	400a035d <_ntoa_long_long+0xdd>
400a02a6:	000046        	j	400a02ab <_ntoa_long_long+0x2b>
400a02a9:	0a8d      	mov.n	a8, a10
400a02ab:	047580        	extui	a7, a8, 5, 1
400a02ae:	61a0b2        	movi	a11, 97
400a02b1:	1a4c      	movi.n	a10, 65
400a02b3:	83ab70        	moveqz	a10, a11, a7
400a02b6:	f6caa2        	addi	a10, a10, -10
400a02b9:	20c1b2        	addi	a11, a1, 32
400a02bc:	1c61b2        	s32i	a11, a1, 112
400a02bf:	070c      	movi.n	a7, 0
400a02c1:	1e61a2        	s32i	a10, a1, 120
400a02c4:	000306        	j	400a02d4 <_ntoa_long_long+0x54>
400a02c7:	00          	.byte 00
400a02c8:	80 d2 00 40 	
400a02cc:	f8 cf 00 40 	
400a02d0:	0a9d      	mov.n	a9, a10
400a02d2:	0b6d      	mov.n	a6, a11
400a02d4:	0ecd      	mov.n	a12, a14
400a02d6:	0fdd      	mov.n	a13, a15
400a02d8:	20a990        	or	a10, a9, a9
400a02db:	20b660        	or	a11, a6, a6
400a02de:	1f6182        	s32i	a8, a1, 124
400a02e1:	206192        	s32i	a9, a1, 128
400a02e4:	2161e2        	s32i	a14, a1, 132
400a02e7:	2261f2        	s32i	a15, a1, 136
400a02ea:	fff781        	l32r	a8, 400a02c8 <_ntoa_long_long+0x48>
400a02ed:	0008e0        	callx8	a8
400a02f0:	1e21c2        	l32i	a12, a1, 120
400a02f3:	74a0a0        	extui	a10, a10, 0, 8
400a02f6:	80bac0        	add	a11, a10, a12
400a02f9:	09a0c2        	movi	a12, 9
400a02fc:	1f2182        	l32i	a8, a1, 124
400a02ff:	202192        	l32i	a9, a1, 128
400a0302:	2121e2        	l32i	a14, a1, 132
400a0305:	2221f2        	l32i	a15, a1, 136
400a0308:	74b0b0        	extui	a11, a11, 0, 8
400a030b:	053ca7        	bltu	a12, a10, 400a0314 <_ntoa_long_long+0x94>
400a030e:	30caa2        	addi	a10, a10, 48
400a0311:	74b0a0        	extui	a11, a10, 0, 8
400a0314:	1c21a2        	l32i	a10, a1, 112
400a0317:	0ecd      	mov.n	a12, a14
400a0319:	004ab2        	s8i	a11, a10, 0
400a031c:	0fdd      	mov.n	a13, a15
400a031e:	09ad      	mov.n	a10, a9
400a0320:	20b660        	or	a11, a6, a6
400a0323:	1f6182        	s32i	a8, a1, 124
400a0326:	206192        	s32i	a9, a1, 128
400a0329:	2161e2        	s32i	a14, a1, 132
400a032c:	2261f2        	s32i	a15, a1, 136
400a032f:	ffe781        	l32r	a8, 400a02cc <_ntoa_long_long+0x4c>
400a0332:	0008e0        	callx8	a8
400a0335:	1c21c2        	l32i	a12, a1, 112
400a0338:	2221f2        	l32i	a15, a1, 136
400a033b:	cc1b      	addi.n	a12, a12, 1
400a033d:	1c61c2        	s32i	a12, a1, 112
400a0340:	1f2182        	l32i	a8, a1, 124
400a0343:	202192        	l32i	a9, a1, 128
400a0346:	2121e2        	l32i	a14, a1, 132
400a0349:	01c772        	addi	a7, a7, 1
400a034c:	0d36f7        	bltu	a6, a15, 400a035d <_ntoa_long_long+0xdd>
400a034f:	029f67        	bne	a15, a6, 400a0355 <_ntoa_long_long+0xd5>
400a0352:	0739e7        	bltu	a9, a14, 400a035d <_ntoa_long_long+0xdd>
400a0355:	064c      	movi.n	a6, 64
400a0357:	023677        	bltu	a6, a7, 400a035d <_ntoa_long_long+0xdd>
400a035a:	ffdc86        	j	400a02d0 <_ntoa_long_long+0x50>
400a035d:	312162        	l32i	a6, a1, 196
400a0360:	4189      	s32i.n	a8, a1, 16
400a0362:	3169      	s32i.n	a6, a1, 12
400a0364:	1d2182        	l32i	a8, a1, 116
400a0367:	302162        	l32i	a6, a1, 192
400a036a:	11e9      	s32i.n	a14, a1, 4
400a036c:	2169      	s32i.n	a6, a1, 8
400a036e:	0189      	s32i.n	a8, a1, 0
400a0370:	07fd      	mov.n	a15, a7
400a0372:	20c1e2        	addi	a14, a1, 32
400a0375:	05dd      	mov.n	a13, a5
400a0377:	04cd      	mov.n	a12, a4
400a0379:	03bd      	mov.n	a11, a3
400a037b:	02ad      	mov.n	a10, a2
400a037d:	ffcee5        	call8	400a006c <_ntoa_format>
400a0380:	0a2d      	mov.n	a2, a10
400a0382:	f01d      	retw.n

400a0384 <_vsnprintf>:
400a0384:	00e136        	entry	a1, 112
400a0387:	b129      	s32i.n	a2, a1, 44
400a0389:	c139      	s32i.n	a3, a1, 48
400a038b:	1c2122        	l32i	a2, a1, 112
400a038e:	1d2132        	l32i	a3, a1, 116
400a0391:	d129      	s32i.n	a2, a1, 52
400a0393:	1e2162        	l32i	a6, a1, 120
400a0396:	9159      	s32i.n	a5, a1, 36
400a0398:	e139      	s32i.n	a3, a1, 56
400a039a:	020c      	movi.n	a2, 0
400a039c:	01ff86        	j	400a0b9e <_vsnprintf+0x81a>
400a039f:	9158      	l32i.n	a5, a1, 36
400a03a1:	532c      	movi.n	a3, 37
400a03a3:	551b      	addi.n	a5, a5, 1
400a03a5:	9159      	s32i.n	a5, a1, 36
400a03a7:	071a37        	beq	a10, a3, 400a03b2 <_vsnprintf+0x2e>
400a03aa:	01f306        	j	400a0b7a <_vsnprintf+0x7f6>
400a03ad:	9179      	s32i.n	a7, a1, 36
400a03af:	0003c6        	j	400a03c2 <_vsnprintf+0x3e>
400a03b2:	030c      	movi.n	a3, 0
400a03b4:	b82c      	movi.n	a8, 43
400a03b6:	2a0c      	movi.n	a10, 2
400a03b8:	0b3c      	movi.n	a11, 48
400a03ba:	1c0c      	movi.n	a12, 1
400a03bc:	8d0c      	movi.n	a13, 8
400a03be:	3e2c      	movi.n	a14, 35
400a03c0:	091c      	movi.n	a9, 16
400a03c2:	91f8      	l32i.n	a15, a1, 36
400a03c4:	000f52        	l8ui	a5, a15, 0
400a03c7:	7f1b      	addi.n	a7, a15, 1
400a03c9:	2d1587        	beq	a5, a8, 400a03fa <_vsnprintf+0x76>
400a03cc:	083857        	bltu	a8, a5, 400a03d8 <_vsnprintf+0x54>
400a03cf:	2fc526        	beqi	a5, 32, 400a0402 <_vsnprintf+0x7e>
400a03d2:	3215e7        	beq	a5, a14, 400a0408 <_vsnprintf+0x84>
400a03d5:	0001c6        	j	400a03e0 <_vsnprintf+0x5c>
400a03d8:	df2c      	movi.n	a15, 45
400a03da:	1615f7        	beq	a5, a15, 400a03f4 <_vsnprintf+0x70>
400a03dd:	0d15b7        	beq	a5, a11, 400a03ee <_vsnprintf+0x6a>
400a03e0:	d0c582        	addi	a8, a5, -48
400a03e3:	748080        	extui	a8, a8, 0, 8
400a03e6:	990c      	movi.n	a9, 9
400a03e8:	4d3987        	bltu	a9, a8, 400a0439 <_vsnprintf+0xb5>
400a03eb:	000c46        	j	400a0420 <_vsnprintf+0x9c>
400a03ee:	2033c0        	or	a3, a3, a12
400a03f1:	ffee06        	j	400a03ad <_vsnprintf+0x29>
400a03f4:	2033a0        	or	a3, a3, a10
400a03f7:	ffec86        	j	400a03ad <_vsnprintf+0x29>
400a03fa:	450c      	movi.n	a5, 4
400a03fc:	203350        	or	a3, a3, a5
400a03ff:	ffea86        	j	400a03ad <_vsnprintf+0x29>
400a0402:	2033d0        	or	a3, a3, a13
400a0405:	ffe906        	j	400a03ad <_vsnprintf+0x29>
400a0408:	203390        	or	a3, a3, a9
400a040b:	ffe786        	j	400a03ad <_vsnprintf+0x29>
400a040e:	81a8      	l32i.n	a10, a1, 32
400a0410:	9189      	s32i.n	a8, a1, 36
400a0412:	a07aa0        	addx4	a7, a10, a10
400a0415:	907790        	addx2	a7, a7, a9
400a0418:	d0c792        	addi	a9, a7, -48
400a041b:	8199      	s32i.n	a9, a1, 32
400a041d:	000146        	j	400a0426 <_vsnprintf+0xa2>
400a0420:	050c      	movi.n	a5, 0
400a0422:	8159      	s32i.n	a5, a1, 32
400a0424:	095d      	mov.n	a5, a9
400a0426:	9188      	l32i.n	a8, a1, 36
400a0428:	000892        	l8ui	a9, a8, 0
400a042b:	881b      	addi.n	a8, a8, 1
400a042d:	d0c972        	addi	a7, a9, -48
400a0430:	747070        	extui	a7, a7, 0, 8
400a0433:	d7b577        	bgeu	a5, a7, 400a040e <_vsnprintf+0x8a>
400a0436:	000d06        	j	400a046e <_vsnprintf+0xea>
400a0439:	090c      	movi.n	a9, 0
400a043b:	a82c      	movi.n	a8, 42
400a043d:	8199      	s32i.n	a9, a1, 32
400a043f:	2b9587        	bne	a5, a8, 400a046e <_vsnprintf+0xea>
400a0442:	864b      	addi.n	a8, a6, 4
400a0444:	891c      	movi.n	a9, 24
400a0446:	e158      	l32i.n	a5, a1, 56
400a0448:	06a987        	bge	a9, a8, 400a0452 <_vsnprintf+0xce>
400a044b:	012967        	blt	a9, a6, 400a0450 <_vsnprintf+0xcc>
400a044e:	482c      	movi.n	a8, 36
400a0450:	d158      	l32i.n	a5, a1, 52
400a0452:	558a      	add.n	a5, a5, a8
400a0454:	fcc552        	addi	a5, a5, -4
400a0457:	0558      	l32i.n	a5, a5, 0
400a0459:	8159      	s32i.n	a5, a1, 32
400a045b:	00b5d6        	bgez	a5, 400a046a <_vsnprintf+0xe6>
400a045e:	250c      	movi.n	a5, 2
400a0460:	203350        	or	a3, a3, a5
400a0463:	8158      	l32i.n	a5, a1, 32
400a0465:	605050        	neg	a5, a5
400a0468:	8159      	s32i.n	a5, a1, 32
400a046a:	086d      	mov.n	a6, a8
400a046c:	9179      	s32i.n	a7, a1, 36
400a046e:	9188      	l32i.n	a8, a1, 36
400a0470:	090c      	movi.n	a9, 0
400a0472:	000872        	l8ui	a7, a8, 0
400a0475:	e52c      	movi.n	a5, 46
400a0477:	a199      	s32i.n	a9, a1, 40
400a0479:	689757        	bne	a7, a5, 400a04e5 <_vsnprintf+0x161>
400a047c:	010892        	l8ui	a9, a8, 1
400a047f:	00a472        	movi	a7, 0x400
400a0482:	581b      	addi.n	a5, a8, 1
400a0484:	d0c982        	addi	a8, a9, -48
400a0487:	203370        	or	a3, a3, a7
400a048a:	748080        	extui	a8, a8, 0, 8
400a048d:	970c      	movi.n	a7, 9
400a048f:	223787        	bltu	a7, a8, 400a04b5 <_vsnprintf+0x131>
400a0492:	000386        	j	400a04a4 <_vsnprintf+0x120>
400a0495:	a188      	l32i.n	a8, a1, 40
400a0497:	a05880        	addx4	a5, a8, a8
400a049a:	905590        	addx2	a5, a5, a9
400a049d:	d0c552        	addi	a5, a5, -48
400a04a0:	a159      	s32i.n	a5, a1, 40
400a04a2:	0a5d      	mov.n	a5, a10
400a04a4:	000592        	l8ui	a9, a5, 0
400a04a7:	a51b      	addi.n	a10, a5, 1
400a04a9:	d0c982        	addi	a8, a9, -48
400a04ac:	748080        	extui	a8, a8, 0, 8
400a04af:	e2b787        	bgeu	a7, a8, 400a0495 <_vsnprintf+0x111>
400a04b2:	000b46        	j	400a04e3 <_vsnprintf+0x15f>
400a04b5:	a72c      	movi.n	a7, 42
400a04b7:	289977        	bne	a9, a7, 400a04e3 <_vsnprintf+0x15f>
400a04ba:	764b      	addi.n	a7, a6, 4
400a04bc:	881c      	movi.n	a8, 24
400a04be:	e158      	l32i.n	a5, a1, 56
400a04c0:	06a877        	bge	a8, a7, 400a04ca <_vsnprintf+0x146>
400a04c3:	012867        	blt	a8, a6, 400a04c8 <_vsnprintf+0x144>
400a04c6:	472c      	movi.n	a7, 36
400a04c8:	d158      	l32i.n	a5, a1, 52
400a04ca:	557a      	add.n	a5, a5, a7
400a04cc:	fcc552        	addi	a5, a5, -4
400a04cf:	9198      	l32i.n	a9, a1, 36
400a04d1:	0558      	l32i.n	a5, a5, 0
400a04d3:	060c      	movi.n	a6, 0
400a04d5:	535650        	max	a5, a6, a5
400a04d8:	992b      	addi.n	a9, a9, 2
400a04da:	a159      	s32i.n	a5, a1, 40
400a04dc:	9199      	s32i.n	a9, a1, 36
400a04de:	076d      	mov.n	a6, a7
400a04e0:	000046        	j	400a04e5 <_vsnprintf+0x161>
400a04e3:	9159      	s32i.n	a5, a1, 36
400a04e5:	9188      	l32i.n	a8, a1, 36
400a04e7:	000852        	l8ui	a5, a8, 0
400a04ea:	781b      	addi.n	a7, a8, 1
400a04ec:	6ca082        	movi	a8, 108
400a04ef:	201587        	beq	a5, a8, 400a0513 <_vsnprintf+0x18f>
400a04f2:	0e3857        	bltu	a8, a5, 400a0504 <_vsnprintf+0x180>
400a04f5:	68a082        	movi	a8, 104
400a04f8:	281587        	beq	a5, a8, 400a0524 <_vsnprintf+0x1a0>
400a04fb:	6aa082        	movi	a8, 106
400a04fe:	3f1587        	beq	a5, a8, 400a0541 <_vsnprintf+0x1bd>
400a0501:	001286        	j	400a054f <_vsnprintf+0x1cb>
400a0504:	74a082        	movi	a8, 116
400a0507:	3c1587        	beq	a5, a8, 400a0547 <_vsnprintf+0x1c3>
400a050a:	7aa082        	movi	a8, 122
400a050d:	361587        	beq	a5, a8, 400a0547 <_vsnprintf+0x1c3>
400a0510:	000ec6        	j	400a054f <_vsnprintf+0x1cb>
400a0513:	9198      	l32i.n	a9, a1, 36
400a0515:	010982        	l8ui	a8, a9, 1
400a0518:	021857        	beq	a8, a5, 400a051e <_vsnprintf+0x19a>
400a051b:	000a06        	j	400a0547 <_vsnprintf+0x1c3>
400a051e:	00a352        	movi	a5, 0x300
400a0521:	000406        	j	400a0535 <_vsnprintf+0x1b1>
400a0524:	9198      	l32i.n	a9, a1, 36
400a0526:	010982        	l8ui	a8, a9, 1
400a0529:	051857        	beq	a8, a5, 400a0532 <_vsnprintf+0x1ae>
400a052c:	80a052        	movi	a5, 128
400a052f:	0005c6        	j	400a054a <_vsnprintf+0x1c6>
400a0532:	c0a052        	movi	a5, 192
400a0535:	203350        	or	a3, a3, a5
400a0538:	9158      	l32i.n	a5, a1, 36
400a053a:	552b      	addi.n	a5, a5, 2
400a053c:	9159      	s32i.n	a5, a1, 36
400a053e:	000346        	j	400a054f <_vsnprintf+0x1cb>
400a0541:	00a252        	movi	a5, 0x200
400a0544:	000086        	j	400a054a <_vsnprintf+0x1c6>
400a0547:	00a152        	movi	a5, 0x100
400a054a:	203350        	or	a3, a3, a5
400a054d:	9179      	s32i.n	a7, a1, 36
400a054f:	9188      	l32i.n	a8, a1, 36
400a0551:	63a052        	movi	a5, 99
400a0554:	0008a2        	l8ui	a10, a8, 0
400a0557:	881b      	addi.n	a8, a8, 1
400a0559:	9189      	s32i.n	a8, a1, 36
400a055b:	029a57        	bne	a10, a5, 400a0561 <_vsnprintf+0x1dd>
400a055e:	009b46        	j	400a07cf <_vsnprintf+0x44b>
400a0561:	4835a7        	bltu	a5, a10, 400a05ad <_vsnprintf+0x229>
400a0564:	255c      	movi.n	a5, 82
400a0566:	029a57        	bne	a10, a5, 400a056c <_vsnprintf+0x1e8>
400a0569:	00f9c6        	j	400a0954 <_vsnprintf+0x5d0>
400a056c:	2735a7        	bltu	a5, a10, 400a0597 <_vsnprintf+0x213>
400a056f:	532c      	movi.n	a3, 37
400a0571:	029a37        	bne	a10, a3, 400a0577 <_vsnprintf+0x1f3>
400a0574:	018086        	j	400a0b7a <_vsnprintf+0x7f6>
400a0577:	018406        	j	400a0b8b <_vsnprintf+0x807>
400a057a:	00          	.byte 00
400a057b:	00          	.byte 00
400a057c:	21 08 12 00 	
400a0580:	ffff91        	l32r	a9, 400a057c <_vsnprintf+0x1f8>
400a0583:	34d957        	bbs	a9, a5, 400a05bb <_vsnprintf+0x237>
400a0586:	f70c      	movi.n	a7, 15
400a0588:	029577        	bne	a5, a7, 400a058e <_vsnprintf+0x20a>
400a058b:	013046        	j	400a0a50 <_vsnprintf+0x6cc>
400a058e:	02a526        	beqi	a5, 12, 400a0594 <_vsnprintf+0x210>
400a0591:	017d86        	j	400a0b8b <_vsnprintf+0x807>
400a0594:	016cc6        	j	400a0b4b <_vsnprintf+0x7c7>
400a0597:	355c      	movi.n	a5, 83
400a0599:	029a57        	bne	a10, a5, 400a059f <_vsnprintf+0x21b>
400a059c:	00b246        	j	400a0869 <_vsnprintf+0x4e5>
400a059f:	855c      	movi.n	a5, 88
400a05a1:	161a57        	beq	a10, a5, 400a05bb <_vsnprintf+0x237>
400a05a4:	62a052        	movi	a5, 98
400a05a7:	101a57        	beq	a10, a5, 400a05bb <_vsnprintf+0x237>
400a05aa:	017746        	j	400a0b8b <_vsnprintf+0x807>
400a05ad:	9cca52        	addi	a5, a10, -100
400a05b0:	745050        	extui	a5, a5, 0, 8
400a05b3:	471c      	movi.n	a7, 20
400a05b5:	c7b757        	bgeu	a7, a5, 400a0580 <_vsnprintf+0x1fc>
400a05b8:	0173c6        	j	400a0b8b <_vsnprintf+0x807>
400a05bb:	dfaf52        	movi	a5, -33
400a05be:	105a50        	and	a5, a10, a5
400a05c1:	875c      	movi.n	a7, 88
400a05c3:	1b1577        	beq	a5, a7, 400a05e2 <_vsnprintf+0x25e>
400a05c6:	6fa052        	movi	a5, 111
400a05c9:	029a57        	bne	a10, a5, 400a05cf <_vsnprintf+0x24b>
400a05cc:	017886        	j	400a0bb2 <_vsnprintf+0x82e>
400a05cf:	62a052        	movi	a5, 98
400a05d2:	029a57        	bne	a10, a5, 400a05d8 <_vsnprintf+0x254>
400a05d5:	017786        	j	400a0bb7 <_vsnprintf+0x833>
400a05d8:	f56c      	movi.n	a5, -17
400a05da:	103350        	and	a3, a3, a5
400a05dd:	a70c      	movi.n	a7, 10
400a05df:	000386        	j	400a05f1 <_vsnprintf+0x26d>
400a05e2:	099a57        	bne	a10, a5, 400a05ef <_vsnprintf+0x26b>
400a05e5:	052c      	movi.n	a5, 32
400a05e7:	203350        	or	a3, a3, a5
400a05ea:	071c      	movi.n	a7, 16
400a05ec:	0002c6        	j	400a05fb <_vsnprintf+0x277>
400a05ef:	071c      	movi.n	a7, 16
400a05f1:	97ca52        	addi	a5, a10, -105
400a05f4:	858c      	beqz.n	a5, 400a0600 <_vsnprintf+0x27c>
400a05f6:	9cca52        	addi	a5, a10, -100
400a05f9:	358c      	beqz.n	a5, 400a0600 <_vsnprintf+0x27c>
400a05fb:	357c      	movi.n	a5, -13
400a05fd:	103350        	and	a3, a3, a5
400a0600:	0463a7        	bbci	a3, 10, 400a0608 <_vsnprintf+0x284>
400a0603:	e57c      	movi.n	a5, -2
400a0605:	103350        	and	a3, a3, a5
400a0608:	97cab2        	addi	a11, a10, -105
400a060b:	180c      	movi.n	a8, 1
400a060d:	00a092        	movi	a9, 0
400a0610:	00a252        	movi	a5, 0x200
400a0613:	8398b0        	moveqz	a9, a8, a11
400a0616:	105350        	and	a5, a3, a5
400a0619:	74b090        	extui	a11, a9, 0, 8
400a061c:	008956        	bnez	a9, 400a0628 <_vsnprintf+0x2a4>
400a061f:	9ccaa2        	addi	a10, a10, -100
400a0622:	938ba0        	movnez	a8, a11, a10
400a0625:	0d3816        	beqz	a8, 400a06fc <_vsnprintf+0x378>
400a0628:	050516        	beqz	a5, 400a067c <_vsnprintf+0x2f8>
400a062b:	667b      	addi.n	a6, a6, 7
400a062d:	857c      	movi.n	a5, -8
400a062f:	108650        	and	a8, a6, a5
400a0632:	588b      	addi.n	a5, a8, 8
400a0634:	891c      	movi.n	a9, 24
400a0636:	e168      	l32i.n	a6, a1, 56
400a0638:	06a957        	bge	a9, a5, 400a0642 <_vsnprintf+0x2be>
400a063b:	012987        	blt	a9, a8, 400a0640 <_vsnprintf+0x2bc>
400a063e:	852c      	movi.n	a5, 40
400a0640:	d168      	l32i.n	a6, a1, 52
400a0642:	665a      	add.n	a6, a6, a5
400a0644:	f8c662        	addi	a6, a6, -8
400a0647:	1688      	l32i.n	a8, a6, 4
400a0649:	0698      	l32i.n	a9, a6, 0
400a064b:	316f80        	srai	a6, a8, 31
400a064e:	309690        	xor	a9, a6, a9
400a0651:	c0e960        	sub	a14, a9, a6
400a0654:	30f680        	xor	a15, a6, a8
400a0657:	1a0c      	movi.n	a10, 1
400a0659:	0139e7        	bltu	a9, a14, 400a065e <_vsnprintf+0x2da>
400a065c:	0a0c      	movi.n	a10, 0
400a065e:	6139      	s32i.n	a3, a1, 24
400a0660:	8138      	l32i.n	a3, a1, 32
400a0662:	c0ff60        	sub	a15, a15, a6
400a0665:	a168      	l32i.n	a6, a1, 40
400a0667:	5139      	s32i.n	a3, a1, 20
400a0669:	058f80        	extui	a8, a8, 31, 1
400a066c:	030c      	movi.n	a3, 0
400a066e:	4169      	s32i.n	a6, a1, 16
400a0670:	2179      	s32i.n	a7, a1, 8
400a0672:	3139      	s32i.n	a3, a1, 12
400a0674:	0189      	s32i.n	a8, a1, 0
400a0676:	c0ffa0        	sub	a15, a15, a10
400a0679:	002d06        	j	400a0731 <_vsnprintf+0x3ad>
400a067c:	e198      	l32i.n	a9, a1, 56
400a067e:	564b      	addi.n	a5, a6, 4
400a0680:	881c      	movi.n	a8, 24
400a0682:	1e6387        	bbci	a3, 8, 400a06a4 <_vsnprintf+0x320>
400a0685:	07a857        	bge	a8, a5, 400a0690 <_vsnprintf+0x30c>
400a0688:	022867        	blt	a8, a6, 400a068e <_vsnprintf+0x30a>
400a068b:	24a052        	movi	a5, 36
400a068e:	d198      	l32i.n	a9, a1, 52
400a0690:	995a      	add.n	a9, a9, a5
400a0692:	fcc992        	addi	a9, a9, -4
400a0695:	09e8      	l32i.n	a14, a9, 0
400a0697:	8188      	l32i.n	a8, a1, 32
400a0699:	a198      	l32i.n	a9, a1, 40
400a069b:	3139      	s32i.n	a3, a1, 12
400a069d:	2189      	s32i.n	a8, a1, 8
400a069f:	1199      	s32i.n	a9, a1, 4
400a06a1:	001306        	j	400a06f1 <_vsnprintf+0x36d>
400a06a4:	156367        	bbci	a3, 6, 400a06bd <_vsnprintf+0x339>
400a06a7:	07a857        	bge	a8, a5, 400a06b2 <_vsnprintf+0x32e>
400a06aa:	022867        	blt	a8, a6, 400a06b0 <_vsnprintf+0x32c>
400a06ad:	24a052        	movi	a5, 36
400a06b0:	d198      	l32i.n	a9, a1, 52
400a06b2:	995a      	add.n	a9, a9, a5
400a06b4:	fcc992        	addi	a9, a9, -4
400a06b7:	0009e2        	l8ui	a14, a9, 0
400a06ba:	000a46        	j	400a06e7 <_vsnprintf+0x363>
400a06bd:	146377        	bbci	a3, 7, 400a06d5 <_vsnprintf+0x351>
400a06c0:	06a857        	bge	a8, a5, 400a06ca <_vsnprintf+0x346>
400a06c3:	012867        	blt	a8, a6, 400a06c8 <_vsnprintf+0x344>
400a06c6:	452c      	movi.n	a5, 36
400a06c8:	d198      	l32i.n	a9, a1, 52
400a06ca:	995a      	add.n	a9, a9, a5
400a06cc:	fcc992        	addi	a9, a9, -4
400a06cf:	0099e2        	l16si	a14, a9, 0
400a06d2:	000446        	j	400a06e7 <_vsnprintf+0x363>
400a06d5:	07a857        	bge	a8, a5, 400a06e0 <_vsnprintf+0x35c>
400a06d8:	022867        	blt	a8, a6, 400a06de <_vsnprintf+0x35a>
400a06db:	24a052        	movi	a5, 36
400a06de:	d198      	l32i.n	a9, a1, 52
400a06e0:	995a      	add.n	a9, a9, a5
400a06e2:	fcc992        	addi	a9, a9, -4
400a06e5:	09e8      	l32i.n	a14, a9, 0
400a06e7:	a168      	l32i.n	a6, a1, 40
400a06e9:	3139      	s32i.n	a3, a1, 12
400a06eb:	8138      	l32i.n	a3, a1, 32
400a06ed:	1169      	s32i.n	a6, a1, 4
400a06ef:	2139      	s32i.n	a3, a1, 8
400a06f1:	05ffe0        	extui	a15, a14, 31, 1
400a06f4:	0179      	s32i.n	a7, a1, 0
400a06f6:	60e1e0        	abs	a14, a14
400a06f9:	003086        	j	400a07bf <_vsnprintf+0x43b>
400a06fc:	041516        	beqz	a5, 400a0741 <_vsnprintf+0x3bd>
400a06ff:	857c      	movi.n	a5, -8
400a0701:	667b      	addi.n	a6, a6, 7
400a0703:	106650        	and	a6, a6, a5
400a0706:	568b      	addi.n	a5, a6, 8
400a0708:	891c      	movi.n	a9, 24
400a070a:	e188      	l32i.n	a8, a1, 56
400a070c:	06a957        	bge	a9, a5, 400a0716 <_vsnprintf+0x392>
400a070f:	012967        	blt	a9, a6, 400a0714 <_vsnprintf+0x390>
400a0712:	852c      	movi.n	a5, 40
400a0714:	d188      	l32i.n	a8, a1, 52
400a0716:	885a      	add.n	a8, a8, a5
400a0718:	f8c882        	addi	a8, a8, -8
400a071b:	08e8      	l32i.n	a14, a8, 0
400a071d:	18f8      	l32i.n	a15, a8, 4
400a071f:	a198      	l32i.n	a9, a1, 40
400a0721:	8188      	l32i.n	a8, a1, 32
400a0723:	6139      	s32i.n	a3, a1, 24
400a0725:	030c      	movi.n	a3, 0
400a0727:	5189      	s32i.n	a8, a1, 20
400a0729:	4199      	s32i.n	a9, a1, 16
400a072b:	2179      	s32i.n	a7, a1, 8
400a072d:	3139      	s32i.n	a3, a1, 12
400a072f:	0139      	s32i.n	a3, a1, 0
400a0731:	c1b8      	l32i.n	a11, a1, 48
400a0733:	b1a8      	l32i.n	a10, a1, 44
400a0735:	04dd      	mov.n	a13, a4
400a0737:	02cd      	mov.n	a12, a2
400a0739:	ffb465        	call8	400a0280 <_ntoa_long_long>
400a073c:	0a2d      	mov.n	a2, a10
400a073e:	011686        	j	400a0b9c <_vsnprintf+0x818>
400a0741:	e198      	l32i.n	a9, a1, 56
400a0743:	564b      	addi.n	a5, a6, 4
400a0745:	881c      	movi.n	a8, 24
400a0747:	216387        	bbci	a3, 8, 400a076c <_vsnprintf+0x3e8>
400a074a:	06a857        	bge	a8, a5, 400a0754 <_vsnprintf+0x3d0>
400a074d:	012867        	blt	a8, a6, 400a0752 <_vsnprintf+0x3ce>
400a0750:	452c      	movi.n	a5, 36
400a0752:	d198      	l32i.n	a9, a1, 52
400a0754:	3139      	s32i.n	a3, a1, 12
400a0756:	a168      	l32i.n	a6, a1, 40
400a0758:	8138      	l32i.n	a3, a1, 32
400a075a:	995a      	add.n	a9, a9, a5
400a075c:	fcc992        	addi	a9, a9, -4
400a075f:	2139      	s32i.n	a3, a1, 8
400a0761:	1169      	s32i.n	a6, a1, 4
400a0763:	0179      	s32i.n	a7, a1, 0
400a0765:	09e8      	l32i.n	a14, a9, 0
400a0767:	0f0c      	movi.n	a15, 0
400a0769:	001486        	j	400a07bf <_vsnprintf+0x43b>
400a076c:	156367        	bbci	a3, 6, 400a0785 <_vsnprintf+0x401>
400a076f:	07a857        	bge	a8, a5, 400a077a <_vsnprintf+0x3f6>
400a0772:	022867        	blt	a8, a6, 400a0778 <_vsnprintf+0x3f4>
400a0775:	24a052        	movi	a5, 36
400a0778:	d198      	l32i.n	a9, a1, 52
400a077a:	995a      	add.n	a9, a9, a5
400a077c:	fcc992        	addi	a9, a9, -4
400a077f:	0009e2        	l8ui	a14, a9, 0
400a0782:	000ac6        	j	400a07b1 <_vsnprintf+0x42d>
400a0785:	176377        	bbci	a3, 7, 400a07a0 <_vsnprintf+0x41c>
400a0788:	06a857        	bge	a8, a5, 400a0792 <_vsnprintf+0x40e>
400a078b:	012867        	blt	a8, a6, 400a0790 <_vsnprintf+0x40c>
400a078e:	452c      	movi.n	a5, 36
400a0790:	d198      	l32i.n	a9, a1, 52
400a0792:	995a      	add.n	a9, a9, a5
400a0794:	fcc992        	addi	a9, a9, -4
400a0797:	0019e2        	l16ui	a14, a9, 0
400a079a:	0004c6        	j	400a07b1 <_vsnprintf+0x42d>
400a079d:	000000        	ill
400a07a0:	06a857        	bge	a8, a5, 400a07aa <_vsnprintf+0x426>
400a07a3:	012867        	blt	a8, a6, 400a07a8 <_vsnprintf+0x424>
400a07a6:	452c      	movi.n	a5, 36
400a07a8:	d198      	l32i.n	a9, a1, 52
400a07aa:	995a      	add.n	a9, a9, a5
400a07ac:	fcc992        	addi	a9, a9, -4
400a07af:	09e8      	l32i.n	a14, a9, 0
400a07b1:	8188      	l32i.n	a8, a1, 32
400a07b3:	a198      	l32i.n	a9, a1, 40
400a07b5:	3139      	s32i.n	a3, a1, 12
400a07b7:	2189      	s32i.n	a8, a1, 8
400a07b9:	1199      	s32i.n	a9, a1, 4
400a07bb:	0179      	s32i.n	a7, a1, 0
400a07bd:	0f0c      	movi.n	a15, 0
400a07bf:	c1b8      	l32i.n	a11, a1, 48
400a07c1:	b1a8      	l32i.n	a10, a1, 44
400a07c3:	20d440        	or	a13, a4, a4
400a07c6:	20c220        	or	a12, a2, a2
400a07c9:	ffa2a5        	call8	400a01f4 <_ntoa_long>
400a07cc:	ffdb06        	j	400a073c <_vsnprintf+0x3b8>
400a07cf:	270c      	movi.n	a7, 2
400a07d1:	107370        	and	a7, a3, a7
400a07d4:	130c      	movi.n	a3, 1
400a07d6:	e7ec      	bnez.n	a7, 400a0808 <_vsnprintf+0x484>
400a07d8:	0003c6        	j	400a07eb <_vsnprintf+0x467>
400a07db:	c1b8      	l32i.n	a11, a1, 48
400a07dd:	b188      	l32i.n	a8, a1, 44
400a07df:	20d440        	or	a13, a4, a4
400a07e2:	20a550        	or	a10, a5, a5
400a07e5:	0008e0        	callx8	a8
400a07e8:	0000c6        	j	400a07ef <_vsnprintf+0x46b>
400a07eb:	073d      	mov.n	a3, a7
400a07ed:	052c      	movi.n	a5, 32
400a07ef:	8198      	l32i.n	a9, a1, 32
400a07f1:	c32a      	add.n	a12, a3, a2
400a07f3:	331b      	addi.n	a3, a3, 1
400a07f5:	e23397        	bltu	a3, a9, 400a07db <_vsnprintf+0x457>
400a07f8:	050c      	movi.n	a5, 0
400a07fa:	390b      	addi.n	a3, a9, -1
400a07fc:	833590        	moveqz	a3, a5, a9
400a07ff:	223a      	add.n	a2, a2, a3
400a0801:	250c      	movi.n	a5, 2
400a0803:	391b      	addi.n	a3, a9, 1
400a0805:	833590        	moveqz	a3, a5, a9
400a0808:	564b      	addi.n	a5, a6, 4
400a080a:	891c      	movi.n	a9, 24
400a080c:	e188      	l32i.n	a8, a1, 56
400a080e:	06a957        	bge	a9, a5, 400a0818 <_vsnprintf+0x494>
400a0811:	012967        	blt	a9, a6, 400a0816 <_vsnprintf+0x492>
400a0814:	452c      	movi.n	a5, 36
400a0816:	d188      	l32i.n	a8, a1, 52
400a0818:	885a      	add.n	a8, a8, a5
400a081a:	fcc882        	addi	a8, a8, -4
400a081d:	621b      	addi.n	a6, a2, 1
400a081f:	02cd      	mov.n	a12, a2
400a0821:	c1b8      	l32i.n	a11, a1, 48
400a0823:	0008a2        	l8ui	a10, a8, 0
400a0826:	b128      	l32i.n	a2, a1, 44
400a0828:	04dd      	mov.n	a13, a4
400a082a:	0002e0        	callx8	a2
400a082d:	37bc      	beqz.n	a7, 400a0864 <_vsnprintf+0x4e0>
400a082f:	0006c6        	j	400a084e <_vsnprintf+0x4ca>
400a0832:	8c1b      	addi.n	a8, a12, 1
400a0834:	c1b8      	l32i.n	a11, a1, 48
400a0836:	b198      	l32i.n	a9, a1, 44
400a0838:	116182        	s32i	a8, a1, 68
400a083b:	20d440        	or	a13, a4, a4
400a083e:	20a770        	or	a10, a7, a7
400a0841:	0009e0        	callx8	a9
400a0844:	112182        	l32i	a8, a1, 68
400a0847:	221b      	addi.n	a2, a2, 1
400a0849:	08cd      	mov.n	a12, a8
400a084b:	000146        	j	400a0854 <_vsnprintf+0x4d0>
400a084e:	032d      	mov.n	a2, a3
400a0850:	06cd      	mov.n	a12, a6
400a0852:	072c      	movi.n	a7, 32
400a0854:	8188      	l32i.n	a8, a1, 32
400a0856:	d83287        	bltu	a2, a8, 400a0832 <_vsnprintf+0x4ae>
400a0859:	00a022        	movi	a2, 0
400a085c:	023837        	bltu	a8, a3, 400a0862 <_vsnprintf+0x4de>
400a085f:	c02830        	sub	a2, a8, a3
400a0862:	662a      	add.n	a6, a6, a2
400a0864:	062d      	mov.n	a2, a6
400a0866:	00cc86        	j	400a0b9c <_vsnprintf+0x818>
400a0869:	564b      	addi.n	a5, a6, 4
400a086b:	881c      	movi.n	a8, 24
400a086d:	0e2172        	l32i	a7, a1, 56
400a0870:	06a857        	bge	a8, a5, 400a087a <_vsnprintf+0x4f6>
400a0873:	012867        	blt	a8, a6, 400a0878 <_vsnprintf+0x4f4>
400a0876:	452c      	movi.n	a5, 36
400a0878:	d178      	l32i.n	a7, a1, 52
400a087a:	775a      	add.n	a7, a7, a5
400a087c:	fcc772        	addi	a7, a7, -4
400a087f:	060c      	movi.n	a6, 0
400a0881:	0798      	l32i.n	a9, a7, 0
400a0883:	068d      	mov.n	a8, a6
400a0885:	ffa372        	movi	a7, 0x3ff
400a0888:	000306        	j	400a0898 <_vsnprintf+0x514>
400a088b:	00          	.byte 00
400a088c:	3c 07 fe 3f 	
400a0890:	946090        	extui	a6, a9, 0, 10
400a0893:	881b      	addi.n	a8, a8, 1
400a0895:	419a90        	srli	a9, a9, 10
400a0898:	02b797        	bgeu	a7, a9, 400a089e <_vsnprintf+0x51a>
400a089b:	f158b6        	bltui	a8, 5, 400a0890 <_vsnprintf+0x50c>
400a089e:	81a8      	l32i.n	a10, a1, 32
400a08a0:	a1b8      	l32i.n	a11, a1, 40
400a08a2:	21a9      	s32i.n	a10, a1, 8
400a08a4:	11b9      	s32i.n	a11, a1, 4
400a08a6:	b1a8      	l32i.n	a10, a1, 44
400a08a8:	c1b8      	l32i.n	a11, a1, 48
400a08aa:	a70c      	movi.n	a7, 10
400a08ac:	a06660        	addx4	a6, a6, a6
400a08af:	09ed      	mov.n	a14, a9
400a08b1:	02cd      	mov.n	a12, a2
400a08b3:	3139      	s32i.n	a3, a1, 12
400a08b5:	006172        	s32i	a7, a1, 0
400a08b8:	00a0f2        	movi	a15, 0
400a08bb:	04dd      	mov.n	a13, a4
400a08bd:	a06660        	addx4	a6, a6, a6
400a08c0:	116182        	s32i	a8, a1, 68
400a08c3:	106192        	s32i	a9, a1, 64
400a08c6:	1166e0        	slli	a6, a6, 2
400a08c9:	ff92a5        	call8	400a01f4 <_ntoa_long>
400a08cc:	ffa322        	movi	a2, 0x3ff
400a08cf:	112182        	l32i	a8, a1, 68
400a08d2:	0aed      	mov.n	a14, a10
400a08d4:	31b267        	bgeu	a2, a6, 400a0909 <_vsnprintf+0x585>
400a08d7:	c1b8      	l32i.n	a11, a1, 48
400a08d9:	b168      	l32i.n	a6, a1, 44
400a08db:	0acd      	mov.n	a12, a10
400a08dd:	2a1b      	addi.n	a2, a10, 1
400a08df:	04dd      	mov.n	a13, a4
400a08e1:	ea2c      	movi.n	a10, 46
400a08e3:	0006e0        	callx8	a6
400a08e6:	8168      	l32i.n	a6, a1, 32
400a08e8:	102192        	l32i	a9, a1, 64
400a08eb:	2169      	s32i.n	a6, a1, 8
400a08ed:	a168      	l32i.n	a6, a1, 40
400a08ef:	c1b8      	l32i.n	a11, a1, 48
400a08f1:	b1a8      	l32i.n	a10, a1, 44
400a08f3:	09ed      	mov.n	a14, a9
400a08f5:	3139      	s32i.n	a3, a1, 12
400a08f7:	1169      	s32i.n	a6, a1, 4
400a08f9:	0179      	s32i.n	a7, a1, 0
400a08fb:	0f0c      	movi.n	a15, 0
400a08fd:	04dd      	mov.n	a13, a4
400a08ff:	02cd      	mov.n	a12, a2
400a0901:	ff8f25        	call8	400a01f4 <_ntoa_long>
400a0904:	112182        	l32i	a8, a1, 68
400a0907:	0aed      	mov.n	a14, a10
400a0909:	ffe021        	l32r	a2, 400a088c <_vsnprintf+0x508>
400a090c:	a08820        	addx4	a8, a8, a2
400a090f:	0868      	l32i.n	a6, a8, 0
400a0911:	0e2d      	mov.n	a2, a14
400a0913:	00a472        	movi	a7, 0x400
400a0916:	000686        	j	400a0934 <_vsnprintf+0x5b0>
400a0919:	a189      	s32i.n	a8, a1, 40
400a091b:	821b      	addi.n	a8, a2, 1
400a091d:	c1b8      	l32i.n	a11, a1, 48
400a091f:	b198      	l32i.n	a9, a1, 44
400a0921:	02cd      	mov.n	a12, a2
400a0923:	116182        	s32i	a8, a1, 68
400a0926:	f1e9      	s32i.n	a14, a1, 60
400a0928:	04dd      	mov.n	a13, a4
400a092a:	0009e0        	callx8	a9
400a092d:	112182        	l32i	a8, a1, 68
400a0930:	f1e8      	l32i.n	a14, a1, 60
400a0932:	082d      	mov.n	a2, a8
400a0934:	c082e0        	sub	a8, a2, a14
400a0937:	868a      	add.n	a8, a6, a8
400a0939:	0008a2        	l8ui	a10, a8, 0
400a093c:	25ca16        	beqz	a10, 400a0b9c <_vsnprintf+0x818>
400a093f:	d80377        	bnone	a3, a7, 400a091b <_vsnprintf+0x597>
400a0942:	a198      	l32i.n	a9, a1, 40
400a0944:	890b      	addi.n	a8, a9, -1
400a0946:	fcf956        	bnez	a9, 400a0919 <_vsnprintf+0x595>
400a0949:	0093c6        	j	400a0b9c <_vsnprintf+0x818>
400a094c:	13 00 fe 3f 	
400a0950:	00 00 fe 3f 	
400a0954:	564b      	addi.n	a5, a6, 4
400a0956:	881c      	movi.n	a8, 24
400a0958:	e178      	l32i.n	a7, a1, 56
400a095a:	06a857        	bge	a8, a5, 400a0964 <_vsnprintf+0x5e0>
400a095d:	012867        	blt	a8, a6, 400a0962 <_vsnprintf+0x5de>
400a0960:	452c      	movi.n	a5, 36
400a0962:	d178      	l32i.n	a7, a1, 52
400a0964:	775a      	add.n	a7, a7, a5
400a0966:	fcc772        	addi	a7, a7, -4
400a0969:	0768      	l32i.n	a6, a7, 0
400a096b:	a188      	l32i.n	a8, a1, 40
400a096d:	660b      	addi.n	a6, a6, -1
400a096f:	fff791        	l32r	a9, 400a094c <_vsnprintf+0x5c8>
400a0972:	fff7a1        	l32r	a10, 400a0950 <_vsnprintf+0x5cc>
400a0975:	839a60        	moveqz	a9, a10, a6
400a0978:	f67c      	movi.n	a6, -1
400a097a:	936880        	movnez	a6, a8, a8
400a097d:	696a      	add.n	a6, a9, a6
400a097f:	097d      	mov.n	a7, a9
400a0981:	000046        	j	400a0986 <_vsnprintf+0x602>
400a0984:	771b      	addi.n	a7, a7, 1
400a0986:	000782        	l8ui	a8, a7, 0
400a0989:	188c      	beqz.n	a8, 400a098e <_vsnprintf+0x60a>
400a098b:	f59677        	bne	a6, a7, 400a0984 <_vsnprintf+0x600>
400a098e:	00a462        	movi	a6, 0x400
400a0991:	106360        	and	a6, a3, a6
400a0994:	c07790        	sub	a7, a7, a9
400a0997:	368c      	beqz.n	a6, 400a099e <_vsnprintf+0x61a>
400a0999:	a188      	l32i.n	a8, a1, 40
400a099b:	637780        	minu	a7, a7, a8
400a099e:	280c      	movi.n	a8, 2
400a09a0:	103380        	and	a3, a3, a8
400a09a3:	060356        	bnez	a3, 400a0a07 <_vsnprintf+0x683>
400a09a6:	000846        	j	400a09cb <_vsnprintf+0x647>
400a09a9:	ec1b      	addi.n	a14, a12, 1
400a09ab:	c1b8      	l32i.n	a11, a1, 48
400a09ad:	b1f8      	l32i.n	a15, a1, 44
400a09af:	116182        	s32i	a8, a1, 68
400a09b2:	106192        	s32i	a9, a1, 64
400a09b5:	f1e9      	s32i.n	a14, a1, 60
400a09b7:	04dd      	mov.n	a13, a4
400a09b9:	0a2c      	movi.n	a10, 32
400a09bb:	000fe0        	callx8	a15
400a09be:	f1e8      	l32i.n	a14, a1, 60
400a09c0:	112182        	l32i	a8, a1, 68
400a09c3:	102192        	l32i	a9, a1, 64
400a09c6:	0ecd      	mov.n	a12, a14
400a09c8:	000106        	j	400a09d0 <_vsnprintf+0x64c>
400a09cb:	02cd      	mov.n	a12, a2
400a09cd:	c08720        	sub	a8, a7, a2
400a09d0:	81b8      	l32i.n	a11, a1, 32
400a09d2:	a8ca      	add.n	a10, a8, a12
400a09d4:	d13ab7        	bltu	a10, a11, 400a09a9 <_vsnprintf+0x625>
400a09d7:	00a082        	movi	a8, 0
400a09da:	023b77        	bltu	a11, a7, 400a09e0 <_vsnprintf+0x65c>
400a09dd:	c08b70        	sub	a8, a11, a7
400a09e0:	771b      	addi.n	a7, a7, 1
400a09e2:	228a      	add.n	a2, a2, a8
400a09e4:	787a      	add.n	a7, a8, a7
400a09e6:	000746        	j	400a0a07 <_vsnprintf+0x683>
400a09e9:	a1b9      	s32i.n	a11, a1, 40
400a09eb:	e81b      	addi.n	a14, a8, 1
400a09ed:	08cd      	mov.n	a12, a8
400a09ef:	c1b8      	l32i.n	a11, a1, 48
400a09f1:	b188      	l32i.n	a8, a1, 44
400a09f3:	106192        	s32i	a9, a1, 64
400a09f6:	f1e9      	s32i.n	a14, a1, 60
400a09f8:	04dd      	mov.n	a13, a4
400a09fa:	0008e0        	callx8	a8
400a09fd:	f1e8      	l32i.n	a14, a1, 60
400a09ff:	102192        	l32i	a9, a1, 64
400a0a02:	0e8d      	mov.n	a8, a14
400a0a04:	000046        	j	400a0a09 <_vsnprintf+0x685>
400a0a07:	028d      	mov.n	a8, a2
400a0a09:	c0a820        	sub	a10, a8, a2
400a0a0c:	a9aa      	add.n	a10, a9, a10
400a0a0e:	000aa2        	l8ui	a10, a10, 0
400a0a11:	8a8c      	beqz.n	a10, 400a0a1d <_vsnprintf+0x699>
400a0a13:	fd4616        	beqz	a6, 400a09eb <_vsnprintf+0x667>
400a0a16:	a1c8      	l32i.n	a12, a1, 40
400a0a18:	bc0b      	addi.n	a11, a12, -1
400a0a1a:	fcbc56        	bnez	a12, 400a09e9 <_vsnprintf+0x665>
400a0a1d:	125316        	beqz	a3, 400a0b46 <_vsnprintf+0x7c2>
400a0a20:	000606        	j	400a0a3c <_vsnprintf+0x6b8>
400a0a23:	c1b8      	l32i.n	a11, a1, 48
400a0a25:	b168      	l32i.n	a6, a1, 44
400a0a27:	116182        	s32i	a8, a1, 68
400a0a2a:	04dd      	mov.n	a13, a4
400a0a2c:	0a2c      	movi.n	a10, 32
400a0a2e:	01cc32        	addi	a3, a12, 1
400a0a31:	0006e0        	callx8	a6
400a0a34:	112182        	l32i	a8, a1, 68
400a0a37:	03cd      	mov.n	a12, a3
400a0a39:	000106        	j	400a0a41 <_vsnprintf+0x6bd>
400a0a3c:	08cd      	mov.n	a12, a8
400a0a3e:	c02780        	sub	a2, a7, a8
400a0a41:	8198      	l32i.n	a9, a1, 32
400a0a43:	3c2a      	add.n	a3, a12, a2
400a0a45:	da3397        	bltu	a3, a9, 400a0a23 <_vsnprintf+0x69f>
400a0a48:	003c06        	j	400a0b3c <_vsnprintf+0x7b8>
400a0a4b:	00          	.byte 00
400a0a4c:	23 00 fe 3f 	
400a0a50:	564b      	addi.n	a5, a6, 4
400a0a52:	881c      	movi.n	a8, 24
400a0a54:	e178      	l32i.n	a7, a1, 56
400a0a56:	06a857        	bge	a8, a5, 400a0a60 <_vsnprintf+0x6dc>
400a0a59:	012867        	blt	a8, a6, 400a0a5e <_vsnprintf+0x6da>
400a0a5c:	452c      	movi.n	a5, 36
400a0a5e:	d178      	l32i.n	a7, a1, 52
400a0a60:	775a      	add.n	a7, a7, a5
400a0a62:	fcc772        	addi	a7, a7, -4
400a0a65:	0798      	l32i.n	a9, a7, 0
400a0a67:	19cc      	bnez.n	a9, 400a0a6c <_vsnprintf+0x6e8>
400a0a69:	fff891        	l32r	a9, 400a0a4c <_vsnprintf+0x6c8>
400a0a6c:	a188      	l32i.n	a8, a1, 40
400a0a6e:	f67c      	movi.n	a6, -1
400a0a70:	936880        	movnez	a6, a8, a8
400a0a73:	696a      	add.n	a6, a9, a6
400a0a75:	097d      	mov.n	a7, a9
400a0a77:	000046        	j	400a0a7c <_vsnprintf+0x6f8>
400a0a7a:	771b      	addi.n	a7, a7, 1
400a0a7c:	000782        	l8ui	a8, a7, 0
400a0a7f:	188c      	beqz.n	a8, 400a0a84 <_vsnprintf+0x700>
400a0a81:	f59677        	bne	a6, a7, 400a0a7a <_vsnprintf+0x6f6>
400a0a84:	00a462        	movi	a6, 0x400
400a0a87:	106360        	and	a6, a3, a6
400a0a8a:	c07790        	sub	a7, a7, a9
400a0a8d:	368c      	beqz.n	a6, 400a0a94 <_vsnprintf+0x710>
400a0a8f:	a188      	l32i.n	a8, a1, 40
400a0a91:	637780        	minu	a7, a7, a8
400a0a94:	280c      	movi.n	a8, 2
400a0a96:	103380        	and	a3, a3, a8
400a0a99:	05f356        	bnez	a3, 400a0afc <_vsnprintf+0x778>
400a0a9c:	000846        	j	400a0ac1 <_vsnprintf+0x73d>
400a0a9f:	ec1b      	addi.n	a14, a12, 1
400a0aa1:	c1b8      	l32i.n	a11, a1, 48
400a0aa3:	b1f8      	l32i.n	a15, a1, 44
400a0aa5:	116182        	s32i	a8, a1, 68
400a0aa8:	106192        	s32i	a9, a1, 64
400a0aab:	f1e9      	s32i.n	a14, a1, 60
400a0aad:	04dd      	mov.n	a13, a4
400a0aaf:	0a2c      	movi.n	a10, 32
400a0ab1:	000fe0        	callx8	a15
400a0ab4:	f1e8      	l32i.n	a14, a1, 60
400a0ab6:	112182        	l32i	a8, a1, 68
400a0ab9:	102192        	l32i	a9, a1, 64
400a0abc:	0ecd      	mov.n	a12, a14
400a0abe:	000106        	j	400a0ac6 <_vsnprintf+0x742>
400a0ac1:	02cd      	mov.n	a12, a2
400a0ac3:	c08720        	sub	a8, a7, a2
400a0ac6:	81b8      	l32i.n	a11, a1, 32
400a0ac8:	a8ca      	add.n	a10, a8, a12
400a0aca:	d13ab7        	bltu	a10, a11, 400a0a9f <_vsnprintf+0x71b>
400a0acd:	080c      	movi.n	a8, 0
400a0acf:	023b77        	bltu	a11, a7, 400a0ad5 <_vsnprintf+0x751>
400a0ad2:	c08b70        	sub	a8, a11, a7
400a0ad5:	771b      	addi.n	a7, a7, 1
400a0ad7:	228a      	add.n	a2, a2, a8
400a0ad9:	787a      	add.n	a7, a8, a7
400a0adb:	000746        	j	400a0afc <_vsnprintf+0x778>
400a0ade:	a1b9      	s32i.n	a11, a1, 40
400a0ae0:	e81b      	addi.n	a14, a8, 1
400a0ae2:	08cd      	mov.n	a12, a8
400a0ae4:	c1b8      	l32i.n	a11, a1, 48
400a0ae6:	b188      	l32i.n	a8, a1, 44
400a0ae8:	106192        	s32i	a9, a1, 64
400a0aeb:	f1e9      	s32i.n	a14, a1, 60
400a0aed:	04dd      	mov.n	a13, a4
400a0aef:	0008e0        	callx8	a8
400a0af2:	f1e8      	l32i.n	a14, a1, 60
400a0af4:	102192        	l32i	a9, a1, 64
400a0af7:	0e8d      	mov.n	a8, a14
400a0af9:	000046        	j	400a0afe <_vsnprintf+0x77a>
400a0afc:	028d      	mov.n	a8, a2
400a0afe:	c0a820        	sub	a10, a8, a2
400a0b01:	a9aa      	add.n	a10, a9, a10
400a0b03:	000aa2        	l8ui	a10, a10, 0
400a0b06:	8a8c      	beqz.n	a10, 400a0b12 <_vsnprintf+0x78e>
400a0b08:	fd4616        	beqz	a6, 400a0ae0 <_vsnprintf+0x75c>
400a0b0b:	a1c8      	l32i.n	a12, a1, 40
400a0b0d:	bc0b      	addi.n	a11, a12, -1
400a0b0f:	fcbc56        	bnez	a12, 400a0ade <_vsnprintf+0x75a>
400a0b12:	03bc      	beqz.n	a3, 400a0b46 <_vsnprintf+0x7c2>
400a0b14:	000606        	j	400a0b30 <_vsnprintf+0x7ac>
400a0b17:	c1b8      	l32i.n	a11, a1, 48
400a0b19:	b168      	l32i.n	a6, a1, 44
400a0b1b:	116182        	s32i	a8, a1, 68
400a0b1e:	04dd      	mov.n	a13, a4
400a0b20:	0a2c      	movi.n	a10, 32
400a0b22:	01cc32        	addi	a3, a12, 1
400a0b25:	0006e0        	callx8	a6
400a0b28:	112182        	l32i	a8, a1, 68
400a0b2b:	03cd      	mov.n	a12, a3
400a0b2d:	000106        	j	400a0b35 <_vsnprintf+0x7b1>
400a0b30:	08cd      	mov.n	a12, a8
400a0b32:	c02780        	sub	a2, a7, a8
400a0b35:	8198      	l32i.n	a9, a1, 32
400a0b37:	32ca      	add.n	a3, a2, a12
400a0b39:	da3397        	bltu	a3, a9, 400a0b17 <_vsnprintf+0x793>
400a0b3c:	020c      	movi.n	a2, 0
400a0b3e:	023977        	bltu	a9, a7, 400a0b44 <_vsnprintf+0x7c0>
400a0b41:	c02970        	sub	a2, a9, a7
400a0b44:	882a      	add.n	a8, a8, a2
400a0b46:	082d      	mov.n	a2, a8
400a0b48:	001406        	j	400a0b9c <_vsnprintf+0x818>
400a0b4b:	172c      	movi.n	a7, 33
400a0b4d:	564b      	addi.n	a5, a6, 4
400a0b4f:	881c      	movi.n	a8, 24
400a0b51:	207370        	or	a7, a3, a7
400a0b54:	e138      	l32i.n	a3, a1, 56
400a0b56:	06a857        	bge	a8, a5, 400a0b60 <_vsnprintf+0x7dc>
400a0b59:	012867        	blt	a8, a6, 400a0b5e <_vsnprintf+0x7da>
400a0b5c:	452c      	movi.n	a5, 36
400a0b5e:	d138      	l32i.n	a3, a1, 52
400a0b60:	860c      	movi.n	a6, 8
400a0b62:	2169      	s32i.n	a6, a1, 8
400a0b64:	a168      	l32i.n	a6, a1, 40
400a0b66:	335a      	add.n	a3, a3, a5
400a0b68:	1169      	s32i.n	a6, a1, 4
400a0b6a:	061c      	movi.n	a6, 16
400a0b6c:	fcc332        	addi	a3, a3, -4
400a0b6f:	3179      	s32i.n	a7, a1, 12
400a0b71:	0169      	s32i.n	a6, a1, 0
400a0b73:	03e8      	l32i.n	a14, a3, 0
400a0b75:	0f0c      	movi.n	a15, 0
400a0b77:	ff1106        	j	400a07bf <_vsnprintf+0x43b>
400a0b7a:	c1b8      	l32i.n	a11, a1, 48
400a0b7c:	b188      	l32i.n	a8, a1, 44
400a0b7e:	04dd      	mov.n	a13, a4
400a0b80:	02cd      	mov.n	a12, a2
400a0b82:	01c232        	addi	a3, a2, 1
400a0b85:	0008e0        	callx8	a8
400a0b88:	000306        	j	400a0b98 <_vsnprintf+0x814>
400a0b8b:	c1b8      	l32i.n	a11, a1, 48
400a0b8d:	b198      	l32i.n	a9, a1, 44
400a0b8f:	04dd      	mov.n	a13, a4
400a0b91:	02cd      	mov.n	a12, a2
400a0b93:	321b      	addi.n	a3, a2, 1
400a0b95:	0009e0        	callx8	a9
400a0b98:	065d      	mov.n	a5, a6
400a0b9a:	032d      	mov.n	a2, a3
400a0b9c:	056d      	mov.n	a6, a5
400a0b9e:	9138      	l32i.n	a3, a1, 36
400a0ba0:	0003a2        	l8ui	a10, a3, 0
400a0ba3:	1a8c      	beqz.n	a10, 400a0ba8 <_vsnprintf+0x824>
400a0ba5:	fdfd86        	j	400a039f <_vsnprintf+0x1b>
400a0ba8:	02cd      	mov.n	a12, a2
400a0baa:	0e3247        	bltu	a2, a4, 400a0bbc <_vsnprintf+0x838>
400a0bad:	c40b      	addi.n	a12, a4, -1
400a0baf:	000246        	j	400a0bbc <_vsnprintf+0x838>
400a0bb2:	870c      	movi.n	a7, 8
400a0bb4:	fe90c6        	j	400a05fb <_vsnprintf+0x277>
400a0bb7:	270c      	movi.n	a7, 2
400a0bb9:	fe8f86        	j	400a05fb <_vsnprintf+0x277>
400a0bbc:	c1b8      	l32i.n	a11, a1, 48
400a0bbe:	b168      	l32i.n	a6, a1, 44
400a0bc0:	04dd      	mov.n	a13, a4
400a0bc2:	00a0a2        	movi	a10, 0
400a0bc5:	0006e0        	callx8	a6
400a0bc8:	f01d      	retw.n
400a0bca:	00          	.byte 00
400a0bcb:	00          	.byte 00
400a0bcc:	10 30 fe 3f 	
400a0bd0:	48 f0 f1 3f 	
400a0bd4:	4c f0 f1 3f 	

400a0bd8 <pid_prepare>:
400a0bd8:	004136        	entry	a1, 32
400a0bdb:	ff4465        	call8	400a0020 <get_cpu_index>
400a0bde:	11aa90        	slli	a10, a10, 7
400a0be1:	fffa81        	l32r	a8, 400a0bcc <_vsnprintf+0x848>
400a0be4:	88aa      	add.n	a8, a8, a10
400a0be6:	1a2882        	l32i	a8, a8, 104
400a0be9:	0c0892        	l8ui	a9, a8, 12
400a0bec:	fff981        	l32r	a8, 400a0bd0 <_vsnprintf+0x84c>
400a0bef:	0020c0        	memw
400a0bf2:	0899      	s32i.n	a9, a8, 0
400a0bf4:	fff881        	l32r	a8, 400a0bd4 <_vsnprintf+0x850>
400a0bf7:	190c      	movi.n	a9, 1
400a0bf9:	0020c0        	memw
400a0bfc:	0899      	s32i.n	a9, a8, 0
400a0bfe:	f01d      	retw.n
400a0c00:	10 31 fe 3f 	

400a0c04 <umm_disconnect_from_free_list>:
400a0c04:	004136        	entry	a1, 32
400a0c07:	fffe81        	l32r	a8, 400a0c00 <pid_prepare+0x28>
400a0c0a:	08a8      	l32i.n	a10, a8, 0
400a0c0c:	b022a0        	addx8	a2, a2, a10
400a0c0f:	070282        	l8ui	a8, a2, 7
400a0c12:	060292        	l8ui	a9, a2, 6
400a0c15:	118880        	slli	a8, a8, 8
400a0c18:	0502b2        	l8ui	a11, a2, 5
400a0c1b:	0402c2        	l8ui	a12, a2, 4
400a0c1e:	208890        	or	a8, a8, a9
400a0c21:	b098a0        	addx8	a9, a8, a10
400a0c24:	0449c2        	s8i	a12, a9, 4
400a0c27:	0549b2        	s8i	a11, a9, 5
400a0c2a:	050292        	l8ui	a9, a2, 5
400a0c2d:	0402b2        	l8ui	a11, a2, 4
400a0c30:	119980        	slli	a9, a9, 8
400a0c33:	2099b0        	or	a9, a9, a11
400a0c36:	b099a0        	addx8	a9, a9, a10
400a0c39:	064982        	s8i	a8, a9, 6
400a0c3c:	418880        	srli	a8, a8, 8
400a0c3f:	074982        	s8i	a8, a9, 7
400a0c42:	010282        	l8ui	a8, a2, 1
400a0c45:	000292        	l8ui	a9, a2, 0
400a0c48:	118880        	slli	a8, a8, 8
400a0c4b:	208890        	or	a8, a8, a9
400a0c4e:	004282        	s8i	a8, a2, 0
400a0c51:	648880        	extui	a8, a8, 8, 7
400a0c54:	014282        	s8i	a8, a2, 1
400a0c57:	f01d      	retw.n
400a0c59:	00          	.byte 00
400a0c5a:	00          	.byte 00
400a0c5b:	00          	.byte 00
400a0c5c:	4c 00 0a 40 	

400a0c60 <printf_>:
400a0c60:	00c136        	entry	a1, 96
400a0c63:	20c192        	addi	a9, a1, 32
400a0c66:	40c1a2        	addi	a10, a1, 64
400a0c69:	480c      	movi.n	a8, 4
400a0c6b:	41a9      	s32i.n	a10, a1, 16
400a0c6d:	01a9      	s32i.n	a10, a1, 0
400a0c6f:	02dd      	mov.n	a13, a2
400a0c71:	9139      	s32i.n	a3, a1, 36
400a0c73:	a149      	s32i.n	a4, a1, 40
400a0c75:	b159      	s32i.n	a5, a1, 44
400a0c77:	c169      	s32i.n	a6, a1, 48
400a0c79:	d179      	s32i.n	a7, a1, 52
400a0c7b:	5199      	s32i.n	a9, a1, 20
400a0c7d:	6189      	s32i.n	a8, a1, 24
400a0c7f:	1199      	s32i.n	a9, a1, 4
400a0c81:	2189      	s32i.n	a8, a1, 8
400a0c83:	fc7c      	movi.n	a12, -1
400a0c85:	1cc1b2        	addi	a11, a1, 28
400a0c88:	fff5a1        	l32r	a10, 400a0c5c <umm_disconnect_from_free_list+0x58>
400a0c8b:	ff6fa5        	call8	400a0384 <_vsnprintf>
400a0c8e:	0a2d      	mov.n	a2, a10
400a0c90:	f01d      	retw.n
400a0c92:	00          	.byte 00
400a0c93:	00          	.byte 00
400a0c94:	2a 00 fe 3f 	
400a0c98:	38 00 fe 3f 	
400a0c9c:	a0 06 fe 3f 	
400a0ca0:	3f 00 fe 3f 	
400a0ca4:	44 00 fe 3f 	
400a0ca8:	3c 00 fe 3f 	
400a0cac:	38 00 fe 3f 	
400a0cb0:	4f 00 fe 3f 	

400a0cb4 <task_regs_dump>:
400a0cb4:	004136        	entry	a1, 32
400a0cb7:	4422b2        	l32i	a11, a2, 0x110
400a0cba:	fff6a1        	l32r	a10, 400a0c94 <printf_+0x34>
400a0cbd:	fffa25        	call8	400a0c60 <printf_>
400a0cc0:	fff6a1        	l32r	a10, 400a0c98 <printf_+0x38>
400a0cc3:	fff9e5        	call8	400a0c60 <printf_>
400a0cc6:	00a032        	movi	a3, 0
400a0cc9:	fff461        	l32r	a6, 400a0c9c <printf_+0x3c>
400a0ccc:	fff5a1        	l32r	a10, 400a0ca0 <printf_+0x40>
400a0ccf:	07a072        	movi	a7, 7
400a0cd2:	fff8e5        	call8	400a0c60 <printf_>
400a0cd5:	b05360        	addx8	a5, a3, a6
400a0cd8:	040c      	movi.n	a4, 0
400a0cda:	c07730        	sub	a7, a7, a3
400a0cdd:	171477        	beq	a4, a7, 400a0cf8 <task_regs_dump+0x44>
400a0ce0:	1588      	l32i.n	a8, a5, 4
400a0ce2:	05b8      	l32i.n	a11, a5, 0
400a0ce4:	828a      	add.n	a8, a2, a8
400a0ce6:	0028c2        	l32i	a12, a8, 0
400a0ce9:	ffeea1        	l32r	a10, 400a0ca4 <printf_+0x44>
400a0cec:	01c442        	addi	a4, a4, 1
400a0cef:	fff725        	call8	400a0c60 <printf_>
400a0cf2:	08c552        	addi	a5, a5, 8
400a0cf5:	e44466        	bnei	a4, 4, 400a0cdd <task_regs_dump+0x29>
400a0cf8:	ffeca1        	l32r	a10, 400a0ca8 <printf_+0x48>
400a0cfb:	334b      	addi.n	a3, a3, 4
400a0cfd:	fff625        	call8	400a0c60 <printf_>
400a0d00:	c88366        	bnei	a3, 8, 400a0ccc <task_regs_dump+0x18>
400a0d03:	ffeaa1        	l32r	a10, 400a0cac <printf_+0x4c>
400a0d06:	fff5a5        	call8	400a0c60 <printf_>
400a0d09:	040c      	movi.n	a4, 0
400a0d0b:	ffe951        	l32r	a5, 400a0cb0 <printf_+0x50>
400a0d0e:	000706        	j	400a0d2e <task_regs_dump+0x7a>
400a0d11:	00          	.byte 00
400a0d12:	00          	.byte 00
400a0d13:	00          	.byte 00
400a0d14:	3f 00 fe 3f 	
400a0d18:	3c 00 fe 3f 	
400a0d1c:	38 00 fe 3f 	
400a0d20:	5b 00 fe 3f 	
400a0d24:	3f 00 fe 3f 	
400a0d28:	68 00 fe 3f 	
400a0d2c:	034d      	mov.n	a4, a3
400a0d2e:	fff9a1        	l32r	a10, 400a0d14 <task_regs_dump+0x60>
400a0d31:	fff2e5        	call8	400a0c60 <printf_>
400a0d34:	043d      	mov.n	a3, a4
400a0d36:	a06320        	addx4	a6, a3, a2
400a0d39:	06c8      	l32i.n	a12, a6, 0
400a0d3b:	03bd      	mov.n	a11, a3
400a0d3d:	20a550        	or	a10, a5, a5
400a0d40:	01c332        	addi	a3, a3, 1
400a0d43:	644b      	addi.n	a6, a4, 4
400a0d45:	fff1a5        	call8	400a0c60 <printf_>
400a0d48:	ea9637        	bne	a6, a3, 400a0d36 <task_regs_dump+0x82>
400a0d4b:	fff3a1        	l32r	a10, 400a0d18 <task_regs_dump+0x64>
400a0d4e:	fff125        	call8	400a0c60 <printf_>
400a0d51:	d7b366        	bnei	a3, 16, 400a0d2c <task_regs_dump+0x78>
400a0d54:	fff2a1        	l32r	a10, 400a0d1c <task_regs_dump+0x68>
400a0d57:	fff0a5        	call8	400a0c60 <printf_>
400a0d5a:	04a032        	movi	a3, 4
400a0d5d:	fff041        	l32r	a4, 400a0d20 <task_regs_dump+0x6c>
400a0d60:	fff1a1        	l32r	a10, 400a0d24 <task_regs_dump+0x70>
400a0d63:	ffefe5        	call8	400a0c60 <printf_>
400a0d66:	fcc352        	addi	a5, a3, -4
400a0d69:	462282        	l32i	a8, a2, 0x118
400a0d6c:	1188e0        	slli	a8, a8, 2
400a0d6f:	c08580        	sub	a8, a5, a8
400a0d72:	0028d6        	bgez	a8, 400a0d78 <task_regs_dump+0xc4>
400a0d75:	40c882        	addi	a8, a8, 64
400a0d78:	a08820        	addx4	a8, a8, a2
400a0d7b:	08c8      	l32i.n	a12, a8, 0
400a0d7d:	05bd      	mov.n	a11, a5
400a0d7f:	20a440        	or	a10, a4, a4
400a0d82:	146050        	extui	a6, a5, 0, 2
400a0d85:	ffeda5        	call8	400a0c60 <printf_>
400a0d88:	283666        	bnei	a6, 3, 400a0db4 <task_regs_dump+0x100>
400a0d8b:	472262        	l32i	a6, a2, 0x11c
400a0d8e:	217250        	srai	a7, a5, 2
400a0d91:	462292        	l32i	a9, a2, 0x118
400a0d94:	180c      	movi.n	a8, 1
400a0d96:	401700        	ssl	a7
400a0d99:	a18800        	sll	a8, a8
400a0d9c:	108860        	and	a8, a8, a6
400a0d9f:	c09970        	sub	a9, a9, a7
400a0da2:	062c      	movi.n	a6, 32
400a0da4:	dc3c      	movi.n	a12, 61
400a0da6:	cb3c      	movi.n	a11, 60
400a0da8:	93c690        	movnez	a12, a6, a9
400a0dab:	83b680        	moveqz	a11, a6, a8
400a0dae:	ffdea1        	l32r	a10, 400a0d28 <task_regs_dump+0x74>
400a0db1:	ffeae5        	call8	400a0c60 <printf_>
400a0db4:	551b      	addi.n	a5, a5, 1
400a0db6:	af9537        	bne	a5, a3, 400a0d69 <task_regs_dump+0xb5>
400a0db9:	354b      	addi.n	a3, a5, 4
400a0dbb:	454c      	movi.n	a5, 68
400a0dbd:	9f9357        	bne	a3, a5, 400a0d60 <task_regs_dump+0xac>
400a0dc0:	f01d      	retw.n
400a0dc2:	00          	.byte 00
400a0dc3:	00          	.byte 00
400a0dc4:	6f 00 fe 3f 	
400a0dc8:	0e 07 fe 3f 	
400a0dcc:	7f 00 fe 3f 	
400a0dd0:	8a 00 fe 3f 	

400a0dd4 <cas_task_state$part$0>:
400a0dd4:	004136        	entry	a1, 32
400a0dd7:	529347        	bne	a3, a4, 400a0e2d <cas_task_state$part$0+0x59>
400a0dda:	92a0e2        	movi	a14, 146
400a0ddd:	fff9d1        	l32r	a13, 400a0dc4 <task_regs_dump+0x110>
400a0de0:	fffac1        	l32r	a12, 400a0dc8 <task_regs_dump+0x114>
400a0de3:	fffab1        	l32r	a11, 400a0dcc <task_regs_dump+0x118>
400a0de6:	fffaa1        	l32r	a10, 400a0dd0 <task_regs_dump+0x11c>
400a0de9:	ffe765        	call8	400a0c60 <printf_>
400a0dec:	ffff06        	j	400a0dec <cas_task_state$part$0+0x18>
400a0def:	00          	.byte 00
400a0df0:	6f 00 fe 3f 	
400a0df4:	0e 07 fe 3f 	
400a0df8:	b1 00 fe 3f 	
400a0dfc:	8a 00 fe 3f 	
400a0e00:	262282        	l32i	a8, a2, 152
400a0e03:	1e3366        	bnei	a3, 3, 400a0e25 <cas_task_state$part$0+0x51>
400a0e06:	1b1866        	bnei	a8, 1, 400a0e25 <cas_task_state$part$0+0x51>
400a0e09:	99a0e2        	movi	a14, 153
400a0e0c:	fff9d1        	l32r	a13, 400a0df0 <cas_task_state$part$0+0x1c>
400a0e0f:	fff9c1        	l32r	a12, 400a0df4 <cas_task_state$part$0+0x20>
400a0e12:	fff9b1        	l32r	a11, 400a0df8 <cas_task_state$part$0+0x24>
400a0e15:	fff9a1        	l32r	a10, 400a0dfc <cas_task_state$part$0+0x28>
400a0e18:	ffe465        	call8	400a0c60 <printf_>
400a0e1b:	ffff06        	j	400a0e1b <cas_task_state$part$0+0x47>
400a0e1e:	880b      	addi.n	a8, a8, -1
400a0e20:	38cc      	bnez.n	a8, 400a0e27 <cas_task_state$part$0+0x53>
400a0e22:	0001c6        	j	400a0e2d <cas_task_state$part$0+0x59>
400a0e25:	a80c      	movi.n	a8, 10
400a0e27:	262292        	l32i	a9, a2, 152
400a0e2a:	f09397        	bne	a3, a9, 400a0e1e <cas_task_state$part$0+0x4a>
400a0e2d:	048d      	mov.n	a8, a4
400a0e2f:	130c30        	wsr.scompare1	a3
400a0e32:	26e282        	s32c1i	a8, a2, 152
400a0e35:	c79837        	bne	a8, a3, 400a0e00 <cas_task_state$part$0+0x2c>
400a0e38:	f01d      	retw.n
400a0e3a:	00          	.byte 00
400a0e3b:	00          	.byte 00
400a0e3c:	10 30 fe 3f 	

400a0e40 <mmu_activate>:
400a0e40:	006136        	entry	a1, 48
400a0e43:	ff1de5        	call8	400a0020 <get_cpu_index>
400a0e46:	117a90        	slli	a7, a10, 7
400a0e49:	fffc41        	l32r	a4, 400a0e3c <cas_task_state$part$0+0x68>
400a0e4c:	060c      	movi.n	a6, 0
400a0e4e:	774a      	add.n	a7, a7, a4
400a0e50:	065d      	mov.n	a5, a6
400a0e52:	113ad0        	slli	a3, a10, 3
400a0e55:	690c      	movi.n	a9, 6
400a0e57:	6c8976        	loop	a9, 400a0ec7 <mmu_activate+0x87>
400a0e5a:	4788      	l32i.n	a8, a7, 16
400a0e5c:	489287        	bne	a2, a8, 400a0ea8 <mmu_activate+0x68>
400a0e5f:	ff1c25        	call8	400a0020 <get_cpu_index>
400a0e62:	236a      	add.n	a2, a3, a6
400a0e64:	11aa90        	slli	a10, a10, 7
400a0e67:	1122c0        	slli	a2, a2, 4
400a0e6a:	a4aa      	add.n	a10, a4, a10
400a0e6c:	228b      	addi.n	a2, a2, 8
400a0e6e:	1a2a52        	l32i	a5, a10, 104
400a0e71:	242a      	add.n	a2, a4, a2
400a0e73:	029257        	bne	a2, a5, 400a0e79 <mmu_activate+0x39>
400a0e76:	00a1c6        	j	400a1101 <mmu_activate+0x2c1>
400a0e79:	ff1a65        	call8	400a0020 <get_cpu_index>
400a0e7c:	11aa90        	slli	a10, a10, 7
400a0e7f:	54aa      	add.n	a5, a4, a10
400a0e81:	0588      	l32i.n	a8, a5, 0
400a0e83:	1598      	l32i.n	a9, a5, 4
400a0e85:	b81b      	addi.n	a11, a8, 1
400a0e87:	170c      	movi.n	a7, 1
400a0e89:	013b87        	bltu	a11, a8, 400a0e8e <mmu_activate+0x4e>
400a0e8c:	070c      	movi.n	a7, 0
400a0e8e:	636a      	add.n	a6, a3, a6
400a0e90:	1166c0        	slli	a6, a6, 4
400a0e93:	646a      	add.n	a6, a4, a6
400a0e95:	779a      	add.n	a7, a7, a9
400a0e97:	a4aa      	add.n	a10, a4, a10
400a0e99:	05b9      	s32i.n	a11, a5, 0
400a0e9b:	1579      	s32i.n	a7, a5, 4
400a0e9d:	2689      	s32i.n	a8, a6, 8
400a0e9f:	3699      	s32i.n	a9, a6, 12
400a0ea1:	1a6a22        	s32i	a2, a10, 104
400a0ea4:	009646        	j	400a1101 <mmu_activate+0x2c1>
400a0ea7:	00          	.byte 00
400a0ea8:	835a      	add.n	a8, a3, a5
400a0eaa:	1188c0        	slli	a8, a8, 4
400a0ead:	848a      	add.n	a8, a4, a8
400a0eaf:	38b8      	l32i.n	a11, a8, 12
400a0eb1:	37a8      	l32i.n	a10, a7, 12
400a0eb3:	093ab7        	bltu	a10, a11, 400a0ec0 <mmu_activate+0x80>
400a0eb6:	089ba7        	bne	a11, a10, 400a0ec2 <mmu_activate+0x82>
400a0eb9:	2888      	l32i.n	a8, a8, 8
400a0ebb:	27a8      	l32i.n	a10, a7, 8
400a0ebd:	01ba87        	bgeu	a10, a8, 400a0ec2 <mmu_activate+0x82>
400a0ec0:	065d      	mov.n	a5, a6
400a0ec2:	661b      	addi.n	a6, a6, 1
400a0ec4:	10c772        	addi	a7, a7, 16
400a0ec7:	635a      	add.n	a6, a3, a5
400a0ec9:	1166c0        	slli	a6, a6, 4
400a0ecc:	768b      	addi.n	a7, a6, 8
400a0ece:	847a      	add.n	a8, a4, a7
400a0ed0:	646a      	add.n	a6, a4, a6
400a0ed2:	006182        	s32i	a8, a1, 0
400a0ed5:	ff14a5        	call8	400a0020 <get_cpu_index>
400a0ed8:	4698      	l32i.n	a9, a6, 16
400a0eda:	11a9      	s32i.n	a10, a1, 4
400a0edc:	4629      	s32i.n	a2, a6, 16
400a0ede:	e9ec      	bnez.n	a9, 400a0f10 <mmu_activate+0xd0>
400a0ee0:	0168      	l32i.n	a6, a1, 0
400a0ee2:	02cd      	mov.n	a12, a2
400a0ee4:	226262        	s32i	a6, a2, 136
400a0ee7:	635a      	add.n	a6, a3, a5
400a0ee9:	1166c0        	slli	a6, a6, 4
400a0eec:	646a      	add.n	a6, a4, a6
400a0eee:	1406b2        	l8ui	a11, a6, 20
400a0ef1:	080c      	movi.n	a8, 0
400a0ef3:	24d0b0        	extui	a13, a11, 0, 3
400a0ef6:	0f7c      	movi.n	a15, -16
400a0ef8:	11ddc0        	slli	a13, a13, 4
400a0efb:	8faf62        	movi	a6, -113
400a0efe:	0e1c      	movi.n	a14, 16
400a0f00:	003806        	j	400a0fe4 <mmu_activate+0x1a4>
400a0f03:	00          	.byte 00
400a0f04:	04 05 f0 3f 	
400a0f08:	44 05 f0 3f 	
400a0f0c:	2c 03 f0 3f 	
400a0f10:	222962        	l32i	a6, a9, 136
400a0f13:	00a082        	movi	a8, 0
400a0f16:	0c06a2        	l8ui	a10, a6, 12
400a0f19:	fffae1        	l32r	a14, 400a0f04 <mmu_activate+0xc4>
400a0f1c:	8fafd2        	movi	a13, -113
400a0f1f:	fffaf1        	l32r	a15, 400a0f08 <mmu_activate+0xc8>
400a0f22:	10a072        	movi	a7, 16
400a0f25:	3f8776        	loop	a7, 400a0f68 <mmu_activate+0x128>
400a0f28:	a0b8e0        	addx4	a11, a8, a14
400a0f2b:	0020c0        	memw
400a0f2e:	000bc2        	l8ui	a12, a11, 0
400a0f31:	1168e0        	slli	a6, a8, 2
400a0f34:	24c4c0        	extui	a12, a12, 4, 3
400a0f37:	0e9ac7        	bne	a10, a12, 400a0f49 <mmu_activate+0x109>
400a0f3a:	0020c0        	memw
400a0f3d:	000bc2        	l8ui	a12, a11, 0
400a0f40:	10ccd0        	and	a12, a12, a13
400a0f43:	0020c0        	memw
400a0f46:	004bc2        	s8i	a12, a11, 0
400a0f49:	6f6a      	add.n	a6, a15, a6
400a0f4b:	0020c0        	memw
400a0f4e:	0006b2        	l8ui	a11, a6, 0
400a0f51:	24b4b0        	extui	a11, a11, 4, 3
400a0f54:	0e9ab7        	bne	a10, a11, 400a0f66 <mmu_activate+0x126>
400a0f57:	0020c0        	memw
400a0f5a:	0006b2        	l8ui	a11, a6, 0
400a0f5d:	10bbd0        	and	a11, a11, a13
400a0f60:	0020c0        	memw
400a0f63:	0046b2        	s8i	a11, a6, 0
400a0f66:	881b      	addi.n	a8, a8, 1
400a0f68:	202962        	l32i	a6, a9, 128
400a0f6b:	212972        	l32i	a7, a9, 132
400a0f6e:	207670        	or	a7, a6, a7
400a0f71:	f6b716        	beqz	a7, 400a0ee0 <mmu_activate+0xa0>
400a0f74:	608060        	neg	a8, a6
400a0f77:	108860        	and	a8, a8, a6
400a0f7a:	40f880        	nsau	a8, a8
400a0f7d:	1d0c      	movi.n	a13, 1
400a0f7f:	608080        	neg	a8, a8
400a0f82:	401a00        	ssl	a10
400a0f85:	a1ad00        	sll	a10, a13
400a0f88:	fe7c      	movi.n	a14, -1
400a0f8a:	20c882        	addi	a8, a8, 32
400a0f8d:	30aea0        	xor	a10, a14, a10
400a0f90:	ffdff1        	l32r	a15, 400a0f0c <mmu_activate+0xcc>
400a0f93:	000d86        	j	400a0fcd <mmu_activate+0x18d>
400a0f96:	401800        	ssl	a8
400a0f99:	a16d00        	sll	a6, a13
400a0f9c:	a066f0        	addx4	a6, a6, a15
400a0f9f:	0020c0        	memw
400a0fa2:	0678      	l32i.n	a7, a6, 0
400a0fa4:	308e80        	xor	a8, a14, a8
400a0fa7:	1077a0        	and	a7, a7, a10
400a0faa:	0020c0        	memw
400a0fad:	0679      	s32i.n	a7, a6, 0
400a0faf:	316f80        	srai	a6, a8, 31
400a0fb2:	1066b0        	and	a6, a6, a11
400a0fb5:	1088c0        	and	a8, a8, a12
400a0fb8:	216962        	s32i	a6, a9, 132
400a0fbb:	606080        	neg	a6, a8
400a0fbe:	106680        	and	a6, a6, a8
400a0fc1:	40f660        	nsau	a6, a6
400a0fc4:	606060        	neg	a6, a6
400a0fc7:	206982        	s32i	a8, a9, 128
400a0fca:	20c682        	addi	a8, a6, 32
400a0fcd:	2029c2        	l32i	a12, a9, 128
400a0fd0:	2129b2        	l32i	a11, a9, 132
400a0fd3:	206cb0        	or	a6, a12, a11
400a0fd6:	fbc656        	bnez	a6, 400a0f96 <mmu_activate+0x156>
400a0fd9:	ffc0c6        	j	400a0ee0 <mmu_activate+0xa0>
400a0fdc:	04 05 f0 3f 	
400a0fe0:	44 05 f0 3f 	
400a0fe4:	a07820        	addx4	a7, a8, a2
400a0fe7:	002772        	l32i	a7, a7, 0
400a0fea:	147870        	extui	a7, a7, 8, 2
400a0fed:	2f1766        	bnei	a7, 1, 400a1020 <mmu_activate+0x1e0>
400a0ff0:	000c92        	l8ui	a9, a12, 0
400a0ff3:	fffaa1        	l32r	a10, 400a0fdc <mmu_activate+0x19c>
400a0ff6:	a099a0        	addx4	a9, a9, a10
400a0ff9:	0020c0        	memw
400a0ffc:	0009a2        	l8ui	a10, a9, 0
400a0fff:	347080        	extui	a7, a8, 0, 4
400a1002:	10aaf0        	and	a10, a10, a15
400a1005:	20aa70        	or	a10, a10, a7
400a1008:	0020c0        	memw
400a100b:	0049a2        	s8i	a10, a9, 0
400a100e:	0020c0        	memw
400a1011:	000972        	l8ui	a7, a9, 0
400a1014:	107760        	and	a7, a7, a6
400a1017:	2077d0        	or	a7, a7, a13
400a101a:	0020c0        	memw
400a101d:	004972        	s8i	a7, a9, 0
400a1020:	a07820        	addx4	a7, a8, a2
400a1023:	102772        	l32i	a7, a7, 64
400a1026:	147870        	extui	a7, a7, 8, 2
400a1029:	2f1766        	bnei	a7, 1, 400a105c <mmu_activate+0x21c>
400a102c:	400c92        	l8ui	a9, a12, 64
400a102f:	ffeca1        	l32r	a10, 400a0fe0 <mmu_activate+0x1a0>
400a1032:	a099a0        	addx4	a9, a9, a10
400a1035:	0020c0        	memw
400a1038:	0009a2        	l8ui	a10, a9, 0
400a103b:	347080        	extui	a7, a8, 0, 4
400a103e:	10aaf0        	and	a10, a10, a15
400a1041:	20aa70        	or	a10, a10, a7
400a1044:	0020c0        	memw
400a1047:	0049a2        	s8i	a10, a9, 0
400a104a:	0020c0        	memw
400a104d:	000972        	l8ui	a7, a9, 0
400a1050:	107760        	and	a7, a7, a6
400a1053:	2077d0        	or	a7, a7, a13
400a1056:	0020c0        	memw
400a1059:	004972        	s8i	a7, a9, 0
400a105c:	881b      	addi.n	a8, a8, 1
400a105e:	cc4b      	addi.n	a12, a12, 4
400a1060:	ee0b      	addi.n	a14, a14, -1
400a1062:	f7ee56        	bnez	a14, 400a0fe4 <mmu_activate+0x1a4>
400a1065:	202272        	l32i	a7, a2, 128
400a1068:	212262        	l32i	a6, a2, 132
400a106b:	206760        	or	a6, a7, a6
400a106e:	26fc      	bnez.n	a6, 400a10a4 <mmu_activate+0x264>
400a1070:	1168      	l32i.n	a6, a1, 4
400a1072:	170c      	movi.n	a7, 1
400a1074:	112690        	slli	a2, a6, 7
400a1077:	642a      	add.n	a6, a4, a2
400a1079:	0688      	l32i.n	a8, a6, 0
400a107b:	1698      	l32i.n	a9, a6, 4
400a107d:	a81b      	addi.n	a10, a8, 1
400a107f:	013a87        	bltu	a10, a8, 400a1084 <mmu_activate+0x244>
400a1082:	070c      	movi.n	a7, 0
400a1084:	335a      	add.n	a3, a3, a5
400a1086:	1133c0        	slli	a3, a3, 4
400a1089:	343a      	add.n	a3, a4, a3
400a108b:	2389      	s32i.n	a8, a3, 8
400a108d:	0188      	l32i.n	a8, a1, 0
400a108f:	779a      	add.n	a7, a7, a9
400a1091:	242a      	add.n	a2, a4, a2
400a1093:	06a9      	s32i.n	a10, a6, 0
400a1095:	1679      	s32i.n	a7, a6, 4
400a1097:	3399      	s32i.n	a9, a3, 12
400a1099:	1a6282        	s32i	a8, a2, 104
400a109c:	001846        	j	400a1101 <mmu_activate+0x2c1>
400a109f:	00          	.byte 00
400a10a0:	2c 03 f0 3f 	
400a10a4:	606070        	neg	a6, a7
400a10a7:	106670        	and	a6, a6, a7
400a10aa:	40f660        	nsau	a6, a6
400a10ad:	606060        	neg	a6, a6
400a10b0:	180c      	movi.n	a8, 1
400a10b2:	20c662        	addi	a6, a6, 32
400a10b5:	401b00        	ssl	a11
400a10b8:	a1b800        	sll	a11, a8
400a10bb:	fff991        	l32r	a9, 400a10a0 <mmu_activate+0x260>
400a10be:	fa7c      	movi.n	a10, -1
400a10c0:	000b86        	j	400a10f2 <mmu_activate+0x2b2>
400a10c3:	401600        	ssl	a6
400a10c6:	a1c800        	sll	a12, a8
400a10c9:	a0cc90        	addx4	a12, a12, a9
400a10cc:	306a60        	xor	a6, a10, a6
400a10cf:	0020c0        	memw
400a10d2:	0cb9      	s32i.n	a11, a12, 0
400a10d4:	31cf60        	srai	a12, a6, 31
400a10d7:	107670        	and	a7, a6, a7
400a10da:	106cd0        	and	a6, a12, a13
400a10dd:	216262        	s32i	a6, a2, 132
400a10e0:	606070        	neg	a6, a7
400a10e3:	106670        	and	a6, a6, a7
400a10e6:	40f660        	nsau	a6, a6
400a10e9:	606060        	neg	a6, a6
400a10ec:	206272        	s32i	a7, a2, 128
400a10ef:	20c662        	addi	a6, a6, 32
400a10f2:	202272        	l32i	a7, a2, 128
400a10f5:	2122d2        	l32i	a13, a2, 132
400a10f8:	20c7d0        	or	a12, a7, a13
400a10fb:	fc4c56        	bnez	a12, 400a10c3 <mmu_activate+0x283>
400a10fe:	ffdb86        	j	400a1070 <mmu_activate+0x230>
400a1101:	f01d      	retw.n
400a1103:	00          	.byte 00
400a1104:	10 31 fe 3f 	
400a1108:	ff 7f 00 00 	

400a110c <create_task>:
400a110c:	010136        	entry	a1, 128
400a110f:	106162        	s32i	a6, a1, 64
400a1112:	e149      	s32i.n	a4, a1, 56
400a1114:	f159      	s32i.n	a5, a1, 60
400a1116:	116172        	s32i	a7, a1, 68
400a1119:	026d      	mov.n	a6, a2
400a111b:	fffa21        	l32r	a2, 400a1104 <mmu_activate+0x2c4>
400a111e:	0248      	l32i.n	a4, a2, 0
400a1120:	050422        	l8ui	a2, a4, 5
400a1123:	040452        	l8ui	a5, a4, 4
400a1126:	112280        	slli	a2, a2, 8
400a1129:	202250        	or	a2, a2, a5
400a112c:	02ad      	mov.n	a10, a2
400a112e:	fff651        	l32r	a5, 400a1108 <mmu_activate+0x2c8>
400a1131:	080c      	movi.n	a8, 0
400a1133:	591c      	movi.n	a9, 21
400a1135:	000dc6        	j	400a1170 <create_task+0x64>
400a1138:	b07a40        	addx8	a7, a10, a4
400a113b:	010782        	l8ui	a8, a7, 1
400a113e:	0007b2        	l8ui	a11, a7, 0
400a1141:	118880        	slli	a8, a8, 8
400a1144:	2088b0        	or	a8, a8, a11
400a1147:	e48080        	extui	a8, a8, 0, 15
400a114a:	c088a0        	sub	a8, a8, a10
400a114d:	f48080        	extui	a8, a8, 0, 16
400a1150:	02b987        	bgeu	a9, a8, 400a1156 <create_task+0x4a>
400a1153:	093857        	bltu	a8, a5, 400a1160 <create_task+0x54>
400a1156:	02ad      	mov.n	a10, a2
400a1158:	000186        	j	400a1162 <create_task+0x56>
400a115b:	00          	.byte 00
400a115c:	ff 7f 00 00 	
400a1160:	085d      	mov.n	a5, a8
400a1162:	0407b2        	l8ui	a11, a7, 4
400a1165:	050772        	l8ui	a7, a7, 5
400a1168:	0a2d      	mov.n	a2, a10
400a116a:	117780        	slli	a7, a7, 8
400a116d:	20a7b0        	or	a10, a7, a11
400a1170:	fc4a56        	bnez	a10, 400a1138 <create_task+0x2c>
400a1173:	fffa71        	l32r	a7, 400a115c <create_task+0x50>
400a1176:	c07570        	sub	a7, a5, a7
400a1179:	93a270        	movnez	a10, a2, a7
400a117c:	938570        	movnez	a8, a5, a7
400a117f:	b05a40        	addx8	a5, a10, a4
400a1182:	010522        	l8ui	a2, a5, 1
400a1185:	000572        	l8ui	a7, a5, 0
400a1188:	112280        	slli	a2, a2, 8
400a118b:	202270        	or	a2, a2, a7
400a118e:	e4b020        	extui	a11, a2, 0, 15
400a1191:	2c9b16        	beqz	a11, 400a145e <create_task+0x352>
400a1194:	521c      	movi.n	a2, 21
400a1196:	023287        	bltu	a2, a8, 400a119c <create_task+0x90>
400a1199:	00b046        	j	400a145e <create_task+0x352>
400a119c:	621c      	movi.n	a2, 22
400a119e:	169827        	bne	a8, a2, 400a11b8 <create_task+0xac>
400a11a1:	ffa625        	call8	400a0c04 <umm_disconnect_from_free_list>
400a11a4:	002386        	j	400a1236 <create_task+0x12a>
400a11a7:	00          	.byte 00
400a11a8:	00 80 00 00 	
400a11ac:	4c c4 00 40 	
400a11b0:	00 30 fe 3f 	
400a11b4:	2e 09 fe 3f 	
400a11b8:	16ca22        	addi	a2, a10, 22
400a11bb:	fffb71        	l32r	a7, 400a11a8 <create_task+0x9c>
400a11be:	b09240        	addx8	a9, a2, a4
400a11c1:	207b70        	or	a7, a11, a7
400a11c4:	0249a2        	s8i	a10, a9, 2
400a11c7:	417870        	srli	a7, a7, 8
400a11ca:	f4a8a0        	extui	a10, a10, 8, 16
400a11cd:	0049b2        	s8i	a11, a9, 0
400a11d0:	0349a2        	s8i	a10, a9, 3
400a11d3:	014972        	s8i	a7, a9, 1
400a11d6:	010582        	l8ui	a8, a5, 1
400a11d9:	000572        	l8ui	a7, a5, 0
400a11dc:	118880        	slli	a8, a8, 8
400a11df:	208870        	or	a8, a8, a7
400a11e2:	e48080        	extui	a8, a8, 0, 15
400a11e5:	74b020        	extui	a11, a2, 0, 8
400a11e8:	74a820        	extui	a10, a2, 8, 8
400a11eb:	b08840        	addx8	a8, a8, a4
400a11ee:	0248b2        	s8i	a11, a8, 2
400a11f1:	0348a2        	s8i	a10, a8, 3
400a11f4:	070582        	l8ui	a8, a5, 7
400a11f7:	060522        	l8ui	a2, a5, 6
400a11fa:	118880        	slli	a8, a8, 8
400a11fd:	208820        	or	a8, a8, a2
400a1200:	0045b2        	s8i	a11, a5, 0
400a1203:	0145a2        	s8i	a10, a5, 1
400a1206:	b02840        	addx8	a2, a8, a4
400a1209:	0442b2        	s8i	a11, a2, 4
400a120c:	0542a2        	s8i	a10, a2, 5
400a120f:	064982        	s8i	a8, a9, 6
400a1212:	418880        	srli	a8, a8, 8
400a1215:	074982        	s8i	a8, a9, 7
400a1218:	050582        	l8ui	a8, a5, 5
400a121b:	040522        	l8ui	a2, a5, 4
400a121e:	118880        	slli	a8, a8, 8
400a1221:	208820        	or	a8, a8, a2
400a1224:	b02840        	addx8	a2, a8, a4
400a1227:	0642b2        	s8i	a11, a2, 6
400a122a:	0742a2        	s8i	a10, a2, 7
400a122d:	044982        	s8i	a8, a9, 4
400a1230:	418880        	srli	a8, a8, 8
400a1233:	054982        	s8i	a8, a9, 5
400a1236:	254b      	addi.n	a2, a5, 4
400a1238:	0b0c      	movi.n	a11, 0
400a123a:	a8a0c2        	movi	a12, 168
400a123d:	02ad      	mov.n	a10, a2
400a123f:	ffdb81        	l32r	a8, 400a11ac <create_task+0xa0>
400a1242:	0008e0        	callx8	a8
400a1245:	ffda91        	l32r	a9, 400a11b0 <create_task+0xa4>
400a1248:	000982        	l8ui	a8, a9, 0
400a124b:	ffdab1        	l32r	a11, 400a11b4 <create_task+0xa8>
400a124e:	a81b      	addi.n	a10, a8, 1
400a1250:	570c      	movi.n	a7, 5
400a1252:	044582        	s8i	a8, a5, 4
400a1255:	001b82        	l16ui	a8, a11, 0
400a1258:	276572        	s32i	a7, a5, 156
400a125b:	0049a2        	s8i	a10, a9, 0
400a125e:	046856        	bnez	a8, 400a12a8 <create_task+0x19c>
400a1261:	c02240        	sub	a2, a2, a4
400a1264:	f46320        	extui	a6, a2, 3, 16
400a1267:	b05640        	addx8	a5, a6, a4
400a126a:	0105a2        	l8ui	a10, a5, 1
400a126d:	000522        	l8ui	a2, a5, 0
400a1270:	11aa80        	slli	a10, a10, 8
400a1273:	20aa20        	or	a10, a10, a2
400a1276:	b02a40        	addx8	a2, a10, a4
400a1279:	000232        	l8ui	a3, a2, 0
400a127c:	010222        	l8ui	a2, a2, 1
400a127f:	112280        	slli	a2, a2, 8
400a1282:	202230        	or	a2, a2, a3
400a1285:	232280        	sext	a2, a2, 15
400a1288:	1462d6        	bgez	a2, 400a13d2 <create_task+0x2c6>
400a128b:	004346        	j	400a139c <create_task+0x290>
400a128e:	00          	.byte 00
400a128f:	00          	.byte 00
400a1290:	e0 ff 01 00 	
400a1294:	64 11 00 00 	
400a1298:	4c c4 00 40 	
400a129c:	4c c4 00 40 	
400a12a0:	84 e3 09 40 	
400a12a4:	2c 00 0a 40 	
400a12a8:	60a080        	neg	a10, a8
400a12ab:	10aa80        	and	a10, a10, a8
400a12ae:	40faa0        	nsau	a10, a10
400a12b1:	60a0a0        	neg	a10, a10
400a12b4:	190c      	movi.n	a9, 1
400a12b6:	1fcaa2        	addi	a10, a10, 31
400a12b9:	401a00        	ssl	a10
400a12bc:	a1c900        	sll	a12, a9
400a12bf:	f47c      	movi.n	a4, -1
400a12c1:	3044c0        	xor	a4, a4, a12
400a12c4:	108840        	and	a8, a8, a4
400a12c7:	890542        	l8ui	a4, a5, 137
400a12ca:	005b82        	s16i	a8, a11, 0
400a12cd:	c87c      	movi.n	a8, -4
400a12cf:	104480        	and	a4, a4, a8
400a12d2:	204490        	or	a4, a4, a9
400a12d5:	894542        	s8i	a4, a5, 137
400a12d8:	ffee41        	l32r	a4, 400a1290 <create_task+0x184>
400a12db:	8845a2        	s8i	a10, a5, 136
400a12de:	aa4a      	add.n	a10, a10, a4
400a12e0:	11aa30        	slli	a10, a10, 13
400a12e3:	2965a2        	s32i	a10, a5, 164
400a12e6:	ffebc1        	l32r	a12, 400a1294 <create_task+0x188>
400a12e9:	0b0c      	movi.n	a11, 0
400a12eb:	ffeb81        	l32r	a8, 400a1298 <create_task+0x18c>
400a12ee:	0008e0        	callx8	a8
400a12f1:	292542        	l32i	a4, a5, 164
400a12f4:	490c      	movi.n	a9, 4
400a12f6:	11d482        	addmi	a8, a4, 0x1100
400a12f9:	09cd      	mov.n	a12, a9
400a12fb:	0b0c      	movi.n	a11, 0
400a12fd:	54c8a2        	addi	a10, a8, 84
400a1300:	146182        	s32i	a8, a1, 80
400a1303:	156192        	s32i	a9, a1, 84
400a1306:	ffe581        	l32r	a8, 400a129c <create_task+0x190>
400a1309:	0008e0        	callx8	a8
400a130c:	142182        	l32i	a8, a1, 80
400a130f:	152192        	l32i	a9, a1, 84
400a1312:	0a2c      	movi.n	a10, 32
400a1314:	564892        	s8i	a9, a8, 86
400a1317:	ffe291        	l32r	a9, 400a12a0 <create_task+0x194>
400a131a:	5448a2        	s8i	a10, a8, 84
400a131d:	74a890        	extui	a10, a9, 8, 8
400a1320:	504892        	s8i	a9, a8, 80
400a1323:	5148a2        	s8i	a10, a8, 81
400a1326:	75a090        	extui	a10, a9, 16, 8
400a1329:	759890        	extui	a9, a9, 24, 8
400a132c:	5248a2        	s8i	a10, a8, 82
400a132f:	534892        	s8i	a9, a8, 83
400a1332:	10d442        	addmi	a4, a4, 0x1000
400a1335:	748860        	extui	a8, a6, 8, 8
400a1338:	484462        	s8i	a6, a4, 72
400a133b:	494482        	s8i	a8, a4, 73
400a133e:	758060        	extui	a8, a6, 16, 8
400a1341:	756860        	extui	a6, a6, 24, 8
400a1344:	4b4462        	s8i	a6, a4, 75
400a1347:	746840        	extui	a6, a4, 8, 8
400a134a:	454462        	s8i	a6, a4, 69
400a134d:	756040        	extui	a6, a4, 16, 8
400a1350:	2925b2        	l32i	a11, a5, 164
400a1353:	464462        	s8i	a6, a4, 70
400a1356:	756840        	extui	a6, a4, 24, 8
400a1359:	4a4482        	s8i	a8, a4, 74
400a135c:	474462        	s8i	a6, a4, 71
400a135f:	444442        	s8i	a4, a4, 68
400a1362:	60c182        	addi	a8, a1, 96
400a1365:	30c162        	addi	a6, a1, 48
400a1368:	840c      	movi.n	a4, 8
400a136a:	8169      	s32i.n	a6, a1, 32
400a136c:	7189      	s32i.n	a8, a1, 28
400a136e:	9149      	s32i.n	a4, a1, 36
400a1370:	4189      	s32i.n	a8, a1, 16
400a1372:	5169      	s32i.n	a6, a1, 20
400a1374:	6149      	s32i.n	a4, a1, 24
400a1376:	0189      	s32i.n	a8, a1, 0
400a1378:	1169      	s32i.n	a6, a1, 4
400a137a:	2149      	s32i.n	a4, a1, 8
400a137c:	03dd      	mov.n	a13, a3
400a137e:	0c4c      	movi.n	a12, 64
400a1380:	10dbb2        	addmi	a11, a11, 0x1000
400a1383:	ffc8a1        	l32r	a10, 400a12a4 <create_task+0x198>
400a1386:	feffe5        	call8	400a0384 <_vsnprintf>
400a1389:	3c0c      	movi.n	a12, 3
400a138b:	20b770        	or	a11, a7, a7
400a138e:	20a220        	or	a10, a2, a2
400a1391:	ffa425        	call8	400a0dd4 <cas_task_state$part$0>
400a1394:	003206        	j	400a1460 <create_task+0x354>
400a1397:	00          	.byte 00
400a1398:	00 80 00 00 	
400a139c:	ff8665        	call8	400a0c04 <umm_disconnect_from_free_list>
400a139f:	010522        	l8ui	a2, a5, 1
400a13a2:	000532        	l8ui	a3, a5, 0
400a13a5:	112280        	slli	a2, a2, 8
400a13a8:	202230        	or	a2, a2, a3
400a13ab:	b02240        	addx8	a2, a2, a4
400a13ae:	010232        	l8ui	a3, a2, 1
400a13b1:	000272        	l8ui	a7, a2, 0
400a13b4:	113380        	slli	a3, a3, 8
400a13b7:	203370        	or	a3, a3, a7
400a13ba:	e43030        	extui	a3, a3, 0, 15
400a13bd:	b02340        	addx8	a2, a3, a4
400a13c0:	417860        	srli	a7, a6, 8
400a13c3:	024262        	s8i	a6, a2, 2
400a13c6:	034272        	s8i	a7, a2, 3
400a13c9:	004532        	s8i	a3, a5, 0
400a13cc:	413830        	srli	a3, a3, 8
400a13cf:	014532        	s8i	a3, a5, 1
400a13d2:	030532        	l8ui	a3, a5, 3
400a13d5:	020522        	l8ui	a2, a5, 2
400a13d8:	113380        	slli	a3, a3, 8
400a13db:	010572        	l8ui	a7, a5, 1
400a13de:	203320        	or	a3, a3, a2
400a13e1:	000582        	l8ui	a8, a5, 0
400a13e4:	b02340        	addx8	a2, a3, a4
400a13e7:	010292        	l8ui	a9, a2, 1
400a13ea:	117780        	slli	a7, a7, 8
400a13ed:	207780        	or	a7, a7, a8
400a13f0:	ffea81        	l32r	a8, 400a1398 <create_task+0x28c>
400a13f3:	208780        	or	a8, a7, a8
400a13f6:	119980        	slli	a9, a9, 8
400a13f9:	747070        	extui	a7, a7, 0, 8
400a13fc:	418880        	srli	a8, a8, 8
400a13ff:	2069f7        	bbci	a9, 15, 400a1423 <create_task+0x317>
400a1402:	004272        	s8i	a7, a2, 0
400a1405:	014282        	s8i	a8, a2, 1
400a1408:	010522        	l8ui	a2, a5, 1
400a140b:	000562        	l8ui	a6, a5, 0
400a140e:	112280        	slli	a2, a2, 8
400a1411:	202260        	or	a2, a2, a6
400a1414:	b02240        	addx8	a2, a2, a4
400a1417:	024232        	s8i	a3, a2, 2
400a141a:	413830        	srli	a3, a3, 8
400a141d:	034232        	s8i	a3, a2, 3
400a1420:	000e86        	j	400a145e <create_task+0x352>
400a1423:	050432        	l8ui	a3, a4, 5
400a1426:	040422        	l8ui	a2, a4, 4
400a1429:	113380        	slli	a3, a3, 8
400a142c:	203320        	or	a3, a3, a2
400a142f:	b02340        	addx8	a2, a3, a4
400a1432:	749060        	extui	a9, a6, 0, 8
400a1435:	416860        	srli	a6, a6, 8
400a1438:	064292        	s8i	a9, a2, 6
400a143b:	074262        	s8i	a6, a2, 7
400a143e:	044532        	s8i	a3, a5, 4
400a1441:	020c      	movi.n	a2, 0
400a1443:	413830        	srli	a3, a3, 8
400a1446:	054532        	s8i	a3, a5, 5
400a1449:	064522        	s8i	a2, a5, 6
400a144c:	074522        	s8i	a2, a5, 7
400a144f:	044492        	s8i	a9, a4, 4
400a1452:	054462        	s8i	a6, a4, 5
400a1455:	004572        	s8i	a7, a5, 0
400a1458:	014582        	s8i	a8, a5, 1
400a145b:	000046        	j	400a1460 <create_task+0x354>
400a145e:	020c      	movi.n	a2, 0
400a1460:	f01d      	retw.n
400a1462:	00          	.byte 00
400a1463:	00          	.byte 00
400a1464:	28 09 fe 3f 	
400a1468:	00 04 40 50 	

400a146c <dport_map_interrupt$part$0>:
400a146c:	004136        	entry	a1, 32
400a146f:	fffda1        	l32r	a10, 400a1464 <create_task+0x358>
400a1472:	0a98      	l32i.n	a9, a10, 0
400a1474:	439c      	beqz.n	a3, 400a148c <dport_map_interrupt$part$0+0x20>
400a1476:	fffc31        	l32r	a3, 400a1468 <create_task+0x35c>
400a1479:	000486        	j	400a148f <dport_map_interrupt$part$0+0x23>
400a147c:	ff fb bf af 	
400a1480:	f0 00 fe 3f 	
400a1484:	26 07 fe 3f 	
400a1488:	04 01 fe 3f 	
400a148c:	fffc31        	l32r	a3, 400a147c <dport_map_interrupt$part$0+0x10>
400a148f:	103930        	and	a3, a9, a3
400a1492:	e3dc      	bnez.n	a3, 400a14b4 <dport_map_interrupt$part$0+0x48>
400a1494:	99a0e2        	movi	a14, 153
400a1497:	fffad1        	l32r	a13, 400a1480 <dport_map_interrupt$part$0+0x14>
400a149a:	fffac1        	l32r	a12, 400a1484 <dport_map_interrupt$part$0+0x18>
400a149d:	2b0c      	movi.n	a11, 2
400a149f:	fffaa1        	l32r	a10, 400a1488 <dport_map_interrupt$part$0+0x1c>
400a14a2:	ff7be5        	call8	400a0c60 <printf_>
400a14a5:	220c      	movi.n	a2, 2
400a14a7:	000f86        	j	400a14e9 <dport_map_interrupt$part$0+0x7d>
400a14aa:	00          	.byte 00
400a14ab:	00          	.byte 00
400a14ac:	3c 01 fe 3f 	
400a14b0:	04 01 f0 3f 	
400a14b4:	60c030        	neg	a12, a3
400a14b7:	10cc30        	and	a12, a12, a3
400a14ba:	40fcc0        	nsau	a12, a12
400a14bd:	60c0c0        	neg	a12, a12
400a14c0:	1fcc32        	addi	a3, a12, 31
400a14c3:	e87c      	movi.n	a8, -2
400a14c5:	401300        	ssl	a3
400a14c8:	818880        	src	a8, a8, a8
400a14cb:	108890        	and	a8, a8, a9
400a14ce:	0a89      	s32i.n	a8, a10, 0
400a14d0:	20b220        	or	a11, a2, a2
400a14d3:	20c330        	or	a12, a3, a3
400a14d6:	fff5a1        	l32r	a10, 400a14ac <dport_map_interrupt$part$0+0x40>
400a14d9:	ff7865        	call8	400a0c60 <printf_>
400a14dc:	fff581        	l32r	a8, 400a14b0 <dport_map_interrupt$part$0+0x44>
400a14df:	a02280        	addx4	a2, a2, a8
400a14e2:	0020c0        	memw
400a14e5:	0239      	s32i.n	a3, a2, 0
400a14e7:	020c      	movi.n	a2, 0
400a14e9:	f01d      	retw.n
400a14eb:	00          	.byte 00
400a14ec:	53 01 fe 3f 	
400a14f0:	1d 07 fe 3f 	
400a14f4:	66 01 fe 3f 	

400a14f8 <init_wdt>:
400a14f8:	004136        	entry	a1, 32
400a14fb:	0b0c      	movi.n	a11, 0
400a14fd:	0a1c      	movi.n	a10, 16
400a14ff:	fff6e5        	call8	400a146c <dport_map_interrupt$part$0>
400a1502:	0a2d      	mov.n	a2, a10
400a1504:	044a16        	beqz	a10, 400a154c <init_wdt+0x54>
400a1507:	6aa0d2        	movi	a13, 106
400a150a:	fff8c1        	l32r	a12, 400a14ec <dport_map_interrupt$part$0+0x80>
400a150d:	fff8b1        	l32r	a11, 400a14f0 <dport_map_interrupt$part$0+0x84>
400a1510:	fff9a1        	l32r	a10, 400a14f4 <dport_map_interrupt$part$0+0x88>
400a1513:	ff74e5        	call8	400a0c60 <printf_>
400a1516:	0027c6        	j	400a15b9 <init_wdt+0xc1>
400a1519:	00          	.byte 00
400a151a:	00          	.byte 00
400a151b:	00          	.byte 00
400a151c:	64 f0 f5 3f 	
400a1520:	a1 3a d8 50 	
400a1524:	00 00 20 38 	
400a1528:	48 f0 f5 3f 	
400a152c:	00 00 40 9c 	
400a1530:	4c f0 f5 3f 	
400a1534:	50 f0 f5 3f 	
400a1538:	54 f0 f5 3f 	
400a153c:	00 00 00 80 	
400a1540:	ef be ad de 	
400a1544:	98 f0 f5 3f 	
400a1548:	a4 f0 f5 3f 	
400a154c:	fff4a1        	l32r	a10, 400a151c <init_wdt+0x24>
400a154f:	fff481        	l32r	a8, 400a1520 <init_wdt+0x28>
400a1552:	0020c0        	memw
400a1555:	0a89      	s32i.n	a8, a10, 0
400a1557:	fff391        	l32r	a9, 400a1524 <init_wdt+0x2c>
400a155a:	fff381        	l32r	a8, 400a1528 <init_wdt+0x30>
400a155d:	0020c0        	memw
400a1560:	0899      	s32i.n	a9, a8, 0
400a1562:	fff2b1        	l32r	a11, 400a152c <init_wdt+0x34>
400a1565:	fff291        	l32r	a9, 400a1530 <init_wdt+0x38>
400a1568:	0020c0        	memw
400a156b:	09b9      	s32i.n	a11, a9, 0
400a156d:	a90c      	movi.n	a9, 10
400a156f:	fff1b1        	l32r	a11, 400a1534 <init_wdt+0x3c>
400a1572:	0020c0        	memw
400a1575:	0b99      	s32i.n	a9, a11, 0
400a1577:	fff0b1        	l32r	a11, 400a1538 <init_wdt+0x40>
400a157a:	0020c0        	memw
400a157d:	0b99      	s32i.n	a9, a11, 0
400a157f:	0020c0        	memw
400a1582:	0898      	l32i.n	a9, a8, 0
400a1584:	ffeeb1        	l32r	a11, 400a153c <init_wdt+0x44>
400a1587:	2099b0        	or	a9, a9, a11
400a158a:	0020c0        	memw
400a158d:	0899      	s32i.n	a9, a8, 0
400a158f:	ffec81        	l32r	a8, 400a1540 <init_wdt+0x48>
400a1592:	0020c0        	memw
400a1595:	0a89      	s32i.n	a8, a10, 0
400a1597:	ffeb91        	l32r	a9, 400a1544 <init_wdt+0x4c>
400a159a:	0020c0        	memw
400a159d:	0988      	l32i.n	a8, a9, 0
400a159f:	4a0c      	movi.n	a10, 4
400a15a1:	2088a0        	or	a8, a8, a10
400a15a4:	0020c0        	memw
400a15a7:	0989      	s32i.n	a8, a9, 0
400a15a9:	ffe791        	l32r	a9, 400a1548 <init_wdt+0x50>
400a15ac:	0020c0        	memw
400a15af:	0988      	l32i.n	a8, a9, 0
400a15b1:	2088a0        	or	a8, a8, a10
400a15b4:	0020c0        	memw
400a15b7:	0989      	s32i.n	a8, a9, 0
400a15b9:	f01d      	retw.n
400a15bb:	00          	.byte 00
400a15bc:	04 30 fe 3f 	
400a15c0:	08 30 fe 3f 	

400a15c4 <schedule>:
400a15c4:	004136        	entry	a1, 32
400a15c7:	fffd91        	l32r	a9, 400a15bc <init_wdt+0xc4>
400a15ca:	fffd81        	l32r	a8, 400a15c0 <init_wdt+0xc8>
400a15cd:	0938      	l32i.n	a3, a9, 0
400a15cf:	239c      	beqz.n	a3, 400a15e5 <schedule+0x21>
400a15d1:	330b      	addi.n	a3, a3, -1
400a15d3:	0939      	s32i.n	a3, a9, 0
400a15d5:	0838      	l32i.n	a3, a8, 0
400a15d7:	a38c      	beqz.n	a3, 400a15e5 <schedule+0x21>
400a15d9:	272392        	l32i	a9, a3, 156
400a15dc:	0899      	s32i.n	a9, a8, 0
400a15de:	a9ec      	bnez.n	a9, 400a160c <schedule+0x48>
400a15e0:	1899      	s32i.n	a9, a8, 4
400a15e2:	000986        	j	400a160c <schedule+0x48>
400a15e5:	007000        	waiti	0
400a15e8:	fff846        	j	400a15cd <schedule+0x9>
400a15eb:	00          	.byte 00
400a15ec:	10 30 fe 3f 	
400a15f0:	64 f0 f5 3f 	
400a15f4:	a1 3a d8 50 	
400a15f8:	60 f0 f5 3f 	
400a15fc:	ef be ad de 	
400a1600:	48 f0 f5 3f 	
400a1604:	00 00 00 80 	
400a1608:	c8 c2 00 40 	
400a160c:	fea125        	call8	400a0020 <get_cpu_index>
400a160f:	11aa90        	slli	a10, a10, 7
400a1612:	fff681        	l32r	a8, 400a15ec <schedule+0x28>
400a1615:	88aa      	add.n	a8, a8, a10
400a1617:	1c6832        	s32i	a3, a8, 112
400a161a:	03ad      	mov.n	a10, a3
400a161c:	02a0c2        	movi	a12, 2
400a161f:	01a0b2        	movi	a11, 1
400a1622:	ff7b25        	call8	400a0dd4 <cas_task_state$part$0>
400a1625:	fff281        	l32r	a8, 400a15f0 <schedule+0x2c>
400a1628:	fff391        	l32r	a9, 400a15f4 <schedule+0x30>
400a162b:	0020c0        	memw
400a162e:	0899      	s32i.n	a9, a8, 0
400a1630:	fff2a1        	l32r	a10, 400a15f8 <schedule+0x34>
400a1633:	1b0c      	movi.n	a11, 1
400a1635:	0020c0        	memw
400a1638:	0ab9      	s32i.n	a11, a10, 0
400a163a:	fff0a1        	l32r	a10, 400a15fc <schedule+0x38>
400a163d:	0020c0        	memw
400a1640:	08a9      	s32i.n	a10, a8, 0
400a1642:	0020c0        	memw
400a1645:	0899      	s32i.n	a9, a8, 0
400a1647:	ffeeb1        	l32r	a11, 400a1600 <schedule+0x3c>
400a164a:	0020c0        	memw
400a164d:	0b98      	l32i.n	a9, a11, 0
400a164f:	ffedc1        	l32r	a12, 400a1604 <schedule+0x40>
400a1652:	2099c0        	or	a9, a9, a12
400a1655:	0020c0        	memw
400a1658:	006b92        	s32i	a9, a11, 0
400a165b:	2823b2        	l32i	a11, a3, 160
400a165e:	0020c0        	memw
400a1661:	0068a2        	s32i	a10, a8, 0
400a1664:	10dbb2        	addmi	a11, a11, 0x1000
400a1667:	24a1c2        	movi	a12, 0x124
400a166a:	40cbb2        	addi	a11, a11, 64
400a166d:	02ad      	mov.n	a10, a2
400a166f:	ffe681        	l32r	a8, 400a1608 <schedule+0x44>
400a1672:	0008e0        	callx8	a8
400a1675:	a38b      	addi.n	a10, a3, 8
400a1677:	ff7ca5        	call8	400a0e40 <mmu_activate>
400a167a:	ff55e5        	call8	400a0bd8 <pid_prepare>
400a167d:	f01d      	retw.n
400a167f:	00          	.byte 00
400a1680:	10 30 fe 3f 	
400a1684:	84 01 fe 3f 	
400a1688:	fc 06 fe 3f 	
400a168c:	99 01 fe 3f 	
400a1690:	8a 00 fe 3f 	

400a1694 <save_current_task>:
400a1694:	004136        	entry	a1, 32
400a1697:	fe98a5        	call8	400a0020 <get_cpu_index>
400a169a:	fff941        	l32r	a4, 400a1680 <schedule+0xbc>
400a169d:	11aa90        	slli	a10, a10, 7
400a16a0:	a4aa      	add.n	a10, a4, a10
400a16a2:	1c2a42        	l32i	a4, a10, 112
400a16a5:	b4dc      	bnez.n	a4, 400a16c4 <save_current_task+0x30>
400a16a7:	9da0e2        	movi	a14, 157
400a16aa:	fff6d1        	l32r	a13, 400a1684 <schedule+0xc0>
400a16ad:	fff6c1        	l32r	a12, 400a1688 <schedule+0xc4>
400a16b0:	fff7b1        	l32r	a11, 400a168c <schedule+0xc8>
400a16b3:	fff7a1        	l32r	a10, 400a1690 <schedule+0xcc>
400a16b6:	ff5aa5        	call8	400a0c60 <printf_>
400a16b9:	ffff06        	j	400a16b9 <save_current_task+0x25>
400a16bc:	c8 c2 00 40 	
400a16c0:	08 30 fe 3f 	
400a16c4:	080c      	movi.n	a8, 0
400a16c6:	1c6a82        	s32i	a8, a10, 112
400a16c9:	2824a2        	l32i	a10, a4, 160
400a16cc:	24a1c2        	movi	a12, 0x124
400a16cf:	10daa2        	addmi	a10, a10, 0x1000
400a16d2:	02bd      	mov.n	a11, a2
400a16d4:	40caa2        	addi	a10, a10, 64
400a16d7:	fff981        	l32r	a8, 400a16bc <save_current_task+0x28>
400a16da:	0008e0        	callx8	a8
400a16dd:	b3ec      	bnez.n	a3, 400a170c <save_current_task+0x78>
400a16df:	1c0c      	movi.n	a12, 1
400a16e1:	2b0c      	movi.n	a11, 2
400a16e3:	04ad      	mov.n	a10, a4
400a16e5:	ff6ee5        	call8	400a0dd4 <cas_task_state$part$0>
400a16e8:	fff681        	l32r	a8, 400a16c0 <save_current_task+0x2c>
400a16eb:	1898      	l32i.n	a9, a8, 4
400a16ed:	276432        	s32i	a3, a4, 156
400a16f0:	898c      	beqz.n	a9, 400a16fc <save_current_task+0x68>
400a16f2:	276942        	s32i	a4, a9, 156
400a16f5:	000146        	j	400a16fe <save_current_task+0x6a>
400a16f8:	04 30 fe 3f 	
400a16fc:	0849      	s32i.n	a4, a8, 0
400a16fe:	1849      	s32i.n	a4, a8, 4
400a1700:	fffe81        	l32r	a8, 400a16f8 <save_current_task+0x64>
400a1703:	0848      	l32i.n	a4, a8, 0
400a1705:	441b      	addi.n	a4, a4, 1
400a1707:	0849      	s32i.n	a4, a8, 0
400a1709:	000206        	j	400a1715 <save_current_task+0x81>
400a170c:	3c0c      	movi.n	a12, 3
400a170e:	2b0c      	movi.n	a11, 2
400a1710:	04ad      	mov.n	a10, a4
400a1712:	ff6c25        	call8	400a0dd4 <cas_task_state$part$0>
400a1715:	f01d      	retw.n
400a1717:	00          	.byte 00
400a1718:	64 f0 f5 3f 	
400a171c:	a1 3a d8 50 	
400a1720:	48 f0 f5 3f 	
400a1724:	ff ff ff 7f 	
400a1728:	ef be ad de 	
400a172c:	b4 01 fe 3f 	
400a1730:	80 07 fe 3f 	
400a1734:	c7 01 fe 3f 	

400a1738 <common_exception_handler>:
400a1738:	004136        	entry	a1, 32
400a173b:	03e830        	rsr.exccause	a3
400a173e:	fff691        	l32r	a9, 400a1718 <save_current_task+0x84>
400a1741:	fff681        	l32r	a8, 400a171c <save_current_task+0x88>
400a1744:	0020c0        	memw
400a1747:	0989      	s32i.n	a8, a9, 0
400a1749:	fff5a1        	l32r	a10, 400a1720 <save_current_task+0x8c>
400a174c:	0020c0        	memw
400a174f:	0a88      	l32i.n	a8, a10, 0
400a1751:	fff4b1        	l32r	a11, 400a1724 <save_current_task+0x90>
400a1754:	1088b0        	and	a8, a8, a11
400a1757:	0020c0        	memw
400a175a:	0a89      	s32i.n	a8, a10, 0
400a175c:	fff381        	l32r	a8, 400a1728 <save_current_task+0x94>
400a175f:	fff3a1        	l32r	a10, 400a172c <save_current_task+0x98>
400a1762:	0020c0        	memw
400a1765:	0989      	s32i.n	a8, a9, 0
400a1767:	ff4fa5        	call8	400a0c60 <printf_>
400a176a:	782c      	movi.n	a8, 39
400a176c:	243837        	bltu	a8, a3, 400a1794 <common_exception_handler+0x5c>
400a176f:	fff081        	l32r	a8, 400a1730 <save_current_task+0x9c>
400a1772:	a08380        	addx4	a8, a3, a8
400a1775:	08b8      	l32i.n	a11, a8, 0
400a1777:	9b9c      	beqz.n	a11, 400a1794 <common_exception_handler+0x5c>
400a1779:	03cd      	mov.n	a12, a3
400a177b:	ffeea1        	l32r	a10, 400a1734 <save_current_task+0xa0>
400a177e:	ff4e25        	call8	400a0c60 <printf_>
400a1781:	0005c6        	j	400a179c <common_exception_handler+0x64>
400a1784:	cf 01 fe 3f 	
400a1788:	00 f0 17 37 	
400a178c:	d2 01 fe 3f 	
400a1790:	3c 00 fe 3f 	
400a1794:	03bd      	mov.n	a11, a3
400a1796:	fffba1        	l32r	a10, 400a1784 <common_exception_handler+0x4c>
400a1799:	ff4c65        	call8	400a0c60 <printf_>
400a179c:	fec382        	addi	a8, a3, -2
400a179f:	1128b6        	bltui	a8, 2, 400a17b4 <common_exception_handler+0x7c>
400a17a2:	f7c382        	addi	a8, a3, -9
400a17a5:	00b816        	beqz	a8, 400a17b4 <common_exception_handler+0x7c>
400a17a8:	1da082        	movi	a8, 29
400a17ab:	0e3837        	bltu	a8, a3, 400a17bd <common_exception_handler+0x85>
400a17ae:	fff681        	l32r	a8, 400a1788 <common_exception_handler+0x50>
400a17b1:	085837        	bbc	a8, a3, 400a17bd <common_exception_handler+0x85>
400a17b4:	03eeb0        	rsr.excvaddr	a11
400a17b7:	fff5a1        	l32r	a10, 400a178c <common_exception_handler+0x54>
400a17ba:	ff4a65        	call8	400a0c60 <printf_>
400a17bd:	fff4a1        	l32r	a10, 400a1790 <common_exception_handler+0x58>
400a17c0:	ff49e5        	call8	400a0c60 <printf_>
400a17c3:	02ad      	mov.n	a10, a2
400a17c5:	ff4ee5        	call8	400a0cb4 <task_regs_dump>
400a17c8:	ffff06        	j	400a17c8 <common_exception_handler+0x90>
400a17cb:	00          	.byte 00
400a17cc:	a0 f0 f5 3f 	
400a17d0:	e8 03 f0 3f 	
400a17d4:	e1 01 fe 3f 	
400a17d8:	05 02 fe 3f 	
400a17dc:	ec 00 f0 3f 	

400a17e0 <common_interrupt_handler>:
400a17e0:	004136        	entry	a1, 32
400a17e3:	fffa31        	l32r	a3, 400a17cc <common_exception_handler+0x94>
400a17e6:	0020c0        	memw
400a17e9:	0338      	l32i.n	a3, a3, 0
400a17eb:	043230        	extui	a3, a3, 2, 1
400a17ee:	a3fc      	bnez.n	a3, 400a182c <common_interrupt_handler+0x4c>
400a17f0:	02ad      	mov.n	a10, a2
400a17f2:	ff4c25        	call8	400a0cb4 <task_regs_dump>
400a17f5:	fff621        	l32r	a2, 400a17d0 <common_exception_handler+0x98>
400a17f8:	0020c0        	memw
400a17fb:	0022b2        	l32i	a11, a2, 0
400a17fe:	fff5a1        	l32r	a10, 400a17d4 <common_exception_handler+0x9c>
400a1801:	ff45e5        	call8	400a0c60 <printf_>
400a1804:	0020c0        	memw
400a1807:	0122b2        	l32i	a11, a2, 4
400a180a:	fff3a1        	l32r	a10, 400a17d8 <common_exception_handler+0xa0>
400a180d:	ff4525        	call8	400a0c60 <printf_>
400a1810:	032d      	mov.n	a2, a3
400a1812:	fff241        	l32r	a4, 400a17dc <common_exception_handler+0xa4>
400a1815:	0015c6        	j	400a1870 <common_interrupt_handler+0x90>
400a1818:	64 f0 f5 3f 	
400a181c:	a1 3a d8 50 	
400a1820:	60 f0 f5 3f 	
400a1824:	ef be ad de 	
400a1828:	a4 f0 f5 3f 	
400a182c:	fffb31        	l32r	a3, 400a1818 <common_interrupt_handler+0x38>
400a182f:	fffb41        	l32r	a4, 400a181c <common_interrupt_handler+0x3c>
400a1832:	0020c0        	memw
400a1835:	0349      	s32i.n	a4, a3, 0
400a1837:	180c      	movi.n	a8, 1
400a1839:	fff941        	l32r	a4, 400a1820 <common_interrupt_handler+0x40>
400a183c:	0020c0        	memw
400a183f:	0489      	s32i.n	a8, a4, 0
400a1841:	fff841        	l32r	a4, 400a1824 <common_interrupt_handler+0x44>
400a1844:	0020c0        	memw
400a1847:	0349      	s32i.n	a4, a3, 0
400a1849:	fff781        	l32r	a8, 400a1828 <common_interrupt_handler+0x48>
400a184c:	0020c0        	memw
400a184f:	0838      	l32i.n	a3, a8, 0
400a1851:	440c      	movi.n	a4, 4
400a1853:	203340        	or	a3, a3, a4
400a1856:	02ad      	mov.n	a10, a2
400a1858:	0020c0        	memw
400a185b:	006832        	s32i	a3, a8, 0
400a185e:	00a0b2        	movi	a11, 0
400a1861:	ffe325        	call8	400a1694 <save_current_task>
400a1864:	02ad      	mov.n	a10, a2
400a1866:	ffd5e5        	call8	400a15c4 <schedule>
400a1869:	f01d      	retw.n
400a186b:	00          	.byte 00
400a186c:	29 02 fe 3f 	
400a1870:	213520        	srai	a3, a2, 5
400a1873:	a03340        	addx4	a3, a3, a4
400a1876:	0020c0        	memw
400a1879:	0338      	l32i.n	a3, a3, 0
400a187b:	3d5327        	bbc	a3, a2, 400a18bc <common_interrupt_handler+0xdc>
400a187e:	334c      	movi.n	a3, 67
400a1880:	141237        	beq	a2, a3, 400a1898 <common_interrupt_handler+0xb8>
400a1883:	434c      	movi.n	a3, 68
400a1885:	1f1237        	beq	a2, a3, 400a18a8 <common_interrupt_handler+0xc8>
400a1888:	234c      	movi.n	a3, 66
400a188a:	fff8a1        	l32r	a10, 400a186c <common_interrupt_handler+0x8c>
400a188d:	0a1237        	beq	a2, a3, 400a189b <common_interrupt_handler+0xbb>
400a1890:	000806        	j	400a18b4 <common_interrupt_handler+0xd4>
400a1893:	00          	.byte 00
400a1894:	49 02 fe 3f 	
400a1898:	ffffa1        	l32r	a10, 400a1894 <common_interrupt_handler+0xb4>
400a189b:	ff3c65        	call8	400a0c60 <printf_>
400a189e:	000686        	j	400a18bc <common_interrupt_handler+0xdc>
400a18a1:	00          	.byte 00
400a18a2:	00          	.byte 00
400a18a3:	00          	.byte 00
400a18a4:	69 02 fe 3f 	
400a18a8:	ffffa1        	l32r	a10, 400a18a4 <common_interrupt_handler+0xc4>
400a18ab:	fffb06        	j	400a189b <common_interrupt_handler+0xbb>
400a18ae:	00          	.byte 00
400a18af:	00          	.byte 00
400a18b0:	8b 02 fe 3f 	
400a18b4:	02bd      	mov.n	a11, a2
400a18b6:	fffea1        	l32r	a10, 400a18b0 <common_interrupt_handler+0xd0>
400a18b9:	ff3a65        	call8	400a0c60 <printf_>
400a18bc:	221b      	addi.n	a2, a2, 1
400a18be:	534c      	movi.n	a3, 69
400a18c0:	ac9237        	bne	a2, a3, 400a1870 <common_interrupt_handler+0x90>
400a18c3:	ffff06        	j	400a18c3 <common_interrupt_handler+0xe3>
400a18c6:	00          	.byte 00
400a18c7:	00          	.byte 00
400a18c8:	00 00 04 00 	
400a18cc:	0c 00 f4 3f 	
400a18d0:	a4 02 fe 3f 	
400a18d4:	bd 02 fe 3f 	
400a18d8:	7a 07 fe 3f 	
400a18dc:	c8 02 fe 3f 	
400a18e0:	8a 00 fe 3f 	

400a18e4 <kmain>:
400a18e4:	00a136        	entry	a1, 80
400a18e7:	03e620        	rsr.ps	a2
400a18ea:	c0af32        	movi	a3, -64
400a18ed:	8129      	s32i.n	a2, a1, 32
400a18ef:	102230        	and	a2, a2, a3
400a18f2:	f32c      	movi.n	a3, 47
400a18f4:	202230        	or	a2, a2, a3
400a18f7:	204122        	s8i	a2, a1, 32
400a18fa:	8128      	l32i.n	a2, a1, 32
400a18fc:	fff331        	l32r	a3, 400a18c8 <common_interrupt_handler+0xe8>
400a18ff:	202230        	or	a2, a2, a3
400a1902:	8129      	s32i.n	a2, a1, 32
400a1904:	13e620        	wsr.ps	a2
400a1907:	030c      	movi.n	a3, 0
400a1909:	fff021        	l32r	a2, 400a18cc <common_interrupt_handler+0xec>
400a190c:	fff1a1        	l32r	a10, 400a18d0 <common_interrupt_handler+0xf0>
400a190f:	0020c0        	memw
400a1912:	006232        	s32i	a3, a2, 0
400a1915:	ff34a5        	call8	400a0c60 <printf_>
400a1918:	fe7065        	call8	400a0020 <get_cpu_index>
400a191b:	511a37        	beq	a10, a3, 400a1970 <kmain+0x8c>
400a191e:	42a0e2        	movi	a14, 66
400a1921:	ffecd1        	l32r	a13, 400a18d4 <common_interrupt_handler+0xf4>
400a1924:	ffedc1        	l32r	a12, 400a18d8 <common_interrupt_handler+0xf8>
400a1927:	ffedb1        	l32r	a11, 400a18dc <common_interrupt_handler+0xfc>
400a192a:	ffeda1        	l32r	a10, 400a18e0 <common_interrupt_handler+0x100>
400a192d:	ff3325        	call8	400a0c60 <printf_>
400a1930:	ffff06        	j	400a1930 <kmain+0x4c>
400a1933:	00          	.byte 00
400a1934:	00 00 f0 3f 	
400a1938:	04 00 f0 3f 	
400a193c:	40 00 f0 3f 	
400a1940:	58 00 f0 3f 	
400a1944:	7c 00 f0 3f 	
400a1948:	04 01 f0 3f 	
400a194c:	18 02 f0 3f 	
400a1950:	dc 00 f0 3f 	
400a1954:	80 00 f0 3f 	
400a1958:	84 00 f0 3f 	
400a195c:	98 05 f0 3f 	
400a1960:	ff ff ff 00 	
400a1964:	f0 00 fe 3f 	
400a1968:	50 07 fe 3f 	
400a196c:	66 01 fe 3f 	
400a1970:	fff121        	l32r	a2, 400a1934 <kmain+0x50>
400a1973:	0020c0        	memw
400a1976:	02a9      	s32i.n	a10, a2, 0
400a1978:	fff021        	l32r	a2, 400a1938 <kmain+0x54>
400a197b:	0020c0        	memw
400a197e:	0062a2        	s32i	a10, a2, 0
400a1981:	ffee41        	l32r	a4, 400a193c <kmain+0x58>
400a1984:	0020c0        	memw
400a1987:	000422        	l8ui	a2, a4, 0
400a198a:	0020c0        	memw
400a198d:	0044a2        	s8i	a10, a4, 0
400a1990:	0020c0        	memw
400a1993:	010422        	l8ui	a2, a4, 1
400a1996:	0020c0        	memw
400a1999:	0144a2        	s8i	a10, a4, 1
400a199c:	0020c0        	memw
400a199f:	020422        	l8ui	a2, a4, 2
400a19a2:	0020c0        	memw
400a19a5:	0244a2        	s8i	a10, a4, 2
400a19a8:	0020c0        	memw
400a19ab:	030422        	l8ui	a2, a4, 3
400a19ae:	ffe421        	l32r	a2, 400a1940 <kmain+0x5c>
400a19b1:	0020c0        	memw
400a19b4:	0344a2        	s8i	a10, a4, 3
400a19b7:	0020c0        	memw
400a19ba:	000232        	l8ui	a3, a2, 0
400a19bd:	0020c0        	memw
400a19c0:	0042a2        	s8i	a10, a2, 0
400a19c3:	0020c0        	memw
400a19c6:	010232        	l8ui	a3, a2, 1
400a19c9:	0020c0        	memw
400a19cc:	0142a2        	s8i	a10, a2, 1
400a19cf:	0020c0        	memw
400a19d2:	020232        	l8ui	a3, a2, 2
400a19d5:	0020c0        	memw
400a19d8:	0242a2        	s8i	a10, a2, 2
400a19db:	0020c0        	memw
400a19de:	030232        	l8ui	a3, a2, 3
400a19e1:	ffd831        	l32r	a3, 400a1944 <kmain+0x60>
400a19e4:	0020c0        	memw
400a19e7:	0342a2        	s8i	a10, a2, 3
400a19ea:	0020c0        	memw
400a19ed:	03a9      	s32i.n	a10, a3, 0
400a19ef:	0020c0        	memw
400a19f2:	000432        	l8ui	a3, a4, 0
400a19f5:	10a052        	movi	a5, 16
400a19f8:	203350        	or	a3, a3, a5
400a19fb:	0020c0        	memw
400a19fe:	004432        	s8i	a3, a4, 0
400a1a01:	0020c0        	memw
400a1a04:	000232        	l8ui	a3, a2, 0
400a1a07:	203350        	or	a3, a3, a5
400a1a0a:	0020c0        	memw
400a1a0d:	004232        	s8i	a3, a2, 0
400a1a10:	0020c0        	memw
400a1a13:	000432        	l8ui	a3, a4, 0
400a1a16:	f66357        	bbci	a3, 5, 400a1a10 <kmain+0x12c>
400a1a19:	0020c0        	memw
400a1a1c:	000232        	l8ui	a3, a2, 0
400a1a1f:	043530        	extui	a3, a3, 5, 1
400a1a22:	ff3316        	beqz	a3, 400a1a19 <kmain+0x135>
400a1a25:	0020c0        	memw
400a1a28:	000452        	l8ui	a5, a4, 0
400a1a2b:	860c      	movi.n	a6, 8
400a1a2d:	205560        	or	a5, a5, a6
400a1a30:	0020c0        	memw
400a1a33:	004452        	s8i	a5, a4, 0
400a1a36:	0020c0        	memw
400a1a39:	000242        	l8ui	a4, a2, 0
400a1a3c:	ffc381        	l32r	a8, 400a1948 <kmain+0x64>
400a1a3f:	204460        	or	a4, a4, a6
400a1a42:	0020c0        	memw
400a1a45:	004242        	s8i	a4, a2, 0
400a1a48:	051c      	movi.n	a5, 16
400a1a4a:	020c      	movi.n	a2, 0
400a1a4c:	ffc071        	l32r	a7, 400a194c <kmain+0x68>
400a1a4f:	544c      	movi.n	a4, 69
400a1a51:	118476        	loop	a4, 400a1a66 <kmain+0x182>
400a1a54:	a06280        	addx4	a6, a2, a8
400a1a57:	0020c0        	memw
400a1a5a:	0659      	s32i.n	a5, a6, 0
400a1a5c:	a06270        	addx4	a6, a2, a7
400a1a5f:	0020c0        	memw
400a1a62:	0659      	s32i.n	a5, a6, 0
400a1a64:	221b      	addi.n	a2, a2, 1
400a1a66:	ffba21        	l32r	a2, 400a1950 <kmain+0x6c>
400a1a69:	0b0c      	movi.n	a11, 0
400a1a6b:	0020c0        	memw
400a1a6e:	02b9      	s32i.n	a11, a2, 0
400a1a70:	0020c0        	memw
400a1a73:	12b9      	s32i.n	a11, a2, 4
400a1a75:	0020c0        	memw
400a1a78:	22b9      	s32i.n	a11, a2, 8
400a1a7a:	0020c0        	memw
400a1a7d:	32b9      	s32i.n	a11, a2, 12
400a1a7f:	ffb541        	l32r	a4, 400a1954 <kmain+0x70>
400a1a82:	120c      	movi.n	a2, 1
400a1a84:	0020c0        	memw
400a1a87:	0429      	s32i.n	a2, a4, 0
400a1a89:	ffb341        	l32r	a4, 400a1958 <kmain+0x74>
400a1a8c:	0020c0        	memw
400a1a8f:	0429      	s32i.n	a2, a4, 0
400a1a91:	2a4c      	movi.n	a10, 66
400a1a93:	ffb221        	l32r	a2, 400a195c <kmain+0x78>
400a1a96:	ffb241        	l32r	a4, 400a1960 <kmain+0x7c>
400a1a99:	0020c0        	memw
400a1a9c:	0249      	s32i.n	a4, a2, 0
400a1a9e:	ff9ce5        	call8	400a146c <dport_map_interrupt$part$0>
400a1aa1:	07fa16        	beqz	a10, 400a1b24 <kmain+0x240>
400a1aa4:	eca0d2        	movi	a13, 236
400a1aa7:	ffafc1        	l32r	a12, 400a1964 <kmain+0x80>
400a1aaa:	ffafb1        	l32r	a11, 400a1968 <kmain+0x84>
400a1aad:	ffafa1        	l32r	a10, 400a196c <kmain+0x88>
400a1ab0:	ff1ae5        	call8	400a0c60 <printf_>
400a1ab3:	0028c6        	j	400a1b5a <kmain+0x276>
400a1ab6:	00          	.byte 00
400a1ab7:	00          	.byte 00
400a1ab8:	04 05 f0 3f 	
400a1abc:	b4 00 f0 3f 	
400a1ac0:	04 f0 f1 3f 	
400a1ac4:	40 e3 09 40 	
400a1ac8:	80 e1 09 40 	
400a1acc:	c0 e1 09 40 	
400a1ad0:	00 e0 09 40 	
400a1ad4:	28 f0 f1 3f 	
400a1ad8:	2c f0 f1 3f 	
400a1adc:	00 f0 f1 3f 	
400a1ae0:	20 f0 f1 3f 	
400a1ae4:	18 30 fe 3f 	
400a1ae8:	30 31 fe 3f 	
400a1aec:	d8 ab 01 00 	
400a1af0:	1c 31 fe 3f 	
400a1af4:	20 31 fe 3f 	
400a1af8:	dd 02 fe 3f 	
400a1afc:	10 31 fe 3f 	
400a1b00:	4c c4 00 40 	
400a1b04:	00 80 ff ff 	
400a1b08:	00 20 fc 3f 	
400a1b0c:	f8 02 fe 3f 	
400a1b10:	01 20 fc 3f 	
400a1b14:	05 20 fc 3f 	
400a1b18:	1f 03 fe 3f 	
400a1b1c:	4c c4 00 40 	
400a1b20:	41 50 50 20 	
400a1b24:	ffe541        	l32r	a4, 400a1ab8 <kmain+0x1d4>
400a1b27:	0020c0        	memw
400a1b2a:	3c0422        	l8ui	a2, a4, 60
400a1b2d:	f60c      	movi.n	a6, 15
400a1b2f:	202260        	or	a2, a2, a6
400a1b32:	0020c0        	memw
400a1b35:	3c4422        	s8i	a2, a4, 60
400a1b38:	0020c0        	memw
400a1b3b:	3c0422        	l8ui	a2, a4, 60
400a1b3e:	8faf62        	movi	a6, -113
400a1b41:	102260        	and	a2, a2, a6
400a1b44:	202250        	or	a2, a2, a5
400a1b47:	0020c0        	memw
400a1b4a:	3c4422        	s8i	a2, a4, 60
400a1b4d:	ffdb21        	l32r	a2, 400a1abc <kmain+0x1d8>
400a1b50:	0020c0        	memw
400a1b53:	02a9      	s32i.n	a10, a2, 0
400a1b55:	0020c0        	memw
400a1b58:	12a9      	s32i.n	a10, a2, 4
400a1b5a:	ffd921        	l32r	a2, 400a1ac0 <kmain+0x1dc>
400a1b5d:	ffd941        	l32r	a4, 400a1ac4 <kmain+0x1e0>
400a1b60:	0020c0        	memw
400a1b63:	0249      	s32i.n	a4, a2, 0
400a1b65:	ffd841        	l32r	a4, 400a1ac8 <kmain+0x1e4>
400a1b68:	0020c0        	memw
400a1b6b:	1249      	s32i.n	a4, a2, 4
400a1b6d:	ffd751        	l32r	a5, 400a1acc <kmain+0x1e8>
400a1b70:	ffd841        	l32r	a4, 400a1ad0 <kmain+0x1ec>
400a1b73:	0020c0        	memw
400a1b76:	2259      	s32i.n	a5, a2, 8
400a1b78:	02d452        	addmi	a5, a4, 0x200
400a1b7b:	0020c0        	memw
400a1b7e:	3259      	s32i.n	a5, a2, 12
400a1b80:	40a252        	movi	a5, 0x240
400a1b83:	545a      	add.n	a5, a4, a5
400a1b85:	0020c0        	memw
400a1b88:	4259      	s32i.n	a5, a2, 16
400a1b8a:	80a252        	movi	a5, 0x280
400a1b8d:	545a      	add.n	a5, a4, a5
400a1b8f:	0020c0        	memw
400a1b92:	5259      	s32i.n	a5, a2, 20
400a1b94:	c0a252        	movi	a5, 0x2c0
400a1b97:	445a      	add.n	a4, a4, a5
400a1b99:	0020c0        	memw
400a1b9c:	6249      	s32i.n	a4, a2, 24
400a1b9e:	020c      	movi.n	a2, 0
400a1ba0:	ffcd41        	l32r	a4, 400a1ad4 <kmain+0x1f0>
400a1ba3:	0020c0        	memw
400a1ba6:	0429      	s32i.n	a2, a4, 0
400a1ba8:	ffcc41        	l32r	a4, 400a1ad8 <kmain+0x1f4>
400a1bab:	0020c0        	memw
400a1bae:	0429      	s32i.n	a2, a4, 0
400a1bb0:	0020c0        	memw
400a1bb3:	1429      	s32i.n	a2, a4, 4
400a1bb5:	0020c0        	memw
400a1bb8:	2429      	s32i.n	a2, a4, 8
400a1bba:	0020c0        	memw
400a1bbd:	3429      	s32i.n	a2, a4, 12
400a1bbf:	0020c0        	memw
400a1bc2:	4429      	s32i.n	a2, a4, 16
400a1bc4:	0020c0        	memw
400a1bc7:	5429      	s32i.n	a2, a4, 20
400a1bc9:	0020c0        	memw
400a1bcc:	6429      	s32i.n	a2, a4, 24
400a1bce:	fea052        	movi	a5, 254
400a1bd1:	ffc241        	l32r	a4, 400a1adc <kmain+0x1f8>
400a1bd4:	0020c0        	memw
400a1bd7:	0459      	s32i.n	a5, a4, 0
400a1bd9:	ffc141        	l32r	a4, 400a1ae0 <kmain+0x1fc>
400a1bdc:	0020c0        	memw
400a1bdf:	0429      	s32i.n	a2, a4, 0
400a1be1:	fe43e5        	call8	400a0020 <get_cpu_index>
400a1be4:	ffc041        	l32r	a4, 400a1ae4 <kmain+0x200>
400a1be7:	11aa90        	slli	a10, a10, 7
400a1bea:	aa4a      	add.n	a10, a10, a4
400a1bec:	240c      	movi.n	a4, 2
400a1bee:	0c4a42        	s8i	a4, a10, 12
400a1bf1:	340c      	movi.n	a4, 3
400a1bf3:	1c4a42        	s8i	a4, a10, 28
400a1bf6:	440c      	movi.n	a4, 4
400a1bf8:	2c4a42        	s8i	a4, a10, 44
400a1bfb:	540c      	movi.n	a4, 5
400a1bfd:	3c4a42        	s8i	a4, a10, 60
400a1c00:	640c      	movi.n	a4, 6
400a1c02:	4c4a42        	s8i	a4, a10, 76
400a1c05:	740c      	movi.n	a4, 7
400a1c07:	5c4a42        	s8i	a4, a10, 92
400a1c0a:	ffb741        	l32r	a4, 400a1ae8 <kmain+0x204>
400a1c0d:	c57c      	movi.n	a5, -4
400a1c0f:	b43b      	addi.n	a11, a4, 3
400a1c11:	10bb50        	and	a11, a11, a5
400a1c14:	c04b40        	sub	a4, a11, a4
400a1c17:	ffb5c1        	l32r	a12, 400a1aec <kmain+0x208>
400a1c1a:	c0cc40        	sub	a12, a12, a4
400a1c1d:	10cc50        	and	a12, a12, a5
400a1c20:	ffb441        	l32r	a4, 400a1af0 <kmain+0x20c>
400a1c23:	ffb451        	l32r	a5, 400a1af4 <kmain+0x210>
400a1c26:	ffb4a1        	l32r	a10, 400a1af8 <kmain+0x214>
400a1c29:	05b9      	s32i.n	a11, a5, 0
400a1c2b:	04c9      	s32i.n	a12, a4, 0
400a1c2d:	ff0325        	call8	400a0c60 <printf_>
400a1c30:	04c8      	l32i.n	a12, a4, 0
400a1c32:	05a8      	l32i.n	a10, a5, 0
400a1c34:	4143c0        	srli	a4, a12, 3
400a1c37:	ffb151        	l32r	a5, 400a1afc <kmain+0x218>
400a1c3a:	02bd      	mov.n	a11, a2
400a1c3c:	15c9      	s32i.n	a12, a5, 4
400a1c3e:	045542        	s16i	a4, a5, 8
400a1c41:	05a9      	s32i.n	a10, a5, 0
400a1c43:	ffaf81        	l32r	a8, 400a1b00 <kmain+0x21c>
400a1c46:	0008e0        	callx8	a8
400a1c49:	0548      	l32i.n	a4, a5, 0
400a1c4b:	041552        	l16ui	a5, a5, 8
400a1c4e:	ffad81        	l32r	a8, 400a1b04 <kmain+0x220>
400a1c51:	650b      	addi.n	a6, a5, -1
400a1c53:	206680        	or	a6, a6, a8
400a1c56:	170c      	movi.n	a7, 1
400a1c58:	084462        	s8i	a6, a4, 8
400a1c5b:	746860        	extui	a6, a6, 8, 8
400a1c5e:	004472        	s8i	a7, a4, 0
400a1c61:	014422        	s8i	a2, a4, 1
400a1c64:	044472        	s8i	a7, a4, 4
400a1c67:	054422        	s8i	a2, a4, 5
400a1c6a:	064472        	s8i	a7, a4, 6
400a1c6d:	074422        	s8i	a2, a4, 7
400a1c70:	094462        	s8i	a6, a4, 9
400a1c73:	b04540        	addx8	a4, a5, a4
400a1c76:	f8c442        	addi	a4, a4, -8
400a1c79:	024472        	s8i	a7, a4, 2
400a1c7c:	034422        	s8i	a2, a4, 3
400a1c7f:	03e620        	rsr.ps	a2
400a1c82:	047c      	movi.n	a4, -16
400a1c84:	102240        	and	a2, a2, a4
400a1c87:	8129      	s32i.n	a2, a1, 32
400a1c89:	13e620        	wsr.ps	a2
400a1c8c:	13e370        	wsr.intclear	a7
400a1c8f:	13e470        	wsr.intenable	a7
400a1c92:	002010        	rsync
400a1c95:	ff9c21        	l32r	a2, 400a1b08 <kmain+0x224>
400a1c98:	0002b2        	l8ui	a11, a2, 0
400a1c9b:	ff9ca1        	l32r	a10, 400a1b0c <kmain+0x228>
400a1c9e:	fefc25        	call8	400a0c60 <printf_>
400a1ca1:	000222        	l8ui	a2, a2, 0
400a1ca4:	268216        	beqz	a2, 400a1f10 <kmain+0x62c>
400a1ca7:	ff9a21        	l32r	a2, 400a1b10 <kmain+0x22c>
400a1caa:	010252        	l8ui	a5, a2, 1
400a1cad:	000242        	l8ui	a4, a2, 0
400a1cb0:	115580        	slli	a5, a5, 8
400a1cb3:	205540        	or	a5, a5, a4
400a1cb6:	020242        	l8ui	a4, a2, 2
400a1cb9:	0302c2        	l8ui	a12, a2, 3
400a1cbc:	114400        	slli	a4, a4, 16
400a1cbf:	204450        	or	a4, a4, a5
400a1cc2:	01cc80        	slli	a12, a12, 24
400a1cc5:	20cc40        	or	a12, a12, a4
400a1cc8:	ff93b1        	l32r	a11, 400a1b14 <kmain+0x230>
400a1ccb:	ff93a1        	l32r	a10, 400a1b18 <kmain+0x234>
400a1cce:	fef925        	call8	400a0c60 <printf_>
400a1cd1:	010252        	l8ui	a5, a2, 1
400a1cd4:	000242        	l8ui	a4, a2, 0
400a1cd7:	115580        	slli	a5, a5, 8
400a1cda:	205540        	or	a5, a5, a4
400a1cdd:	020242        	l8ui	a4, a2, 2
400a1ce0:	030262        	l8ui	a6, a2, 3
400a1ce3:	114400        	slli	a4, a4, 16
400a1ce6:	204450        	or	a4, a4, a5
400a1ce9:	016680        	slli	a6, a6, 24
400a1cec:	0c2c      	movi.n	a12, 32
400a1cee:	fb7c      	movi.n	a11, -1
400a1cf0:	01ad      	mov.n	a10, a1
400a1cf2:	ff8a81        	l32r	a8, 400a1b1c <kmain+0x238>
400a1cf5:	0008e0        	callx8	a8
400a1cf8:	206640        	or	a6, a6, a4
400a1cfb:	450242        	l8ui	a4, a2, 69
400a1cfe:	440252        	l8ui	a5, a2, 68
400a1d01:	114480        	slli	a4, a4, 8
400a1d04:	204450        	or	a4, a4, a5
400a1d07:	460252        	l8ui	a5, a2, 70
400a1d0a:	1e1c      	movi.n	a14, 17
400a1d0c:	115500        	slli	a5, a5, 16
400a1d0f:	205540        	or	a5, a5, a4
400a1d12:	470242        	l8ui	a4, a2, 71
400a1d15:	014480        	slli	a4, a4, 24
400a1d18:	204450        	or	a4, a4, a5
400a1d1b:	ff8151        	l32r	a5, 400a1b20 <kmain+0x23c>
400a1d1e:	5f9457        	bne	a4, a5, 400a1d81 <kmain+0x49d>
400a1d21:	3e1c      	movi.n	a14, 19
400a1d23:	193e67        	bltu	a14, a6, 400a1d40 <kmain+0x45c>
400a1d26:	2e1c      	movi.n	a14, 18
400a1d28:	001546        	j	400a1d81 <kmain+0x49d>
400a1d2b:	00          	.byte 00
400a1d2c:	3c 03 fe 3f 	
400a1d30:	59 07 fe 3f 	
400a1d34:	04 01 fe 3f 	
400a1d38:	2e 09 fe 3f 	
400a1d3c:	2c 09 fe 3f 	
400a1d40:	490242        	l8ui	a4, a2, 73
400a1d43:	480252        	l8ui	a5, a2, 72
400a1d46:	114480        	slli	a4, a4, 8
400a1d49:	204450        	or	a4, a4, a5
400a1d4c:	4a0252        	l8ui	a5, a2, 74
400a1d4f:	4c0282        	l8ui	a8, a2, 76
400a1d52:	115500        	slli	a5, a5, 16
400a1d55:	205540        	or	a5, a5, a4
400a1d58:	4b0242        	l8ui	a4, a2, 75
400a1d5b:	014480        	slli	a4, a4, 24
400a1d5e:	204450        	or	a4, a4, a5
400a1d61:	4d0252        	l8ui	a5, a2, 77
400a1d64:	115580        	slli	a5, a5, 8
400a1d67:	205580        	or	a5, a5, a8
400a1d6a:	4e0282        	l8ui	a8, a2, 78
400a1d6d:	118800        	slli	a8, a8, 16
400a1d70:	208850        	or	a8, a8, a5
400a1d73:	4f0252        	l8ui	a5, a2, 79
400a1d76:	015580        	slli	a5, a5, 24
400a1d79:	205580        	or	a5, a5, a8
400a1d7c:	554a      	add.n	a5, a5, a4
400a1d7e:	36b657        	bgeu	a6, a5, 400a1db8 <kmain+0x4d4>
400a1d81:	ffead1        	l32r	a13, 400a1d2c <kmain+0x448>
400a1d84:	ffebc1        	l32r	a12, 400a1d30 <kmain+0x44c>
400a1d87:	20b770        	or	a11, a7, a7
400a1d8a:	ffeaa1        	l32r	a10, 400a1d34 <kmain+0x450>
400a1d8d:	feed25        	call8	400a0c60 <printf_>
400a1d90:	080c      	movi.n	a8, 0
400a1d92:	ffe9d1        	l32r	a13, 400a1d38 <kmain+0x454>
400a1d95:	ffe9c1        	l32r	a12, 400a1d3c <kmain+0x458>
400a1d98:	001d42        	l16ui	a4, a13, 0
400a1d9b:	001ca2        	l16ui	a10, a12, 0
400a1d9e:	085d      	mov.n	a5, a8
400a1da0:	089d      	mov.n	a9, a8
400a1da2:	ff0c      	movi.n	a15, 15
400a1da4:	1e0c      	movi.n	a14, 1
400a1da6:	0b2c      	movi.n	a11, 32
400a1da8:	002a06        	j	400a1e54 <kmain+0x570>
400a1dab:	00          	.byte 00
400a1dac:	ff ff 07 40 	
400a1db0:	3c 03 fe 3f 	
400a1db4:	59 07 fe 3f 	
400a1db8:	550262        	l8ui	a6, a2, 85
400a1dbb:	540252        	l8ui	a5, a2, 84
400a1dbe:	116680        	slli	a6, a6, 8
400a1dc1:	206650        	or	a6, a6, a5
400a1dc4:	560252        	l8ui	a5, a2, 86
400a1dc7:	5702a2        	l8ui	a10, a2, 87
400a1dca:	115500        	slli	a5, a5, 16
400a1dcd:	205560        	or	a5, a5, a6
400a1dd0:	01aa80        	slli	a10, a10, 24
400a1dd3:	20aa50        	or	a10, a10, a5
400a1dd6:	fff521        	l32r	a2, 400a1dac <kmain+0x4c8>
400a1dd9:	07b2a7        	bgeu	a2, a10, 400a1de4 <kmain+0x500>
400a1ddc:	221b      	addi.n	a2, a2, 1
400a1dde:	804420        	add	a4, a4, a2
400a1de1:	1b3a47        	bltu	a10, a4, 400a1e00 <kmain+0x51c>
400a1de4:	4e1c      	movi.n	a14, 20
400a1de6:	fff2d1        	l32r	a13, 400a1db0 <kmain+0x4cc>
400a1de9:	fff2c1        	l32r	a12, 400a1db4 <kmain+0x4d0>
400a1dec:	1b0c      	movi.n	a11, 1
400a1dee:	ffe606        	j	400a1d8a <kmain+0x4a6>
400a1df1:	00          	.byte 00
400a1df2:	00          	.byte 00
400a1df3:	00          	.byte 00
400a1df4:	05 20 fc 3f 	
400a1df8:	3c 03 fe 3f 	
400a1dfc:	59 07 fe 3f 	
400a1e00:	fffdb1        	l32r	a11, 400a1df4 <kmain+0x510>
400a1e03:	ff30a5        	call8	400a110c <create_task>
400a1e06:	eadc      	bnez.n	a10, 400a1e28 <kmain+0x544>
400a1e08:	8e1c      	movi.n	a14, 24
400a1e0a:	fffbd1        	l32r	a13, 400a1df8 <kmain+0x514>
400a1e0d:	fffbc1        	l32r	a12, 400a1dfc <kmain+0x518>
400a1e10:	2b0c      	movi.n	a11, 2
400a1e12:	ffdd06        	j	400a1d8a <kmain+0x4a6>
400a1e15:	00          	.byte 00
400a1e16:	00          	.byte 00
400a1e17:	00          	.byte 00
400a1e18:	e8 03 f0 3f 	
400a1e1c:	e1 01 fe 3f 	
400a1e20:	05 02 fe 3f 	
400a1e24:	4e 03 fe 3f 	
400a1e28:	aa8b      	addi.n	a10, a10, 8
400a1e2a:	ff0165        	call8	400a0e40 <mmu_activate>
400a1e2d:	fffa21        	l32r	a2, 400a1e18 <kmain+0x534>
400a1e30:	0020c0        	memw
400a1e33:	0022b2        	l32i	a11, a2, 0
400a1e36:	fff9a1        	l32r	a10, 400a1e1c <kmain+0x538>
400a1e39:	fee265        	call8	400a0c60 <printf_>
400a1e3c:	0020c0        	memw
400a1e3f:	0122b2        	l32i	a11, a2, 4
400a1e42:	fff7a1        	l32r	a10, 400a1e20 <kmain+0x53c>
400a1e45:	fee1a5        	call8	400a0c60 <printf_>
400a1e48:	fff7a1        	l32r	a10, 400a1e24 <kmain+0x540>
400a1e4b:	fee165        	call8	400a0c60 <printf_>
400a1e4e:	fed8a5        	call8	400a0bd8 <pid_prepare>
400a1e51:	ffff06        	j	400a1e51 <kmain+0x56d>
400a1e54:	219a      	add.n	a2, a1, a9
400a1e56:	000222        	l8ui	a2, a2, 0
400a1e59:	232200        	sext	a2, a2, 7
400a1e5c:	290226        	beqi	a2, -1, 400a1e89 <kmain+0x5a5>
400a1e5f:	401200        	ssl	a2
400a1e62:	a12e00        	sll	a2, a14
400a1e65:	172f97        	blt	a15, a9, 400a1e80 <kmain+0x59c>
400a1e68:	202a20        	or	a2, a10, a2
400a1e6b:	f4a020        	extui	a10, a2, 0, 16
400a1e6e:	035d      	mov.n	a5, a3
400a1e70:	000546        	j	400a1e89 <kmain+0x5a5>
400a1e73:	00          	.byte 00
400a1e74:	bd 02 fe 3f 	
400a1e78:	69 07 fe 3f 	
400a1e7c:	66 01 fe 3f 	
400a1e80:	202420        	or	a2, a4, a2
400a1e83:	f44020        	extui	a4, a2, 0, 16
400a1e86:	208330        	or	a8, a3, a3
400a1e89:	991b      	addi.n	a9, a9, 1
400a1e8b:	bb0b      	addi.n	a11, a11, -1
400a1e8d:	fc3b56        	bnez	a11, 400a1e54 <kmain+0x570>
400a1e90:	188c      	beqz.n	a8, 400a1e95 <kmain+0x5b1>
400a1e92:	005d42        	s16i	a4, a13, 0
400a1e95:	158c      	beqz.n	a5, 400a1e9a <kmain+0x5b6>
400a1e97:	005ca2        	s16i	a10, a12, 0
400a1e9a:	cd2c      	movi.n	a13, 44
400a1e9c:	fff6c1        	l32r	a12, 400a1e74 <kmain+0x590>
400a1e9f:	fff6b1        	l32r	a11, 400a1e78 <kmain+0x594>
400a1ea2:	fff6a1        	l32r	a10, 400a1e7c <kmain+0x598>
400a1ea5:	fedba5        	call8	400a0c60 <printf_>
400a1ea8:	dd5c      	movi.n	a13, 93
400a1eaa:	000446        	j	400a1ebf <kmain+0x5db>
400a1ead:	00          	.byte 00
400a1eae:	00          	.byte 00
400a1eaf:	00          	.byte 00
400a1eb0:	bd 02 fe 3f 	
400a1eb4:	7a 07 fe 3f 	
400a1eb8:	66 01 fe 3f 	
400a1ebc:	60a0d2        	movi	a13, 96
400a1ebf:	fffcc1        	l32r	a12, 400a1eb0 <kmain+0x5cc>
400a1ec2:	fffcb1        	l32r	a11, 400a1eb4 <kmain+0x5d0>
400a1ec5:	fffca1        	l32r	a10, 400a1eb8 <kmain+0x5d4>
400a1ec8:	fed965        	call8	400a0c60 <printf_>
400a1ecb:	000a46        	j	400a1ef8 <kmain+0x614>
400a1ece:	00          	.byte 00
400a1ecf:	00          	.byte 00
400a1ed0:	66 03 fe 3f 	
400a1ed4:	a20c      	movi.n	a2, 10
400a1ed6:	005000        	syscall
400a1ed9:	fffda1        	l32r	a10, 400a1ed0 <kmain+0x5ec>
400a1edc:	fed825        	call8	400a0c60 <printf_>
400a1edf:	000086        	j	400a1ee5 <kmain+0x601>
400a1ee2:	ffff06        	j	400a1ee2 <kmain+0x5fe>
400a1ee5:	ffff06        	j	400a1ee5 <kmain+0x601>
400a1ee8:	bd 02 fe 3f 	
400a1eec:	7a 07 fe 3f 	
400a1ef0:	7d 03 fe 3f 	
400a1ef4:	8a 00 fe 3f 	
400a1ef8:	65a0e2        	movi	a14, 101
400a1efb:	fffbd1        	l32r	a13, 400a1ee8 <kmain+0x604>
400a1efe:	fffbc1        	l32r	a12, 400a1eec <kmain+0x608>
400a1f01:	fffbb1        	l32r	a11, 400a1ef0 <kmain+0x60c>
400a1f04:	fffca1        	l32r	a10, 400a1ef4 <kmain+0x610>
400a1f07:	fed5a5        	call8	400a0c60 <printf_>
400a1f0a:	fff506        	j	400a1ee2 <kmain+0x5fe>
400a1f0d:	000000        	ill
400a1f10:	ff5e65        	call8	400a14f8 <init_wdt>
400a1f13:	fbda16        	beqz	a10, 400a1ed4 <kmain+0x5f0>
400a1f16:	ffe886        	j	400a1ebc <kmain+0x5d8>
400a1f19:	000000        	ill

400a1f1c <common_syscall_handler>:
400a1f1c:	004136        	entry	a1, 32
400a1f1f:	2238      	l32i.n	a3, a2, 8
400a1f21:	040c      	movi.n	a4, 0
400a1f23:	2249      	s32i.n	a4, a2, 8
400a1f25:	6b9326        	beqi	a3, 10, 400a1f94 <common_syscall_handler+0x78>
400a1f28:	a80c      	movi.n	a8, 10
400a1f2a:	0a3837        	bltu	a8, a3, 400a1f38 <common_syscall_handler+0x1c>
400a1f2d:	178326        	beqi	a3, 8, 400a1f48 <common_syscall_handler+0x2c>
400a1f30:	980c      	movi.n	a8, 9
400a1f32:	3e1387        	beq	a3, a8, 400a1f74 <common_syscall_handler+0x58>
400a1f35:	004ec6        	j	400a2074 <common_syscall_handler+0x158>
400a1f38:	f40c      	movi.n	a4, 15
400a1f3a:	029347        	bne	a3, a4, 400a1f40 <common_syscall_handler+0x24>
400a1f3d:	0036c6        	j	400a201c <common_syscall_handler+0x100>
400a1f40:	004c06        	j	400a2074 <common_syscall_handler+0x158>
400a1f43:	00          	.byte 00
400a1f44:	10 30 fe 3f 	
400a1f48:	1b0c      	movi.n	a11, 1
400a1f4a:	20a220        	or	a10, a2, a2
400a1f4d:	ff7465        	call8	400a1694 <save_current_task>
400a1f50:	fe0ce5        	call8	400a0020 <get_cpu_index>
400a1f53:	11aa90        	slli	a10, a10, 7
400a1f56:	fffb31        	l32r	a3, 400a1f44 <common_syscall_handler+0x28>
400a1f59:	8033a0        	add	a3, a3, a10
400a1f5c:	1d2382        	l32i	a8, a3, 116
400a1f5f:	079816        	beqz	a8, 400a1fdc <common_syscall_handler+0xc0>
400a1f62:	1e23a2        	l32i	a10, a3, 120
400a1f65:	0008e0        	callx8	a8
400a1f68:	1d6342        	s32i	a4, a3, 116
400a1f6b:	1e6342        	s32i	a4, a3, 120
400a1f6e:	001a86        	j	400a1fdc <common_syscall_handler+0xc0>
400a1f71:	000000        	ill
400a1f74:	04bd      	mov.n	a11, a4
400a1f76:	20a220        	or	a10, a2, a2
400a1f79:	ff71a5        	call8	400a1694 <save_current_task>
400a1f7c:	002086        	j	400a2002 <common_syscall_handler+0xe6>
400a1f7f:	00          	.byte 00
400a1f80:	10 30 fe 3f 	
400a1f84:	6f 00 fe 3f 	
400a1f88:	d8 06 fe 3f 	
400a1f8c:	8c 03 fe 3f 	
400a1f90:	8a 00 fe 3f 	
400a1f94:	fe08a5        	call8	400a0020 <get_cpu_index>
400a1f97:	11aa90        	slli	a10, a10, 7
400a1f9a:	fff931        	l32r	a3, 400a1f80 <common_syscall_handler+0x64>
400a1f9d:	33aa      	add.n	a3, a3, a10
400a1f9f:	1c23a2        	l32i	a10, a3, 112
400a1fa2:	1c6342        	s32i	a4, a3, 112
400a1fa5:	3abc      	beqz.n	a10, 400a1fdc <common_syscall_handler+0xc0>
400a1fa7:	05a0c2        	movi	a12, 5
400a1faa:	02a0b2        	movi	a11, 2
400a1fad:	fee265        	call8	400a0dd4 <cas_task_state$part$0>
400a1fb0:	87a0e2        	movi	a14, 135
400a1fb3:	fff4d1        	l32r	a13, 400a1f84 <common_syscall_handler+0x68>
400a1fb6:	fff4c1        	l32r	a12, 400a1f88 <common_syscall_handler+0x6c>
400a1fb9:	fff4b1        	l32r	a11, 400a1f8c <common_syscall_handler+0x70>
400a1fbc:	fff5a1        	l32r	a10, 400a1f90 <common_syscall_handler+0x74>
400a1fbf:	feca25        	call8	400a0c60 <printf_>
400a1fc2:	ffff06        	j	400a1fc2 <common_syscall_handler+0xa6>
400a1fc5:	00          	.byte 00
400a1fc6:	00          	.byte 00
400a1fc7:	00          	.byte 00
400a1fc8:	64 f0 f5 3f 	
400a1fcc:	a1 3a d8 50 	
400a1fd0:	48 f0 f5 3f 	
400a1fd4:	ff ff ff 7f 	
400a1fd8:	ef be ad de 	
400a1fdc:	fffb41        	l32r	a4, 400a1fc8 <common_syscall_handler+0xac>
400a1fdf:	fffb31        	l32r	a3, 400a1fcc <common_syscall_handler+0xb0>
400a1fe2:	0020c0        	memw
400a1fe5:	0439      	s32i.n	a3, a4, 0
400a1fe7:	fffa81        	l32r	a8, 400a1fd0 <common_syscall_handler+0xb4>
400a1fea:	0020c0        	memw
400a1fed:	0838      	l32i.n	a3, a8, 0
400a1fef:	fff991        	l32r	a9, 400a1fd4 <common_syscall_handler+0xb8>
400a1ff2:	103390        	and	a3, a3, a9
400a1ff5:	0020c0        	memw
400a1ff8:	0839      	s32i.n	a3, a8, 0
400a1ffa:	fff731        	l32r	a3, 400a1fd8 <common_syscall_handler+0xbc>
400a1ffd:	0020c0        	memw
400a2000:	0439      	s32i.n	a3, a4, 0
400a2002:	20a220        	or	a10, a2, a2
400a2005:	ff5be5        	call8	400a15c4 <schedule>
400a2008:	002106        	j	400a2090 <common_syscall_handler+0x174>
400a200b:	00          	.byte 00
400a200c:	10 30 fe 3f 	
400a2010:	00 00 04 c0 	
400a2014:	e0 ff 01 00 	
400a2018:	a2 03 fe 3f 	
400a201c:	3248      	l32i.n	a4, a2, 12
400a201e:	062222        	l32i	a2, a2, 24
400a2021:	fdffe5        	call8	400a0020 <get_cpu_index>
400a2024:	fffa31        	l32r	a3, 400a200c <common_syscall_handler+0xf0>
400a2027:	11aa90        	slli	a10, a10, 7
400a202a:	a3aa      	add.n	a10, a3, a10
400a202c:	fff991        	l32r	a9, 400a2010 <common_syscall_handler+0xf4>
400a202f:	1c2a82        	l32i	a8, a10, 112
400a2032:	229a      	add.n	a2, a2, a9
400a2034:	412d20        	srli	a2, a2, 13
400a2037:	a02280        	addx4	a2, a2, a8
400a203a:	480222        	l8ui	a2, a2, 72
400a203d:	fff581        	l32r	a8, 400a2014 <common_syscall_handler+0xf8>
400a2040:	228a      	add.n	a2, a2, a8
400a2042:	fdfde5        	call8	400a0020 <get_cpu_index>
400a2045:	11aa90        	slli	a10, a10, 7
400a2048:	33aa      	add.n	a3, a3, a10
400a204a:	1c2332        	l32i	a3, a3, 112
400a204d:	112230        	slli	a2, a2, 13
400a2050:	2823b2        	l32i	a11, a3, 160
400a2053:	02dd      	mov.n	a13, a2
400a2055:	04cd      	mov.n	a12, a4
400a2057:	10dbb2        	addmi	a11, a11, 0x1000
400a205a:	ffefa1        	l32r	a10, 400a2018 <common_syscall_handler+0xfc>
400a205d:	fec025        	call8	400a0c60 <printf_>
400a2060:	000b06        	j	400a2090 <common_syscall_handler+0x174>
400a2063:	00          	.byte 00
400a2064:	b4 03 fe 3f 	
400a2068:	cd 03 fe 3f 	
400a206c:	e5 06 fe 3f 	
400a2070:	04 01 fe 3f 	
400a2074:	0b0c      	movi.n	a11, 0
400a2076:	fffba1        	l32r	a10, 400a2064 <common_syscall_handler+0x148>
400a2079:	febe65        	call8	400a0c60 <printf_>
400a207c:	1e3c      	movi.n	a14, 49
400a207e:	fffad1        	l32r	a13, 400a2068 <common_syscall_handler+0x14c>
400a2081:	fffac1        	l32r	a12, 400a206c <common_syscall_handler+0x150>
400a2084:	4b0c      	movi.n	a11, 4
400a2086:	fffaa1        	l32r	a10, 400a2070 <common_syscall_handler+0x154>
400a2089:	c37c      	movi.n	a3, -4
400a208b:	febd65        	call8	400a0c60 <printf_>
400a208e:	2239      	s32i.n	a3, a2, 8
400a2090:	f01d      	retw.n
	...

400a2094 <save_full_interrupt_context>:
400a2094:	03b120        	rsr.epc1	a2
400a2097:	446122        	s32i	a2, a1, 0x110
400a209a:	03e620        	rsr.ps	a2
400a209d:	456122        	s32i	a2, a1, 0x114
400a20a0:	030320        	rsr.sar	a2
400a20a3:	406122        	s32i	a2, a1, 0x100
400a20a6:	030020        	rsr.lbeg	a2
400a20a9:	416122        	s32i	a2, a1, 0x104
400a20ac:	030120        	rsr.lend	a2
400a20af:	426122        	s32i	a2, a1, 0x108
400a20b2:	030220        	rsr.lcount	a2
400a20b5:	436122        	s32i	a2, a1, 0x10c
400a20b8:	034820        	rsr.windowbase	a2
400a20bb:	034930        	rsr.windowstart	a3
400a20be:	466122        	s32i	a2, a1, 0x118
400a20c1:	476132        	s32i	a3, a1, 0x11c
400a20c4:	13d130        	wsr.excsave1	a3
400a20c7:	400200        	ssr	a2
400a20ca:	112300        	slli	a2, a3, 16
400a20cd:	812320        	src	a2, a3, a2
400a20d0:	f52020        	extui	a2, a2, 16, 16
400a20d3:	905122        	s16i	a2, a1, 0x120
400a20d6:	23e217        	bbsi	a2, 1, 400a20fd <.full_spill>
400a20d9:	4149      	s32i.n	a4, a1, 16
400a20db:	5159      	s32i.n	a5, a1, 20
400a20dd:	6169      	s32i.n	a6, a1, 24
400a20df:	7179      	s32i.n	a7, a1, 28
400a20e1:	18e227        	bbsi	a2, 2, 400a20fd <.full_spill>
400a20e4:	8189      	s32i.n	a8, a1, 32
400a20e6:	9199      	s32i.n	a9, a1, 36
400a20e8:	a1a9      	s32i.n	a10, a1, 40
400a20ea:	b1b9      	s32i.n	a11, a1, 44
400a20ec:	0de237        	bbsi	a2, 3, 400a20fd <.full_spill>
400a20ef:	c1c9      	s32i.n	a12, a1, 48
400a20f1:	d1d9      	s32i.n	a13, a1, 52
400a20f3:	e1e9      	s32i.n	a14, a1, 56
400a20f5:	f1f9      	s32i.n	a15, a1, 60
400a20f7:	021266        	bnei	a2, 1, 400a20fd <.full_spill>
400a20fa:	000ec6        	j	400a2139 <.done_spill>

400a20fd <.full_spill>:
400a20fd:	320b      	addi.n	a3, a2, -1
400a20ff:	603030        	neg	a3, a3
400a2102:	103320        	and	a3, a3, a2
400a2105:	40f320        	nsau	a2, a3
400a2108:	f1c222        	addi	a2, a2, -15
400a210b:	915122        	s16i	a2, a1, 0x122

400a210e <.spill_loop>:
400a210e:	4080f0        	rotw	-1
400a2111:	3c6502        	s32i	a0, a5, 240
400a2114:	3d6512        	s32i	a1, a5, 244
400a2117:	3e6522        	s32i	a2, a5, 248
400a211a:	3f6532        	s32i	a3, a5, 252
400a211d:	260b      	addi.n	a2, a6, -1
400a211f:	f0c512        	addi	a1, a5, -16
400a2122:	fe8256        	bnez	a2, 400a210e <.spill_loop>
400a2125:	030320        	rsr.sar	a2
400a2128:	130c      	movi.n	a3, 1
400a212a:	401200        	ssl	a2
400a212d:	a13300        	sll	a3, a3
400a2130:	134930        	wsr.windowstart	a3
400a2133:	134820        	wsr.windowbase	a2
400a2136:	002010        	rsync

400a2139 <.done_spill>:
400a2139:	f00d      	ret.n
	...

400a213c <restore_full_interrupt_context>:
400a213c:	13d110        	wsr.excsave1	a1
400a213f:	13b100        	wsr.epc1	a0
400a2142:	462122        	l32i	a2, a1, 0x118
400a2145:	472132        	l32i	a3, a1, 0x11c
400a2148:	134930        	wsr.windowstart	a3
400a214b:	134820        	wsr.windowbase	a2
400a214e:	002010        	rsync
400a2151:	03d110        	rsr.excsave1	a1
400a2154:	03b100        	rsr.epc1	a0
400a2157:	13d120        	wsr.excsave1	a2
400a215a:	911122        	l16ui	a2, a1, 0x122
400a215d:	4080f0        	rotw	-1
400a2160:	01c616        	beqz	a6, 400a2180 <.zero_regs>
400a2163:	202660        	or	a2, a6, a6
400a2166:	203550        	or	a3, a5, a5

400a2169 <.restore_loop>:
400a2169:	4080f0        	rotw	-1
400a216c:	f0c732        	addi	a3, a7, -16
400a216f:	260b      	addi.n	a2, a6, -1
400a2171:	402342        	l32i	a4, a3, 0x100
400a2174:	412352        	l32i	a5, a3, 0x104
400a2177:	422362        	l32i	a6, a3, 0x108
400a217a:	432372        	l32i	a7, a3, 0x10c
400a217d:	fe8256        	bnez	a2, 400a2169 <.restore_loop>

400a2180 <.zero_regs>:
400a2180:	034800        	rsr.windowbase	a0
400a2183:	03d130        	rsr.excsave1	a3
400a2186:	c03030        	sub	a3, a0, a3
400a2189:	339c      	beqz.n	a3, 400a21a0 <.done_zeroing_regs>
400a218b:	343030        	extui	a3, a3, 0, 4

400a218e <.zero_loop>:
400a218e:	4080f0        	rotw	-1
400a2191:	370b      	addi.n	a3, a7, -1
400a2193:	040c      	movi.n	a4, 0
400a2195:	050c      	movi.n	a5, 0
400a2197:	00a062        	movi	a6, 0
400a219a:	00a072        	movi	a7, 0
400a219d:	ed13e6        	bgei	a3, 1, 400a218e <.zero_loop>

400a21a0 <.done_zeroing_regs>:
400a21a0:	442122        	l32i	a2, a1, 0x110
400a21a3:	13b120        	wsr.epc1	a2
400a21a6:	452122        	l32i	a2, a1, 0x114
400a21a9:	13e620        	wsr.ps	a2
400a21ac:	402122        	l32i	a2, a1, 0x100
400a21af:	130320        	wsr.sar	a2
400a21b2:	412122        	l32i	a2, a1, 0x104
400a21b5:	130020        	wsr.lbeg	a2
400a21b8:	422122        	l32i	a2, a1, 0x108
400a21bb:	130120        	wsr.lend	a2
400a21be:	432122        	l32i	a2, a1, 0x10c
400a21c1:	130220        	wsr.lcount	a2
400a21c4:	901122        	l16ui	a2, a1, 0x120
400a21c7:	1de217        	bbsi	a2, 1, 400a21e8 <.done_restore_regs>
400a21ca:	4148      	l32i.n	a4, a1, 16
400a21cc:	5158      	l32i.n	a5, a1, 20
400a21ce:	6168      	l32i.n	a6, a1, 24
400a21d0:	7178      	l32i.n	a7, a1, 28
400a21d2:	12e227        	bbsi	a2, 2, 400a21e8 <.done_restore_regs>
400a21d5:	8188      	l32i.n	a8, a1, 32
400a21d7:	9198      	l32i.n	a9, a1, 36
400a21d9:	a1a8      	l32i.n	a10, a1, 40
400a21db:	b1b8      	l32i.n	a11, a1, 44
400a21dd:	07e237        	bbsi	a2, 3, 400a21e8 <.done_restore_regs>
400a21e0:	c1c8      	l32i.n	a12, a1, 48
400a21e2:	d1d8      	l32i.n	a13, a1, 52
400a21e4:	e1e8      	l32i.n	a14, a1, 56
400a21e6:	f1f8      	l32i.n	a15, a1, 60

400a21e8 <.done_restore_regs>:
400a21e8:	002010        	rsync
400a21eb:	f00d      	ret.n
400a21ed:	00          	.byte 00
400a21ee:	00          	.byte 00
400a21ef:	00          	.byte 00
400a21f0:	0f 00 04 00 	

400a21f4 <enable_kernel_exceptions>:
400a21f4:	ffff21        	l32r	a2, 400a21f0 <.done_restore_regs+0x8>
400a21f7:	13e620        	wsr.ps	a2
400a21fa:	002010        	rsync
400a21fd:	f00d      	ret.n

400a21ff <disable_kernel_exceptions>:
400a21ff:	f21c      	movi.n	a2, 31
400a2201:	13e620        	wsr.ps	a2
400a2204:	002010        	rsync
400a2207:	f00d      	ret.n
400a2209:	00          	.byte 00
400a220a:	00          	.byte 00
400a220b:	00          	.byte 00
400a220c:	ff 21 0a 40 	

400a2210 <common_exception_entry>:
400a2210:	ffe805        	call0	400a2094 <save_full_interrupt_context>
400a2213:	fffe05        	call0	400a21f4 <enable_kernel_exceptions>
400a2216:	206110        	or	a6, a1, a1
400a2219:	ff51d5        	call4	400a1738 <common_exception_handler>
400a221c:	fffc01        	l32r	a0, 400a220c <disable_kernel_exceptions+0xd>
400a221f:	0000c0        	callx0	a0
400a2222:	fff185        	call0	400a213c <restore_full_interrupt_context>
400a2225:	fa6b01        	l32r	a0, 400a0bd4 <_vsnprintf+0x850>
400a2228:	01a022        	movi	a2, 1
400a222b:	006022        	s32i	a2, a0, 0
400a222e:	0108      	l32i.n	a0, a1, 0
400a2230:	2128      	l32i.n	a2, a1, 8
400a2232:	3138      	l32i.n	a3, a1, 12
400a2234:	1118      	l32i.n	a1, a1, 4
400a2236:	003000        	rfe
400a2239:	000000        	ill

400a223c <common_interrupt_entry>:
400a223c:	ffe545        	call0	400a2094 <save_full_interrupt_context>
400a223f:	fffb45        	call0	400a21f4 <enable_kernel_exceptions>
400a2242:	206110        	or	a6, a1, a1
400a2245:	ff5995        	call4	400a17e0 <common_interrupt_handler>
400a2248:	fff101        	l32r	a0, 400a220c <disable_kernel_exceptions+0xd>
400a224b:	0000c0        	callx0	a0
400a224e:	ffeec5        	call0	400a213c <restore_full_interrupt_context>
400a2251:	fa6001        	l32r	a0, 400a0bd4 <_vsnprintf+0x850>
400a2254:	01a022        	movi	a2, 1
400a2257:	006022        	s32i	a2, a0, 0
400a225a:	0108      	l32i.n	a0, a1, 0
400a225c:	2128      	l32i.n	a2, a1, 8
400a225e:	3138      	l32i.n	a3, a1, 12
400a2260:	1118      	l32i.n	a1, a1, 4
400a2262:	003000        	rfe
400a2265:	000000        	ill

400a2268 <syscall_entry>:
400a2268:	03b100        	rsr.epc1	a0
400a226b:	003b      	addi.n	a0, a0, 3
400a226d:	030120        	rsr.lend	a2
400a2270:	0c9027        	bne	a0, a2, 400a2280 <.skipped_syscall>
400a2273:	030220        	rsr.lcount	a2
400a2276:	628c      	beqz.n	a2, 400a2280 <.skipped_syscall>
400a2278:	220b      	addi.n	a2, a2, -1
400a227a:	130220        	wsr.lcount	a2
400a227d:	030000        	rsr.lbeg	a0

400a2280 <.skipped_syscall>:
400a2280:	13b100        	wsr.epc1	a0
400a2283:	000146        	j	400a228c <.slow_path>

400a2286 <.fast_path>:
400a2286:	0005c6        	j	400a22a1 <.return_from_syscall>
400a2289:	000000        	ill

400a228c <.slow_path>:
400a228c:	ffe045        	call0	400a2094 <save_full_interrupt_context>
400a228f:	fff645        	call0	400a21f4 <enable_kernel_exceptions>
400a2292:	206110        	or	a6, a1, a1
400a2295:	ffc855        	call4	400a1f1c <common_syscall_handler>
400a2298:	ffdd01        	l32r	a0, 400a220c <disable_kernel_exceptions+0xd>
400a229b:	0000c0        	callx0	a0
400a229e:	ffe9c5        	call0	400a213c <restore_full_interrupt_context>

400a22a1 <.return_from_syscall>:
400a22a1:	fa4c01        	l32r	a0, 400a0bd4 <_vsnprintf+0x850>
400a22a4:	01a022        	movi	a2, 1
400a22a7:	006022        	s32i	a2, a0, 0
400a22aa:	0108      	l32i.n	a0, a1, 0
400a22ac:	2128      	l32i.n	a2, a1, 8
400a22ae:	3138      	l32i.n	a3, a1, 12
400a22b0:	1118      	l32i.n	a1, a1, 4
400a22b2:	003000        	rfe
	...
400a22c1:	10          	.byte 0x10
400a22c2:	00          	.byte 00
400a22c3:	00          	.byte 00
400a22c4:	00 10 fe 3f 	
	...

400a22d0 <_start>:
400a22d0:	110c      	movi.n	a1, 1
400a22d2:	000c      	movi.n	a0, 0
400a22d4:	134910        	wsr.windowstart	a1
400a22d7:	134800        	wsr.windowbase	a0
400a22da:	002010        	rsync
400a22dd:	fdfc01        	l32r	a0, 400a1ad0 <kmain+0x1ec>
400a22e0:	13e700        	wsr.vecbase	a0
400a22e3:	00a002        	movi	a0, 0
400a22e6:	130200        	wsr.lcount	a0
400a22e9:	fff501        	l32r	a0, 400a22c0 <.return_from_syscall+0x1f>
400a22ec:	fff611        	l32r	a1, 400a22c4 <.return_from_syscall+0x23>
400a22ef:	801100        	add	a1, a1, a0
400a22f2:	ff5f15        	call4	400a18e4 <kmain>
400a22f5:	000000        	ill

Disassembly of section .vdso:

4009e000 <vecbase>:
4009e000:	49c500        	s32e	a0, a5, -16
4009e003:	49d510        	s32e	a1, a5, -12
4009e006:	49e520        	s32e	a2, a5, -8
4009e009:	49f530        	s32e	a3, a5, -4
4009e00c:	003400        	rfwo
	...

4009e040 <window_underflow_4>:
4009e040:	09c500        	l32e	a0, a5, -16
4009e043:	09d510        	l32e	a1, a5, -12
4009e046:	09e520        	l32e	a2, a5, -8
4009e049:	09f530        	l32e	a3, a5, -4
4009e04c:	003500        	rfwu
	...

4009e080 <window_overflow_8>:
4009e080:	49c900        	s32e	a0, a9, -16
4009e083:	09d100        	l32e	a0, a1, -12
4009e086:	49d910        	s32e	a1, a9, -12
4009e089:	49e920        	s32e	a2, a9, -8
4009e08c:	49f930        	s32e	a3, a9, -4
4009e08f:	498040        	s32e	a4, a0, -32
4009e092:	499050        	s32e	a5, a0, -28
4009e095:	49a060        	s32e	a6, a0, -24
4009e098:	49b070        	s32e	a7, a0, -20
4009e09b:	003400        	rfwo
	...

4009e0c0 <window_underflow_8>:
4009e0c0:	09c900        	l32e	a0, a9, -16
4009e0c3:	09d910        	l32e	a1, a9, -12
4009e0c6:	09e920        	l32e	a2, a9, -8
4009e0c9:	09d170        	l32e	a7, a1, -12
4009e0cc:	09f930        	l32e	a3, a9, -4
4009e0cf:	098740        	l32e	a4, a7, -32
4009e0d2:	099750        	l32e	a5, a7, -28
4009e0d5:	09a760        	l32e	a6, a7, -24
4009e0d8:	09b770        	l32e	a7, a7, -20
4009e0db:	003500        	rfwu
	...

4009e100 <window_overflow_12>:
4009e100:	49cd00        	s32e	a0, a13, -16
4009e103:	09d100        	l32e	a0, a1, -12
4009e106:	49dd10        	s32e	a1, a13, -12
4009e109:	49ed20        	s32e	a2, a13, -8
4009e10c:	49fd30        	s32e	a3, a13, -4
4009e10f:	494040        	s32e	a4, a0, -48
4009e112:	495050        	s32e	a5, a0, -44
4009e115:	496060        	s32e	a6, a0, -40
4009e118:	497070        	s32e	a7, a0, -36
4009e11b:	498080        	s32e	a8, a0, -32
4009e11e:	499090        	s32e	a9, a0, -28
4009e121:	49a0a0        	s32e	a10, a0, -24
4009e124:	49b0b0        	s32e	a11, a0, -20
4009e127:	003400        	rfwo
	...

4009e140 <window_underflow_12>:
4009e140:	09cd00        	l32e	a0, a13, -16
4009e143:	09dd10        	l32e	a1, a13, -12
4009e146:	09ed20        	l32e	a2, a13, -8
4009e149:	09d1b0        	l32e	a11, a1, -12
4009e14c:	09fd30        	l32e	a3, a13, -4
4009e14f:	094b40        	l32e	a4, a11, -48
4009e152:	095b50        	l32e	a5, a11, -44
4009e155:	096b60        	l32e	a6, a11, -40
4009e158:	097b70        	l32e	a7, a11, -36
4009e15b:	098b80        	l32e	a8, a11, -32
4009e15e:	099b90        	l32e	a9, a11, -28
4009e161:	09aba0        	l32e	a10, a11, -24
4009e164:	09bbb0        	l32e	a11, a11, -20
4009e167:	003500        	rfwu
	...
4009e17e:	000000        	ill
4009e181:	1003d2        	l8ui	a13, a3, 16
4009e184:	000032        	l8ui	a3, a0, 0
	...
4009e1bf:	d30000        	movt	a0, a0, b0
4009e1c2:	331003        	lsi	f0, a0, 204
	...
4009e201:	1003d4        	lsi	f13, a3, 64
4009e204:	000034        	lsi	f3, a0, 0
	...
4009e23f:	d50000        	extui	a0, a0, 16, 14
4009e242:	351003        	lsi	f0, a0, 212
	...
4009e281:	1003d6        	bgez	a3, 4009e385 <task_trampoline+0x1>
4009e284:	000036        	entry	a0, 0
	...
4009e2bf:	d70000        	lsi	f0, a0, 0x35c
4009e2c2:	371003        	lsi	f0, a0, 220
	...

4009e300 <kernel_exception>:
4009e300:	003000        	rfe
4009e303:	092000        	l32e	a0, a0, -56
4009e306:	fe          	.byte 0xfe
4009e307:	3f          	.byte 0x3f
4009e308:	fe0820        	f64iter	a0, a8, a2, 3, 1
4009e30b:	3f          	.byte 0x3f
	...

4009e340 <user_exception>:
4009e340:	13d110        	wsr.excsave1	a1
4009e343:	13c000        	wsr.depc	a0
4009e346:	03eb10        	rsr.prid	a1
4009e349:	041d10        	extui	a1, a1, 13, 1
4009e34c:	ffee01        	l32r	a0, 4009e304 <kernel_exception+0x4>
4009e34f:	a01100        	addx4	a1, a1, a0
4009e352:	0118      	l32i.n	a1, a1, 0
4009e354:	ffd112        	addmi	a1, a1, 0xffffff00
4009e357:	dcc112        	addi	a1, a1, -36
4009e35a:	03c000        	rsr.depc	a0
4009e35d:	0109      	s32i.n	a0, a1, 0
4009e35f:	03d100        	rsr.excsave1	a0
4009e362:	1109      	s32i.n	a0, a1, 4
4009e364:	2129      	s32i.n	a2, a1, 8
4009e366:	3139      	s32i.n	a3, a1, 12
4009e368:	03e800        	rsr.exccause	a0
4009e36b:	ffe721        	l32r	a2, 4009e308 <kernel_exception+0x8>
4009e36e:	a00020        	addx4	a0, a0, a2
4009e371:	0008      	l32i.n	a0, a0, 0
4009e373:	0000a0        	jx	a0
	...
4009e37e:	000000        	ill
4009e381:	000032        	l8ui	a3, a0, 0

4009e384 <task_trampoline>:
4009e384:	004136        	entry	a1, 32
4009e387:	0002e0        	callx8	a2
4009e38a:	a20c      	movi.n	a2, 10
4009e38c:	005000        	syscall
4009e38f:	f01d      	retw.n
4009e391:	000000        	ill
