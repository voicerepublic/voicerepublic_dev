bundle update --source fidelity
git commit -am 'update fidelity'
git push
cap staging deploy
