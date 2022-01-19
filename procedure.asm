        jump.i  #lab0                   ;jump.i  lab0
f:
        enter.i #20                     ;enter.i 20
        sub.i   *BP+12,*BP+8,BP-12      ;sub.i   b,c,$t0
        inttoreal.i BP-12,BP-20         ;inttoreal.i $t0,$t1
        mov.r   BP-20,BP-8              ;mov.r   $t1,g
        write.r BP-8                    ;write.r g
        leave                           ;leave   
        return                          ;return  
lab0:
        mov.i   #4,8                    ;mov.i   4,i
        mov.i   #4,12                   ;mov.i   4,j
        mod.i   #2,#3,16                ;mod.i   2,3,$t2
        mov.i   16,0                    ;mov.i   $t2,g
        push.i  #8                      ;push.i  &i
        push.i  #12                     ;push.i  &j
        call.i  #f                      ;call.i  &f
        incsp.i #8                      ;incsp.i 8
        write.i 0                       ;write.i g
        write.i 4                       ;write.i h
        exit                            ;exit    
