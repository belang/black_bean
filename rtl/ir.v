`timescale 1ns/1ps
// file name: ir.v
// author: lianghy
// time: 2017-4-14 16:47:19

/*This is a ir defining file*/

`define JUMP  8'b00000010 
`define STOP  8'b00001110 
`define LOAD  8'b10000000 
`define STORE 8'b10000001 
`define RESET 8'b00001111 
`define SET_D 8'b00010000 
`define SET_R 8'b00010001 
`define SET_A 8'b00010010 
`define ADD   8'b00100000 
`define SUB   8'b00100001 
`define MOD   8'b00100010 
`define DIV   8'b00100011 
`define LARGE 8'b00101000 
`define SMALL 8'b00101001 
`define EQUAL 8'b00101010 
