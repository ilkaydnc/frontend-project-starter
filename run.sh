# Download template and config files from GitHub
curl -LkSs "https://github.com/ilkaydnc/frontend-project-starter/archive/main.zip" -o main.zip
unzip -qq main.zip
rm main.zip

RESOURCE_DIR="${PWD}/frontend-project-starter-main"
CONFIGS_DIR="$RESOURCE_DIR/configs"
TEMPLATES_DIR="$RESOURCE_DIR/templates"

project_name=$1
working_dir=$2

# Get project name and path with a prompt if not provided
if [ -z "$project_name" ]; then
    read -p "Enter a project name: " project_name
fi

if [ -z "$working_dir" ]; then
    read -p "Enter a path to the project directory: " working_dir
fi

# Resolve path
working_dir="$( cd "$working_dir" && pwd )"

project_path="$working_dir/$project_name"

# Change directory to project
cd "$working_dir"

# Run create-next-app command
npx create-next-app@latest $project_name --typescript --use-npm --eslint

# Remove default pages
rm -rf $project_path/pages
rm -rf $project_path/styles

# Create src directory
mkdir $project_path/src

# Install dependencies
cd $project_path
npm install sass @reduxjs/toolkit react-redux
npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint eslint-config-prettier eslint-plugin-prettier eslint-plugin-simple-import-sort prettier typescript

# Update ESLint, Prettier, VSCode, and TypeScript config files
cp $CONFIGS_DIR/eslint.txt $project_path/.eslintrc.json
cp $CONFIGS_DIR/prettier.txt $project_path/.prettierrc
cp $CONFIGS_DIR/tsconfig.txt $project_path/tsconfig.json

mkdir $project_path/.vscode
cp $CONFIGS_DIR/vscode.txt $project_path/.vscode/settings.json

# Update `next.config.js` file
cp $CONFIGS_DIR/next.txt $project_path/next.config.js

# Copy all files from `templates` directory to project and remove .txt extension
cp -r $TEMPLATES_DIR/* $project_path/src

# Remove .txt extension from all files in `src` directory
find $project_path/src -type f -name "*.txt" -exec bash -c 'mv -f "$0" "${0%.txt}"' {} \;

# Run lint and format
npm run lint -- --fix

# Remove .git directory
rm -rf $project_path/.git

# Initialize git repository
git init $project_path

# Create initial commit
git add .
git commit -m "Initial commit"

# Delete script files
rm -rf $RESOURCE_DIR