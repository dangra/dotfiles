#!/usr/bin/env python

'''send diffs from Mercurial to various pastebin websites
'''

import base64
import urllib2
from mercurial import cmdutil, commands, help, util
from urllib import urlencode


def _paste_dpaste(content, **parameters):
    data = {'content': content, 'language': 'Diff'}
    if parameters['title']:
        data['title'] = parameters['title']
    if parameters['user']:
        data['poster'] = parameters['user']

    if len(data['poster']) > 30:
        data['poster'] = data['poster'][:30]

    if parameters['keep']:
        data['hold'] = 'on'
    data = urlencode(data)
    
    if parameters['url']:
        url = parameters['url']
    else:
        url = pastebins['dpaste']['url']
 
    request = urllib2.Request(url, data)
    if parameters['httpauth']:
        request.add_header('Authorization', 'Basic %s' \
                    % base64.encodestring(parameters['httpauth'])[:-1])
    elif parameters['usenetrc']:
        auth = _netrc_get_credentials(url)
        if auth:
            request.add_header('Authorization', 'Basic %s' \
                    % base64.encodestring('%s:%s' % (auth[0], auth[2]))[:-1])
    response = urllib2.urlopen(request)
    return response.geturl()

def _paste_dpaste_org(content, **parameters):
    data = {'content': content, 'lexer': 'diff'}
    if parameters['title']:
        data['title'] = parameters['title']
    if parameters['user']:
        data['author'] = parameters['user']

    if len(data['author']) > 30:
        data['author'] = data['author'][:30]

    # Same values used in dpaste.org form for default (a month) and forever expires.
    data['expire_options'] = '3110400000' if parameters['keep'] else '2592000'
    data = urlencode(data)

    if parameters['url']:
        url = parameters['url']
    else:
        url = pastebins['dpaste.org']['url']
    
    request = urllib2.Request(url, data)
    if parameters['httpauth']:
        request.add_header('Authorization', 'Basic %s' \
                    % base64.encodestring(parameters['httpauth'])[:-1])
    elif parameters['usenetrc']:
        auth = _netrc_get_credentials(url)
        if auth:
            request.add_header('Authorization', 'Basic %s' \
                    % base64.encodestring('%s:%s' % (auth[0], auth[2]))[:-1])
    response = urllib2.urlopen(request)
    return response.geturl()

def _netrc_get_credentials(url):
    import netrc, urlparse
    credentials = netrc.netrc()
    host = urlparse.urlparse(url).hostname
    return credentials.authenticators(host)

pastebins = {
    'dpaste': { 'url': 'http://dpaste.com/api/v1/',
                'parameters': {
                    'required': ['content'],
                    'optional': ['title', 'user', 'keep'], },
                'handler': _paste_dpaste,
    },
    'dpaste.org': { 'url': 'http://dpaste.org/',
                'parameters': {
                    'required': ['content'],
                    'optional': ['title', 'user', 'keep'], },
                'handler': _paste_dpaste_org,
    },
}

def paste(ui, repo, *fnames, **opts):
    '''send diffs from Mercurial to various pastebin websites
    
    Send a diff of the specified files to a pastebin website to easily
    share with other people.  If no files are specified all files will
    be included.
    
    To paste a diff of all uncommitted changes in the working directory:
    
        hg paste
    
    To paste the changes that revision REV made:
    
        hg paste -r REV
    
    To paste the changes between revisions REV1 and REV2:
    
        hg paste -r REV1:REV2
    
    Several options can be used to specify more metadata about the paste:
    
        hg paste --user Steve --title 'Progress on feature X' --keep
    
    The pastebin website to use can be specified with --dest.  See
    'hg help pastebins' for more information.
    
    '''
    dest = opts.pop('dest')
    dry = opts.pop('dry_run')
    if not dest:
        dest = 'dpaste'
    if dest not in pastebins:
        raise util.Abort('unknown pastebin (see "hg help pastebins")!')
    
    if not opts['user']:
        opts['user'] = ui.username().replace('<', '').replace('>', '')
    
    ui.pushbuffer()
    if opts['rev']:
        rev = opts.pop('rev')
        revs = cmdutil.revrange(repo, rev)
        
        if len(revs) == 1:
            opts['change'] = revs[0]
        else:
            opts['rev'] = rev
        
        commands.diff(ui, repo, *fnames, **opts)
    else:
        commands.diff(ui, repo, *fnames, **opts)
    content = ui.popbuffer()
    
    if not content.strip():
        raise util.Abort('nothing to paste!')
    
    if ui.verbose:
        ui.status('Pasting:\n%s\n' % content)
    
    if not dry:
        url = pastebins[dest]['handler'](content=content, **opts)
        ui.write('%s\n' % url)


cmdtable = {
    'paste': (paste, [
        ('r', 'rev',   [], 'paste a patch of the given revision(s)'),
        ('d', 'dest',  '', 'the pastebin site to use (defaults to dpaste)'),
        ('t', 'title', '', 'the title of the paste (optional)'),
        ('u', 'user',  '', 'the name of the paste\'s author (defaults to the '
                           'username configured for Mercurial)'),
        ('k', 'keep', False, 'specify that the pastebin should keep the paste '
                             'for as long as possible (optional)'),
        ('',  'dry-run', False, 'do not paste to the pastebin'),
        ('',  'url', '', 'perform request against this url'),
        ('',  'httpauth', '', 'http authorization (user:pass)'),
        ('',  'usenetrc', False, 'use ~/.netrc for http authorization'),
    ] + commands.diffopts + commands.walkopts,
    'hg paste [OPTION] [-r REV] [FILE...]')
}

help.helptable += (
    (['pastebins', 'pastebins'], ('Pastebins supported by hg-paste'),
     (r'''
    hg-paste currently supports dpaste.com and dpaste.org.  More pastebins
    will be supported in the future.
    
    Available pastebins:
    
    dpaste
        website: http://dpaste.com/
        supported metadata options: --title, --keep, --user

    dpaste.org
        website: http://dpaste.org/
        supported metadata options: --title, --keep, --user
    ''')),
)
