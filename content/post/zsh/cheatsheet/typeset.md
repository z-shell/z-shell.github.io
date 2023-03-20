---
title: "Typeset"
date: 2023-03-20T01:39:43Z
draft: false
---

## Typeset

Set or display attributes and values for shell parameters.
Except as noted below for control flags that change the behavior, a parameter is created for each name that does not already
refer to one. When inside a function, a new parameter is created for every name (even those that already exist) and is unset again when the function completes.
See <kbd>Local Parameters</kbd> in zshparam(1). The same rules apply to special shell parameters, which retain their special attributes when made <kbd>local</kbd>.

For each name=value assignment, the parameter name is set to value.

If the shell option <samp>TYPESET_SILENT</samp> is not set, for each remaining name that refers to a parameter that is already set, the
name and value of the parameter are printed in the form of an
assignment. Nothing is printed for newly-created parameters, or
when any attribute flags listed below are given along with the
name. Using <kbd>+</kbd> instead of minus to introduce an attribute turns it off.

If no name is present, the names and values of all parameters
are printed. In this case the attribute flags restrict the display to only those parameters that have the specified attributes, and using <kbd>+</kbd> rather than <kbd>-</kbd> to introduce the flag
suppresses printing of the values of parameters when there is no
parameter name.

All forms of the command handle scalar assignment. Array assignment is possible if any of the reserved words <kbd>declare</kbd>, export, <kbd>float</kbd>, <kbd>integer</kbd>, <kbd>local</kbd>, <kbd>readonly</kbd> or typeset is matched when
the line is parsed (N.B. not when it is executed). In this case the arguments are parsed as assignments, except that the <kbd>+=</kbd>
syntax and the <samp>GLOB_ASSIGN</samp> option are not supported, and scalar
values after <kbd>=</kbd> are not split further into words, even if expanded (regardless of the setting of the <samp>KSH_TYPESET</samp> option; this option is obsolete).

```shell
typeset [ {+|-}AHUaghlmrtux ] [ {+|-}EFLRZip [ n ] ] [ + ] [ name[=value] ... ]
```

```shell
typeset -T [ {+|-}Uglrux ] [ {+|-}LRZp [ n ] ] [ + | SCALAR[=value] array[=(value ...)] [ sep ] ]
```

```shell
typeset -f [ {+|-}TUkmtuz ] [ + ] [ name ... ]
```

Examples of the differences between command and reserved word parsing:

- Reserved word parsing

```shell
typeset svar=$(echo one word) avar=(several words)
```

The above creates a scalar parameter svar and an array parameter avar as if the assignments had been:

```shell
svar="one word"
avar=(several words)
```

On the other hand:

- Normal builtin interface

```shell
builtin typeset svar=$(echo two words)
```

The builtin keyword causes the above to use the standard builtin
interface to typeset in which argument parsing is performed in
the same way as for other commands. This example creates a
scalar svar containing the value two and another scalar parameter words with no value. An array value in this case would either cause an error or be treated as an obscure set of glob
qualifiers.

Arbitrary arguments are allowed if they take the form of assignments after command line expansion; however, these only perform scalar assignment:

```shell
var='svar=val'
typeset $var
```

The above sets the scalar parameter svar to the value val.
Parentheses around the value within var would not cause array
assignment as they will be treated as ordinary characters when
<samp>$var</samp> is substituted. Any non-trivial expansion in the name part
of the assignment causes the argument to be treated in this fashion:

```shell
typeset {var1,var2,var3}=name
```

The above syntax is valid, and has the expected effect of setting the three parameters to the same value, but the command
line is parsed as a set of three normal command line arguments
to typeset after expansion. Hence it is not possible to assign
to multiple arrays by this means.

> **Note**: that each interface to any of the commands my be disabled
> separately. For example, <kbd>disable <kbd>-r</kbd> typeset</kbd> disables the reserved word interface to typeset, exposing the builtin interface, while <kbd>disable typeset</kbd> disables the builtin.

