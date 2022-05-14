---
title: "Print"
date: 2022-05-10T08:03:03+01:00
draft: false
---

# Zsh — print command examples ( with help document )

`print` is zsh law layer command.

For example it probably build zle command behaviour.

If you master it you will get so beautifule zsh style.

## Examples

### Format

**command [-option] ( formal or non formal — remembering name )**

### print -a ( align )

> Print arguments with the column incrementing first. Only useful with the -c and -C options.
Outputs indented

```
$ print -a -c "Alice" "Bob" "Carol" "\nDavid" "Eric" "Fred"
Alice  Bob    Carol
David  Eric   Fred
```

### print -C ( Cols )

> -C cols
>
> Print the arguments in cols columns. Unless -a is also given, arguments are printed with the row incrementing first.
```
$ print -C 2 Alice Bob Carol David Eric
Alice  David
Bob    Eric
Carol
```

### print -D ( Directory replacing )

> -D
>
> Treat the arguments as paths, replacing directory prefixes with ~ expressions corresponding to directory names, as appropriate.
```
$ print -D /Users/yuma/tmp ~/tmp
~/tmp ~/tmp
```

### print -i ( independently )

> -i
>
> If given together with -o or -O, sorting is performed case-independently.
Sorting

ASC

```
$ print -i -o Bob Carol Alice
Alice Bob Carol
```

DESC

```
$ print -i -O Bob Carol Alice
Carol Bob Alice
```

## print -l

```
print -l "Alice" "Bob" "Carol"
Alice
Bob
Carol
```

### print -m

```
$ print -m "Bob" "Alice" "Bob" "Carol"
Bob
```

### print -n ( no newline )

```
print -n "Alice"
Alice%
```

In this case `%` means end of line ( no newline )

### print -N ( NULL )

> Print the arguments separated and terminated by nulls.
```
print -N "Alice" "Bob" "Carol"
AliceBobCarol%
```

### print -p

> -p
>
> Print the arguments to the input of the coprocess.
### print -P

> -P
> Perform prompt expansion (see Prompt Expansion). In combination with ‘-f’, prompt escape sequences are parsed only within interpolated arguments, not within the format string.
### print -r

> -r
> Ignore the escape conventions of echo.
### print -R

> -R
>
> Emulate the BSD echo command, which does not process escape sequences unless the -e flag is given. The -n flag suppresses the trailing newline. Only the -e and -n flags are recognized after -R; all other arguments and options are printed.
### print -s

> -s
>
> Place the results in the history list instead of on the standard output. Each argument to the print command is treated as a single word in the history, regardless of its content.
### print -S

> -S
>
> Place the results in the history list instead of on the standard output. In this case only a single argument is allowed; it will be split into words as if it were a full shell command line. The effect is similar to reading the line from a history file with the HIST_LEX_WORDS option active.
```
$ print -S "Alice"
$ history | tail -n 1
28580  Alice
```

### print -u

> -u n
>
> Print the arguments to file descriptor n.
### print -v

> -v name
>
> Store the printed arguments as the value of the parameter name.
### print -x

> -x tab-stop
>
> Expand leading tabs on each line of output in the printed string assuming a tab stop every tab-stop characters. This is appropriate for formatting code that may be indented with tabs. Note that leading tabs of any argument to print, not just the first, are expanded, even if print is using spaces to separate arguments (the column count is maintained across arguments but may be incorrect on output owing to previous unexpanded tabs).
>
> The start of the output of each print command is assumed to be aligned with a tab stop. Widths of multibyte characters are handled if the option MULTIBYTE is in effect. This option is ignored if other formatting options are in effect, namely column alignment or printf style, or if output is to a special location such as shell history or the command line editor.
### print -X

> -X tab-stop
>
> This is similar to -x, except that all tabs in the printed string are expanded. This is appropriate if tabs in the arguments are being used to produce a table format.
### print -z

```
$ print -z echo ABC
$ echo Alice
```

`echo Alice` is inputted as console input buffer not as command result stdout.

## Help

[17 Shell Builtin Commands (zsh)](http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html)

```
print [ -abcDilmnNoOpPrsSz ] [ -u n ] [ -f format ] [ -C cols ]
      [ -v name ] [ -xX tabstop ] [ -R [ -en ]] [ arg ... ]
With the ‘-f’ option the arguments are printed as described by printf. With no flags or with the flag ‘-’, the arguments are printed on the standard output as described by echo, with the following differences: the escape sequence ‘\M-x’ (or ‘\Mx’) metafies the character x (sets the highest bit), ‘\C-x’ (or ‘\Cx’) produces a control character (‘\C-@’ and ‘\C-?’ give the characters NULL and delete), a character code in octal is represented by ‘\NNN’ (instead of ‘\0NNN’), and ‘\E’ is a synonym for ‘\e’. Finally, if not in an escape sequence, ‘\’ escapes the following character and is not printed.
-a
Print arguments with the column incrementing first. Only useful with the -c and -C options.
-b
Recognize all the escape sequences defined for the bindkey command, see Zle Builtins.
-c
Print the arguments in columns. Unless -a is also given, arguments are printed with the row incrementing first.
-C cols
Print the arguments in cols columns. Unless -a is also given, arguments are printed with the row incrementing first.
-D
Treat the arguments as paths, replacing directory prefixes with ~ expressions corresponding to directory names, as appropriate.
-i
If given together with -o or -O, sorting is performed case-independently.
-l
Print the arguments separated by newlines instead of spaces.
-m
Take the first argument as a pattern (should be quoted), and remove it from the argument list together with subsequent arguments that do not match this pattern.
-n
Do not add a newline to the output.
-N
Print the arguments separated and terminated by nulls.
-o
Print the arguments sorted in ascending order.
-O
Print the arguments sorted in descending order.
-p
Print the arguments to the input of the coprocess.
-P
Perform prompt expansion (see Prompt Expansion). In combination with ‘-f’, prompt escape sequences are parsed only within interpolated arguments, not within the format string.
-r
Ignore the escape conventions of echo.
-R
Emulate the BSD echo command, which does not process escape sequences unless the -e flag is given. The -n flag suppresses the trailing newline. Only the -e and -n flags are recognized after -R; all other arguments and options are printed.
-s
Place the results in the history list instead of on the standard output. Each argument to the print command is treated as a single word in the history, regardless of its content.
-S
Place the results in the history list instead of on the standard output. In this case only a single argument is allowed; it will be split into words as if it were a full shell command line. The effect is similar to reading the line from a history file with the HIST_LEX_WORDS option active.
-u n
Print the arguments to file descriptor n.
-v name
Store the printed arguments as the value of the parameter name.
-x tab-stop
Expand leading tabs on each line of output in the printed string assuming a tab stop every tab-stop characters. This is appropriate for formatting code that may be indented with tabs. Note that leading tabs of any argument to print, not just the first, are expanded, even if print is using spaces to separate arguments (the column count is maintained across arguments but may be incorrect on output owing to previous unexpanded tabs).
The start of the output of each print command is assumed to be aligned with a tab stop. Widths of multibyte characters are handled if the option MULTIBYTE is in effect. This option is ignored if other formatting options are in effect, namely column alignment or printf style, or if output is to a special location such as shell history or the command line editor.
-X tab-stop
This is similar to -x, except that all tabs in the printed string are expanded. This is appropriate if tabs in the arguments are being used to produce a table format.
-z
Push the arguments onto the editing buffer stack, separated by spaces.
If any of ‘-m’, ‘-o’ or ‘-O’ are used in combination with ‘-f’ and there are no arguments (after the removal process in the case of ‘-m’) then nothing is printed.
```
