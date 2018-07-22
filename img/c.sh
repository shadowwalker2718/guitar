for i in *gif;
do
  name=$(echo "$i" | cut -f 1 -d '.');
  if [ ! -f "$name.png" ]; then
    convert $i $name.png;
  fi
done
