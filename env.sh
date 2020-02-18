
alias btest="docker run -it --rm -u $(id -u) \
	--workdir /work \
	--volume  $(pwd):/work \
	--volume  $HOME/bdd-perl:/usr/src/bdd \
	--env PERL5LIB=/usr/src/bdd/lib:/work/local/lib/perl5 \
	benlittle6/bdd-perl"

alias prove="docker run -it --rm -u $(id -u) \
	--workdir /work \
	--volume  $(pwd):/work \
	--volume  $HOME/bdd-perl:/usr/src/bdd \
	--entrypoint bash \
	--env PERL5LIB=/usr/src/bdd/lib:/work/local/lib/perl5 \
	benlittle6/bdd-perl prove"

alias carton="docker run -it --rm -u $(id -u) \
	--workdir /work \
	--volume  $(pwd):/work \
	carton"

alias tree="tree -a -I '.git|local'"

