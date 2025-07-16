.data
    a: .zero 4100
    nr_operatii: .space 4
    operatie: .space 4
    index: .space 4
    citire: .asciz "%ld"
    afisare: .asciz "%ld\n"
    id: .space 4

    fisiere: .space 4
    dim: .space 4
    spatii: .space 4
    start: .space 4
    finish: .space 4
    afisare_id: .asciz "%ld: (%ld, %ld)\n"
    afisare_add_gol: .asciz "%ld: (0, 0)\n"

    flag: .space 4
    afisare_gol: .asciz "(0, 0)\n"
    afisare_get: .asciz "(%ld, %ld)\n"

    nr_zerouri: .space 4
    loc: .space 4
    flag_zero: .space 4
    nr_spatii: .space 4
    sterge: .space 4

.text

.global main
main:
    lea a, %edi
    pushl $nr_operatii
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    movl $0, index
    xorl %eax, %eax
    et_loop:
        movl index, %ecx
        cmp nr_operatii, %ecx
        je et_exit

        pushl $operatie
        pushl $citire
        call scanf
        popl %ebx
        popl %ebx

        cmp $1, operatie
        je ADD
        cmp $2, operatie
        je GET
        cmp $3, operatie
        je DELETE
        cmp $4, operatie
        je DEFRAG

        ADD:
            pushl $fisiere
            pushl $citire
            call scanf
            popl %ebx
            popl %ebx

            movl $0, %ebp
            et_for_add_1:
                cmp fisiere, %ebp
                je et_exit_add

                pushl $id
                pushl $citire
                call scanf
                popl %ebx
                popl %ebx

                pushl $dim
                pushl $citire
                call scanf
                popl %ebx
                popl %ebx

                et_pas_1_add:
                    movl $0, %edx
                    movl dim, %eax
                    movl $8, %ebx
                    div %ebx
                    cmp $0, %edx
                    je et_pas_2_add
                    incl %eax

                et_pas_2_add:
                    movl $0, %ebx
                    movl $0, start
                    movl %eax, finish
                    et_for_add_2:
                        cmp finish, %ebx
                        je et_exit_for_2

                        cmp $1024, %ebx
                        jg et_exit_no_space

                        cmp $0, (%edi, %ebx, 4)
                        je et_exit2_for_2

                        movl %ebx, start
                        incl start

                        movl %ebx, finish
                        addl %eax, finish
                        incl finish

                        et_exit2_for_2:
                            incl %ebx
                            jmp et_for_add_2
                
                et_exit_for_2:
                    movl finish, %edx
                    cmp $1024, %edx
                    jg et_exit_no_space

                    movl start, %ebx
                    et_for_3:
                        cmp finish, %ebx
                        je et_exit_for_3
                        movl id, %eax
                        movl %eax, (%edi, %ebx, 4)

                        incl %ebx
                        jmp et_for_3

                    et_exit_for_3:
                        subl $1, finish
                        pushl finish
                        pushl start
                        pushl id
                        pushl $afisare_id
                        call printf
                        popl %ebx
                        popl %ebx
                        popl %ebx
                        popl %ebx
                    
                        incl %ebp
                        jmp et_for_add_1

                    et_exit_no_space:
                        pushl id
                        pushl $afisare_add_gol
                        call printf
                        popl %ebx
                        popl %ebx

                        incl %ebp
                        jmp et_for_add_1
            
            et_exit_add:
                incl index
                jmp et_loop

        GET:
            pushl $id
            pushl $citire
            call scanf
            popl %ebx
            popl %ebx

            movl $0, %ebp
            movl $0, flag
            et_for_get:
                cmp $1024, %ebp
                je et_pas_3_get

                et_pas_1_get:
                    movl id, %eax
                    cmp %eax, (%edi, %ebp, 4)
                    jne et_pas_2_get

                    cmp $0, flag
                    jne et_pas_2_get

                    movl %ebp, start
                    movl $1, flag

                et_pas_2_get:
                    movl id, %eax
                    cmp %eax, (%edi, %ebp, 4)
                    jne et_exit_for_get

                    movl %ebp, finish

                et_exit_for_get:
                    incl %ebp
                    jmp et_for_get


            et_pas_3_get:
                cmp $0, flag
                jne et_pas_4_get

                pushl $afisare_gol
                call printf
                popl %ebx

                jmp et_exit_get

                et_pas_4_get:
                    pushl finish
                    pushl start
                    pushl $afisare_get
                    call printf
                    popl %ebx
                    popl %ebx
                    popl %ebx

                et_exit_get:
                    incl index
                    jmp et_loop

        DELETE:
            pushl $id
            pushl $citire
            call scanf
            popl %ebx
            popl %ebx

            movl $0, %ebp
            et_for_delete:
                cmp $1024, %ebp
                je et_afisare

                et_pas_1_delete:
                    movl id, %eax
                    cmp %eax, (%edi, %ebp, 4)
                    jne et_pas_2_delete

                    movl $0, (%edi, %ebp, 4)
                
                et_pas_2_delete:
                    incl %ebp
                    jmp et_for_delete
  
            et_afisare:
                movl $0, flag
                movl $0, %ebp
                et_for_afisare:
                    cmp $1024, %ebp
                    je et_exit_delete
    
                    et_if_1:
                        cmp $0, (%edi, %ebp, 4)
                        je et_if_2

                        movl flag, %eax
                        cmp $0, %eax
                        jne et_if_2

                        movl %ebp, start
                        movl $1, flag

                    et_if_2:
                        movl (%edi, %ebp, 4), %eax
                        cmp %eax, 4(%edi, %ebp, 4)
                        je et_if_3

                        cmp $1, flag
                        jne et_if_3

                        movl %ebp, finish
                        movl $2, flag

                    et_if_3:
                        cmp $2, flag
                        jne et_pas_3_delete

                        pushl %ebp
                        pushl finish
                        pushl start
                        pushl (%edi, %ebp, 4)
                        pushl $afisare_id
                        call printf
                        popl %ebx
                        popl (%edi, %ebp, 4)
                        popl %ebx
                        popl %ebx
                        popl %ebp

                        movl $0, flag
                    
                    et_pas_3_delete:
                        incl %ebp
                        jmp et_for_afisare
            
            et_exit_delete:
                incl index
                jmp et_loop

        DEFRAG:
            movl $0, nr_zerouri
            movl $0, flag_zero
            movl $0, flag
            movl $0, loc
            movl $0, start
            movl $0, finish
            movl $0, %ebp
            et_for_defrag_main:
                cmp $1024, %ebp
                je et_afisare_defrag

                movl (%edi, %ebp, 4), %edx
                et_if_1_defrag_main:
                    cmp $0, %edx
                    jne et_if_2_defrag_main

                    incl nr_zerouri

                    movl flag_zero, %eax
                    cmp $0, %eax
                    jne et_if_2_defrag_main

                    movl %ebp, loc
                    movl $1, flag_zero


                et_if_2_defrag_main:
                    cmp $0, %edx
                    je et_if_3_defrag_main

                    movl flag, %eax
                    cmp $0, %eax
                    jne et_if_3_defrag_main

                    movl %ebp, start
                    movl $1, flag

                et_if_3_defrag_main:
                    cmp $0, %edx
                    je stergere

                    cmp %edx, 4(%edi, %ebp, 4)
                    je stergere

                    movl %ebp, finish
                    movl $2, flag

                stergere:
                    movl flag, %eax
                    cmp $2, %eax
                    jne et_exit_for_defrag

                    movl (%edi, %ebp, 4), %edx

                    movl finish, %eax
                    subl start, %eax
                    addl $1, %eax
                    movl %eax, nr_spatii

                    cmp $0, %eax
                    je et_exit_stergere

                    movl finish, %ebx
                    subl loc, %ebx
                    subl nr_spatii, %ebx
                    incl %ebx
                    movl %ebx, sterge

                    movl loc, %eax
                    movl loc, %ebx
                    addl nr_spatii, %ebx
                    
                    et_for_stergere_1:
                        cmp %ebx, %eax
                        je et_pas_2_defrag

                        movl (%edi, %ebp, 4), %edx
                        movl %edx, (%edi, %eax, 4)

                        incl %eax
                        jmp et_for_stergere_1

                    et_pas_2_defrag:
                        movl loc, %eax
                        addl nr_spatii, %eax
                        movl loc, %ebx
                        addl nr_spatii, %ebx
                        addl sterge, %ebx

                        et_for_stergere_2:
                            cmp %ebx, %eax
                            je et_exit_for_stergere_2

                            movl $0, (%edi, %eax, 4)

                            incl %eax
                            jmp et_for_stergere_2

                        et_exit_for_stergere_2:
                            movl nr_spatii, %eax
                            subl %eax, nr_zerouri
                            addl %eax, loc

                    et_exit_stergere:
                        movl $0, flag

                et_exit_for_defrag:
                    incl %ebp
                    jmp et_for_defrag_main
            
            et_afisare_defrag:
                movl $0, flag
                movl $0, %ebp
                et_for_afisare_defrag:
                    cmp $1024, %ebp
                    je et_exit_defrag
    
                    et_if_1_defrag:
                        cmp $0, (%edi, %ebp, 4)
                        je et_if_2_defrag

                        movl flag, %eax
                        cmp $0, %eax
                        jne et_if_2_defrag

                        movl %ebp, start
                        movl $1, flag

                    et_if_2_defrag:
                        movl (%edi, %ebp, 4), %eax
                        cmp %eax, 4(%edi, %ebp, 4)
                        je et_if_3_defrag

                        cmp $1, flag
                        jne et_if_3_defrag

                        movl %ebp, finish
                        movl $2, flag

                    et_if_3_defrag:
                        cmp $2, flag
                        jne et_pas_3_defrag

                        pushl %ebp
                        pushl finish
                        pushl start
                        pushl (%edi, %ebp, 4)
                        pushl $afisare_id
                        call printf
                        popl %ebx
                        popl (%edi, %ebp, 4)
                        popl %ebx
                        popl %ebx
                        popl %ebp

                        movl $0, flag
                    
                    et_pas_3_defrag:
                        incl %ebp
                        jmp et_for_afisare_defrag
                
                et_exit_defrag:
                    incl index
                    jmp et_loop

et_exit:
    pushl $0
    call fflush
    popl %eax

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80