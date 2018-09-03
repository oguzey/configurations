# Configuration for Ubuntu system
The configuration will install the main tools and configure bash, vim, git tools.
For more details, look at conig.ini


### Format of config.ini

There are three common configuration variables that are handled by specific rules.
1. "packages" contains names of packages that will be installed to the system
2. "sh" contains shell commands that will be executed. It is possible to have few commands in the value. They should be split by LF (\n) symbol.
    If a command finishes with error (the error code not equal to zero), execution of the full program will be terminated
    For instance:
    ```
        sh = echo "1"
             echo "2"
             echo "3"
    ```
    These three commands will be executed one by one. echo "1" => echo "2" => echo "3"
3. "copy_and_edit". A value of the variable must have format "/path/to/source/file to /path/to/destination/file".
For this variable, the source file will be read. Then all variables (like {name}) from a content of the source file will be replaced to values from this group.
And the destination file with the new content will be created.
For example, a config file contains:
```
    [test_group]
    name = 1
    surname = 2
    copy_and_edit = ./raw_test to ./test
```
And the file ./raw_test contains: "Hello, {name} {surname}!"
After running the program, the new file "./test" will be created that contains: "Hello, 1 2!"


For each group, a sequence of running commands is following: copy_and_edit, sh, packages.

