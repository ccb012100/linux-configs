#!/bin/bash
HOME="C:\tools\msys64\home\chris"

if [ -d "$HOME" ];
then
  cp .bash_profile $MSYS2_HOME/.bash_profile
  cp .nanorc $HOME/.nanorc
  cp .tmux.conf $HOME/.tmux.conf
  cp .vimrc $HOME/.vimrc
else
  echo "$HOME does not exist"
fi

