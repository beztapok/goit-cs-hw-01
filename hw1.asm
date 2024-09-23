; Программа для вычисления выражения b - c + a

org 100h      ; Устанавливаем начальный адрес для .COM программы

; === Начало кода ===

start:
    ; Инициализация сегмента данных
    mov ax, cs
    mov ds, ax

    ; Вывод исходных значений a, b и c
    mov dx, msg_a
    call print_string
    mov al, [a]
    call print_value
    call print_newline

    mov dx, msg_b
    call print_string
    mov al, [b]
    call print_value
    call print_newline

    mov dx, msg_c
    call print_string
    mov al, [c]
    call print_value
    call print_newline

    ; Вычисление выражения b - c + a
    mov al, [b]     ; AL = b
    sub al, [c]     ; AL = b - c
    add al, [a]     ; AL = b - c + a

    ; Сохранение результата
    mov [result], al

    ; Вывод результата
    mov dx, msg_result
    call print_string
    mov al, [result]
    call print_value
    call print_newline

    ; Завершение программы
    mov ah, 0       ; Ожидание нажатия клавиши
    int 16h

    mov ah, 4Ch     ; Завершение программы
    int 21h

; === Процедуры ===

; Процедура вывода строки, заканчивающейся символом '$'
print_string:
    mov ah, 09h
    int 21h
    ret

; Процедура вывода значения из регистра AL в виде числа
print_value:
    push ax         ; Сохраняем регистр AX
    push bx         ; Сохраняем регистр BX
    push cx         ; Сохраняем регистр CX
    push dx         ; Сохраняем регистр DX
    push si         ; Сохраняем регистр SI

    ; Проверяем, равно ли значение нулю
    cmp al, 0
    jne pv_non_zero

    ; Если значение равно нулю, выводим '0'
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp pv_done

pv_non_zero:
    mov ah, 0       ; Очищаем AH для корректного деления
    mov bl, 10      ; Делитель 10
    xor cx, cx      ; Счетчик цифр = 0

    ; Инициализируем указатель стека для хранения цифр
    lea si, [digit_buffer + 16] ; Начинаем с конца буфера

pv_convert_loop:
    div bl          ; Делим AX на BL, частное в AL, остаток в AH
    dec si
    add ah, '0'     ; Преобразуем остаток в ASCII
    mov [si], ah    ; Сохраняем символ в буфере
    inc cx          ; Увеличиваем счетчик цифр
    mov ah, 0       ; Очищаем AH перед следующей итерацией
    cmp al, 0
    jne pv_convert_loop

    ; Выводим цифры
pv_print_loop:
    mov dl, [si]
    mov ah, 02h
    int 21h
    inc si
    loop pv_print_loop

pv_done:
    pop si          ; Восстанавливаем регистры
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Процедура вывода новой строки
print_newline:
    mov ah, 02h
    mov dl, 0Dh     ; Код возврата каретки
    int 21h
    mov dl, 0Ah     ; Код новой строки
    int 21h
    ret

; === Данные ===

; Объявляем переменные после кода в .COM программе
a db 5
b db 10
c db 3
result db 0

msg_a db 'a = $'
msg_b db 'b = $'
msg_c db 'c = $'
msg_result db 'Result (b - c + a) = $'

digit_buffer db 17 dup(0) ; Буфер для цифр (макс 16 цифр + 1)

; Конец программы