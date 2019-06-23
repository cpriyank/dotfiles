sudo tlmgr update --self
sudo tlmgr install latexmk
# curl -o cmu-serif.zip https://fontlibrary.org/assets/downloads/cmu-serif/59c4efc3fa08079ca44060ca808c8f58/cmu-serif.zip
sudo tlmgr install fontawesome
sudo tlmgr install titlesec
sudo tlmgr install enumitem
curl -o fontawesome.ttf https://raw.githubusercontent.com/creationix/font-awesome/master/FontAwesome.ttf
open fontawesome.ttf
rm fontawesome.ttf
# for mtheme
sudo tlmgr install pgfopts pgfplots appendixnumberbeamer ctexart
sudo tlmgr install latexindent