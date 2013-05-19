#!/usr/bin/env python

import re
import base64
import urllib2
import smtplib
import imaplib
import getpass
import StringIO
import MimeWriter

print 'Imports done'

urlrex = re.compile('^.*(?P<url>https://crm.schedom-europe.net/include/pdf/[a-zA-Z0-9]+\.pdf).*vereist.*$', re.MULTILINE)

print 'Making SMTP connection'

m = imaplib.IMAP4_SSL('imap.gmail.com')

print 'Getting password'

passwd = 'GMAIL_PASSWORD'

print ' * Logging in'

res, msgs = m.login('GMAIL_ADDRESS', passwd)
if res != 'OK':
    raise RuntimeError('Login failed')

invoices = []

print ' * Switching to Dommel folder'
m.select('Dommel')
print ' * Fetching unseen messages'
res, messages = m.search(None, 'UNSEEN')
for message in messages:
    if message:
        status, data = m.fetch(message, '(RFC822)')
        body = data[0][1]
        for line in body.splitlines():
            match = re.match(urlrex, line)
            if match:
                print '   * Got invoice %s' % match.groupdict()['url']
                invoices.append(match.groupdict()['url'])


print ' * Building message'
message = StringIO.StringIO()
writer = MimeWriter.MimeWriter(message)
writer.addheader('MIME-Version', '1.0')
writer.addheader('Subject', 'Internetfactuur')
writer.addheader('To', 'RECIPIENT_ADDRESS')
writer.addheader('BCC', 'GMAIL_ADDRESS' )
writer.addheader('From', 'SENDER_ADDRESS' )
print ' * Starting multipartbody'
writer.startmultipartbody('mixed')
part = writer.nextpart()
body = part.startbody('text/plain')
body.write('Hoi,\n')
body.write('\n')
body.write('In bijlage de volgende internetfactuur.\n')
body.write('\n')
body.write('Mvg,\n')
body.write('\n')
body.write('Erik\n')
part = writer.nextpart()

print ' * Looping over invoices %s' % invoices

for invoice in invoices:
    opener = urllib2.build_opener(urllib2.HTTPHandler)
    request = urllib2.Request(invoice)
    request.add_header('Content-Type', 'text/http')
    url = opener.open(request)
    invoice_data = url.read()
    invoice_fname = 'invoice_%s.pdf' % invoices.index(invoice)

    print ' * Adding header for invoice %s ' % invoice
    part.addheader('Content-Transfer-Encoding', 'base64')
    body = part.startbody('application/pdf; name=%s' % invoice_fname)
    body.write(base64.encodestring( invoice_data ))

print ' * Finish off'
writer.lastpart()

if invoices:
    print 'Building SMTP connection'
    conn = smtplib.SMTP('smtp.gmail.com', 587)
    conn.starttls()
    conn.login('GMAIL_ADDRESS', passwd)
    conn.sendmail(from_addr='SENDER_ADDRESS', to_addrs=['RECIPIENT_ADDRESS', 'GMAIL_ADDRESS'], msg=message.getvalue())

    conn.quit()

m.logout()
