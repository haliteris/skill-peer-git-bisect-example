# Git Bisect Demonstration Repository

This repository provides a simple script, `setup_repo.sh`, to create a sample Git repository. This sample repository is specifically designed to help you learn and master the `git bisect` command in a controlled environment.

`git bisect` is a powerful Git command that uses a binary search algorithm to find the specific commit that introduced a bug. This tool can save you a massive amount of time when you know a feature was working in the past but is broken now.

---

## Quick Start

Follow these steps to set up the demonstration repository on your local machine.

1.  **Clone or Download**
    Clone this repository or simply download the `setup_repo.sh` file.

2.  **Make the Script Executable**
    Open your terminal and grant execution permissions to the script.
    ```bash
    chmod +x setup_repo.sh
    ```

3.  **Edit & Run the Script**
    Write your git defined username and email adress in the script. Then execute the script. It will create a new directory named `bisect-demo`, initialize a Git repository inside it, and create 30 commits.
    ```bash
    ./setup_repo.sh
    ```

4.  **Navigate to the Demo Directory**
    Change your current directory to the newly created `bisect-demo`. All subsequent commands should be run from inside this directory.
    ```bash
    cd bisect-demo
    ```

---

## 🎯 The Scenario

You've just run the setup script. Welcome to your new project! Here's the situation:

* The repository contains a script called `demo.sh`. This script simulates a system check.
* If you run the script now (at the `HEAD` of the `main` branch), you'll see a failure. The State of Charge (SOC) shows `NaN`.

    ```bash
    ./demo.sh
    ```
    **Output:**
    ```
    Battery ID: MAIN_MASTER
    Voltage: 97.33 V
    Current: 7.5 A
    State of Charge (SOC): NaN
    ```
    The script also exits with a status code of `1`, indicating an error. You can check this with `echo $?`.

* We know that the script was working correctly in the very first commit. You can verify this by checking out the first commit and running the script again.

Your mission, should you choose to accept it, is to find the **exact commit** that introduced this bug without checking each commit one by one. This is the perfect job for `git bisect`!

---

## 🕵️‍♂️ Finding the Bug with `git bisect`

Here’s how to use `git bisect` to automatically find the faulty commit.

### Step 1: Start the Bisect Process

First, tell Git you want to start a bisect session.

```bash
git bisect start
```

### Step 2: Mark the `Bad` and `Good` Commits

Next, you need to tell Git the boundaries of the search.

1. Mark the current commit as `bad` because we know it's broken.

```bash
git bisect bad HEAD
```

2. Mark the first commit as `good`. First, find its hash. The `setup_repo.sh` script was designed so this is the very first commit in the history.

```bash
    # This command gets the hash of the first commit
    FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD)

    # Now, mark it as good
    git bisect good $FIRST_COMMIT
```

### Step 3: Automate the Search

Git will now checkout a commit halfway between the `good` and `bad` ones. You could manually run `./demo.sh`, check the output, and type `git bisect good` or `git bisect bad` repeatedly.

However, our `demo.sh` script is perfect for automation because it exits with 0 on success (`good`) and 1 on failure (`bad`). We can simply tell git bisect to run the script for us.
```Bash
git bisect run ./demo.sh
```

### Step 4: Analyze the Result

After a few seconds, git bisect will stop and print the result. The output will look something like this:

```bash
xxxxxxxxxxxxxHASHxxxxxxxxxxxxxxxxxxxxxxx is the first bad commit
commit xxxxxxxxxxxxxxxHASHxxxxxxxxxxxxxxxxxxxxx
Author: Lord Haliteris <your@email.com>
Date:   Wed Sep 07 18:38:35 2025 +0200

    Commit 16: Refactored the core logic

 .../bisect-demo/file.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

Success! git bisect has identified "Commit 16" as the one that introduced the bug.

### Step 5: Clean Up

Once you've found the culprit, you should end the bisect session to return your repository to its original state (HEAD).
```Bash

git bisect reset
```

You're now back at your main branch, armed with the knowledge of exactly where the problem was introduced. Happy bug hunting! 🐛

This project is licensed under the terms of the MIT license.