> **Note**: that disabling the reserved word interface for typeset may cause
> problems with the output of <kbd>typeset <kbd>-p</kbd> </kbd>, which assumes the reserved word interface is available in order to restore array and
> associative array values.

Unlike parameter assignment statements, typeset's exit status on
an assignment that involves a command substitution does not reflect the exit status of the command substitution.
Therefore, to test for an error in a command substitution, separate the
declaration of the parameter from its initialization:

- **WRONG**

```shell
typeset var1=$(exit 1) || echo "Trouble with var1"
```

- **RIGHT**

```shell
typeset var1 && var1=$(exit 1) || echo "Trouble with var1"
```

To initialize a parameter param to a command output and mark it <kbd>readonly</kbd>, use typeset <kbd>-r</kbd> param or <kbd>readonly</kbd> param after the parameter assignment statement.

If no attribute flags are given, and either no name arguments
are present or the flag <kbd>+m</kbd> is used, then each parameter name
printed is preceded by a list of the attributes of that parameter (array, association, exported, <kbd>float</kbd>, <kbd>integer</kbd>, <kbd>readonly</kbd>, or
undefined for autoloaded parameters not yet loaded). If <kbd>+m</kbd> is
used with attribute flags, and all those flags are introduced
with <kbd>+</kbd>, the matching parameter names are printed but their values are not.

The following control flags change the behavior of typeset:

### <kbd>+</kbd>

If <kbd>+</kbd> appears by itself in a separate word as the last
option, then the names of all parameters (functions with <kbd>-f</kbd>) are printed, but the values (function bodies) are
not. No name arguments may appear, and it is an error for any other options to follow <kbd>+</kbd>.

The effect of <kbd>+</kbd> is as if all attribute flags which precede it were given with a <kbd>+</kbd> prefix. For example, <kbd>typeset <kbd>-U</kbd> <kbd>+</kbd></kbd> is equivalent to <kbd>typeset +U</kbd> and displays the names of all arrays having the uniqueness attribute, whereas <kbd>typeset <kbd>-f</kbd> <kbd>-U</kbd> <kbd>+</kbd></kbd> displays the names of all autoloadable functions.
If <kbd>+</kbd> is the only option, then type information (array, <kbd>readonly</kbd>, etc.) is also printed for each parameter, in the same manner as <kbd>typeset +m "\*"</kbd>.

### <kbd>-g</kbd>

The <kbd>-g</kbd> (global) means that any resulting parameter will not be restricted to <kbd>local</kbd> scope.

> **Note**: that this does not necessarily mean that the parameter will be global,
> as the flag will apply to any existing parameter (even if
> unset) from an enclosing function. This flag does not
> affect the parameter after creation, hence it has no effect when listing existing parameters, nor does the flag
> <kbd>+g</kbd> have any effect except in combination with <kbd>-m</kbd> (see below).

### <kbd>-m</kbd>

If the <kbd>-m</kbd> flag is given the name arguments are taken as
patterns (use quoting to prevent these from being interpreted as file patterns). With no attribute flags, all
parameters (or functions with the <kbd>-f</kbd> flag) with matching
names are printed (the shell option <samp>TYPESET_SILENT</samp> is not
used in this case).

If the <kbd>+g</kbd> flag is combined with <kbd>-m</kbd>, a new <kbd>local</kbd> parameter
is created for every matching parameter that is not already <kbd>local</kbd>.
Otherwise <kbd>-m</kbd> applies all other flags or assignments to the existing parameters.

Except when assignments are made with name=value, using
+m forces the matching parameters and their attributes to
be printed, even inside a function.

> **Note**: that <kbd>-m</kbd> is ignored if no patterns are given, so <kbd>typeset <kbd>-m</kbd> </kbd> displays
> attributes but <kbd>typeset <kbd>-a</kbd> <kbd>+m</kbd> </kbd> does not.

