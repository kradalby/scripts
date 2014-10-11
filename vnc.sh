

vnc () {
    re='^[0-9]+$'
    if [[ $1 =~ $re ]] ; then
        open vnc://localhost:$1
    else 
        open vnc://$1:$2
    fi
    
}

