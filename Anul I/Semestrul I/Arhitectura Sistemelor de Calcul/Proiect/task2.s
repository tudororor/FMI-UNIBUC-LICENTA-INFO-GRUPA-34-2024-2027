.data
    m: .zero 4294304
    #ar trebui 4194304
    nr_el_linie: .long 1024
    nr_operatii: .space 4
    index: .space 4
    operatie: .space 4
    citire: .asciz "%ld"
    afisare: .asciz "%ld\n"

    id: .space 4
    flag: .space 4
    linie: .space 4
    start: .space 4
    finish: .space 4
    afisare_id: .asciz "%ld: ((%ld, %ld), (%ld, %ld))\n"

    fisiere: .space 4
    e: .space 4
    dim: .space 4
    spatii: .space 4
    afisare_add_gol: .asciz "%ld: ((0, 0), (0, 0))\n"

    afisare_get: .asciz "((%ld, %ld), (%ld, %ld))\n"
    afisare_get_gol: .asciz "((0, 0), (0, 0))\n"

    last_i: .space 4
    last_j: .space 4
    nr_spatii: .space 4
    nr_zerouri: .space 4
    finish_defrag: .space 4

.text

.global main
main:
    lea m, %edi
    pushl $nr_operatii
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    movl $0, index
    et_loop:
        movl index, %ecx
        cmpl nr_operatii, %ecx
        je et_exit

        pushl $operatie
        pushl $citire
        call scanf
        popl %ebx
        popl %ebx

        cmpl $1, operatie
        je ADD
        cmpl $2, operatie
        je GET
        cmpl $3, operatie
        je DELETE
        cmpl $4, operatie
        je DEFRAG

        ADD:
            pushl $fisiere
            pushl $citire
            call scanf
            popl %ebx
            popl %ebx

            movl $0, e
            et_for_add_main:
                movl e, %ecx
                cmpl fisiere, %ecx
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
                    cmpl $0, %edx
                    je et_pas_2_add
                    incl %eax

                et_pas_2_add:
                    movl %eax, spatii
                    movl $0, %ebx
                    et_while_add:
                        cmp $1024, %ebx
                        jge et_exit_while_add

                        movl $0, start
                        movl spatii, %eax
                        movl %eax, finish

                        movl $0, %ecx
                        et_for_add:
                            cmp finish, %ecx
                            je et_adaugare_id

                            movl $1, %eax
                            mull nr_el_linie
                            mull %ebx
                            addl %ecx, %eax

                            cmpl $0, (%edi, %eax, 4)
                            je et_exit_for_add
                            
                            movl %ecx, start
                            incl start

                            movl %ecx, finish
                            movl spatii, %edx
                            addl %edx, finish
                            incl finish
                            
                            et_exit_for_add:
                                incl %ecx
                                jmp et_for_add

                        et_adaugare_id:
                            cmpl $1024, finish
                            jg next_while_i

                            movl start, %ecx
                            et_for_adaugare_id:
                                cmp finish, %ecx
                                je et_exit_for_adaugare_id

                                movl $1, %eax
                                mull nr_el_linie
                                mull %ebx
                                addl %ecx, %eax

                                movl id, %edx
                                movl %edx, (%edi, %eax, 4)

                                incl %ecx
                                jmp et_for_adaugare_id

                            et_exit_for_adaugare_id:
                                decl finish

                                pushl %ebx
                                pushl %ecx
                                pushl finish
                                pushl %ebx
                                pushl start
                                pushl %ebx
                                pushl id
                                pushl $afisare_id
                                call printf
                                popl %edx
                                popl %edx
                                popl %ebx
                                popl %edx
                                popl %ebx
                                popl %edx
                                popl %ecx
                                popl %ebx

                                movl $1025, %ebx
                                jmp et_while_add

                        next_while_i:
                            incl %ebx
                            jmp et_while_add

                    et_exit_while_add:
                        cmp $1024, %ebx
                        jne et_exit_for

                        pushl %ebx
                        pushl %ecx
                        pushl id
                        pushl $afisare_add_gol
                        call printf
                        popl %edx
                        popl %edx
                        popl %ecx
                        popl %ebx

                et_exit_for:
                    incl e
                    jmp et_for_add_main

            et_exit_add:
                incl index
                jmp et_loop

        GET:
            movl $0, flag

            pushl $id
            pushl $citire
            call scanf
            popl %ebx
            popl %ebx

            movl $0, %ebx
            et_for_get_i:
                cmpl $1024, %ebx
                je et_exit_for_get_i

                movl $0, %ecx
                et_for_get_j:
                    cmpl $1024, %ecx
                    je et_exit_for_get_j

                    movl $1, %eax
                    mull nr_el_linie
                    mull %ebx
                    addl %ecx, %eax
                    movl (%edi, %eax, 4), %edx

                    cmpl id, %edx
                    jne et_next_j_get

                    cmpl $0, flag
                    jne et_get_set_finish

                    movl %ebx, linie
                    movl %ecx, start
                    movl $1, flag

                    et_get_set_finish:
                        movl %ecx, finish

                    et_next_j_get:
                        incl %ecx
                        jmp et_for_get_j

                et_exit_for_get_j:
                    incl %ebx
                    jmp et_for_get_i

            et_exit_for_get_i:
                cmpl $0, flag
                jne et_afisare_get

                pushl $afisare_get_gol
                call printf
                popl %ebx

                jmp et_exit_get

            et_afisare_get:
                pushl finish
                pushl linie
                pushl start
                pushl linie
                pushl $afisare_get
                call printf
                popl %ebx
                popl %ebx
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

            movl $0, %ebx
            et_for_delete_i_main:
                cmpl $1024, %ebx
                je et_afisare_delete

                movl $0, %ecx
                et_for_delete_j_main:
                    cmpl $1024, %ecx
                    je et_exit_for_delete_j_main

                    movl $1, %eax
                    mull nr_el_linie
                    mull %ebx
                    addl %ecx, %eax
                    movl (%edi, %eax, 4), %edx
                    
                    cmpl id, %edx
                    jne et_next_j_delete_main

                    movl $0, (%edi, %eax, 4)

                    et_next_j_delete_main:
                        incl %ecx
                        jmp et_for_delete_j_main

                et_exit_for_delete_j_main:
                    incl %ebx
                    jmp et_for_delete_i_main

            et_afisare_delete:
                movl $0, flag
                movl $0, %ebx
                et_for_delete_i:
                    cmpl $1024, %ebx
                    je et_exit_delete

                    movl $0, %ecx
                    et_for_delete_j:
                        cmpl $1024, %ecx
                        je et_exit_for_delete_j

                        movl $1, %eax
                        mull nr_el_linie
                        mull %ebx
                        addl %ecx, %eax
                        movl (%edi, %eax, 4), %edx

                        et_if_1_delete:
                            cmpl $0, %edx
                            je et_next_j_delete

                            cmpl $0, flag
                            jne et_if_2_delete

                            movl %ebx, linie
                            movl %ecx, start
                            movl $1, flag

                        et_if_2_delete:
                            incl %eax
                            cmpl %edx, (%edi, %eax, 4)
                            je et_next_j_delete

                            cmpl $1, flag
                            jne et_if_3_delete

                            movl %ecx, finish
                            movl $2, flag

                        et_if_3_delete:
                            cmpl $2, flag
                            jne et_next_j_delete

                            pushl %ecx
                            pushl finish
                            pushl linie
                            pushl start
                            pushl linie
                            pushl %edx
                            pushl $afisare_id
                            call printf
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %ecx

                            movl $0, flag

                        et_next_j_delete:
                            incl %ecx
                            jmp et_for_delete_j

                    et_exit_for_delete_j:
                        incl %ebx
                        jmp et_for_delete_i

            et_exit_delete:
                incl index
                jmp et_loop

        DEFRAG:
            movl $0, last_i
            movl $-1, last_j
            movl $0, flag
            
            movl $0, %ebx
            et_for_defrag_i:
                cmpl $1024, %ebx
                je et_afisare_defrag

                movl $0, %ecx
                et_for_defrag_j:
                    cmpl $1024, %ecx
                    je et_next_i_defrag

                    movl $1, %eax
                    mull nr_el_linie
                    mull %ebx
                    addl %ecx, %eax
                    movl (%edi, %eax, 4), %edx

                    et_if_1_defrag:
                        cmpl $0, %edx
                        je et_next_j_defrag

                        cmpl $0, flag
                        jne et_if_2_defrag

                        movl %ebx, linie
                        movl %ecx, start
                        movl $1, flag

                    et_if_2_defrag:
                        incl %eax
                        cmpl (%edi, %eax, 4), %edx
                        je et_next_j_defrag

                        cmpl $1, flag
                        jne et_next_j_defrag

                        movl %ecx, finish
                        movl $2, flag

                    et_if_main_defrag:
                        cmpl $2, flag
                        jne et_next_j_defrag

                        movl %edx, id
                        movl finish, %eax
                        subl start, %eax
                        incl %eax
                        movl %eax, nr_spatii

                        et_if_1_main_defrag:
                            movl linie, %eax
                            cmpl %eax, last_i
                            je et_else_1_main_defrag

                            movl $1024, %eax
                            subl last_j, %eax
                            decl %eax
                            movl %eax, nr_zerouri

                            et_yes_space_defrag:
                                cmpl %eax, nr_spatii
                                jg et_no_space_defrag

                                movl start, %ebp
                                et_for_1_yes_space_defrag:
                                    cmpl finish, %ebp
                                    jg et_pas_2_yes_space_defrag

                                    movl $1, %eax
                                    mull nr_el_linie
                                    mull linie
                                    addl %ebp, %eax
                                    movl $0, (%edi, %eax, 4)

                                    incl %ebp
                                    jmp et_for_1_yes_space_defrag

                                et_pas_2_yes_space_defrag:
                                    movl last_j, %ebp
                                    incl %ebp
                                    movl last_j, %edx
                                    addl nr_spatii, %edx
                                    movl %edx, finish_defrag
                                    
                                    et_for_2_yes_space_defrag:
                                        cmpl finish_defrag, %ebp
                                        jg et_exit_yes_space_defrag

                                        movl $1, %eax
                                        mull nr_el_linie
                                        mull last_i
                                        addl %ebp, %eax
                                        movl id, %edx
                                        movl %edx, (%edi, %eax, 4)

                                        incl %ebp
                                        jmp et_for_2_yes_space_defrag

                                et_exit_yes_space_defrag:
                                    movl nr_spatii, %eax
                                    addl %eax, last_j
                                    jmp et_exit_if_main_defrag

                            et_no_space_defrag:
                                movl start, %ebp
                                et_for_1_no_space_defrag:
                                    cmpl finish, %ebp
                                    jg et_pas_2_no_space_defrag

                                    movl $1, %eax
                                    mull nr_el_linie
                                    mull linie
                                    addl %ebp, %eax
                                    movl $0, (%edi, %eax, 4)

                                    incl %ebp
                                    jmp et_for_1_no_space_defrag

                                et_pas_2_no_space_defrag:
                                    movl $0, %ebp
                                    incl last_i
                                    et_for_2_no_space_defrag:
                                        cmpl nr_spatii, %ebp
                                        je et_exit_no_space_defrag

                                        movl $1, %eax
                                        mull nr_el_linie
                                        mull last_i
                                        addl %ebp, %eax
                                        movl id, %edx
                                        movl %edx, (%edi, %eax, 4)
                                        
                                        incl %ebp
                                        jmp et_for_2_no_space_defrag

                                et_exit_no_space_defrag:
                                    movl nr_spatii, %edx
                                    decl %edx
                                    movl %edx, last_j
                                    jmp et_exit_if_main_defrag

                        et_else_1_main_defrag:
                            movl start, %ebp
                            et_for_1_else_defrag:
                                cmpl finish, %ebp
                                jg et_pas_2_else_defrag

                                movl $1, %eax
                                mull nr_el_linie
                                mull linie
                                addl %ebp, %eax
                                movl $0, (%edi, %eax, 4)

                                incl %ebp
                                jmp et_for_1_else_defrag

                            et_pas_2_else_defrag:
                                movl last_j, %ebp
                                incl %ebp
                                movl last_j, %edx
                                addl nr_spatii, %edx
                                movl %edx, finish_defrag

                                et_for_2_else_defrag:
                                    cmp finish_defrag, %ebp
                                    jg et_exit_else_defrag

                                    movl $1, %eax
                                    mull nr_el_linie
                                    mull linie
                                    addl %ebp, %eax
                                    movl id, %edx
                                    movl %edx, (%edi, %eax, 4)

                                    incl %ebp
                                    jmp et_for_2_else_defrag

                                et_exit_else_defrag:
                                    movl nr_spatii, %edx
                                    addl %edx, last_j

                        et_exit_if_main_defrag:
                            movl $0, flag

                    et_next_j_defrag:
                        incl %ecx
                        jmp et_for_defrag_j

                et_next_i_defrag:
                    incl %ebx
                    jmp et_for_defrag_i

            et_afisare_defrag:
                movl $0, flag
                movl $0, %ebx
                et_for_defrag_i_afisare:
                    cmpl $1024, %ebx
                    je et_exit_defrag

                    movl $0, %ecx
                    et_for_defrag_j_afisare:
                        cmpl $1024, %ecx
                        je et_exit_for_defrag_j_afisare

                        movl $1, %eax
                        mull nr_el_linie
                        mull %ebx
                        addl %ecx, %eax
                        movl (%edi, %eax, 4), %edx

                        et_if_1_defrag_afisare:
                            cmpl $0, %edx
                            je et_next_j_defrag_afisare

                            cmpl $0, flag
                            jne et_if_2_defrag_afisare

                            movl %ebx, linie
                            movl %ecx, start
                            movl $1, flag

                        et_if_2_defrag_afisare:
                            incl %eax
                            cmpl %edx, (%edi, %eax, 4)
                            je et_next_j_defrag_afisare

                            cmpl $1, flag
                            jne et_if_3_defrag_afisare

                            movl %ecx, finish
                            movl $2, flag

                        et_if_3_defrag_afisare:
                            cmpl $2, flag
                            jne et_next_j_defrag_afisare

                            pushl %ecx
                            pushl finish
                            pushl linie
                            pushl start
                            pushl linie
                            pushl %edx
                            pushl $afisare_id
                            call printf
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %edx
                            popl %ecx

                            movl $0, flag

                        et_next_j_defrag_afisare:
                            incl %ecx
                            jmp et_for_defrag_j_afisare

                    et_exit_for_defrag_j_afisare:
                        incl %ebx
                        jmp et_for_defrag_i_afisare

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
    .section .note.GNU-stack,"",@progbits