### <kbd>-p</kbd> [ n ]

If the <kbd>-p</kbd> option is given, parameters and values are
printed in the form of a typeset command with an assignment, regardless of other flags and options.

> **Note**: that the <kbd>-h</kbd> flag on parameters is respected; no value will be shown for these parameters.

<kbd>-p</kbd> may be followed by an optional <kbd>integer</kbd> argument. Currently only the value 1 is supported. In this case arrays and associative arrays are printed with newlines between indented elements for readability.

### <kbd>-T</kbd> [ scalar[=value] array[=(value ...)] [ sep ] ]

This flag has a different meaning when used with <kbd>-f</kbd>; see below.

Otherwise the <kbd>-T</kbd> option requires zero, two, or three arguments to be present. With no arguments, the
list of parameters created in this fashion is shown.
With two or three arguments, the first two are the name of a scalar and of an array parameter (in that order)
that will be tied together in the manner of <samp>$PATH</samp> and
 <samp>$path</samp>. The optional third argument is a single-character
separator which will be used to join the elements of the array to form the scalar; if absent, a colon is used, as
with <samp>$PATH</samp>. Only the first character of the separator is significant; any remaining characters are ignored.
Multibyte characters are not yet supported.

Only one of the scalar and array parameters may be assigned an initial value (the restrictions on assignment
forms described above also apply).

Both the scalar and the array may be manipulated as normal. If one is unset, the other will automatically be
unset too. There is no way of untying the variables
without unsetting them, nor of converting the type of one
of them with another typeset command; +T does not work,
assigning an array to scalar is an error, and assigning a
scalar to array sets it to be a single-element array.

> **Note**: that both <kbd>typeset <kbd>-xT</kbd> ...</kbd> and <kbd>export <kbd>-T</kbd> ...</kbd>
> work, but only the scalar will be marked for export.
> Setting the value using the scalar version causes a split
> on all separators (which cannot be quoted). It is possi ble to apply <kbd>-T</kbd> to two previously tied variables but with
> a different separator character, in which case the vari ables remain joined as before but the separator is changed.

When an existing scalar is tied to a new array, the value
of the scalar is preserved but no attribute other than export will be preserved.

Attribute flags that transform the final value (<kbd>-L</kbd>, <kbd>-R</kbd>, <kbd>-Z</kbd>, <kbd>-l</kbd>, <kbd>-u</kbd>) are only applied to the expanded value at the point of a parameter expansion expression using <kbd>$</kbd>. They are not applied
when a parameter is retrieved internally by the shell for any
purpose.

The following attribute flags may be specified:

### <kbd>-A</kbd>

The names refer to associative array parameters; see <kbd>Array Parameters</kbd> in zshparam(1).

### <kbd>-L</kbd> [ n ]

Left justify and remove leading blanks from the value
when the parameter is expanded. If n is nonzero, it defines the width of the field. If n is zero, the width is
determined by the width of the value of the first assignment. In the case of numeric parameters, the length of
the complete value assigned to the parameter is used to
determine the width, not the value that would be output.

The width is the count of characters, which may be multibyte characters if the MULTIBYTE option is in effect.

> **Note**: that the screen width of the character is not taken
> into account; if this is required, use padding with parameter expansion flags ${(ml...)...} as described in
> <kbd>Parameter Expansion Flags</kbd> in zshexpn(1).

When the parameter is expanded, it is filled on the right
with blanks or truncated if necessary to fit the field.

> **Note**: truncation can lead to unexpected results with numeric parameters. Leading zeros are removed if the -Z flag is also set.

### <kbd>-R</kbd> [ n ]

Similar to <kbd>-L</kbd>, except that right justification is used;
when the parameter is expanded, the field is left filled
with blanks or truncated from the end. May not be combined with the <kbd>-Z</kbd> flag.

### <kbd>-U</kbd>

