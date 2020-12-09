# Propensive Style Guide

The following are an evolving set of guidelines for formatting Scala 2 code. The

Whilst concise code is not a direct goal, it is often favored as an indirect consequence.

## Terminology

- _brackets_ — square brackets, commonly associated with types, `[` and `]`
- _braces_ — curly brackets, usually used for delimiting blocks, `{` and `}`
- _parentheses_ — round brackets, `(` and `)`


## Naming

Names should be written in American English, and abbreviations should not be used unless their usage is
widespread and unambiguous.

### Capitalization

Multi-word identifiers should concatenate all the words, capitalizing the initial letter of the second and later
words, and making all others lower-case. Additionally, if the identifier is a type or a value which is intended
to be used in a pattern match, the initial letter of the first word should also be capitalized.

Acronyms should be treated the same as other words, and written entirely in lower-case, except the initial
letter which will depend on the context.

## Parentheses

### Lambdas

Anonymous lambdas—those which do not name their parameter—should be preferred over lambdas with named
parameters. Anonymous lambdas should always be written inside parentheses, whereas lambdas whose parameter is
named should be written inside braces.

Braces, and not parentheses, should be used around multiline expressions.

Brackets and parentheses should be written close to their surrounding syntax, and the syntax they enclose, i.e.
without any whitespace. Braces should be separated from the content they enclose with some whitespace, usually a
space (` `). When a block delimited by braces is applied to :


## Linebreaks

A multi-line statement or expression should always be surrounded by a blank line above and below, except when it
is the first or last statement or expression in a block.

An expression at the end of a multi-line block should be preceded by a blank line to set it apart from the body.

Multiple blank lines should be reduced to a single blank line. Blank lines should never appear between closing
braces.

## Imports

Imports should appear at the top of the file, below the package declaration. Wildcard imports are preferred
over long lists of members, except when a package contains members which may conflict with others. In these
cases, the import should either list all the required members, or import certain members renamed to include the
important part of the package name to prefix the name. This should be the same prefix for all renamed members.

## Long lines

Lines should be limited to a maximum of 112 characters. Sometimes a line would naturally be longer than 112
characters, in which case there are a number of strategies to force the rule. Method and class signatures have
their own set of rules (see [below](#signatures)), but 

### 1. extract expressions into named identifiers

If a line is long, it may also be difficult to understand. Extracting subexpressions into named `val`s may
help to clarify their intent, whilst the substitution of a named identifier in place of the expression it
references may help to reduce the number of characters in a line.

Names should, however, be meaningful, and artificial contrived names should not be used.

### 2. break the line on a space (` `)

If strategy _1_ cannot be applied to 

### 3. wrap the line

If strategies _1_ and _2_ do not produce 


### Signatures
