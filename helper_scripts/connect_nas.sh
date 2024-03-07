ip=NULL
target=NULL
mount=NULL

if [[ "$ip" = "NULL" || "$target" = "NULL" || "$mntPoint" = "NULL" ]]; then
    echo "Please set variables"
    exit 1
fi
