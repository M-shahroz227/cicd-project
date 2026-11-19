
#!/bin/bash
set -e

echo "Running application tests..."

# Check if index.html exists
test -f index.html

# Check if index.html is not empty
test -s index.html

# Check expected text
grep -q "Hello DevOps!" index.html

echo "All tests passed!"
