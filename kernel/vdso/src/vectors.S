
.section .text

/**
 * The way interrupt vectors work in xtensa is that there are 64byte between vector entries and
 * it jumps to the constant offset between each of them.
 */

/***********************************************************************************************************************
 * Window overflow/underflow, these are pretty simple
 *
 * For these we simply need to spill/load to/from the stack the first x gpregs,
 * we need to use the special rfwo (return from window overflow) and rfwu (return from window underflow)
 * to properly handle these
 **********************************************************************************************************************/

.global vecbase

.align 64
vecbase:
/* window overflow 4 - 0x00 */
	s32e	a0, a5, -16
	s32e	a1, a5, -12
	s32e	a2, a5,  -8
	s32e	a3, a5,  -4
	rfwo

.align 64
/* window underflow 4 - 0x40 */
	l32e	a0, a5, -16
	l32e	a1, a5, -12
	l32e	a2, a5,  -8
	l32e	a3, a5,  -4
	rfwu

.align 64
/* windows overflow 8 - 0x80 */
	s32e	a0, a9, -16
	l32e	a0, a1, -12
	s32e	a2, a9,  -8
	s32e	a1, a9, -12
	s32e	a3, a9,  -4
	s32e	a4, a0, -32
	s32e	a5, a0, -28
	s32e	a6, a0, -24
	s32e	a7, a0, -20
	rfwo

.align 64
/* windows underflow 8 - 0xc0 */
	l32e	a1, a9, -12
	l32e	a0, a9, -16
	l32e	a7, a1, -12
	l32e	a2, a9,  -8
	l32e	a4, a7, -32
	l32e	a3, a9,  -4
	l32e	a5, a7, -28
	l32e	a6, a7, -24
	l32e	a7, a7, -20
	rfwu

.align 64
/* windows overflow 12 - 0x100 */
	s32e	a0,  a13, -16
	l32e	a0,  a1,  -12
	s32e	a1,  a13, -12
	s32e	a2,  a13,  -8
	s32e	a3,  a13,  -4
	s32e	a4,  a0,  -48
	s32e	a5,  a0,  -44
	s32e	a6,  a0,  -40
	s32e	a7,  a0,  -36
	s32e	a8,  a0,  -32
	s32e	a9,  a0,  -28
	s32e	a10, a0,  -24
	s32e	a11, a0,  -20
	rfwo

.align 64
/* windows underflow 12 - 0x140 */
	l32e	a1,  a13, -12
	l32e	a0,  a13, -16
	l32e	a11, a1,  -12
	l32e	a2,  a13,  -8
	l32e	a4,  a11, -48
	l32e	a8,  a11, -32
	l32e	a3,  a13,  -4
	l32e	a5,  a11, -44
	l32e	a6,  a11, -40
	l32e	a7,  a11, -36
	l32e	a9,  a11, -28
	l32e	a10, a11, -24
	l32e	a11, a11, -20
	rfwu

/***********************************************************************************************************************
 * Interrupt levels
 **********************************************************************************************************************/

.align 64
/* interrupt level 2 - 0x180 */
    rfi 2

.align 64
/* interrupt level 3 - 0x1c0 */
    rfi 3

.align 64
/* interrupt level 4 - 0x200 */
    rfi 4

.align 64
/* interrupt level 5 - 0x240 */
    rfi 5

.align 64
/* interrupt level 6 (debug) - 0x280 */
    rfi 6

.align 64
/* interrupt level 7 (nmi) - 0x2c0 */
    rfi 7

/***********************************************************************************************************************
 * Normal exceptions
 **********************************************************************************************************************/

.align 64
/* kernel exception - 0x300 */
    rfe

.align 64
/* user exception - 0x340 */
    rfe

.align 64
/* double exception - 0x380 */
    rfde
