# Configurations

* brew
* zsh
* macvim
* hammerspoon

* Set zsh as default shell `chsh -s $(which zsh)`

* Install Vundle `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

```
ln -s $(pwd)/zshrc ~/.zshrc
ln -s $(pwd)/vimrc ~/.vimrc
ln -s $(pwd)/hammerspoon ~/.hammerspoon
```

* Weather API: forecast.io `echo API_KEY > hammerspoon/weather.api`
