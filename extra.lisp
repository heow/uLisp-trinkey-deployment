
(defun *pc* 1000)

(defun delay4 (n)
  (list
   ($mov 'r5 n)
   ($sub 'r5 1)
   ($bne (- *pc* 2))))

(defvar dirset #x08)
(defvar outset #x18)
(defvar outclr #x14)

(defcode neopixel (a b c d)
  ($push '(lr r5 r4 r3 r2 r1 r0))
  ($ldr 'r4 porta)
  ($mov 'r1 1)
  ($lsl 'r3 'r1 5)
  ($str 'r3 '(r4 dirset)) ; make pin an output
  ($mov 'r2 4)
  nextled
  ($pop '(r0)) ; get bytes
  ($mov 'r1 1)
  ($lsl 'r1 23)
  nextbit
  ($tst 'r0 'r1) ; test if bit is 1
  ($bne one)
  zero
  ($cpsid 3)
  ($str 'r3 '(r4 outset))
  (delay4 4)             
  ($str 'r3 '(r4 outclr))
  (delay4 10)
  ($cpsie 3)
  ($b next)
  one
  ($str 'r3 '(r4 outset))
  (delay4 8)
  ($str 'r3 '(r4 outclr))
  (delay4 7)
  next
  ($lsr 'r1 1)
  ($bne nextbit)
  ($sub 'r2 1)
  ($bne nextled)
  ($pop '(r4 r5 pc))
  porta
  ($word #x41004400))

(defun animate ()
  (let ((lst '(#x000707 #x070707 #x070700 #x070007)))
    (loop
     (eval (cons 'neopixel lst))
     (delay 200)
     (setq lst (append (cdr lst) (list (car lst)))))))

(defun disp (p0 p1 p2 p3) (neopixel p0 p1 p2 p3))

(defun disp-off () (disp 0 0 0 0))

(save-image 'animate)
