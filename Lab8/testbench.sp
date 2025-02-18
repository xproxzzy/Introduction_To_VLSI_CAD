*** testbench ***
.INC'circuit.spi'
.GLOBAL gnd
+vdd

.protect
.lib 'cic018.l' TT
.unprotect

.op
.options post
.tran 0.05n 160n
.temp 25

xinv in out_1 VDD GND inv
xnand A B out_2 VDD GND nand
xnor C D out_3 VDD GND nor

*** Testing Voltage ***
v1 vdd gnd DC 1.8v
v2 gnd gnd DC 0v
v3 in gnd pulse(0 1.8 0 0.1n 0.1n 20n 40n)
v4 A gnd pulse(0 1.8 0 0.1n 0.1n 20n 40n)
v5 B gnd pulse(0 1.8 0 0.1n 0.1n 40n 80n)
v6 C gnd pulse(0 1.8 0 0.1n 0.1n 20n 40n)
v7 D gnd pulse(0 1.8 0 0.1n 0.1n 40n 80n)
.end