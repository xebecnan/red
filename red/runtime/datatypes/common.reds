Red/System [
	Title:   "Common datatypes utility functions"
	Author:  "Nenad Rakocevic"
	File: 	 %common.reds
	Tabs:	 4
	Rights:  "Copyright (C) 2011-2012 Nenad Rakocevic. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/dockimbel/Red/blob/master/BSL-License.txt
	}
]

names!: alias struct! [
	buffer	[c-string!]								;-- datatype name string
	size	[integer!]								;-- buffer size - 1 (not counting terminal `!`)
	word	[red-word!]								;-- datatype name as word! value
]

name-table:   declare names! 						;-- datatype names table
action-table: declare int-ptr!						;-- actions jump table


set-type: func [										;@@ convert to macro?
	cell [cell!]
	type [integer!]
][
	cell/header: cell/header and type-mask or type
]

alloc-at-tail: func [
	blk		[red-block!]
	return: [cell!]
][
	alloc-tail as series! blk/node/value
]

alloc-tail: func [
	s		 [series!]
	return:  [cell!]
	/local 
		cell [red-value!]
][
	if (as byte-ptr! s/tail + 1) > ((as byte-ptr! s + 1) + s/size) [
		s: expand-series s 0
	]
	
	cell: s/tail
	;-- ensure that cell is within series upper boundary
	assert (as byte-ptr! cell) < ((as byte-ptr! s + 1) + s/size)
	
	s/tail: cell + 1									;-- move tail to next cell
	cell
]

alloc-tail-unit: func [
	s		 [series!]
	unit 	 [integer!]
	return:  [byte-ptr!]
	/local 
		p	 [byte-ptr!]
][
	if ((as byte-ptr! s/tail) + unit) > ((as byte-ptr! s + 1) + s/size) [
		s: expand-series s 0
	]
	
	p: as byte-ptr! s/tail
	;-- ensure that cell is within series upper boundary
	assert p < ((as byte-ptr! s + 1) + s/size)
	
	s/tail: as cell! p + unit							;-- move tail to next unit slot
	p
]

copy-cell: func [
	src		[cell!]
	dst		[cell!]
	return: [red-value!]
][
	copy-memory											;@@ optimize for 16 bytes copying
		as byte-ptr! dst
		as byte-ptr! src
		size? cell!
	dst
]


words: context [
	_spec:			as red-word! 0
	_body:			as red-word! 0
	_words:			as red-word! 0
	_logic!:		as red-word! 0
	_integer!:		as red-word! 0
	_windows:		as red-word! 0
	_syllable:		as red-word! 0
	_macosx:		as red-word! 0
	_linux:			as red-word! 0
	_repeat:		as red-word! 0
	_foreach:		as red-word! 0
	_map-each:		as red-word! 0
	_remove-each:	as red-word! 0
	_exit:			as red-word! 0
	_return:		as red-word! 0
	
	_any:			as red-word! 0
	_copy:			as red-word! 0
	_end:			as red-word! 0
	_fail:			as red-word! 0
	_into:			as red-word! 0
	_opt:			as red-word! 0
	_not:			as red-word! 0
	_quote:			as red-word! 0
	_reject:		as red-word! 0
	_set:			as red-word! 0
	_skip:			as red-word! 0
	_some:			as red-word! 0
	_thru:			as red-word! 0
	_to:			as red-word! 0
	_none:			as red-word! 0
	_pipe:			as red-word! 0
	_dash:			as red-word! 0
	_then:			as red-word! 0
	
	spec:			-1
	body:			-1
	words:			-1
	logic!:			-1
	integer!:		-1
	repeat:			-1
	foreach:		-1
	map-each:		-1
	remove-each:	-1
	exit*:			-1
	return*:		-1
	
	any*:			-1
	break*:			-1
	copy:			-1
	end:			-1
	fail:			-1
	into:			-1
	opt:			-1
	not*:			-1
	quote:			-1
	reject:			-1
	set:			-1
	skip:			-1
	some:			-1
	thru:			-1
	to:				-1
	none:			-1
	pipe:			-1
	dash:			-1
	then:			-1
	
	build: does [
		_spec:			word/load "spec"
		_body:			word/load "body"
		_words:			word/load "words"
		_logic!:		word/load "logic!"
		_integer!:		word/load "integer!"
		_exit:			word/load "exit"
		_return:		word/load "return"

		_windows:		word/load "Windows"
		_syllable:		word/load "Syllable"
		_macosx:		word/load "MacOSX"
		_linux:			word/load "Linux"
		
		_repeat:		word/load "repeat"
		_foreach:		word/load "foreach"
		_map-each:		word/load "map-each"
		_remove-each:	word/load "remove-each"
		
		_any:			word/load "any"
		_break:			word/load "break"
		_copy:			word/load "copy"
		_end:			word/load "end"
		_fail:			word/load "fail"
		_into:			word/load "into"
		_opt:			word/load "opt"
		_not:			word/load "not"
		_quote:			word/load "quote"
		_reject:		word/load "reject"
		_set:			word/load "set"	
		_skip:			word/load "skip"
		_some:			word/load "some"
		_thru:			word/load "thru"
		_to:			word/load "to"	
		_none:			word/load "none"
		_pipe:			word/load "|"
		_dash:			word/load "-"
		_then:			word/load "then"
		
		
		spec:			_spec/symbol
		body:			_body/symbol
		words:			_words/symbol
		logic!:			_logic!/symbol
		integer!:		_integer!/symbol
		repeat:			_repeat/symbol
		foreach:		_foreach/symbol
		map-each:		_map-each/symbol
		remove-each:	_remove-each/symbol
		exit*:			_exit/symbol
		return*:		_return/symbol
		
		any*:			_any/symbol
		break*:			_break/symbol
		copy:			_copy/symbol
		end:			_end/symbol
		fail:			_fail/symbol
		into:			_into/symbol
		opt:			_opt/symbol
		not*:			_not/symbol
		quote:			_quote/symbol
		reject:			_reject/symbol
		set:			_set/symbol
		skip:			_skip/symbol
		some:			_some/symbol
		thru:			_thru/symbol
		to:				_to/symbol
		none:			_none/symbol
		pipe:			_pipe/symbol
		dash:			_dash/symbol
		then:			_then/symbol
	]
]

refinements: context [
	local: 		as red-refinement! 0
	extern: 	as red-refinement! 0
	
	build: does [
		local:	refinement/load "local"
		extern:	refinement/load "extern"
	]
]