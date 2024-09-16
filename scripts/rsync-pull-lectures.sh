#!/bin/bash

MODULES=(
	"CS3050"
	"CS3052"
	"CS3099"
	"CS3104"
	"CS3105"
	"CS3102"
	"CS3106"
)

UNI_USER="gs248"                          # Your uni username (<xxxxxx>@st-andrews.ac.uk)
UNI_DOMAIN="teaching.cs.st-andrews.ac.uk" # Uni teaching service domain
YEAR="2024_2025"                          # Current academic year
OLD_YEAR="2023_2024"                      # Also copy older materials from this year. Useful because they tend to be similar. Set to empty string to disable.
STUDRES_ROOT="/cs/studres"                # Studres mounting location on uni servers
DESTINATION="$HOME/Documents/PARA/Resources/University/St Andrews/CS"

HOST="${UNI_USER}@${UNI_USER}.${UNI_DOMAIN}"
STUDRES="${HOST}:${STUDRES_ROOT}"

# Check SSH accessibility to the host
echo "Checking SSH accessibility to ${HOST}..."
if ! ssh -q "${HOST}" exit; then
	echo "[ERROR] Unable to connect to ${HOST} via SSH."
	echo "- Check that you have set up public key auth on the uni servers"
	echo "- If you are not on the uni network, check that the jump server is configured correctly"
	echo "See: https://wiki.cs.st-andrews.ac.uk/index.php?title=Using_SSH"
	exit 1
fi

mkdir -p "${DESTINATION}"

FILES=()
OLD_FILES=()

for module in "${MODULES[@]}"; do
	FILES+=("${STUDRES}/${YEAR}/${module}")

	if [ "$OLD_YEAR" ]; then
		OLD_FILES+=("${STUDRES}/${OLD_YEAR}/${module}")
	fi
done

echo "Uni user: ${UNI_USER}, chowning to $USER:$USER"
echo "Uni host: ${HOST}"
echo "Copying lecture slides to ${DESTINATION}"
echo ""

# -a - Archive mode (copy recursively, keeping times, permissions, etc)
# -z - Use compression (speeds up data transfer over a network)
# -v - Print verbose output
# -h - Use human-friendly output
# -P - Show progress
# --chown - Set user & group for copied files
# See: rsync --help
rsync -azvhP --chown="$USER:$USER" "${FILES[@]}" "${DESTINATION}/"

if [ $? -ne 0 ]; then
	echo "[ERROR] rsync exited with code $?"
else
	echo "Files copied successfully!"
fi

# Handle copying old files if OLD_YEAR is set
if [ "$OLD_YEAR" ]; then
	echo ""
	echo "Copying old lecture slides from ${OLD_YEAR} to ${DESTINATION}/${OLD_YEAR}/"

	mkdir -p "${DESTINATION}/${OLD_YEAR}"
	rsync -azvhP --chown="$USER:$USER" "${OLD_FILES[@]}" "${DESTINATION}/${OLD_YEAR}/"

	if [ $? -ne 0 ]; then
		echo "[ERROR] rsync for old files exited with code $?"
	else
		echo "Old files copied successfully!"
	fi
fi
