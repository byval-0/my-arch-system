Add pacman mirror, so it up to date.

```
sudo pacman -S reflector

sudo reflector \
  --country SG,JP,HK,KR \
  --protocol https \
  --age 12 \
  --sort rate \
  --save /etc/pacman.d/mirrorlist

sudo pacman -Syyu
```



