echo "\033[0;34mCloning Rails Boletia app template generator...\033[0m"
hash git >/dev/null && /usr/bin/env git clone https://github.com/https://github.com/JohanAlvarado/boletia_generators.git ~/.boletia_generators || {
  echo "git not installed"
  exit
}

echo "\033[0;34mGenerating .railsrc file...\033][0m"
if [ -f ~/.railsrc ] || [ -h ~/.railsrc ]
then
  echo "\033[0;34mYou already have a .railsrc file.\033[0m \033[0;32mBacking up to ~/.railsrc.previous\033[0m"
  mv ~/.railsrc ~/.railsrc.previous;
fi

echo "\033[0;34mCopying the Icalia .railsrc template to ~/.railsrc\033[0m"
cp ~/.boletia_generators/templates/railsrc_template ~/.railsrc


echo "\n\n \033[0;32mThanks for installing our custom rails Boletia app generator\033[0m"
