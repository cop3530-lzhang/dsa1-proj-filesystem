# FileSystem simulator

## Objective:
This project is meant to provide you with hands-on experience on implementation
of trees. In particular, you will be implementing a file system simulator. Files
and directories will be represented by nodes forming a binary tree.

## Learning Outcomes:
Develop a program that uses:
- Recursion
- Trees

## Problem Overview:

The objective of this project is to develop a simulator for a Linux file
system. A file system is a hierarchical structure composed of files and
directories, with the topmost directory being the root. Each directory within
the file system can contain additional files and directories, creating a nested
structure.

The representation of a file system can vary depending on the structure and
number of files and directories within it. One common option is to utilize a
tree data structure, where each node in the tree represents a file or
directory. Directories in the tree can have links to their children (other
files and directories).

To achieve this representation, a vector of pointers can be used to link to a
variable number of children. This approach allows for flexibility in
representing the file system and enables efficient traversal of the tree to
locate specific files or directories.

To simplify the implementation of the file system representation, we can use a
uniform node structure for both files and directories. Each node will contain
an indicator character that specifies whether it represents a file (f) or a
directory (d). In addition to this, every node will maintain a pointer to its
parent node, allowing for easy reference to the parent from the child.

We will utilize the aforementioned file system structure to simulate various
Linux commands that interact with the file system. The simulated commands that
are supported are as follows:

`ls`

    Lists all files and directories in the current directory.

`mkdir <dirname>`

    Creates a new directory within the current directory.

`cd <dirname>`

    Changes the current working directory to a given dirname. `cd ..` changes
    to the parent directory.

`pwd`

    Prints the current working directory. e.g. /root/nextdir/etc

`touch <filename>`

    Adds a file to the current directory

`mv <name1> <name2>`

    Change the name of the file or directory to the specified file/directory
    name. To keep it simple, this command can only rename files or directories
    in the current directory.

`rm <filename/dirname>`

    Remove a file or directory. If the directory has files/directories inside,
    they are also removed recursively.

`exit`

    Exits the program and return to bash.

## Project Requirements:
The simulator will provide feedback to the user by printing messages in
response to their input. These messages will correspond to the expected
behavior of the supported commands and will be consistent with the sample run
and test cases provided.

The file system simulator only permits the use of simple names for files and
directories. These names must consist of a single string, such as `a.txt` or
`dir1`, and cannot include multiple directory or file names concatenated
together, such as `/root/abc`.

As a file system simulator, the tree data structure will be employed to
memorize the name and organization of files and directories. There will be no
real file and directory stored.


## Command-line Interface:
Upon starting the program, a root node with the name `/root` is automatically
created. The user will be prompted with a `$` symbol, similar to a Linux
Terminal, indicating that they can enter commands.

The user can input commands to perform various file system operations. If the
user inputs an incorrect command, the terminal will provide an error message
indicating the mistake. Please refer to the test suite files located in
[test/](test/) for specific examples of these error messages.

To provide a better understanding of the file system simulator, a sample run
will be demonstrated using the supported commands.

## Sample run of program:

Takes a second or so to start. You can ignore the cd command.

```
$ pwd
/root
$ ls

$ touch file1
file file1 created successfully
$ touch file1
Error: file1 exists
$ mkdir dir1
directory dir1 created successfully
$ mkdir dir1
Error: dir1 exists
$ ls
f file1
d dir1

$ cd dir1
/root/dir1
$ touch file1
file file1 created successfully
$ mkdir dir2
directory dir2 created successfully
$ cd ..
/root
$ cd ..
/root
$ ls
f file1
d dir1

$ mv file1 file2
file/dir renamed successfully
$ mv file1 file3
file not found
$ mv dir1 dir2
file/dir renamed successfully
$ ls
f file2
d dir2

$ rm file1
No such file or directory
$ rm file2
file2 removed successfully
$ rm dir2
dir2 removed successfully
$ ls

$ exit
```

## Code Organization:

You will need to make sure that your code meets the following specifications.
Note that there is some room for interpretation, but a general code outline is
given below.

### The Main File
The main file will create an instance of the terminal and start up the program.

