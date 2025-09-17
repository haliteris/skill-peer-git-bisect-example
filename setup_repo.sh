#!/bin/bash

# Clean up previous demo directory if it exists
rm -rf bisect-demo
mkdir bisect-demo
cd bisect-demo

# Initialize Git repository
git init
git config user.name "your.username"
git config user.email "your@email.com"

# Create the initial test script (which works)
cat << 'EOF' > demo.sh
#!/bin/bash
# This script checks for a specific condition.
# It exits with 0 if the condition is met (good), and 1 otherwise (bad).
if [[ "$(cat file.txt)" == "Everything is OK" ]]; then
  echo "Battery ID: MAIN_MASTER"
  echo "Voltage: 97.33 V"
  echo "Current: 7.5 A"
  echo "State of Charge (SOC): %91"
  exit 0
else  
  echo "Battery ID: MAIN_MASTER"
  echo "Voltage: 97.33 V"
  echo "Current: 7.5 A"
  echo "State of Charge (SOC): NaN"
  exit 1
fi
EOF
chmod +x demo.sh

# Create the initial file and the first "good" commit
echo "Everything is OK" > file.txt
git add .
git commit -m "Initial commit: System is working correctly"

# Create 14 more good commits
for i in {2..15}
do
  echo "Change #$i" >> changes.log
  git add changes.log
  git commit -m "Commit $i: Feature enhancement"
done

# Introduce the bug in the 16th commit
echo "Something went wrong" > file.txt
git add file.txt
git commit -m "Commit 16: Refactored the core logic"

# Create 14 more commits after the bug was introduced
for i in {17..30}
do
  echo "Another change #$i" >> more_changes.log
  git add more_changes.log
  git commit -m "Commit $i: Minor update"
done

echo "Repository setup complete."
echo "A bug was introduced in commit 16."
echo "Run './demo.sh' at HEAD to see the software failure as ('NaN')."
echo "Checkout the first commit to see it working with a number ('OK')."