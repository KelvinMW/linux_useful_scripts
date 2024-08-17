#Sync files and folders
rsync -av --exclude=".git/*" --exclude=".gitignore" source_directory destination_directory