For arrays (but not for associative arrays), keep only
the first occurrence of each duplicated value. This may
also be set for tied parameters (see <kbd>-T</kbd>) or colon-separated special parameters like PATH or FIGNORE, etc.

> **Note**: the flag takes effect on assignment, and the type of the
> variable being assigned to is determinative; for variables with shared values it is therefore recommended to
> set the flag for all interfaces, e.g. <kbd>typeset <kbd>-U</kbd> PATH path</kbd>.

This flag has a different meaning when used with <kbd>-f</kbd>; see below.

### <kbd>-Z</kbd> [ n ]

Specially handled if set along with the <kbd>-L</kbd> flag. Otherwise,
similar to <kbd>-R</kbd>, except that leading zeros are used
for padding instead of blanks if the first non-blank
character is a digit. Numeric parameters are specially
handled: they are always eligible for padding with zeroes, and the zeroes are inserted at an appropriate place in the output.

### <kbd>-a</kbd>

The names refer to array parameters. An array parameter
may be created this way, but it may be assigned to in the
typeset statement only if the reserved word form of typeset is enabled (as it is by default). When displaying,
both normal and associative arrays are shown.

### <kbd>-f</kbd>

The names refer to functions rather than parameters. No assignments can be made, and the only other valid flags
are <kbd>-t</kbd>, <kbd>-T</kbd>, <kbd>-k</kbd>, <kbd>-u</kbd>, <kbd>-U</kbd> and <kbd>-z</kbd>. The flag <kbd>-t</kbd> turns on execution tracing for this function; the flag <kbd>-T</kbd> does the
same, but turns off tracing for any named (not anonymous)
function called from the present one, unless that function also has the <kbd>-t</kbd> or <kbd>-T</kbd> flag. The <kbd>-u</kbd> and <kbd>-U</kbd> flags
cause the function to be marked for autoloading; <kbd>-U</kbd> also
causes alias expansion to be suppressed when the function is loaded. See the description of the <kbd>autoload</kbd> builtin
for details.

> **Note**: that the builtin functions provides the same basic
> capabilities as typeset <kbd>-f</kbd> but gives access to a few extra options; autoload gives further additional options
> for the case typeset <kbd>-fu</kbd> and typeset <kbd>-fU</kbd>.

### <kbd>-h</kbd>

Hide: only useful for special parameters (those marked <kbd><S></kbd> in the table in zshparam(1)), and for <kbd>local</kbd> parameters with the same name as a special parameter, though
harmless for others. A special parameter with this attribute will not retain its special effect when made <kbd>local</kbd>. Thus after <kbd>typeset <kbd>-h</kbd> PATH</kbd>, a function containing
<kbd>typeset PATH</kbd> will create an ordinary <kbd>local</kbd> parameter without the usual behaviour of PATH. Alternatively, the <kbd>local</kbd> parameter may itself be given this attribute; hence
inside a function <kbd>typeset <kbd>-h</kbd> PATH</kbd> creates an ordinary <kbd>local</kbd> parameter and the special PATH parameter is not altered in any way.

It is also possible to create a <kbd>local</kbd> parameter using <kbd>typeset <kbd>+h</kbd> special</kbd>, where the <kbd>local</kbd>
copy of special will retain its special properties regardless of having the <kbd>-h</kbd> attribute.
Global special parameters loaded from shell modules (currently those in <samp>zsh/mapfile</samp> and <samp>zsh/parameter</samp>) are automatically given the <kbd>-h</kbd> attribute to avoid name clashes.

### <kbd>-H</kbd>

Hide value: specifies that typeset will not display the
value of the parameter when listing parameters; the display for such parameters is always as if the <kbd>+</kbd> flag had
been given. Use of the parameter is in other respects
normal, and the option does not apply if the parameter is
specified by name, or by pattern with the <kbd>-m</kbd> option.
This is on by default for the parameters in the <samp>zsh/parameter</samp> and <samp>zsh/mapfile</samp> modules.

