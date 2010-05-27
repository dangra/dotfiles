" Vim syntax file
" Language:	Debian Network Interfaces 
" Version:      0.1
" Maintainer:	Daniel Graña <dangra@gmail.com>
" Filenames:    /etc/network/interfaces
" URL:		
" Last change:	Fri Mar 17 2006
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Shorewall rules file syntax match according to:
" http://www.shorewall.net/Documentation.htm#Rules

" We want case sensitive matchs
syn case match

" Action examples: ACCEPT DENY AllowFTP ACCEPT:info LOG:info ACCEPT:info:ftp

"syn match  niStanzaError    "^\s*\S\+" nextgroup=swSrcZone
"syn match  niStanza         "(iface|mapping|auto|allow-.*)"        nextgroup=,swSrcZoneError skipwhite

syn keyword autoStatement auto
syn keyword mappingStatement mapping
syn keyword ifaceStatement iface
syn match   allowStatement "allow-\w*"

let b:current_syntax = "interfaces"

" vim: ts=8
