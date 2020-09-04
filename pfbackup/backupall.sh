while IFS=, read -r host user password desc
do
    echo "Backing up $host"
    ./pfbackup.sh $host $user $password $desc
done < hosts
