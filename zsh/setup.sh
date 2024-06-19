set -ex

ZSHD_DIR="~/.zshrc.d"
mkdir -p "$ZSHD_DIR"
test -f ~/.zshrc || touch ~/.zshrc

cp ./zsh/ohuzei.zshrc.zsh "$ZSHD_DIR/ohuzei.zsh"
if ! grep -qq 'ohuzei.zsh' ~/.zshrc; then
    echo '. ~/.zshrc.d/ohuzei.zsh' >> ~/.zshrc
fi

echo "Installing zsh-syntax-highlighting"
git clone --depth 1 --branch "0.8.0" https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSHD_DIR/zsh"
mv "$ZSHD_DIR/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$ZSHD_DIR/zsh-syntax-highlighting.zsh"
rm -rf "$ZSHD_DIR/zsh"
if ! grep -qq 'zsh-syntax-highlighting.zsh' ~/.zshrc; then
    echo '. ~/.zshrc.d/zsh-syntax-highlighting.zsh' >> ~/.zshrc
fi

echo "Installing zsh-auto-suggestion"
git clone --depth 1 --branch "v0.7.0" https://github.com/zsh-users/zsh-autosuggestions.git "$ZSHD_DIR/zas"
mv "$ZSHD_DIR/zas/zsh-autosuggestions.zsh" "$ZSHD_DIR/zsh-autosuggestions.zsh"
rm -rf "$ZSHD_DIR/zas"
if ! grep -qq 'zsh-autosuggestions.zsh' ~/.zshrc; then
    echo '. ~/.zshrc.d/zsh-autosuggestions.zsh' >> ~/.zshrc
fi

echo "Installing OhMyPosh"
curl -s https://ohmyposh.dev/install.sh | bash -s
cp zsh/oh-my-posh-microverse-power.omp.json "$ZSHD_DIR/oh-my-posh-microverse-power.omp.json"



if ! grep -qq 'oh-my-posh' ~/.zshrc; then
    echo 'eval "$(oh-my-posh init zsh --config ~/.zshrc.d/oh-my-posh-microverse-power.omp.json)"' >> ~/.zshrc
fi

echo
echo
echo "Run 'chsh -s $(which zsh)' to use ZSH"
echo
echo
