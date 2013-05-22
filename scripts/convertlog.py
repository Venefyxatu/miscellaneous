#!/usr/bin/env python

import os

import re
import shutil

OLDSPEECH = r'^(?P<timestamp>\d{2}:\d{2})\s+\|(?P<nick>[\s@][-\w_|]+)\s>(?P<text>.*)'
OLDACTION = r'^(?P<timestamp>\d{2}:\d{2})\s+>(?P<nick>[\s@][-\w_|]+)\s(?P<text>.*)'
OLDINFO = r'^(?P<timestamp>\d{2}:\d{2})\s+\|-INFO\s>\s(?P<nick>[-\w_|]+)\s(?P<host>\[.*\]) has (?P<action>joined #dutchnano|quit|left #dutchnano).*'
OLDNICKCHANGE = r'^(?P<timestamp>\d{2}:\d{2})\s+\|-INFO\s>\s(?P<nick>[-\w_|]+) is now known as (?P<newnick>[-\w_|]+)'
OLDMODECHANGE = r'^(?P<timestamp>\d{2}:\d{2})\s+\|-INFO\s>\smode/#dutchnano \[(?P<mode>[-+][a-z]+)\s(?P<nick>[-\w_|]+)\] by ChanServ'
OLDNICKTOTALS = r'^(?P<timestamp>\d{2}:\d{2})\s+\|-INFO\s>\sIrssi: #dutchnano: Total of (?P<count>\d+) nicks \[(?P<ops>\d+) ops, (?P<halfops>\d+) halfops, (?P<voices>\d+) voices, (?P<normal>\d+) normal\]'
OLDJOINCOMPLETED = r'^(?P<timestamp>\d{2}:\d{2})\s+\|-INFO\s>\sIrssi: Join to #dutchnano was synced in (?P<seconds>\d+) secs'
LOGLINE = r'^--- Log (closed|opened) .*'
DAYCHANGED = r'^--- Day changed (?P<newday>[\w\s\d]+)'

speech_regex = re.compile(OLDSPEECH, re.MULTILINE)
action_regex = re.compile(OLDACTION, re.MULTILINE)
info_regex = re.compile(OLDINFO, re.MULTILINE)
nickchange_regex = re.compile(OLDNICKCHANGE, re.MULTILINE)
modechange_regex = re.compile(OLDMODECHANGE, re.MULTILINE)
nicktotals_regex = re.compile(OLDNICKTOTALS, re.MULTILINE)
joincompleted_regex = re.compile(OLDJOINCOMPLETED, re.MULTILINE)
log_regex = re.compile(LOGLINE, re.MULTILINE)
day_regex = re.compile(DAYCHANGED, re.MULTILINE)

logfiles = filter(lambda x: x.startswith('#dutchnano.11'), os.listdir('/RAID/logs/irssi/2011/Freenode/'))
outputdir = '/RAID/logs/nano2011/'

for logfile in logfiles:
    newfilecontent = []

    print 'Converting %s' % logfile
    testfile = '/tmp/test.log'

    shutil.copyfile('/RAID/logs/irssi/2011/Freenode/%s' % logfile, testfile)

    f = open(testfile, 'r')
    try:
        for line in f.readlines():
            match = re.match(speech_regex, line)
            if match:
                newline = '%(timestamp)s <%(nick)s>%(text)s' % match.groupdict()
                newfilecontent.append(newline)
            else:
                match = re.match(action_regex, line)
                if match:
                    groupdict = match.groupdict()
                    groupdict['nick'] = groupdict['nick'].replace('@', ' ')
                    newline = '%(timestamp)s  *%(nick)s %(text)s' % match.groupdict()
                    newfilecontent.append(newline)
                else:
                    match = re.match(info_regex, line)
                    if match:
                        newline = '%(timestamp)s -!- %(nick)s has %(action)s' % match.groupdict()
                        newfilecontent.append(newline)
                    else:
                        match = re.match(nickchange_regex, line)
                        if match:
                            newline = '%(timestamp)s -!- %(nick)s is now known as %(newnick)s' % match.groupdict()
                            newfilecontent.append(newline)
                        else:
                            match = re.match(modechange_regex, line)
                            if match:
                                newline = '%(timestamp)s -!- mode/#dutchnano [%(mode)s %(nick)s] by ChanServ' % match.groupdict()
                                newfilecontent.append(newline)
                            else:
                                match = re.match(nicktotals_regex, line)
                                if match:
                                    newline = '%(timestamp)s -!- Irssi: #dutchnano: Total of %(count)s nicks [%(ops)s ops, %(halfops)s halfops, %(voices)s voices, %(normal)s normal]' % match.groupdict()
                                    newfilecontent.append(newline)
                                else:
                                    match = re.match(joincompleted_regex, line)
                                    if match:
                                        newline = '%(timestamp)s -!- Irssi: Join to #dutchnano was synced in %(seconds)s secs' % match.groupdict()
                                        newfilecontent.append(newline)
                                    else:
                                        match = re.match(log_regex, line)
                                        if match:
                                            newfilecontent.append(line.strip('\n'))
                                        else:
                                            match = re.match(day_regex, line)
                                            if match:
                                                newfilecontent.append(line.strip('\n'))
                                            else:
                                                newfilecontent.append(line.strip('\n'))
    finally:
        f.close()

    print 'DONE!'
    f = open('%s%s' % (outputdir, logfile), 'w')
    try:
        print 'Writing to %s%s' % (outputdir, logfile)
        f.write('\n'.join(newfilecontent))
    finally:
        f.close()