> **Note**: that unlike the <kbd>-h</kbd> flag this is also useful for non-special parameters.

### <kbd>-i</kbd> [ n ]

Use an internal <kbd>integer</kbd> representation. If n is nonzero
it defines the output arithmetic base, otherwise it is
determined by the first assignment. Bases from 2 to 36 inclusive are allowed.

### <kbd>-E</kbd> [ n ]

Use an internal double-precision floating point representation. On output the variable will be converted to scientific notation. If n is nonzero it defines the number
of significant figures to display; the default is ten.

### <kbd>-F</kbd> [ n ]

Use an internal double-precision floating point representation. On output the variable will be converted to
fixed-point decimal notation. If n is nonzero it defines the number of digits to display after the decimal point; the default is ten.

### <kbd>-l</kbd>

Convert the result to lower case whenever the parameter
is expanded. The value is not converted when assigned.

### <kbd>-r</kbd>

The given names are marked <kbd>readonly</kbd>.

> **Note**: that if name is a special parameter, the <kbd>readonly</kbd> attribute can be turned on, but cannot then be turned off.

If the <samp>POSIX_BUILTINS</samp> option is set, the <kbd>readonly</kbd> attribute is more restrictive: unset variables can be marked
<kbd>readonly</kbd> and cannot then be set; furthermore, the <kbd>readonly</kbd> attribute cannot be removed from any variable.

It is still possible to change other attributes of the
variable though, some of which like <kbd>-U</kbd> or <kbd>-Z</kbd> would affect
the value. More generally, the <kbd>readonly</kbd> attribute should
not be relied on as a security mechanism.

> **Note**: that in zsh (like in pdksh but unlike most other shells) it is still possible to create a <kbd>local</kbd> variable
> of the same name as this is considered a different variable (though this variable, too, can be marked <kbd>readonly</kbd>).
> Special variables that have been made <kbd>readonly</kbd> retain their value and <kbd>readonly</kbd> attribute when made <kbd>local</kbd>.

### <kbd>-t</kbd>

Tags the named parameters. Tags have no special meaning to the shell. This flag has a different meaning when used with <kbd>-f</kbd>; see above.

### <kbd>-u</kbd>

Convert the result to upper case whenever the parameter is expanded. The value is not converted when assigned. This flag has a different meaning when used with <kbd>-f</kbd>; see above.

### <kbd>-x</kbd>

Mark for automatic export to the environment of subsequently executed commands. If the option <samp>GLOBAL_EXPORT</samp> is set, this implies the option <kbd>-g</kbd>, unless <kbd>+g</kbd> is also explicitly given; in other words the parameter is not made <kbd>local</kbd> to the enclosing function. This is for compatibility with previous versions of zsh.

### <kbd>declare</kbd>

Same as typeset.

### <kbd>float</kbd> [ {+|-}Hghlprtux ] [ {+|-}EFLRZ [ n ] ] [ name[=value] ... ]

Equivalent to typeset <kbd>-E</kbd>, except that options irrelevant to
floating point numbers are not permitted.

### <kbd>integer</kbd> [ {+|-}Hghlprtux ] [ {+|-}LRZi [ n ] ] [ name[=value] ... ]

Equivalent to typeset <kbd>-i</kbd>, except that options irrelevant to integers are not permitted.

### <kbd>local</kbd> [ {+|-}AHUahlprtux ] [ {+|-}EFLRZi [ n ] ] [ name[=value] ... ]

Same as typeset, except that the options <kbd>-g</kbd>, and <kbd>-f</kbd> are not permitted. In this case the <kbd>-x</kbd> option does not force the use of
<kbd>-g</kbd>, i.e. exported variables will be <kbd>local</kbd> to functions.

### <kbd>readonly</kbd>

Same as typeset <kbd>-r</kbd>. With the <samp>POSIX_BUILTINS<samp> option set, same as <kbd>typeset <kbd>-gr</kbd></kbd>.
