all:
	happy -gca ParBeatle.y
	alex -g LexBeatle.x
	ghc --make TestBeatle.hs -o TestBeatle

clean:
	-rm -f *.log *.aux *.hi *.o *.dvi

distclean: clean
	-rm -f DocBeatle.* LexBeatle.* ParBeatle.* LayoutBeatle.* SkelBeatle.* PrintBeatle.* TestBeatle.* AbsBeatle.* TestBeatle ErrM.* SharedString.* ComposOp.* Beatle.dtd XMLBeatle.* Makefile*
	