### The Node class
![UML of Node class](http://www.plantuml.com/plantuml/png/XL3DIWCn4BxdAOOURBJr1OfAmNlnu0l4P5WNyhDCPXUAwBExax1bWrfliz__vfZP48_1A-jDpd1A3k53tKDcTpXafZvs44t06RBlXe3FWzoYkuF144PUr1DQJlHGgATPtNj769NQ5RMsAMPkScya61vXizbVmkLx2zjzqp1ZSVH-OBfLE_WIIiirfTw1SUvPkdHrMBb_a7-rhuh5yvQI1yAG9hngk-Hdv9SoKQ_thkdNyu2wALcOambuhQ0cTiZ_Jldb-HSROTHDM9qhMFtrhauKe0dloa31FzKHenk3_mO0)

```
class Node {
- std::string name
- char type
- Node* parent
- std::vector<Node*> children

+ Node(const std::string &name = "", char type = ' ', Node* parent = nullptr)
+ ~Node()
+ void addChild(Node* child)
+ void addChild(const std::string &name, char type)
+ bool removeChild(const std::string &name)
+ void setParent(Node* parent)
+ void setType(char type)
+ void setName(const std::string &name)
+ Node* getChild(const std::string &name)
+ std::vector<Node*> getChildren()
+ Node* getParent()
+ char getType()
+ std::string getName()
}
```

- This class class represents a file or directory within the file system.
- The destructor should delete all children before deleting itself.
- Each node contains information for the name of the file or directory, the type
  (`f` for file and `d` for directory), and information on a node's
  children and parent.
- The methods provided allow you to modify these values or to retrieve
  values based on the name of a file or directory.
- Note, that `getChildren` allows you to retrieve all the children of a node.
- The destructor should be able to `delete` all children so the destructor of
  children will be triggered.
- The `removeChild` finds a child based on the name and removes it from the
  vector of children. This method should return false if the name is not found.
  If found, `delete` the child and then remove the pointer from the vector
  using the `vector::erase` method.


### The FileSystem Class
![UML of FileSystem class](http://www.plantuml.com/plantuml/png/ZOrDJe1038NtSugk3FXp0LOiZ4itdc0o7NJYT6hQ3eOOFRiI4a804vQlx-ltUZKlLYcxaBqgFAKSNoQrIF3b7k2PCSAjCDiQGXM9nHwJn60iqrynSaBmY3FGB5IxyaCgIn6ug84QTfsQfF8ADr0ynTRTRMQREVxiylQ9tZ79lx8zRLp3ssNwunCFUraF9w7BHXfFqK6Oxk6iCTuh0fugCCao-EtwMB1I_WK0)

```
class FileSystem {
- Node *root
- Node *currentDirectory
- void addNode(Node *)
- Node *findNode(const std::string & name)
+ FileSystem()
+ ~FileSystem()
+ std::string mkdir(const std::string & name)
+ std::string touch(const std::string & name)
+ std::string pwd()
+ std::string ls()
+ std::string rm(const std::string & name)
+ std::string mv(const std::string & from, const std::string & to)
+ std::string cd(const std::string & dirname)
}
```

This class is responsible for storing the filesystem and carrying out the
commands that manipulate it from the terminal. The majority of the methods shown
in this UML are described in the table above. The string return values are what
should be printed to the screen as a result of carrying out the operation.

Public methods:
* The destructor should delete the root to trigger its destructor.

Private methods:
* `addNode` Adds a new file or directory within the current directory. It can
  be triggered by `mkdir` and `touch` commands.

* `findNode` Looks for the file or directory within the current directory and
  returns it if it exists.

### The Terminal Class
![UML of Terminal class](http://www.plantuml.com/plantuml/png/SoWkIImgAStDuKhEIImkLWX9BShDp4lCKQZcqbLmoyn93QuiBadDLKWhvkBIXijgQ08vPVcPAGf5fNb0JYsNGsfU2j0K0000)

```
class Terminal {
- FileSystem fs
+ Terminal()
+ void run()
}
```

The responsibility of this class is to interact with the user. It takes in
commands and user input and calls the corresponding methods on the
**FileSystem** to get the results.

## Implementation Notes:
Your application must function as described below:
1. Create a project that is object oriented, therefore there should be several
   classes.
1. Your program must adhere to the class diagrams provided in this description.
1. You must use the data structures listed in this description for building your
   file system. Inappropriate use of other data structures or using data
   structures ways not discussed in this description can result in a large
   deduction of points.
1. **You must implement the removal recursively.**
1. Your program must compile and pass a tests listed above.

    - This application must be compiled by running `make main` and shall create
        an executable file called `main`. You can run it using the command
        `./main`
    - All tests must pass by running together with `make test-all`. You can run
        individual test during development.
    - You can test sample run using `make test-run`
    - You can also test memory problem with `make test-mem1` and `make
      test-mem2` (Note: not working on Mac OS, use codespace in that case)

1. You classes must be memory leak free. Memory leakage will be checked and
   graded in autograding.

## Building and Testing

A `Makefile` is provided to automate compilation and testing:
- **Compile main program**: `make main`
- **Run interactive CLI shell test**: `make test-run`
- **Run all unit tests**: `make test-all`
- **Run individual unit tests**:
  - `make test-1-node`: Node class unit tests.
  - `make test-2-touch-mkdir`: Filesystem creation unit tests (touch/mkdir).
  - `make test-3-cd-mv`: Filesystem navigation unit tests (cd/mv).
  - `make test-4-rm`: Filesystem removal unit tests (rm).
- **Run memory leak checks**:
  - `make test-mem1`: Memory leak check on Node class.
  - `make test-mem2`: Memory leak check on Filesystem.
  - `make test-mem`: Runs both memory leak checks.
- **Clean build artifacts**: `make clean`

> **Note for macOS / Xcode users**: Valgrind is not natively supported on macOS. If you are using macOS command line tools (Xcode), you cannot directly execute `valgrind` / `make test-mem` locally. Please launch a **GitHub Codespaces** instance on GitHub (or use a Linux container) to run memory leak checks.

## Important Notes:
- Projects will be graded on whether they correctly solve the problem, and
  whether they adhere to good programming practices.
- Projects must be received by the time specified on the due date. Projects
  received after that time will get a grade of zero.
- Do not change the test files! The results you get will be pointless as they
  will not align with our grading.
- Please review the academic honesty policy.
  - Note that viewing another student's solution, whether in whole or in part,
    is considered academic dishonesty.
  - Also note that submitting code obtained through the Internet or other
    sources, whether in whole or in part, is considered academic dishonesty.
    **All programs submitted will be reviewed for evidence of academic
    dishonesty, and all violations will be handled accordingly**.

## Submission Requirements:
1. All code must be added and committed to your local git repository.
2. All code must be pushed to the GitHub repository created when you "accepted"
   the assignment.
    1. After pushing, with `git push origin main`, visit the web URL of your
       repository to verify that your code is there. If you don't see the code
       there, then we can't see it either.
3. Your code must compile and run. The auto-grading tests will indicate your
   score for your submission.
    1. The auto-grading build should begin automatically when you push your code
       to GitHub.
    2. If your program will not compile, the graders will not be responsible for
       trying to test it.
    3. You should get an email regarding the status of your build, if it does
       not pass, keep trying.

## Grading Information:
- Breakdown
    + 80% GitHub Auto-grading
    + 10% Coding style (naming convention, neatness of code, etc)
    + 10% Code organization (modular design, separate files, headers, etc.)

## Checking Auto-grading Results:

After you push your code, GitHub will automatically run tests on your
submission. To view the results:

1. On your GitHub repository page, click the :arrow_forward: **Actions** tab at
   the top
2. Click on the most recent workflow run (it will show your commit message)
3. Wait until the run finishes (showing either ✅ or ❌)
4. Scroll down to "Autograding summary" section to see the summary
5. It will display:
   - **Points:** Your score (e.g., 10/10)
   - ✅ All tests passed! or ❌ Some tests failed
6. If tests failed, click the "Autograding" button above to see detailed logs:
   - Expand the **education/autograding@v1** step to see which tests failed
   - Look for :x: marks to identify specific failures
