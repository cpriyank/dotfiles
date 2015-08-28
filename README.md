# Dotfiles
In \*n\*x systems, dotfiles are files (well, they are files and directories but since [Everything in Unix is a file](https://en.wikipedia.org/wiki/Everything_is_a_file), they are just called dotfiles) where a user and his/her programs store personal customizations and configurations. They override respective system configurations.

Every time you login and/or open a program, your system looks for your dotfiles to apply your personal preferences, aliases, environment variable, etc applies those configurations.
They are called dotfiles because their names start with a '.' character. They are hidden by default and cannot be viewed by an `ls` command from terminal, unless flag `-a` is used, or `Ctrl+H` or `Alt+.` from popular linux file managers in user's home directory.

You can copy your dotfiles on new systems, and the relevant programs will work and behave in the same way as they did in the old system.
