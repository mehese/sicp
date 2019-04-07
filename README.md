The internet was kind enough to offer a full html version of SICP [here](http://sarabander.github.io/sicp/html/)

How to use Racket for going through the book is explained [here](https://docs.racket-lang.org/sicp-manual/index.html)

How to fix printing in DrRacket explained [here](https://stackoverflow.com/questions/9347294/mcons-in-dr-racket).

Another way to run scripts is using

```bash
racket -l sicp --repl < runme.scm
```

This enbles using commands like `(load "file.scm")` to load functions previously defined. However this method doesn't pretty-print lists and pairs. The solution is to have a `.racketrc` file that looks like

```scheme
(#%require (only racket/base print-as-expression print-mpair-curly-braces))
(print-as-expression #f)
(print-mpair-curly-braces #f)
```
