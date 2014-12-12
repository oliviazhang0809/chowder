echo $1
echo "this is my test $2.example.com"
if [ $1 = "v" ]; then
  echo  "$3 $2.example.com $2" 
fi

