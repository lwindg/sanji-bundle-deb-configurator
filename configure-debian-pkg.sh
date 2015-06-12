#!/bin/sh

JQ=1
if ! type jq > /dev/null; then
	JQ=0
fi

if [ ! -f "bundle.json" ]; then
	echo "bundle.json not exist!"
	exit 1
fi

set_author_info () {
	if [ $JQ -eq 1 ]; then
		author=$(cat bundle.json | jq -r .author)
		email=$(cat bundle.json | jq -r .email)
	else
		read -p "             Author: " author
		read -p "              Email: " email
	fi
}

set_package_info () {
	if [ $JQ -eq 1 ]; then
		package=$(cat bundle.json | jq -r .name)
		resource=$(cat bundle.json | jq -r .resources[0].resource)
		description=$(cat bundle.json | jq -r .description)
		git_repo=$(cat bundle.json | jq -r .repository)
	else
		read -p "       Package Name: " package
		read -p "           Resource: " resource
		read -p "        Description: " description
		read -p "                Git: " git_repo
	fi
	read -p "                Web: " web
	read -p "Sanji version (1.0): " sanji_ver
}

set_bundle_items () {
	echo "Files (requirements.txt, README.md, and bundle.json already included):"
	echo "["$(ls -l | grep ^- | awk '{print $9}')"]"
	read -p " " files
	echo "Directories (data already included):"
	echo "["$(ls -d */)"]"
	read -p " " dirs
}

verify_variables () {
	if [ -z "${package}" ]; then
		echo "Package name cannot be empty!"
		exit 1
	fi

	if [ -z "${files}" ]; then
		echo "Please input files to be packed!"
		exit 1
	fi
}


set_package_info
set_author_info
#set_bundle_items
#verify_variables


# set the default values
default_files="requirements.txt README.md bundle.json"
default_dirs="data"

time=$(date +"%a, %d %b %Y %T %z")
author=${author:-moxa}
email=${email:-moxa@moxa.com}

resource=${resource:-${package}}
sanji_ver=${sanji_ver:-1.0}

files="${default_files} ${files}"
dirs="${default_dirs} ${dirs}"

# Debian naming rule: lower case, 0 ~ 9, +, -, and .
package=$(echo "$package" | tr '[A-Z]' '[a-z]')
package=$(echo "$package" | sed 's/[[!@#$%^&*()_=|\\{\}:;\"'\''<>?\/]//g')
package=$(echo "$package" | sed 's/\]//g')

# update the value for safe sed
safe_package=$(printf '%s\n' "$package" | sed 's/[[\.*^$/]/\\&/g')
safe_author=$(printf '%s\n' "$author" | sed 's/[[\.*^$/]/\\&/g')
safe_email=$(printf '%s\n' "$email" | sed 's/[[\.*^$/]/\\&/g')
safe_description=$(printf '%s\n' "$description" | sed 's/[[\.*^$/]/\\&/g')
safe_git=$(printf '%s\n' "$git_repo" | sed 's/[[\.*^$/]/\\&/g')
safe_web=$(printf '%s\n' "$web" | sed 's/[[\.*^$/]/\\&/g')

# prepare the Debian package files
for file in $(find build-deb/debian/ -type f); do
	sed -i "s/%%package%%/${safe_package}/g" $file
	sed -i "s/%%author%%/${safe_author}/g" $file
	sed -i "s/%%email%%/${safe_email}/g" $file
	sed -i "s/%%time%%/${time}/g" $file
	sed -i "s/%%description%%/${safe_description}/g" $file
	sed -i "s/%%git%%/${safe_git}/g" $file
	sed -i "s/%%web%%/${safe_web}/g" $file
done

