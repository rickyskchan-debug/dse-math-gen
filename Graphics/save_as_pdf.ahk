#SingleInstance force

#s::
;Send, {CTRLDOWN}s{CTRLUP}
;Sleep, 500
;Send, {CTRLDOWN}{SHIFTDOWN}s{SHIFTUP}{CTRLUP}
;WinWait, Save As, 
;IfWinNotActive, Save As, , WinActivate, Save As, 
;WinWaitActive, Save As, 
;Send, {ALTDOWN}t{ALTUP}{DOWN}{DOWN}{ENTER}{ENTER}{ENTER}
;WinWait, Save Adobe PDF, 
;IfWinNotActive, Save Adobe PDF, , WinActivate, Save Adobe PDF, 
;WinWaitActive, Save Adobe PDF, 
;Send, {ALTDOWN}i{ALTUP}{ALTDOWN}s{ALTUP}
;Sleep, 1300
;Send, {CTRLDOWN}w{CTRLUP}
;return

Send, {CTRLDOWN}{ALTDOWN}s{ALTUP}{CTRLUP}
WinWait, Save a Copy, 
IfWinNotActive, Save a Copy, , WinActivate, Save a Copy, 
WinWaitActive, Save a Copy, 
Send, {END}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{TAB}{DOWN}{DOWN}{ENTER}{ALTDOWN}s{ALTUP}{ALTDOWN}y{ALTUP}
WinWait, Save Adobe PDF, 
IfWinNotActive, Save Adobe PDF, , WinActivate, Save Adobe PDF, 
WinWaitActive, Save Adobe PDF, 
Send, {DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ALTDOWN}s{ALTUP}
Sleep, 100
Send, {CTRLDOWN}s{CTRLUP}

Return



#p::
Send, {ENTER}
Sleep, 500
Send, {CTRLDOWN}{ALTDOWN}s{ALTUP}{CTRLUP}
WinWait, Save a Copy, 
IfWinNotActive, Save a Copy, , WinActivate, Save a Copy, 
WinWaitActive, Save a Copy, 
Send, {END}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{TAB}{DOWN}{DOWN}{ENTER}{ALTDOWN}s{ALTUP}{ALTDOWN}y{ALTUP}
WinWait, Save Adobe PDF, 
IfWinNotActive, Save Adobe PDF, , WinActivate, Save Adobe PDF, 
WinWaitActive, Save Adobe PDF, 
Send, {DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ALTDOWN}s{ALTUP}
Sleep, 100
Send, {CTRLDOWN}s{CTRLUP}
Sleep, 100
Send, {CTRLDOWN}w{CTRLUP}
Send, {ALTDOWN}{ESC}{ALTUP}
return



#t::

Send, {CTRLDOWN}{SHIFTDOWN}p{CTRLUP}{SHIFTUP}
WinWait, Export as Picture, 
IfWinNotActive, Export as Picture, , WinActivate, Export as Picture, 
WinWaitActive, Export as Picture, 
Send, {DOWN}{TAB}{TAB}{TAB}{ENTER}

return


#`::

Send, {Enter}
Sleep, 500
Send, {ALTDOWN}f{ALTUP}e
WinWait, Export, 
IfWinNotActive, Export, , WinActivate, Export, 
WinWaitActive, Export, 
Send, {ALTDOWN}t{ALTUP}p{DOWN}{DOWN}{ENTER}{ALTDOWN}s{ALTUP}
Send, {ALTDOWN}y{ALTUP}
WinWait, PNG Options, 
IfWinNotActive, PNG Options, , WinActivate, PNG Options, 
WinWaitActive, PNG Options, 
Send, {ALTDOWN}h{ALTUP}{ENTER}
Sleep, 400
Send, {CTRLDOWN}w{CTRLUP}
Send, {ALTDOWN}{ESC}{ALTUP}
Return


;#1::

;Loop 1
;{
;Send, {F2}{Home}{Right}{Right}{Right}{Right}{Right}{Right}{Right}_{Enter}
;Sleep, 50
;Send, {Down}
;}

;Return

;#2::

;Loop 1
;{
;Send, {F2}{Home}{Right}{Right}{Right}{Right}{Right}{Right}{Right}{Del}{Enter}
;Send, {Down}
;}

;Return

#4::
Send, {ALTDOWN}f{ALTUP}r{down}{down}{down}{enter}


Return
