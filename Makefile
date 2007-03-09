prefix = /usr/local
bindir = ${prefix}/bin
sysconfdir = ${prefix}/etc
mandir = ${prefix}/man

mkinstalldirs = /bin/sh ./mkinstalldirs
install = ./install-sh -c

# Set these to appropriate values for your system
perl = /usr/bin/perl
pod2man = pod2man

all:
	sed -e "s#/usr/bin/perl#$(perl)#;" -e "s#__PREFIX__#$(prefix)#;" \
	< zetaback > zetaback.new
	if [ ! -f zetaback ]; then mv -f zetaback.new zetaback; \
	elif cmp -s zetaback.new zetaback; then true; \
	else mv -f zetaback.new zetaback; \
	fi
	rm -f zetaback.new
	sed -e "s#/usr/bin/perl#$(perl)#;" -e "s#__PREFIX__#$(prefix)#;" \
	< zetaback_agent > zetaback_agent.new
	if [ ! -f zetaback_agent ]; then mv -f zetaback_agent.new zetaback_agent; \
	elif cmp -s zetaback_agent.new zetaback_agent; then true; \
	else mv -f zetaback_agent.new zetaback_agent; \
	fi
	rm -f zetaback_agent.new

install: all
	$(mkinstalldirs) ${bindir}
	$(mkinstalldirs) ${sysconfdir}
	$(mkinstalldirs) ${mandir}
	$(mkinstalldirs) ${mandir}/man1
	$(pod2man) zetaback zetaback.1
	$(pod2man) zetaback_agent zetaback_agent.1
	$(install) -m 0755 zetaback ${bindir}/zetaback
	$(install) -m 0755 zetaback_agent ${bindir}/zetaback_agent
	$(install) -m 0644 zetaback.conf ${sysconfdir}/zetaback.conf
	$(install) -m 0644 zetaback_agent.conf ${sysconfdir}/zetaback_agent.conf
	$(install) -m 0644 zetaback.1 ${mandir}/man1/zetaback.1
	$(install) -m 0644 zetaback_agent.1 ${mandir}/man1/zetaback_agent.1

clean:
	rm -f zetaback.1 zetaback_agent.1
	@echo "Resetting perl and prefix paths to defaults"
	@echo "#!/usr/bin/perl" > zetaback.clean
	@grep -v '^#!' zetaback | \
	sed -e 's#$PREFIX = q^.*^;#$PREFIX = q^__PREFIX__^;#;' >> zetaback.clean
	@mv zetaback.clean zetaback
	@echo "#!/usr/bin/perl" > zetaback_agent.clean
	@grep -v '^#!' zetaback_agent | \
	sed -e 's#$PREFIX = q^.*^;#$PREFIX = q^__PREFIX__^;#;' >> zetaback_agent.clean
	@mv zetaback_agent.clean zetaback_agent

