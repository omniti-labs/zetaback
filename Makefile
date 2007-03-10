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
	< zetaback.in > zetaback
	sed -e "s#/usr/bin/perl#$(perl)#;" -e "s#__PREFIX__#$(prefix)#;" \
	< zetaback_agent.in > zetaback_agent

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
	rm -f zetaback zetaback_agent zetaback.1 zetaback_agent.1
