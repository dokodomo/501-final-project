clear;close all;clc

syms l1 l2 l3 xo yo zo xa ya za xb yb zb xc yc zc



eqn=[sqrt((xo-xa)^2+(yo-ya)^2+zo^2)==l1;
    sqrt((xo-xb)^2+(yo-yb)^2+zo^2)==l2;
    sqrt((xo-xc)^2+(yo-yc)^2+zo^2)==l3;
];


[x,y,z]=solve(eqn(1),eqn(2),eqn(3),xo,yo,zo);

