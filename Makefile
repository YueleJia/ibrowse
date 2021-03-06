IBROWSE_VSN = $(shell sed -n 's/.*{vsn,.*"\(.*\)"}.*/\1/p' src/ibrowse.app.src)

all:
	./rebar compile

clean:
	./rebar clean

install: all
	mkdir -p $(DESTDIR)/lib/ibrowse-$(IBROWSE_VSN)/
	cp -r ebin $(DESTDIR)/lib/ibrowse-$(IBROWSE_VSN)/

test: all
	./rebar eunit
	erl -noshell -pa .eunit -pa test -s ibrowse -s ibrowse_test unit_tests \
	-s ibrowse_test verify_chunked_streaming \
	-s ibrowse_test test_chunked_streaming_once \
	-s erlang halt

xref: all
	./rebar xref

docs:
	erl -noshell \
		-eval 'edoc:application(ibrowse, ".", []), init:stop().'
